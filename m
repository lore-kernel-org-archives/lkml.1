Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbZKTMe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbZKTMe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 07:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZKTMe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 07:34:28 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:25500 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZKTMe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 07:34:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=jtdDg7/wRpgBffx47MwgDoJTI4BknK7VD5khPYDA9I0FZ+US318MmjLJIC/ZG+DmLe
         l1+KxK4evh0Lc7ytwn5nsfNHFLZ04uXDIbtKEirvUfgSbHCXPTqkxU2jxcpm2u2sYOum
         F5kUlOHFk/oL5kwQypBVv6W4qG59F4AgnhSBE=
Date: Fri, 20 Nov 2009 14:34:14 +0200
From: Dan Carpenter <error27@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] tty: push the BKL down into the handlers a bit
Message-ID: <20091120123414.GA29012@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
References: <20091118142313.3806.47368.stgit@localhost.localdomain> <20091118142404.3806.19238.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118142404.3806.19238.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 02:25:43PM +0000, Alan Cox wrote:
> Start trying to untangle the remaining BKL mess
> 
> Signed-off-by: Alan "I must be out of my tree" Cox <alan@linux.intel.com>
> ---
> 
>  drivers/char/pty.c       |    2 -
>  drivers/char/tty_io.c    |  140 ++++++++++++++++++++++++++--------------------
>  drivers/char/tty_ldisc.c |   13 ++++
>  include/linux/tty.h      |    2 -
>  4 files changed, 94 insertions(+), 63 deletions(-)
> 

  1565                  if (o_tty->termios != tty->driver->other->termios[idx]) {
  1566                          unlock_kernel();
  1567                          printk(KERN_DEBUG "tty_release_dev: other->termios[%d] "
  1568                                            "not o_termios for (%s)\n",
  1569                                 idx, tty->name);
  1570                          return 0;
  1571                  }
  1572                  if (o_tty->link != tty) {

We would need an unlock_kernel() here.

  1573                          printk(KERN_DEBUG "tty_release_dev: bad pty pointers\n");
  1574                          return 0;
  1575                  }

regards,
dan carpenter

