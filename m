Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbXIETq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbXIETq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223AbXIETqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:46:46 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38388 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbXIETqp (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:46:45 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc4-mm1 - git-alsa.patch breaks audio on Dell Latitude D820
In-Reply-To: Your message of "Fri, 31 Aug 2007 21:58:22 PDT."
             <20070831215822.26e1432b.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1189021594_2892P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Sep 2007 15:46:34 -0400
Message-ID: <4658.1189021594@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1189021594_2892P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <4647.1189021586.1@turing-police.cc.vt.edu>

On Fri, 31 Aug 2007 21:58:22 PDT, Andrew Morton said: 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc4/2.6.23-rc4-mm1/

git-alsa.patch breaks audio on my laptop, worked fine in -rc3-mm1.  Almost
certainly bustification in the Intel HDA rewrite.

Symptoms:  alsamixer finds the chipset, can adjust the volumes and mute/unmute,
and /usr/bin/play is able to write a .wav to the ALSA device without complaint.
However, no sound actually comes out.  Very "lights are on but nobody is home".

Dell Latitude D820, lspci reports:

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
and alsamixer reports finding a "SigmaTel STAC9200"

% grep HDA_ .config
CONFIG_SND_HDA_INTEL=y
# CONFIG_SND_HDA_HWDEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
# CONFIG_SND_HDA_CODEC_VIA is not set
# CONFIG_SND_HDA_CODEC_ATIHDMI is not set
# CONFIG_SND_HDA_CODEC_CONEXANT is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
# CONFIG_SND_HDA_CODEC_SI3054 is not set
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set

dmesg under -rc4-mm1:
Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
hda_intel: position_fix set to 1 for device 1028:01cc
ALSA device list:
  #0: HDA Intel at 0xefffc000 irq 506

dmesg under -rc3-mm1:

Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
hda_intel: position_fix set to 1 for device 1028:01cc
ALSA device list:
  #0: HDA Intel at 0xefffc000 irq 506

(Yes, they look the same to me, too...)

I'd provide more info, if I had a clue what else to add...

 


--==_Exmh_1189021594_2892P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG3weacC3lWbTT17ARAvMrAJ9dn+tdKYx5VHtquT2SerodSOMzQwCgvD9e
CnD1eDwGYsJQ99FmDM0y5rk=
=qHaV
-----END PGP SIGNATURE-----

--==_Exmh_1189021594_2892P--
