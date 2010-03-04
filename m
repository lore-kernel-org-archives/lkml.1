Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab0CDCVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 21:21:48 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:7001 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716Ab0CDCVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 21:21:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Wed, 03 Mar 2010 18:21:41 -0800
From: Wei Ni <wni@nvidia.com>
To: "'Takashi Iwai'" <tiwai@suse.de>
CC: "'Pavel Hofman'" <pavel.hofman@insite.cz>,
       "'alsa-devel'" <alsa-devel@alsa-project.org>,
       "'linux-kernel'" <linux-kernel@vger.kernel.org>,
       "'akpm'" <akpm@linux-foundation.org>
Date: Thu, 4 Mar 2010 10:21:39 +0800
Subject: RE: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
Thread-Topic: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
Thread-Index: Acq7G2MmdCDVKmsbStukiqr1IEInhAAI6Fsg
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C16B1AD54C@HKMAIL01.nvidia.com>
References: <6B4D417B830BC44B8026029FD256F7F1C068B2BA8B@HKMAIL01.nvidia.com>
	<s5hmxyrp311.wl%tiwai@suse.de>
	<6B4D417B830BC44B8026029FD256F7F1C068B2BA8C@HKMAIL01.nvidia.com>
	<s5heik3ujy0.wl%tiwai@suse.de>
	<6B4D417B830BC44B8026029FD256F7F1C16A89A118@HKMAIL01.nvidia.com>
	<6B4D417B830BC44B8026029FD256F7F1C16A89A11A@HKMAIL01.nvidia.com>
	<s5haaupoqew.wl%tiwai@suse.de>
	<6B4D417B830BC44B8026029FD256F7F1C16A89A11C@HKMAIL01.nvidia.com>
 <s5htysxm5yo.wl%tiwai@suse.de>
In-Reply-To: <s5htysxm5yo.wl%tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Takashi
1. Yes, it can works for all Nvidia controller.
2. The hda_eld.o doesn't export any symbols.
I tried to put hda_eld.o to snd-had-codec-*, and remove had_eldo.o
from snd-had-codec-intelhdmi-objs, but it will build error. It need
to modify hda_eld.c to export symbols, it will add many changes.

Thanks
Wei.
nvpublic

-----Original Message-----
From: Takashi Iwai [mailto:tiwai@suse.de] 
Sent: Thursday, March 04, 2010 5:49 AM
To: Wei Ni
Cc: 'Pavel Hofman'; 'alsa-devel'; 'linux-kernel'; 'akpm'
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio

At Wed, 3 Mar 2010 15:21:12 +0800,
Wei Ni wrote:
> 
> Hi, Takashi
> I generate the new patch file, please check it.

Thanks.  Review comments below:

> @@ -1367,6 +1368,7 @@ static void azx_bus_reset(struct hda_bus *bus)
>  
>  /* number of codec slots for each chipset: 0 = default slots (i.e. 4) */
>  static unsigned int azx_max_codecs[AZX_NUM_DRIVERS] __devinitdata = {
> +	[AZX_DRIVER_NVIDIA] = 8,

Are you sure that this works for all Nvidia controller chips including
the old nForce chipset?

 
> diff --git a/sound/pci/hda/Makefile b/sound/pci/hda/Makefile
> index 315a1c4..199f440 100644
> --- a/sound/pci/hda/Makefile
> +++ b/sound/pci/hda/Makefile
> @@ -17,7 +17,7 @@ snd-hda-codec-cirrus-objs :=	patch_cirrus.o
>  snd-hda-codec-ca0110-objs :=	patch_ca0110.o
>  snd-hda-codec-conexant-objs :=	patch_conexant.o
>  snd-hda-codec-via-objs :=	patch_via.o
> -snd-hda-codec-nvhdmi-objs :=	patch_nvhdmi.o
> +snd-hda-codec-nvhdmi-objs :=	patch_nvhdmi.o hda_eld.o
>  snd-hda-codec-intelhdmi-objs :=	patch_intelhdmi.o hda_eld.o

This is buggy.  You cannot create multiple modules containing the
same *.o file that exports symbols.

Instead, put hda_eld.o to snd-hda-codec-* (currently commented out),
and remove hda_eld.o from snd-hda-codec-intelhdmi-objs.


Takashi
