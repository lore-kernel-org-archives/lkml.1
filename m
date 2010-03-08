Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0CHEkc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 23:40:32 -0500
Received: from hqemgate03.nvidia.com ([216.228.112.145]:4764 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab0CHEkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 23:40:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Sun, 07 Mar 2010 20:40:24 -0800
From: Wei Ni <wni@nvidia.com>
To: "'VDR User'" <user.vdr@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>, akpm <akpm@linux-foundation.org>,
       alsa-devel <alsa-devel@alsa-project.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Hofman <pavel.hofman@insite.cz>
Date: Mon, 8 Mar 2010 12:35:37 +0800
Subject: RE: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
Thread-Topic: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
Thread-Index: Acq+K3SHF3yVv+OnSc+FoQV3ZdgjzQATJnhw
Message-ID: <6B4D417B830BC44B8026029FD256F7F1C16B1AD562@HKMAIL01.nvidia.com>
References: <6B4D417B830BC44B8026029FD256F7F1C068B2BA8B@HKMAIL01.nvidia.com>
	 <6B4D417B830BC44B8026029FD256F7F1C16B1AD554@HKMAIL01.nvidia.com>
	 <s5h1vg0qrrr.wl%tiwai@suse.de>
	 <6B4D417B830BC44B8026029FD256F7F1C16B1AD555@HKMAIL01.nvidia.com>
	 <s5hwrxspblg.wl%tiwai@suse.de>
	 <6B4D417B830BC44B8026029FD256F7F1C16B1AD556@HKMAIL01.nvidia.com>
	 <s5htyswpb18.wl%tiwai@suse.de>
	 <6B4D417B830BC44B8026029FD256F7F1C16B1AD557@HKMAIL01.nvidia.com>
	 <s5hvddcnlr6.wl%tiwai@suse.de>
	 <6B4D417B830BC44B8026029FD256F7F1C16B1AD558@HKMAIL01.nvidia.com>
 <a3ef07921003071121r24979a0breac27e3b0475bbcb@mail.gmail.com>
In-Reply-To: <a3ef07921003071121r24979a0breac27e3b0475bbcb@mail.gmail.com>
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

Hi,
Because I don't have GT220 card on hand, I didn't test it yet.
So I didn't add this card to the patch file. I think you could add it after
you test it.

About the warning messages, I don't know why.
May be some others can answer.

Thanks
Wei.
nvpublic

-----Original Message-----
From: VDR User [mailto:user.vdr@gmail.com] 
Sent: Monday, March 08, 2010 3:22 AM
To: Wei Ni
Cc: Takashi Iwai; akpm; alsa-devel; Wu Fengguang; linux-kernel; Pavel Hofman
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio

I think this may be relevant to this subject, if not then my apologies.

I've just installed a GT220 card and was able to get audio-over-hdmi
working by compiling the snapshot drivers from 20100307 which contain
Wei's new code.  I further had to patch the driver to recognize my
card with:

--- alsa-driver-orig/alsa-kernel/pci/hda/patch_nvhdmi.c 2010-03-06
18:00:12.000000000 -0800
+++ alsa-driver/alsa-kernel/pci/hda/patch_nvhdmi.c      2010-03-06
18:02:00.000000000 -0800
@@ -1335,6 +1335,8 @@ static struct hda_codec_preset snd_hda_p
          .patch = patch_nvhdmi_8ch_89 },
        { .id = 0x10de000b, .name = "GT21x HDMI",
          .patch = patch_nvhdmi_8ch_89 },
+       { .id = 0x10de000a, .name = "GT220 HDMI",
+         .patch = patch_nvhdmi_8ch_89 },
        { .id = 0x10de000d, .name = "GT240 HDMI",
          .patch = patch_nvhdmi_8ch_89 },
        {} /* terminator */
@@ -1347,6 +1349,7 @@ MODULE_ALIAS("snd-hda-codec-id:10de0006"
 MODULE_ALIAS("snd-hda-codec-id:10de0007");
 MODULE_ALIAS("snd-hda-codec-id:10de0067");
 MODULE_ALIAS("snd-hda-codec-id:10de8001");
+MODULE_ALIAS("snd-hda-codec-id:10de000a");
 MODULE_ALIAS("snd-hda-codec-id:10de000c");
 MODULE_ALIAS("snd-hda-codec-id:10de000b");
 MODULE_ALIAS("snd-hda-codec-id:10de000d");

This seems to work fine when running VDR but if I do anything else
like upgrade packages, compile something, or maybe create a bz2, then
I start to see _a lot_ of the following in my xine log:

pcm_hw.c: snd_pcm_hw_delay() SNDRV_PCM_IOCTL_DELAY failed.

With the old code this didn't happen.  However, my setup was an 8400gs
using SPDIF OUT from my mainboard to SPDIF IN on the card.  Then using
a dvi->hdmi cable into the tv.

Again, I apologize if I'm posting this in the wrong place.

Best regards.
