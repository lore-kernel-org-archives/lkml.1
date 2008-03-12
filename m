Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYCLVpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYCLVpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbYCLVo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:44:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51011 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756149AbYCLVo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:44:57 -0400
Date: Wed, 12 Mar 2008 17:44:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Kosina <jkosina@suse.cz>
cc: Tino Keitel <tino.keitel@gmx.de>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: broken access to a USB HID device after suspend
In-Reply-To: <Pine.LNX.4.64.0803122217580.7266@twin.jikos.cz>
Message-ID: <Pine.LNX.4.44L0.0803121739590.6966-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Jiri Kosina wrote:

> On Wed, 12 Mar 2008, Tino Keitel wrote:
> 
> > I use a tool called hidmon to control the parameters of my LCD in shell
> > scripts. I just had the case where this tool didn't work after suspend
> > to RAM. I just got this error message:
> > 
> > hid_force_open failed with return code 13
> > 
> > The kernel log contains lines like this:
> > 
> > usb 1-1.3: usbfs: USBDEVFS_CONTROL failed cmd hidmon rqt 129 rq 6 len 9 ret -110
> > 
> > Unplugging and replugging the USB cable of the LCD didn't work.
> > However, after a further suspend/resume cycle it works.
> > 
> > This is Linux 2.6.25-rc5. The behaviour is not repoducible, though.
> > However, I just mention it for the case that this might ring a bell
> > somewhere.
> 
> This in fact looks like a problem with usbdevfs and/or libusb library, not 
> the in-kernel HID drvier.
> 
> Did this work before? In 2.6.24? 2.6.23? Alan (added to CC, as well as USB 
> devel mailinglist) has been doing some changes to usbdevfs to make it 
> suspend-aware, if I recall correctly.

No, usbfs hasn't undergone any significant changes recently.

Tino, it would help to see a kernel log showing what happened during 
the suspend, resume, and failure of hidmon.  It would help even more if 
you test under a kernel with CONFIG_USB_DEBUG enabled.

Even if you can't reproduce the problem, do you have the complete 
kernel log from before?

Is it possible that this is really a problem with the LCD device, not 
with the kernel?  I ask because if the device was working properly then 
unplugging and replugging the USB cable should do a complete reset.

Alan Stern

