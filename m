Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbXHWJyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbXHWJyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbXHWJy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:54:29 -0400
Received: from fydelkass.inl.fr ([195.101.59.116]:52657 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879AbXHWJy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:54:28 -0400
X-Greylist: delayed 3013 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2007 05:54:28 EDT
Date: Thu, 23 Aug 2007 11:04:14 +0200
From: Pierre Chifflier <p.chifflier@inl.fr>
To: linux-kernel@vger.kernel.org
Subject: intel_rng: FWH not detected (and no entropy)
Message-ID: <20070823090414.GD22638@piche.inl.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: INL
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a problem with a 82801DB chipset, the intel-rng module refuses to
load with the following error:
intel_rng: FWH not detected

The problem is that there is almost no entropy available for
/dev/random, and so SSL operations take a loooooooong time.

I have tried to look at the intel-rng module, and added some debug code
to check for the command results:

intel_rng:   mfc: 0x00ea (should be 0x0089)
intel_rng:   dvc: 0x0045 (should be 0x00ac or 0x00ad)
intel_rng: FWH not detected
intel_rng: XXX Trying to continue anyway
intel_rng:   hw_status: 0x00 (should contain 0x40)

Then, again a -ENODEV.

Tried with 2.6.19.4 and 2.6.22.3, no result. For what I can tell, 2.6.8
had no RNG but had more entropy available.

I'm not sure the mhat a hardware RNG is present, so I want to check.
How can I know if this motherboard contains a RNG ? (which seems not to
be the case). This is a MB for servers (with a compact flash slot), and
has no soudn card, for ex.

lshw shows:
       description: Motherboard
       product: i845GV-83628HF


Alternatively, how can I make more entropy available ? (other than
tricks like using find() or similar, I do not think this is a serious
solution for a server to run "find /" in a cron every minute ..).

Maybe I have not understood, but it seems that entropy generators try to
create a new device /dev/erandom, for ex, so it would need a
modification of applications to work.

Thanks for your help,
Pierre



lspci:
0000:00:1f.0 ISA bridge: Intel Corp. 82801DB/DBL (ICH4/ICH4-L) LPC
Bridge (rev 02)

lspci -s 00:1f.0 -xxx
0000:00:1f.0 ISA bridge: Intel Corp. 82801DB/DBL (ICH4/ICH4-L) LPC
Bridge (rev 02)
00: 86 80 c0 24 0f 00 80 02 02 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 01 40 00 00 10 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 81 40 00 00 10 00 00 00
60: 0c 0a 0b 05 d0 00 00 00 80 80 80 09 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 75 54 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 20 02 00 00 00 00 00 00 0d 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 55 55 41 05 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 86 21 00 00 02 0f 00 00 04 00 00 00 00 00 00 00
e0: 10 00 00 c0 00 00 0f 34 33 22 11 00 91 02 67 45
f0: 0f 00 60 00 00 00 00 00 60 0f 02 00 00 00 81 00

