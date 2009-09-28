Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbZI1UTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbZI1UTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbZI1UTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:19:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38408 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbZI1UTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:19:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] [PATCH, fix] Re: [Regression] 2.6.31-git: tty change broke resume from hibernation on MSI Wind U100
Date: Mon, 28 Sep 2009 22:20:32 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0909280202280.14348-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0909280202280.14348-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909282220.32582.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 September 2009, Alan Stern wrote:
> On Mon, 28 Sep 2009, Dave Young wrote:
> 
> > On Mon, Sep 28, 2009 at 2:16 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Sunday 27 September 2009, Alan Stern wrote:
> > >> On Sun, 27 Sep 2009, Rafael J. Wysocki wrote:
> > >>
> > >> > Tested, works.
> > >> >
> > >> > Greg, could you please consider taking the patch below? Â It fixes a recent
> > >> > hibernation regression for me, so if not this one, another fix is necessary.
> > >>
> > >> This patch has a mistake.
> > >>
> > >> > Index: linux-2.6/drivers/usb/serial/usb-serial.c
> > >> > ===================================================================
> > >> > --- linux-2.6.orig/drivers/usb/serial/usb-serial.c
> > >> > +++ linux-2.6/drivers/usb/serial/usb-serial.c
> > >> > @@ -1210,7 +1210,7 @@ static const struct tty_operations seria
> > >> > Â  Â  .chars_in_buffer = Â  Â  Â serial_chars_in_buffer,
> > >> > Â  Â  .tiocmget = Â  Â  Â  Â  Â  Â  serial_tiocmget,
> > >> > Â  Â  .tiocmset = Â  Â  Â  Â  Â  Â  serial_tiocmset,
> > >> > - Â  .shutdown = Â  Â  Â  Â  Â  Â  serial_release,
> > >> > + Â  .cleanup = Â  Â  Â  Â  Â  Â  Â serial_release,
> > >> > Â  Â  .install = Â  Â  Â  Â  Â  Â  Â serial_install,
> > >> > Â  Â  .proc_fops = Â  Â  Â  Â  Â  Â &serial_proc_fops,
> > >> > Â };
> > >>
> > >> It isn't enough to change the method pointer. Â The code in
> > >> serial_release() has to be changed too; it must not call tty_shutdown()
> > >> any more.
> > >
> > > Would it be sufficient to remove the tty_shutdown() call from
> > > serial_release()?
> > 
> > I think so, because standard shutdown will be called in queue_release_one_tty.
> > 
> > Alan, could you confirm about this?  Thus I'd like to update the patch.
> 
> Yes, that's right.  Just remove the function call.  But what happens if
> the device is a serial console?  Shouldn't the call to tty_shutdown()  
> be skipped in that case?  (Eventually this won't matter; the console
> code will be straightened out so that we never release a serial console
> device.  But for now it's important.)
> 
> If you think it would be appropriate, you could also rename
> serial_release() to serial_cleanup() -- it's up to you.

The patch has been fixed up by Linus and merged as
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f278a2f7bbc2239f479eaf63d0b3ae573b1d746c

If any more fixes are necessary, they'll have to go on top of it.

Best,
Rafael
