Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbZI0SOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbZI0SOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 14:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbZI0SOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 14:14:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60760 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbZI0SOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 14:14:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH, fix] Re: [Regression] 2.6.31-git: tty change broke resume from hibernation on MSI Wind U100
Date: Sun, 27 Sep 2009 20:16:04 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Young <hidave.darkstar@gmail.com>
References: <Pine.LNX.4.44L0.0909271329400.5871-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0909271329400.5871-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909272016.04597.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 September 2009, Alan Stern wrote:
> On Sun, 27 Sep 2009, Rafael J. Wysocki wrote:
> 
> > Tested, works.
> > 
> > Greg, could you please consider taking the patch below?  It fixes a recent
> > hibernation regression for me, so if not this one, another fix is necessary.
> 
> This patch has a mistake.
> 
> > Index: linux-2.6/drivers/usb/serial/usb-serial.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/usb/serial/usb-serial.c
> > +++ linux-2.6/drivers/usb/serial/usb-serial.c
> > @@ -1210,7 +1210,7 @@ static const struct tty_operations seria
> >  	.chars_in_buffer =	serial_chars_in_buffer,
> >  	.tiocmget =		serial_tiocmget,
> >  	.tiocmset =		serial_tiocmset,
> > -	.shutdown = 		serial_release,
> > +	.cleanup = 		serial_release,
> >  	.install = 		serial_install,
> >  	.proc_fops =		&serial_proc_fops,
> >  };
> 
> It isn't enough to change the method pointer.  The code in 
> serial_release() has to be changed too; it must not call tty_shutdown() 
> any more.

Would it be sufficient to remove the tty_shutdown() call from
serial_release()?

Rafael
