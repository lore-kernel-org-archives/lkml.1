Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968312Ab0B0NUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 08:20:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45004 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968272Ab0B0NUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 08:20:40 -0500
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Alberto Panizzo <maramaopercheseimorto@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: core i7: hang at Booting processor 5 APIC 0x3 ip 0x6000
From: Andi Kleen <andi@firstfloor.org>
References: <4B687649.5070204@wpkg.org> <4B687EFF.8000202@gmail.com>
	<4B687F77.5020409@wpkg.org> <4B6885FA.80509@gmail.com>
	<1265963139.2484.3.camel@realization> <4B751664.8060603@gmail.com>
	<4B891621.5070807@wpkg.org>
Date: Sat, 27 Feb 2010 14:20:34 +0100
In-Reply-To: <4B891621.5070807@wpkg.org> (Tomasz Chmielewski's message of "Sat, 27 Feb 2010 13:54:57 +0100")
Message-ID: <87k4tyrf19.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski <mangoo@wpkg.org> writes:

> Justin P. Mattock wrote:
>
>> but what about 2.6.33*(hot off of the press thing).
>
> I found a way to 100% reproduce the kernel "hang" while booting
> 2.6.33. The symptoms will look like here:
>
> http://wpkg.org/files/i7_hang/
>
>
> To hang the kernel while booting, just tap repeatedly on the keyboard
> as soon as the bootloader starts loading the kernel.
>
> The kernel hangs for me every time as I do it.
>
> If it matters, I use a USB keyboard (as a matter of fact, two USB
> keyboards are connected as its a multiseat PC, although I tap the keys
> on only one of them).

Points to USB legacy BIOS code problems. FWIW i've seen the same problem
occasionally too, but I can't reproduce it reliably.

You could add some printks to the USB handoff code (and see if that appears
around the hang (drivers/usb/host/pci-quirks.c:quirk_usb_disable_ehci)

-Andi
