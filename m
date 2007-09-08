Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbXIHWPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbXIHWPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 18:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbXIHWP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 18:15:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1440 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753370AbXIHWP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 18:15:26 -0400
Date: Sat, 8 Sep 2007 18:15:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?= <tronic+1kf5@trn.iki.fi>
cc: linux-kernel@vger.kernel.org, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.23-rc3 USB segfaults + urb status -32
In-Reply-To: <46E30F24.3060604@trn.iki.fi>
Message-ID: <Pine.LNX.4.44L0.0709081802500.26094-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007, Lasse Kärkkäinen wrote:

> Sorry about late reply. I have been extremely busy with other things.
> 
> > Does 2.6.22 work fine?
> 
> Not perfect, but it does not crash spontaneously. I have been running
> 2.6.22-ck1 since my last email with only one crash and today I have
> tortured 2.6.22.5 as badly as I can (switching bConfigurationValue of
> the sound card, unplugging USB devices on fly, doing heavy I/O, etc),
> without crashes.
> 
> However, with 2.6.23-rc5 I still got segfaults on boot¹ (log1),

Those were problems with the usb_id program, not problems in the 
kernel.  How up-to-date is your udev installation?

> a few
> dozen urb status -32 messages by powering off the sound card while it
> was in use (log2),

Nothing wrong with that.  You should expect that removing a device 
while it is use would produce a few error messages.

> but no crashes there. It did finally crash (log3),
> though, after about three hours of coding + listening to music on text
> console (no Nvidia drivers nor any other external modules). Apparently
> it reset all USB buses, including the one that my system disk is
> connected to (there is nothing else on the same port), effectively
> killing the system, even though technically it didn't crash.

There's no indication in the log that the disk problem was at all
related to the sound card.  Nor is there any indication that all your
USB buses were affected; only the disk drive got messed up.  The card
reader, the hub, the keyboard, and the mouse all seem to have survived.

> It also seems that .23-rc5 no longer exposes bConfigurationValue and a
> few other settings under /sys/bus/usb/devices/*/,

Sure it does.

> so I couldn't test if
> switching the bConfigurationValue of the sound card still causes
> crashes² there (it has been a reliable way to do that in the past).
> 
> I could not reproduce the excessive log flood of urb status -32,
> mentioned in my original message.
> 
> The logs are here:
> http://delenn.homelinux.net/kernel-usb/
> 
> ¹) I gather that usb_id is something related to udev. It does not crash
> with .22 kernels, only with the .23 series.
> ²) OOPSes, to be specific, IIRC.

The events in your logs are not oopses.  The program segfaults, which
means that the crash occurs in userspace, not while the program is
running in the kernel.

Alan Stern

