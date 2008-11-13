Return-Path: <linux-kernel-owner+w=401wt.eu-S1755144AbYKMU5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144AbYKMU5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 15:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYKMU5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 15:57:34 -0500
Received: from styx.suse.cz ([82.119.242.94]:56962 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751595AbYKMU5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 15:57:34 -0500
Date: Thu, 13 Nov 2008 21:57:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>
cc: oprofile-list@lists.sf.net, Jiri Benc <jbenc@suse.cz>,
       Vilem Marsik <vmarsik@suse.cz>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Oprofile [still] doesn't work on 2.6.28-rc4 on certain CPU
Message-ID: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

there has been a bug [1] recently which caused NMIs to be stuck on certain 
Intel CPUs, resultung in oprofile not working.

This has been fixed by 

	commit 7c64ade53a6f977d73f16243865c42ceae999aea
	Author: Andi Kleen <andi@firstfloor.org>
	Date:   Fri Nov 7 14:02:49 2008 +0100

		oprofile: Fix p6 counter overflow check

but we are seeing the very same symptoms still on the following CPU, even 
with 2.6.28-rc4 (which includes 7c64ade5):

	processor       : 0
	vendor_id       : AuthenticAMD
	cpu family      : 15
	model           : 47
	model name      : AMD Athlon(tm) 64 Processor 3000+
	stepping        : 0

After starting oprofile, no NMI is delivered at all:

	vulture:~ # opcontrol --start
	Using 2.6+ OProfile kernel interface.
	Reading module info.
	Using log file /var/lib/oprofile/samples/oprofiled.log
	Daemon started.
	Profiler running.
	vulture:~ # grep NMI /proc/interrupts
	NMI:          0   Non-maskable interrupts
	vulture:~ # grep NMI /proc/interrupts
	NMI:          0   Non-maskable interrupts

on a quite similar CPU, everything seems to be working smoothly though 
with the very same kernel -- NMIs are being delivered, and oprofile 
performs proper profiling:

	processor       : 0
	vendor_id       : AuthenticAMD
	cpu family      : 15
	model           : 4
	model name      : AMD Athlon(tm) 64 Processor 3000+
	stepping        : 8

I haven't yet found a time to start bisecting this.

[1] http://lkml.org/lkml/2008/10/30/319

-- 
Jiri Kosina
SUSE Labs
