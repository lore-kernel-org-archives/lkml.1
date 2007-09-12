Return-Path: <linux-kernel-owner+w=401wt.eu-S968313AbXILOBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968313AbXILOBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757610AbXILOBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:01:03 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47402 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbXILOBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:01:01 -0400
Date: Wed, 12 Sep 2007 15:00:59 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Michael Haas <laga@laga.ath.cx>
cc: linux-kernel@vger.kernel.org
Subject: Re: Problem: screen partially garbled in i830m (regression)
In-Reply-To: <46E7D5AD.7040605@laga.ath.cx>
Message-ID: <Pine.LNX.4.64.0709121458410.12658@skynet.skynet.ie>
References: <46E7D5AD.7040605@laga.ath.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I sent this mail to David Airlie two weeks ago but I haven't gotten a
> reply so far, that's why I'm posting to LKML this time.  Short summary:
> 874808c6dd429f7431b906a32c7f78a68e7636af broke intel_agp.ko for me, I'm
> getting a garbled screen.

I'm travelling, and I'll try and get Zhenyu to take a look at what he 
changed.. but he is also travelling...

We probably need two defines..

Dave.

>
>
> --------------------------------
>
> Hello David,
>
> with recent kernels, there seems to be a problem with agpgart for my
> i830m chipset. The upper part of the screen is garbled, e.g. I can make
> out parts of the image that is to be displayed, but it's chopped and
> repeated. The box with which I'm having this problem is a not a regular
> PC, but a x86-based set top box called S100. It's got a fanless Celeron
> 733 MHz and 128M RAM and it's somewhat popular due to its cheapness.
> Just makes a nice living-room computer :)  I'll attach the output of
> lspci -vvv.
> FYI, I'm not using the official X.org driver but its IEGD counterpart.
> Unfortunately, the S100 comes with a TV-out encoder chip that's only
> supported by their closed source driver. Since the kernel is not tainted
> by that, it shouldn't be a problem - similar problems also occur with
> X.org drivers.
>
> With working kernels, I'd get the following messages in dmesg:
>
> <--snip-->
> [   40.188375] agpgart: Detected an Intel 830M Chipset.
> [   40.188741] agpgart: Detected 380K stolen memory.
> [   40.199908] agpgart: AGP aperture is 128M @ 0xf0000000
> <--snap-->
>
> A broken kernel will result in the following messages:
>
> <--snip-->
> Jul 25 16:29:42 mythbuntu-alpha2 kernel: [   44.941473] Linux agpgart
> interface v0.102 (c) Dave Jones
> Jul 25 16:29:42 mythbuntu-alpha2 kernel: [   44.957021] agpgart:
> Detected an Intel 830M Chipset.
> Jul 25 16:29:42 mythbuntu-alpha2 kernel: [   44.957605] agpgart: No
> pre-allocated video memory detected.
> Jul 25 16:29:42 mythbuntu-alpha2 kernel: [   44.968696] agpgart: AGP
> aperture is 128M @ 0xf0000000
> <--snap-->
>
> I used git-bisect to narrow down change that introduced this problem and
> came up with this:
>
> <--snip-->
>
> 874808c6dd429f7431b906a32c7f78a68e7636af is first bad commit
> commit 874808c6dd429f7431b906a32c7f78a68e7636af
> Author: Wang Zhenyu <zhenyu.z.wang@intel.com>
> Date:   Wed Jun 6 11:16:25 2007 +0800
>
>  [AGPGART] intel_agp: Add support for G33, Q33 and Q35 chipsets
>
>  This patch adds pci ids for G33, Q33 and Q35 chips, and update with new
>  GTT size and stolen mem size detect method on these chips.
>
>  Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
>  Signed-off-by: Dave Jones <davej@redhat.com>
>
> :040000 040000 39b18b6860f139cb28a80020dc9347314753e16d
> da24fb8672087cdfe6509cd1d4cb189534f887d6 M  drivers
> <--snap-->
>
> Particulary, there's a change to agp.h:
>
> <--snip-->
> -#define I830_GMCH_GMS_MASK  0x70
> +#define I830_GMCH_GMS_MASK  0xF0
> <--snap-->
>
> I reverted this change in my git tree and I'm now running
> 2.6.23-rc3-gb377fd39-dirty without any distortion at all. Do you think
> this can be fixed? I'll be glad to provide more Information. Thank you
> for your time!
>
>
> Regards,
>
> Michael
>
>
>
>
>
