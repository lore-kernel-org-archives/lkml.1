Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725Ab0AVXwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab0AVXwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611Ab0AVXwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:52:14 -0500
Received: from borg.medozas.de ([188.40.89.202]:33077 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab0AVXwN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:52:13 -0500
Date: Sat, 23 Jan 2010 00:52:10 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: jens.axboe@oracle.com
Subject: kswapd continuously active
Message-ID: <alpine.LSU.2.01.1001230037350.20442@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


with 2.6.32.2 on sparc64 I am seeing that there is a sync(1) process 
busy in D state, with the following trace:

sync          D 000000000079299c  7552  4851      1 0x208061101000004
Call Trace:
 [000000000053ca58] bdi_sched_wait+0xc/0x1c
 [000000000079299c] __wait_on_bit+0x58/0xb8
 [0000000000792a5c] out_of_line_wait_on_bit+0x60/0x74
 [000000000053ca3c] bdi_sync_writeback+0x6c/0x7c
 [000000000053ca78] sync_inodes_sb+0x10/0xfc
 [0000000000540dd0] __sync_filesystem+0x50/0x88
 [0000000000540ec8] sync_filesystems+0xc0/0x124
 [0000000000540f80] sys_sync+0x1c/0x48
 [0000000000406294] linux_sparc_syscall+0x34/0x44

kswapd is also active all the time, writing something to disk - LED is 
blinking, and that's been going on for over half an hour despite the box 
being not busy. How do I see what kswapd is still flushing to disk? Even 
if all RAM (8 GB) was filled with dirty data, syncing it out would not 
take that long - that is to say, the sync process should have long 
exited.
