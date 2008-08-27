Return-Path: <linux-kernel-owner+w=401wt.eu-S1759331AbYH0QY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331AbYH0QY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbYH0QYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:24:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbYH0QYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:24:01 -0400
Date: Wed, 27 Aug 2008 09:15:50 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, Stefan Kopp <stefan_kopp@agilent.com>,
       Marcel Janssen <korgull@home.nl>, Felipe Balbi <me@felipebalbi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Message-ID: <20080827161550.GE19710@kroah.com>
References: <20080827000501.GA29570@kroah.com> <200808271056.37159.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808271056.37159.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, as I've responded to this multiple times, now summarizing so I make
sure I got everything...

On Wed, Aug 27, 2008 at 10:56:36AM +0200, Oliver Neukum wrote:
> Am Mittwoch 27 August 2008 02:05:01 schrieb Greg KH:
>  
> > I've now added this to my tree, and any review comments are greatly
> > welcome.
> 
> Unfortunately the issues are not trivial.
> 
> 1. USBTMC_SIZE_IOBUFFER
> use 2048. 4096 means a multipage allocation

changed.

> 2. usbtmc_open race with disconnect
> already mailed about

fixed.

> 3. read/write and, if you convert to unlocked_ioctl, need protection
> against reentry

fixed and changed to unlocked_ioctl.

> 4. read, write & ioctl need protection against using a rebound interface
> you add a mutex, that you need for (3) anyway to the descriptor and protected
> by this mutex you set the interface and device pointers to null in disconnect
> and check them in the affected methods

Should now be fixed.

> 5.get_capabilities
> kmalloced buffer is never freed

fixed.

> 6. disconnect fails to remove sysfs attributes

fixed.

> 7. probe will report success even if usb_register_dev fails

fixed.

I'll post a new version now.

thanks a lot for the review, I really appreciate it.

greg k-h
