Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbXLBAOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbXLBAOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 19:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbXLBAO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 19:14:26 -0500
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:51449 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbXLBAOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 19:14:25 -0500
To: linux-kernel@vger.kernel.org
Subject: sym53c8xx2: incredible sloth after parity error / SCSI bus reset
From: Nix <nix@esperi.org.uk>
Emacs: don't cry -- it won't help.
Date: Sun, 02 Dec 2007 00:14:21 +0000
Message-ID: <878x4egdgi.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC--Metrics: hades 1114; Body=1 Fuz1=1 Fuz2=1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

About once a year I get a SCSI parity error on one of my systems (the
only one with SCSI). I presume the cabling is substandard, but given my
coordination deficits and the rarity of the errors I'd do far more
damage replacing it than leaving it be.

I had one of these today.

The system (2.6.23.9) spotted the error, and seemingly recovered:

Dec  1 12:53:40 loki warning: kernel: sym0: SCSI parity error detected: SCR1=132 DBC=50000000 SBCL=0
Dec  1 12:53:40 loki warning: kernel: sym0:0: ERROR (81:0) (8-0-0) (10/9d/0) @ (mem c2800048:ffffffff).
Dec  1 12:53:40 loki warning: kernel: sym0: regdump: da 00 00 9d 47 10 00 0e 00 08 80 00 80 00 0f 0a d0 58 3c 01 02 ff ff ff.
Dec  1 12:53:40 loki warning: kernel: sym0: SCSI BUS reset detected.
Dec  1 12:53:40 loki notice: kernel: sym0: SCSI BUS has been reset.

However, after that reset I/O to any device on that controller is
*incredibly* slow.

A monthly RAID check kicked off shortly afterwards and provided my first
clue. Load average >15, and:

md1 : active raid5 sda6[0] hdc5[3] sdb6[1]
      76807296 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      [========>............]  check = 42.8% (16450780/38403648) finish=253.3min speed=1442K/sec

1442Kb/s is a bit less than I'd expect from a three-drive array with
disks capable of 40Mb/s easily.

/dev/sda:
 Timing buffered disk reads:    8 MB in  3.50 seconds =   2.29 MB/sec

A somewhat slower ATAPI disk on the same machine:

/dev/hdc:
 Timing buffered disk reads:  110 MB in  3.05 seconds =  36.08 MB/sec

So, um, what could cause this? Can I speed it up again other than by
rebooting (which I'm just about to do, but it is annoying).

-- 
`Some people don't think performance issues are "real bugs", and I think 
such people shouldn't be allowed to program.' --- Linus Torvalds
