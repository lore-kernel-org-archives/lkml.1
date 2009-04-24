Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbZDXOVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbZDXOVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbZDXOVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:21:16 -0400
Received: from eazy.amigager.de ([213.239.192.238]:56898 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757849AbZDXOVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:21:15 -0400
Date: Fri, 24 Apr 2009 16:21:13 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: 2.6.29 regression: left audio channel broken after resume from
	suspend with Intel HDA
Message-ID: <20090424142113.GA18668@dose.home.local>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
References: <20090420184024.GA10155@dose.home.local> <s5hmyab15bh.wl%tiwai@suse.de> <20090420194659.GA11399@dose.home.local> <s5h8wluinon.wl%tiwai@suse.de> <20090421073219.GA5866@dose.home.local> <s5hfxg2cv6m.wl%tiwai@suse.de> <20090421183936.GA21935@dose.home.local> <s5hws9a5ewr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <s5hws9a5ewr.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 24, 2009 at 16:01:40 +0200, Takashi Iwai wrote:

[...]

> The codec communication looks a bit unstable on this device...
> Does this still happen on the latest 2.6.30 version?

Yes, at least with 2.6.30-rc3. I reloaded snd-hda-intel a few times,
and at some point /etc/init.d/alsa-utils start complained, I guess
because some index numbers in  the mixer changed. Attached is an
example diff.

Regards,
Tino

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=diff

--- /tmp/alsa-info.txt1	2009-04-24 16:18:00.908001903 +0200
+++ /tmp/alsa-info.txt2	2009-04-24 16:18:22.558834414 +0200
@@ -3,7 +3,7 @@
 !!ALSA Information Script v 0.4.52
 !!################################
 
-!!Script ran on: Fri Apr 24 16:18:00 CEST 2009
+!!Script ran on: Fri Apr 24 16:18:22 CEST 2009
 
 
 !!Linux Distribution
@@ -93,13 +93,13 @@
 Node 0x02 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
   Amp-Out caps: N/A
   Amp-Out vals:  [0xff 0xff]
-  Converter: stream=0, channel=0
+  Converter: stream=5, channel=0
   Power: setting=D0, actual=D0
   Delay: 13 samples
 Node 0x03 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
   Amp-Out caps: N/A
   Amp-Out vals:  [0xff 0xff]
-  Converter: stream=0, channel=0
+  Converter: stream=5, channel=0
   Power: setting=D0, actual=D0
   Delay: 13 samples
 Node 0x04 [Audio Output] wcaps 0xd0c05: Stereo Amp-Out R/L
@@ -115,7 +115,7 @@
   Power: setting=D0, actual=D0
   Delay: 13 samples
 Node 0x06 [Audio Input] wcaps 0x1d0541: Stereo
-  Converter: stream=0, channel=0
+  Converter: stream=1, channel=0
   SDI-Select: 0
   Power: setting=D0, actual=D0
   Delay: 13 samples
@@ -131,7 +131,7 @@
      0x18
   Processing caps: benign=0, ncoeff=0
 Node 0x08 [Audio Output] wcaps 0x40211: Stereo Digital
-  Converter: stream=0, channel=0
+  Converter: stream=5, channel=0
   Digital: Enabled
   Digital category: 0x0
   PCM:
@@ -281,11 +281,11 @@
 !!ALSA Device nodes
 !!-----------------
 
-crw-rw---- 1 root audio 116,  0 Apr 24 16:16 /dev/snd/controlC0
-crw-rw---- 1 root audio 116, 24 Apr 24 16:16 /dev/snd/pcmC0D0c
-crw-rw---- 1 root audio 116, 16 Apr 24 16:16 /dev/snd/pcmC0D0p
-crw-rw---- 1 root audio 116, 25 Apr 24 16:16 /dev/snd/pcmC0D1c
-crw-rw---- 1 root audio 116, 17 Apr 24 16:16 /dev/snd/pcmC0D1p
+crw-rw---- 1 root audio 116,  0 Apr 24 16:18 /dev/snd/controlC0
+crw-rw---- 1 root audio 116, 24 Apr 24 16:18 /dev/snd/pcmC0D0c
+crw-rw---- 1 root audio 116, 16 Apr 24 16:18 /dev/snd/pcmC0D0p
+crw-rw---- 1 root audio 116, 25 Apr 24 16:18 /dev/snd/pcmC0D1c
+crw-rw---- 1 root audio 116, 17 Apr 24 16:18 /dev/snd/pcmC0D1p
 crw-rw---- 1 root audio 116, 33 Apr 22 12:36 /dev/snd/timer
 
 
@@ -296,7 +296,7 @@
 
 **** List of PLAYBACK Hardware Devices ****
 card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
-  Subdevices: 1/1
+  Subdevices: 0/1
   Subdevice #0: subdevice #0
 card 0: Intel [HDA Intel], device 1: STAC92xx Digital [STAC92xx Digital]
   Subdevices: 1/1
@@ -306,7 +306,7 @@
 
 **** List of CAPTURE Hardware Devices ****
 card 0: Intel [HDA Intel], device 0: STAC92xx Analog [STAC92xx Analog]
-  Subdevices: 2/2
+  Subdevices: 1/2
   Subdevice #0: subdevice #0
   Subdevice #1: subdevice #1
 card 0: Intel [HDA Intel], device 1: STAC92xx Digital [STAC92xx Digital]

--17pEHd4RhPHOinZp--
