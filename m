Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbZBIMf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbZBIMf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZBIMfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:35:19 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:32439 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752707AbZBIMfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:35:18 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iYTYb+V2eYedK/RdnvbM3kLoetK8x2CXnVvZitERVSJb9jy+kZZMuNQvGZQlvsS7AHCKBhrgOSO+yoGPz8bhW6YNLICSP/G0dWLUCYSY27Ri5nJlhWsxL0FzA18Vvzm+U8K/IxuMdKKgN0KYd/uP9oBV/D42domclY1Fmo7RmtI=  ;
X-YMail-OSG: 1T7nyLQVM1kcNsF0NqXWybJq8ifBDPQYo23JljfF2MwbPKMIZGWaObvt8EKKu_ZD0tP8p9eMzcGOGzD0f5Y.mEsHOOixLNvqxM_TCWUGOIJggg8b65vBWb.IZZQ78KfBkvsz_wZkehSt1KkoVvzLA1kfOOm8nB8qhshCmnqq8CCPWaMKAhJ6rVHg14gZmQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: wixor <wixorpeek@gmail.com>
Subject: Re: viafb triggers BUG at mm/vmalloc.c:294 [kernel 2.6.28.3]
Date: Mon, 9 Feb 2009 23:34:47 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, JosephChan@via.com.tw,
       linux-kernel@vger.kernel.org
References: <c43b2e150902071144j4f01e754y83205ad8d734fd95@mail.gmail.com> <200902092154.46695.nickpiggin@yahoo.com.au> <c43b2e150902090348r3e88e459j467e47b2e3bc5548@mail.gmail.com>
In-Reply-To: <c43b2e150902090348r3e88e459j467e47b2e3bc5548@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902092334.48635.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 February 2009 22:48:22 wixor wrote:
> Okay, I'm not quite sure what's happening here (i'm not kernel
> developer). That's that I've done:
>     printk(KERN_DEBUG "alloc_vmap_area(%lu, %lu, %p,
> %p)\n",size,align,vstart,vend);
> at the very beginning of alloc_vmap_area,
>     printk(KERN_DEBUG "alloc_vmap_area: allocated %p -
> %p\n",va->va_start, va->va_end);
> at very end and
>         WARN(1,KERN_WARNING "alloc_vmap_area failed\n");

Great, thanks.

alloc_vmap_area(268439552, 524288, f0690000, fffaa000)
vmap allocation failed: use vmalloc=<size> to increase size.
------------[ cut here ]------------
WARNING: at mm/vmalloc.c:395 alloc_vmap_area+0x25d/0x2a0()
alloc_vmap_area failed
Modules linked in: viafb(+) fb i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect 
af_packet p4_clockmod speedstep_lib loop sr_mod cdrom wlan_scan_sta 
snd_hda_intel rtc_cmos rtc_core rtc_lib pcspkr ath_rate_sample snd_pcm psmouse 
ath_pci evdev ehci_hcd snd_timer snd_page_alloc snd_hwdep snd wlan ath_hal(P) 
soundcore uhci_hcd i2c_viapro via_rhine mii i2c_core usbcore pata_via video 
backlight output fan battery ac thermal button processor thermal_sys hwmon 
via_agp agpgart unix
Pid: 1740, comm: modprobe Tainted: P       A   2.6.28.3-dsdt-fix #17
Call Trace:
 [<c01200df>] warn_slowpath+0x6f/0x90
 [<c0243ba0>] vt_console_print+0x0/0x2f0
 [<c0120383>] __call_console_drivers+0x43/0x50
 [<c01111e0>] lapic_next_event+0x10/0x20
...
 [<f08b52ba>] viafb_init+0x2ba/0xf40 [viafb]
 [<c0116e53>] __ioremap_caller+0x1c3/0x350
 [<c0205209>] pci_get_subsys+0x59/0x80
 [<f08b52ba>] viafb_init+0x2ba/0xf40 [viafb]
 [<c0117138>] ioremap_nocache+0x18/0x20
 [<f08b52ba>] viafb_init+0x2ba/0xf40 [viafb]
 [<f08b52ba>] viafb_init+0x2ba/0xf40 [viafb]
 [<f08b5000>] viafb_init+0x0/0xf40 [viafb]
 [<c0101126>] do_one_initcall+0x36/0x1b0

So this path is trying to allocate 256MB of vmalloc space. Even if you did
have enough to satisfy the request, it would leave almost nothing left and
use up a huge amount of precious 32-bit kernel virtual memory.

Does viafb really need to ioremap 256MB? This isn't going to work so 
well on 32-bit systems... Either we should come up with a way to window
into the memory, or otherwise add some sane limits for 32-bit.


> before returning EBUSY. Full dmesg attached. What still bugs me is
> that video ram is allocated from system memory by bios. Does the
> kernel know that and does it try to allocate the framebuffer in that
> "video ram"?

I'm not the one to ask here, but perhaps if you can turn down the memory
size in the BIOS, the driver will use less KVA.

