Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbXHFQPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbXHFQPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 12:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbXHFQPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 12:15:32 -0400
Received: from jan-robben.demon.nl ([83.160.142.71]:56679 "EHLO mail.robben.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbXHFQPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 12:15:31 -0400
Message-ID: <46B7491F.2020105@gert.robben.nu>
Date: Mon, 06 Aug 2007 18:15:27 +0200
From: Gert Robben <lkml@gert.robben.nu>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       mjander@embedded.cl
Subject: Re: [alsa-devel] PROBLEM: snd-au8830: dead after software suspend
References: <46B3A4F5.2000708@gert.robben.nu>	<46B3C44D.7020801@gert.robben.nu>	<46B3CDA0.90804@gert.robben.nu> <s5h7io8er3n.wl%tiwai@suse.de>
In-Reply-To: <s5h7io8er3n.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> The below is an untested fix.  Give it a try.
With the patch, things seem to be much better (but I'm no expert).

The things remaining seem to be:
- sound can't be heard
- MPlayer gives an error, instead of doing nothing.

I've enabled debugging, and did the following, without and with the patch:
boot, mplayer start+pause, suspend, resume, mplayer unpause+exit+start+exit,
rmmod.

Below is an edited diff of the dmesges (printk's begin with a "k"),
without and with the patch, with my comments added. I hope this is 
enough info. If you need the full dmesges, let me know.

Anyway, thanks for you work :)

Gert Robben

--- without patch
+++ with patch
  initial boot:
  k ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 19 (level, low) -> IRQ 19
  k Vortex: init.... <3>ALSA sound/core/control.c:331: control 3:0:0:Play
  k back PCM advanced processing:0 is already present
  k done.
-k PCI driver au8830 lacks driver specific resume support.
  during suspend:
+k Vortex: shutdown...<6>done.
+k ACPI: PCI interrupt for device 0000:00:11.0 disabled
  during resume:
+k PM: Writing back config space on device 0000:00:11.0 at offset 1 (was
  k  2900007, writing 2900003)
  k ACPI: PCI Interrupt 0000:00:11.0[A] -> GSI 19 (level, low) -> IRQ 19
+k Vortex: init.... <6>ata1.00: configured for UDMA/33
+k ALSA sound/core/control.c:331: control 3:0:0:Playback PCM advanced pr
  k ocessing:0 is already present
+k done.
  mplayer unpause:
+- gives mplayer error: alsa-lib: pcm_hw.c:612(snd_pcm_hw_pause) SNDRV_P
    CM_IOCTL_PAUSE failed: File descriptor in bad state
  - nothing else happens
  mplayer exit:
+k vortex_adb_delroutes: route not found! 0x40
+k vortex_adb_delroutes: route not found! 0x2060
  k src alarm
+k vortex_adb_delroutes: route not found! 0x41
+k vortex_adb_delroutes: route not found! 0x2161
  k src alarm
  mplayer start:
-- nothing happens
+- mplayer seems to play fine, but no sound can be heard
  rmmod:
-k vortex: ac97 codec stuck busy
-k vortex: ac97 codec stuck busy
-k vortex: ac97 codec stuck busy
-k vortex: ac97 codec stuck busy
  k analog.c: 0 out of 0 reads (0%) on pci0000:00:11.0/gameport0 failed
-k Vortex: shutdown...<3>mix ALARM 0
-k mix ALARM 0
-k mix ALARM 0
-k mix ALARM 0
-k mix ALARM 0
-k mix ALARM 0
-k done.
+k Vortex: shutdown...<6>done.
  k ACPI: PCI interrupt for device 0000:00:11.0 disabled
