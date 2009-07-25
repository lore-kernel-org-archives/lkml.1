Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbZGYE5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbZGYE5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 00:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZGYE5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 00:57:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZGYE5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 00:57:43 -0400
Date: Fri, 24 Jul 2009 21:48:44 -0700
From: Greg KH <greg@kroah.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, stern@rowland.harvard.edu
Subject: Re: [PATCH] tty: Fix a USB serial crash/scribble
Message-ID: <20090725044844.GC19432@kroah.com>
References: <20090722093735.27118.36158.stgit@localhost.localdomain>
 <20090722101631.GG13236@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090722101631.GG13236@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 12:16:31PM +0200, Daniel Mack wrote:
> On Wed, Jul 22, 2009 at 10:39:51AM +0100, Alan Cox wrote:
> > See if this one looks sensible. It does leave a tiny race window but that
> > semes wiser than hacking up the tty kref_put path in the middle of an -rc
> > series.
> > 
> > Thanks to Daniel and Alan Stern for chasing this down and getting traces. Also
> > to Daniel for being persistent when I took it as a random odd "only seen by one
> > user" error which it wasn't.
> 
> Thanks Alan for your patience. You know the tty layer well which I have
> no clue of, so I missed the bits in the close callback.
> 
> I tested your patch and can confirm it fixes the problem for me.
> 
> Daniel
> 
> 
> 
> > The port lock is used to protect the port state. However the port structure
> > is freed on a hangup, then the lock taken on a close. The right fix is to
> > drop the port on tty->shutdown() but we can't yet do that due to sleep v
> > non-sleeping rules. Instead do the next best thing and fix it up when we are
> > not in -rc season.
> > 
> > Reported-by: Daniel Mack <daniel@caiaq.de>
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> Tested-by: Daniel Mack <daniel@caiaq.de>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

Alan, do you want me to send this to Linus, or will you?

thanks,

greg k-h
