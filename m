Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbZHKPjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbZHKPjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZHKPjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:39:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54134 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbZHKPi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:38:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Scholz <scholz@fias.uni-frankfurt.de>
Subject: Re: [Bug #13935] 2.6.31-rcX breaks Apple MightyMouse (Bluetooth version)
Date: Tue, 11 Aug 2009 17:39:36 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Adrian Ulrich" <kernel@blinkenlights.ch>,
       "Jiri Kosina" <jkosina@suse.cz>, Jiri Slaby <jirislaby@gmail.com>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <u1L1PAbl8zG.A.eKD.hj1fKB@chimera> <87hbwewlk4.fsf@scholz.fias.uni-frankfurt.de>
In-Reply-To: <87hbwewlk4.fsf@scholz.fias.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908111739.36791.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 August 2009, Jan Scholz wrote:
> Hi,
> 
> I can confirm the reported bug, but for me reverting fa047e4f6fa63a6 is
> not sufficient. I have to remove the device id of the mighty mouse from
> the hid_blacklist list in drivers/hid/hid-core.c as well, see the patch below.
> 
> Concerning the need for the quirks: I think there might be some
> dependence on the version of X that is used. If I recall correctly, with
> xorg-server-1.3 the quirk "APPLE_INVERT_HWHEEL" was necessary, but this
> changed when I switched to xorg-server-1.5.3, where now horizontal
> scrolling moves in directions you'd expect from vertical scrolling.
> ...but I wouldn't bet on my memory regarding things with xorg-server-1.3
> since it's been quite some time ago and I never really liked the
> horizontal scrolling anyway.

Thanks for the information.

Best,
Rafael


> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13935
> > Subject		: 2.6.31-rcX breaks Apple MightyMouse (Bluetooth version)
> > Submitter	: Adrian Ulrich <kernel@blinkenlights.ch>
> > Date		: 2009-08-08 22:08 (2 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=fa047e4f6fa63a6e9d0ae4d7749538830d14a343
> >
> 
> From b7393ed6dfe00c9e126a2dd34659156548df15cc Mon Sep 17 00:00:00 2001
> From: Jan Scholz <Scholz@fias.uni-frankfurt.de>
> Date: Tue, 11 Aug 2009 14:33:27 +0200
> Subject: [PATCH] HID: commit fa047e4f is incomplete
> 
> Commit fa047e4f6fa63a6e9d0ae4d7749538830d14a343 "HID: fix inverted
> wheel for bluetooth version of apple mighty mouse" is incomplete. If
> we remove Apple MightyMouse (bluetooth version) from the list of
> apple_devices in drivers/hid/hid-apple.c we have to remove it from
> hid_blacklist in drivers/hid/hid-core.c as well.
> 
> Signed-off-by: Jan Scholz <Scholz@fias.uni-frankfurt.de>
> ---
>  drivers/hid/hid-core.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 5eb10c2..047844d 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1319,7 +1319,6 @@ static const struct hid_device_id hid_blacklist[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
>  
> -	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 0x030c) },
>  	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT) },
>  	{ }
>  };
