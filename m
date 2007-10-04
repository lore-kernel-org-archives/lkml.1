Return-Path: <linux-kernel-owner+w=401wt.eu-S1762207AbXJDLnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207AbXJDLnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761124AbXJDLk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:40:57 -0400
Received: from adsl45-199.ath.forthnet.gr ([77.49.76.199]:42797 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761875AbXJDLk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:40:56 -0400
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Oct 2007 07:40:55 EDT
Message-ID: <4704CFEA.6000307@vergina.dyndns.org>
Date: Thu, 04 Oct 2007 14:35:06 +0300
From: Aggelos Manousidis <agg@vergina.dyndns.org>
Reply-To: agg@vergina.dyndns.org
User-Agent: Thunderbird 2.0.0.6 (X11/20070806)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to reset a sata pcmcia controller port to UDMA/100 ?
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a esata (external) disk drive, which I keep permanently connected
to a sata pcmcia port (using a esata-sata cable). The pcmcia
controller's chipset as reported by lspci is:

02:00.0 Mass storage controller: Silicon Image, Inc. SiI 3112
[SATALink/SATARaid] Serial ATA Controller (rev 02)

and I have built a custom kernel:

laptop ~ # grep -i sil /usr/src/linux/.config
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIL24 is not set
CONFIG_PATA_SIL680=m
# CONFIG_FB_ASILIANT is not set
laptop ~ #

Modules loaded are:
laptop ~ # lsmod
Module                  Size  Used by
af_packet              11272  2
snd_pcm_oss            33952  0
snd_mixer_oss          12640  1 snd_pcm_oss
snd_seq_oss            24768  0
snd_seq_midi_event      5184  1 snd_seq_oss
snd_seq                37424  4 snd_seq_oss,snd_seq_midi_event
snd_seq_device          5804  2 snd_seq_oss,snd_seq
tun                     7296  0
backlight               4032  0
lcd                     3680  0
nfsd                   75240  13
exportfs                3840  1 nfsd
lockd                  52904  2 nfsd
sunrpc                131100  8 nfsd,lockd
usbhid                 14196  0
snd_maestro3           18852  1
snd_ac97_codec         88420  1 snd_maestro3
ac97_bus                1792  1 snd_ac97_codec
snd_pcm                57288  3 snd_pcm_oss,snd_maestro3,snd_ac97_codec
snd_timer              15332  2 snd_seq,snd_pcm
snd_page_alloc          7080  1 snd_pcm
parport_pc             20036  0
parport                18304  1 parport_pc
floppy                 46404  0
i2c_piix4               6860  0
i2c_core               17808  1 i2c_piix4
uhci_hcd               18412  0
usbcore                98872  3 usbhid,uhci_hcd
rtc                     8504  0
intel_agp              19764  1
agpgart                24112  1 intel_agp
unix                   18416  813
laptop ~ #

The problem:
The plug on the pcmcia card seems very sensitive, cause if I try to
touch / slightly move the plug, dmesg gives:

ata4: exception Emask 0x10 SAct 0x0 SErr 0x90000 action 0x2 frozen
ata4: hard resetting port
ata4: port is slow to respond, please be patient (Status 0xff)
ata4: COMRESET failed (errno=-16)
ata4: hard resetting port
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata4.00: configured for UDMA/66
ata4: EH pending after completion, repeating EH (cnt=4)
ata4: EH complete
sd 3:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA

Question: Is there a command to reset the port to UDMA/100 ?
