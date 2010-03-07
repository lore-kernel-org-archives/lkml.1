Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab0CGTVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 14:21:41 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65423 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0CGTVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 14:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Lv3oPZAon9ZQisUBleQFXMWZ6TU9jRyoTuhCjmjEqiaA7I9QEw//4EfqnO4WarpQFU
         Waz1PHtI7UFt/FoyT0Q+DRUMEzSkq5svduHotp1iUmSmDcXTTxCuEA1N/8oslt4W6p7g
         zrhDt8G2mNxN/GN5da+PQaICsevKiTd3ptbGE=
MIME-Version: 1.0
In-Reply-To: <6B4D417B830BC44B8026029FD256F7F1C16B1AD558@HKMAIL01.nvidia.com>
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
Date: Sun, 7 Mar 2010 11:21:38 -0800
Message-ID: <a3ef07921003071121r24979a0breac27e3b0475bbcb@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH]Support MCP89 and GT21x hdmi audio
From: VDR User <user.vdr@gmail.com>
To: Wei Ni <wni@nvidia.com>
Cc: Takashi Iwai <tiwai@suse.de>, akpm <akpm@linux-foundation.org>,
       alsa-devel <alsa-devel@alsa-project.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pavel Hofman <pavel.hofman@insite.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
