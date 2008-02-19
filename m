Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbYBTBvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbYBTBvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbYBTBuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:50:54 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:42612 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbYBTBuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:50:40 -0500
Date: Tue, 19 Feb 2008 23:08:39 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: srostedt@redhat.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: ftrace causing panics.
Message-ID: <20080219173839.GF4754@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080219124222.GB13780@linux.vnet.ibm.com> <20080219140352.GB9965@elte.hu> <20080219155433.GA4754@linux.vnet.ibm.com> <20080219161608.GA1347@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219161608.GA1347@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

ftrace-cmd in -w option when being run for sometime cause this.


llm11.in.ibm.com login: [ 1002.937490] BUG: unable to handle kernel paging request at 285b0010
[ 1002.947087] IP: [<c015f7b5>] find_next_entry+0x4f/0x84
[ 1002.955091] *pdpt = 000000002d589001 *pde = 0000000000000000 
[ 1002.963651] Oops: 0000 [#1] SMP 
[ 1002.967082] Modules linked in:
[ 1002.967082] 
[ 1002.967082] Pid: 16350, comm: cat Not tainted (2.6.25-rc2-sched-devel #9)
[ 1002.967082] EIP: 0060:[<c015f7b5>] EFLAGS: 00010206 CPU: 0
[ 1002.967082] EIP is at find_next_entry+0x4f/0x84
[ 1002.967082] EAX: f6db2c60 EBX: 00000001 ECX: 00000001 EDX: f6db2c60
[ 1002.967082] ESI: 285b0000 EDI: c0850e00 EBP: eed23f04 ESP: eed23eec
[ 1002.967082]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 1002.967082] Process cat (pid: 16350, ti=eed22000 task=f0164620 task.ti=eed22000)
[ 1002.967082] Stack: 00000000 eed23f0c f61ba550 f61ba550 f61ba550 eed23f54 eed23f18 c015f806 
[ 1002.967082]        ffffffff f61ba550 f61ba550 eed23f38 c015f8ae 00007334 f6dccfc0 f61ba5e8 
[ 1002.967082]        c0582970 f61ba5e8 f61ba550 eed23f70 c01998a8 00000f96 00000000 00001000 
[ 1002.967082] Call Trace:
[ 1002.967082]  [<c015f806>] ? find_next_entry_inc+0x1c/0x80
[ 1002.967082]  [<c015f8ae>] ? s_next+0x44/0x7e
[ 1002.967082]  [<c01998a8>] ? seq_read+0x176/0x252
[ 1002.967082]  [<c0182be6>] ? vfs_read+0x90/0x108
[ 1002.967082]  [<c0182ea2>] ? sys_read+0x40/0x65
[ 1002.967082]  [<c0105a5a>] ? sysenter_past_esp+0x5f/0x99
[ 1002.967082]  =======================
[ 1002.967082] Code: e8 2d b2 0e 00 83 f8 07 89 c3 7f 3c 8b 54 87 14 83 3a 00 74 25 50 8b 4d f0 89 f8 e8 41 ff ff ff 59 85 c0 89 c2 74 13 85 f6 74 0a <8b> 46 10 2b 42 10 8 
[ 1002.967082] EIP: [<c015f7b5>] find_next_entry+0x4f/0x84 SS:ESP 0068:eed23eec
[ 1002.967200] Kernel panic - not syncing: Fatal exception

I can send you complete dmesg offlist as it has only trace data. .config
is the same as before (expect CONFIG_SMP is now on)

-- 
regards,
Dhaval
