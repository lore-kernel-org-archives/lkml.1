Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbYASG3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYASG3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 01:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYASG3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 01:29:16 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:23185 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYASG3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 01:29:15 -0500
Date: Sat, 19 Jan 2008 07:29:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: travis@sgi.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Cc: dada1@cosmosbay.com, clameter@sgi.com
Subject: " Change size of node ids from u8 to u16 fixup" causes early panic in __build_all_zonelists
Message-ID: <20080119062912.GA15850@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 19 Jan 2008 06:23:00.0917 (UTC) FILETIME=[BD97E650:01C85A63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One of my test systems didn't boot with latest git-x86.
I bisected it down to f1321f875910172bcc3e1f302fe145a9e4d3bdf7

With later patches the fault seemed to happen even earlier before
other initialization messages.

Config is available at http://halobates.de/config

-Andi

commit f1321f875910172bcc3e1f302fe145a9e4d3bdf7
Author: travis@sgi.com <travis@sgi.com>
Date:   Fri Jan 18 23:05:33 2008 +0100

    x86: Change size of node ids from u8 to u16 fixup
    
    Change the size of node ids for X86_64 from 8 bits to 16 bits
    to accomodate more than 256 nodes.
    
    Introduce a "numanode_t" type for x86-generic usage.
...

swsusp: Registered nosave memory region: 00000000ff700000 - 0000000100000000
Allocating PCI resources starting at e2000000 (gap: e0000000:1ec00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 34912 bytes of per cpu data
PANIC: early exception 0e rip 10:ffffffff802602cd error 0 cr2 6b0
Pid: 0, comm: swapper Not tainted 2.6.24-rc8-g3c2d7552 #27

Call Trace:
 [<ffffffff802602cd>] __build_all_zonelists+0x2a9/0x40a
 [<ffffffff80260110>] __build_all_zonelists+0xec/0x40a
 [<ffffffff802605ce>] build_all_zonelists+0x1a0/0x244
 [<ffffffff80811950>] start_kernel+0x110/0x2bd
 [<ffffffff808111c6>] _sinittext+0x1c6/0x1cd

RIP 0x10



