Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZCIKH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZCIKH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 06:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZCIKHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 06:07:48 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:44886 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbZCIKHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 06:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KmHUfb+08wxwhDoX0weJ0MNIBTXIlInSSAdRbZRxIlLrSKynOGFzsHzCJZQsTS3Mmg
         ACSTTzhmKsqpxY8KwWFL9dPepTYsQPxsXzvczcutjfF0Lw0tD5kdWFfM+K5OHg2xT4e+
         CRwCabDB31vup8jge/jgWYIXUkjfKiTVhR1ok=
Subject: Re: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my
 printer to fail
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0903081243100.5243-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0903081243100.5243-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 12:07:40 +0200
Message-Id: <1236593260.609.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 12:58 -0400, Alan Stern wrote:
> On Sun, 8 Mar 2009, Maxim Levitsky wrote:
> 
> > > No, adding a dependency won't work because it is valid to load 
> > > uhci-hcd without ehci-hcd.  The only time a problem occurs is if you 
> > > load both of them in the wrong order.  (And in fact it's pretty rare 
> > > for that to cause a real problem -- mostly you just get some annoying 
> > > messages in the log.)
> > But since it can cause a problem, this has to be somehow automatically
> > fixed isn't it?
> 
> Can it cause a problem?  I'm not so sure -- it depends on what you mean 
> by "problem".  One person complained forcefully just because he didn't 
> like all the extra "disconnect" messages in the system log, even though 
> everything worked perfectly.
> 
> > For example how to I ensure the correct order with udev?
> 
> You can't.  But you can add rules to /etc/modprobe.conf to insure that 
> ehci-hcd is always loaded before uhci-hcd.
> 
> > > CONFIG_USB_EHCI_ROOT_HUB_TT shouldn't make any difference at all.  
> > > That setting matters only for hardware using the ARC/TDI design, which
> > > is not present in your Intel chipset.  Likewise, provided ehci-hcd is
> > > loaded first, it shouldn't make any difference whether uhci-hcd is
> > > loaded or not.
> > Well, I retest this.
> > But it seems to work
> 
> Best would be if you could send two usbmon traces, one showing the 
> problem and one showing what happens when uhci-hcd isn't loaded but 
> everything else is the same.  For each test, plug in the printer's USB 
> cable after starting the trace.
Will do soon.


> 
> And don't try to confuse matters by querying the printer status while 
> reloading its firmware.
Well, I suspected that there is some concurrent access from both usb
drivers, so I tried all options to crash it....


> Alan Stern
> 

