Return-Path: <linux-kernel-owner+w=401wt.eu-S1762254AbXJRCgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254AbXJRCgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbXJRCf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:35:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60980 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbXJRCf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:35:59 -0400
Message-ID: <4716C68C.4030504@garzik.org>
Date: Wed, 17 Oct 2007 22:35:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: hda-intel: no soundcard with current linus' git tree
References: <471538C2.80806@m3y3r.de>
In-Reply-To: <471538C2.80806@m3y3r.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> $ dmesg
> 
> [schnipp]
> 
> ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
> PCI: Enabling bus mastering for device 0000:00:1b.0
> PCI: Setting latency timer of device 0000:00:1b.0 to 64
> hda_codec: STAC922x, Apple subsys_id=106b0200
> ACPI: PCI interrupt for device 0000:00:1b.0 disabled
> HDA Intel: probe of 0000:00:1b.0 failed with error -16
> 
> [schnipp]

My sound ability similarly disappeared an upstream kernel <24 hours old 
(includes the ALSA merge).

[jgarzik@core ~]$ lsmod | grep -i snd
snd_hda_intel         367396  2
snd_pcm_oss            42080  0
snd_mixer_oss          16640  2 snd_pcm_oss
snd_pcm                79624  2 snd_hda_intel,snd_pcm_oss
snd_page_alloc          9040  2 snd_hda_intel,snd_pcm

[jgarzik@core ~]$ lspci | grep -i audio
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
Definition Audio Controller (rev 01)

[jgarzik@core ~]$ dmesg | egrep -i 'snd|hda'
[jgarzik@core ~]$

mplayer says

	AO: [alsa] 48000Hz 2ch s16le (2 bytes per sample)

but no sound is emitted.

Earlier kernels been working fine since hda_intel was introduced.

	Jeff


