Return-Path: <linux-kernel-owner+w=401wt.eu-S1759417AbXLLL3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417AbXLLL3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXLLL3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:29:22 -0500
Received: from science.horizon.com ([192.35.100.1]:18415 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752613AbXLLL3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:29:22 -0500
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2007 06:29:21 EST
Date: 12 Dec 2007 06:20:49 -0500
Message-ID: <20071212112049.17891.qmail@science.horizon.com>
From: linux@horizon.com
To: linux-kernel@vger.kernel.org, rene.herman@gmail.com
Subject: Re: [RFT] Port 0x80 I/O speed
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a variety of machines:

600 MHz PIII (Katmai), 440BX chipset, 82371AB/EB/MB PIIX4 ISA bridge:
cycles: out 794, in 348
cycles: out 791, in 348
cycles: out 791, in 349
cycles: out 791, in 348
cycles: out 791, in 348

433 MHz Celeron (Mendocino), 440 BX chipset, same ISA bridge:
cycles: out 624, in 297
cycles: out 623, in 296
cycles: out 624, in 297
cycles: out 623, in 297
cycles: out 623, in 296

1100 MHz Athlon, nForce2 chipset, nForce2 ISA bridge:
cycles: out 1295, in 1162
cycles: out 1295, in 1162
cycles: out 1295, in 1162
cycles: out 1295, in 1162
cycles: out 1295, in 1162

800 MHz Transmeta Crusoe TM5800, Transmeta/ALi M7101 chipset.
cycles: out 1212, in 388
cycles: out 1195, in 375
cycles: out 1197, in 377
cycles: out 1196, in 376
cycles: out 1196, in 377

2200 MHz Athlon 64, K8T890 chipset, VT8237 ISA bridge:
cycles: out 1844674407370814, in 1844674407365758
cycles: out 1844674407370813, in 1844674407365756
cycles: out 1844674407370805, in 1844674407365750
cycles: out 1844674407370813, in 1844674407365755
cycles: out 1844674407370814, in 1844674407365756

Um, huh?  That's gcc 4.2.3 (Debian version 4.2.2-4), -O2.  Very odd.

I can run it with -O0:
cycles: out 4894, in 4894
cycles: out 4905, in 4917
cycles: out 4910, in 4896
cycles: out 4909, in 4896
cycles: out 4894, in 4898
cycles: out 4911, in 4898

or with -O2 -m32:
cycles: out 4914, in 4927
cycles: out 4913, in 4927
cycles: out 4913, in 4913
cycles: out 4914, in 4913
cycles: out 4913, in 4929
cycles: out 4912, in 4912
cycles: out 4913, in 4915

With -O2, the cycle counts come out (before division) as
out: 0xFFFFFFFFFFEA6F4F
in:  0xFFFFFFFFFCE68BB6
I think the "A" constraint doesn't work quite the same in
64-bit code.  The compiler seems to be using %rdx rather than
%edx:%eax.
