Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbYAUCog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbYAUCog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 21:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYAUCo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 21:44:28 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:17371 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYAUCo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 21:44:27 -0500
Date: Mon, 21 Jan 2008 03:44:22 +0100
From: Andi Kleen <andi@firstfloor.org>
To: venkatesh.pallipadi@intel.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: bad page table when accessing /dev/mem in dmidecode
Message-ID: <20080121024422.GA23494@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 21 Jan 2008 02:38:09.0597 (UTC) FILETIME=[A8F756D0:01C85BD6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When booting git-x86 tip 28a0fcd6b38e247200bd857996375aee91eae8ce
on a core2 system the userland running dmidecode at boot hits:

config: 64bit make defconfig

-Andi

Failed services in runlevel 3:                                     acpid
dmidecode: Corrupted page table at address 7f74475d2000
PGD 7b583067 PUD 7b599067 PMD 7b598067 PTE ffffffff000f0025
Bad pagetable: 000d [1] SMP
CPU 0
Modules linked in:
Pid: 2724, comm: dmidecode Not tainted 2.6.24-rc8-g28a0fcd6 #1
RIP: 0033:[<00007f744732423f>]  [<00007f744732423f>]
RSP: 002b:00007fff4f5f1300  EFLAGS: 00010206
RAX: 0000000000d21010 RBX: 00007f74475d2000 RCX: 0000000000001000
RDX: 0000000000010000 RSI: 00007f74475d2000 RDI: 0000000000d21010
RBP: 0000000000000000 R08: 0000000000000000 R09: 00007f74475f1c60
R10: 0000000000000001 R11: 0000000000008000 R12: 0000000000010000
R13: 0000000000000003 R14: 0000000000010000 R15: 00000000004086c4
FS:  00007f74475e26e0(0000) GS:ffffffff80747000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f74475d2000 CR3: 000000007b4a3000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process dmidecode (pid: 2724, threadinfo ffff81007c094000, task ffff81007de917d0)

RIP  [<00007f744732423f>]
 RSP <00007fff4f5f1300>
---[ end trace f63babdc9d8f7076 ]---

