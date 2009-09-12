Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbZILH7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbZILH7L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZILH7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:59:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57989 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZILH7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:59:09 -0400
Date: Sat, 12 Sep 2009 09:58:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [origin tree boot crash #2] kernel BUG at kernel/cred.c:855!
Message-ID: <20090912075816.GA27306@elte.hu>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com> <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org> <20090912072450.GA6767@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912072450.GA6767@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


below is another boot crash. This is with the revert in place so 
sourced elsewhere. I already bisected the other one, making this one 
much more difficult to bisect ...

[    0.022999] Security Framework initialized
[    0.023999] SELinux:  Disabled at boot.
[    0.024999] Mount-cache hash table entries: 512
[    0.028999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.029999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.030999] CPU: Physical Processor ID: 0
[    0.031999] CPU: Processor Core ID: 0
[    0.032999] Checking 'hlt' instruction... OK.
[    0.038999] CRED: Invalid process credentials
[    0.039999] CRED: At kernel/cred.c:267
[    0.040999] CRED: Real credentials: c19ab770 [init][real][eff]
[    0.041999] CRED: ->magic=43736564, put_addr=(null)
[    0.042999] CRED: ->usage=4, subscr=2
[    0.043999] CRED: ->*uid = { 0,0,0,0 }
[    0.044999] CRED: ->*gid = { 0,0,0,0 }
[    0.045999] CRED: ->security is (null)
[    0.046999] CRED: Effective creds == Real creds
[    0.047999] ------------[ cut here ]------------
[    0.047999] kernel BUG at kernel/cred.c:855!
[    0.047999] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[    0.047999] last sysfs file: 
[    0.047999] Modules linked in:
[    0.047999] 
[    0.047999] Pid: 0, comm: swapper Not tainted (2.6.31-tip-02294-g6f4c721-dirty #12983) System Product Name
[    0.047999] EIP: 0060:[<c1064f9c>] EFLAGS: 00010282 CPU: 0
[    0.047999] EIP is at __validate_process_creds+0xd6/0xfe
[    0.047999] EAX: c18642ba EBX: c19ab770 ECX: c106d02f EDX: c16cde5d
[    0.047999] ESI: c19a5960 EDI: 0000010b EBP: c199fea4 ESP: c199fe94
[    0.047999]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.047999] Process swapper (pid: 0, ti=c199f000 task=c19a5960 task.ti=c199f000)
[    0.047999] Stack:
[    0.047999]  c18642e2 f7868000 c19a5960 00000000 c199feb8 c10653b1 f7868000 00800b00
[    0.047999] <0> 00000000 c199fed4 c1065771 f7868000 00000000 f7868000 00000000 00000000
[    0.047999] <0> c199ff04 c104c8d8 f7868000 c199ff84 00000000 00800b00 00000001 00000000
[    0.047999] Call Trace:
[    0.047999]  [<c10653b1>] ? prepare_creds+0x1e/0xb1
[    0.047999]  [<c1065771>] ? copy_creds+0x85/0x1cc
[    0.047999]  [<c104c8d8>] ? copy_process+0x18b/0xc75
[    0.047999]  [<c104d4d5>] ? do_fork+0x113/0x28d
[    0.047999]  [<c106faef>] ? __lock_release+0x15e/0x164
[    0.047999]  [<c16ccd91>] ? __mutex_unlock_slowpath+0xf8/0x107
[    0.047999]  [<c1017b13>] ? kernel_thread+0x80/0x88
[    0.047999]  [<c1a15331>] ? kernel_init+0x0/0xa6
[    0.047999]  [<c1a15331>] ? kernel_init+0x0/0xa6
[    0.047999]  [<c1019ab0>] ? kernel_thread_helper+0x0/0x10
[    0.047999]  [<c169c241>] ? rest_init+0x19/0x5f
[    0.047999]  [<c1a158c7>] ? start_kernel+0x310/0x315
[    0.047999]  [<c1a15098>] ? __init_begin+0x98/0x9d
[    0.047999] Code: ff 8b 86 dc 02 00 00 83 c4 10 3b 86 d8 02 00 00 74 0e 89 f1 ba b0 42 86 c1 e8 55 fe ff ff eb 0b 68 ba 42 86 c1 e8 d9 6f 66 00 58 <0f> 0b eb fe 81 7b 0c 64 65 73 43 75 9f e9 58 ff ff ff 81 79 0c 
[    0.047999] EIP: [<c1064f9c>] __validate_process_creds+0xd6/0xfe SS:ESP 0068:c199fe94

I'll try a blind (and manual) revert of:

ee18d64: KEYS: Add a keyctl to install a process's session keyring on its parent [try #6

	Ingo
