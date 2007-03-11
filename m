Return-Path: <linux-kernel-owner+w=401wt.eu-S933592AbXCKWnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592AbXCKWnF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 18:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933582AbXCKWnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 18:43:05 -0400
Received: from narn.hozed.org ([209.234.73.39]:57614 "EHLO narn.hozed.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933595AbXCKWnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 18:43:04 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Mar 2007 18:43:03 EDT
Date: Sun, 11 Mar 2007 17:38:02 -0500
From: Troy Benjegerdes <hozer@hozed.org>
To: linux-kernel@vger.kernel.org
Subject: Debugging x86_64 apic & bootup problems on the Cray XD1
Message-ID: <20070311223802.GB27026@narn.hozed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am attempting to make a 2.6.20 kernel boot on a Cray XD1 node with a
Mellanox InfiniBand card installed, however both the ancient supplied
cray 2.6.5 suse derivative, and a 2.6.20 kernel I just booted fail
on APIC initialization.

Below is a diff of boot-up logs from a node without the mellanox IB
card, and one with.. Does anyone have some pointers on debug options I
should start turning on? Is there some way I can disable some of the
memory regions in the infiniband card via some early PCI init code
before APIC's are set up?

  Processor #0 (Bootup-CPU)
  Processor #1
  I/O APIC #8 at 0xFEC00000.
- I/O APIC #11 at 0xFDC00100.    <- with IB card, misses APIC 9 & 10
- I/O APIC #12 at 0xFE400100.
+ I/O APIC #9 at 0xF8900000.
+ I/O APIC #10 at 0xF8901000.
+ I/O APIC #11 at 0xF9400100.
+ I/O APIC #12 at 0xF9C00100.
  Setting APIC routing to flat
  Processors: 2
  Nosave address range: 000000000009f000 - 00000000000a0000
  Nosave address range: 00000000000a0000 - 0000000000100000
  Nosave address range: 0000000000700000 - 0000000000c00000
  Allocating PCI resources starting at 88000000 (gap: 80000000:80000000)
  PERCPU: Allocating 33216 bytes of per cpu data
  Built 2 zonelists.  Total pages: 515735
  Kernel command line: root=/dev/nfs nfsroot=10.128.28.6:/var/opt/p
ce/nodewc/test1/448.5/root,rsize=1500,wsize=1500 rw no-scroll
console=ttyS0,1152                           00 amroot=5 hdb=non
e hdc=none hdd=none noacpi
  ide_setup: hdb=none
  ide_setup: hdc=none
  ide_setup: hdd=none

@@ -55,101 +65,12 @@
  CPU 0: aperture @ 80000000 size 2048 MB
  Aperture beyond 4GB. Ignoring.
  No AGP bridge found
  Memory: 2054720k/2097152k available (2617k kernel code, 36924k re
served, 1287k data, 328k init)
  Calibrating delay using timer specific routine.. 4391.46 BogoMIPS
(lpj=8782926)
  Security Framework v1.0.0 initialized
  Mount-cache hash table entries: 256
  CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
  CPU: L2 Cache: 1024K (64 bytes/line)
  CPU 0/0 -> Node 0
  Freeing SMP alternatives: 32k freed     <- with IB card, hangs here
- Using local APIC timer interrupts.      <- without IB card, continues

