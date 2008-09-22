Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbYIVViS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbYIVViS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYIVViI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:38:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:25743 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYIVViF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:38:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=nP1tS2MLqFrg1P8TlDElxbfv+H+Js5uX8X7Wy6CUdkf2Zn55kYR2jHVjO/H8HPNyXn
         qYhbFy+QFYWS8En7Xof1Cll+S9+rEyBWQ6zn2Toa1Wqp2Oz7lPiioqQYwYrHH/2Rf3Dx
         pIHbL4BIJ7UsZqwu7lI8LbOEwc9+t2r5S0T18=
Message-ID: <48D81035.8060702@gmail.com>
Date: Mon, 22 Sep 2008 22:37:57 +0100
From: Antonio Cardoso Martins <digiplan.pt@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel does not boot since 2.6.25 (under IBM Netvista N2200)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have compiled many custom kernels for the IBM Netvista N2200 (8363).  http://jeanchristophe.duber.free.fr/netvista_8363/
This is a thin client, that does not have a BIOS, just a simple firmware, and is able to boot a linux kernel with the following requirements:

- Kernel cannot be compressed;
- Kernel must be in .ELF format;
- ELF program-header-count (offset 0x2c) must have the value 1;
- Filesystem must be ext2, and kernel must have the name kernel.2x00 and lie in the root directory;
- Kernel command line parameters are not possible, as the firmware cannot handle them;

I must patch drivers/video/geode/gx1fb_core.c
static char mode_option[32] = "640x480-16@60";
and changed to
static char mode_option[32] = "1024x768-16@60";

also arch/x86/kernel/setup.c
ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
and change it to
ROOT_DEV = Root_SDA1;

And use a custom .config file, like the one in http://www.urbana.fm/~antocm/files/netvista-2200/N2200-openSUSE-10.3-v3/config-linux-2.6.24.7-N2200-RT
Also note that this Geode GX1 machine with Cyrix Cx5530 has no serial ports, PS/2 keyboard or mouse plugs. It has just two USB ports, one VGA, one Ethernet RJ-45 and one Compact Flash adapter to IDE in the motherboard.

However, since kernel 2.6.24.7 that i am not able to boot the kernel anymore. It stops right after being copied to RAM. I would say that the kernel don't even start, because the message "Software is Loading..." just stays on-screen.

I have tried 2.6.25, 2.6.25.2, 2.6.26.3 and 2.6.27-rc7 with no success on any of them.

I would say something has changed in the ELF format since 2.6.25.

Could anyone give me some hints on this? There is a small but strong community holding on to this Penguin.

Best regards

-- 
-----------------------------------------
Antonio Cardoso Martins
        digiplan.pt@gmail.com
Homepage: http://urbana.fm/~antocm
-----------------------------------------

