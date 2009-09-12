Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbZILJ7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbZILJ7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 05:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZILJ7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 05:59:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbZILJ7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 05:59:38 -0400
Subject: Re: [origin tree boot crash #2] kernel BUG at kernel/cred.c:855!
From: Eric Paris <eparis@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, dhowells@redhat.com
Cc: James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090912075816.GA27306@elte.hu>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com>
	 <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org>
	 <20090912072450.GA6767@elte.hu>  <20090912075816.GA27306@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Sep 2009 05:58:24 -0400
Message-Id: <1252749504.2305.97.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-12 at 09:58 +0200, Ingo Molnar wrote:
> below is another boot crash. 

> [    0.022999] Security Framework initialized
> [    0.023999] SELinux:  Disabled at boot.
> [    0.024999] Mount-cache hash table entries: 512
> [    0.028999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> [    0.029999] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.030999] CPU: Physical Processor ID: 0
> [    0.031999] CPU: Processor Core ID: 0
> [    0.032999] Checking 'hlt' instruction... OK.
> [    0.038999] CRED: Invalid process credentials
> [    0.039999] CRED: At kernel/cred.c:267
> [    0.040999] CRED: Real credentials: c19ab770 [init][real][eff]
> [    0.041999] CRED: ->magic=43736564, put_addr=(null)
> [    0.042999] CRED: ->usage=4, subscr=2
> [    0.043999] CRED: ->*uid = { 0,0,0,0 }
> [    0.044999] CRED: ->*gid = { 0,0,0,0 }
> [    0.045999] CRED: ->security is (null)
> [    0.046999] CRED: Effective creds == Real creds
> [    0.047999] ------------[ cut here ]------------
> [    0.047999] kernel BUG at kernel/cred.c:855!
> [    0.047999] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
> [    0.047999] last sysfs file: 
> [    0.047999] Modules linked in:
> [    0.047999] 
> [    0.047999] Pid: 0, comm: swapper Not tainted (2.6.31-tip-02294-g6f4c721-dirty #12983) System Product Name
> [    0.047999] EIP: 0060:[<c1064f9c>] EFLAGS: 00010282 CPU: 0
> [    0.047999] EIP is at __validate_process_creds+0xd6/0xfe
> [    0.047999] EAX: c18642ba EBX: c19ab770 ECX: c106d02f EDX: c16cde5d
> [    0.047999] ESI: c19a5960 EDI: 0000010b EBP: c199fea4 ESP: c199fe94
> [    0.047999]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.047999] Process swapper (pid: 0, ti=c199f000 task=c19a5960 task.ti=c199f000)
> [    0.047999] Stack:
> [    0.047999]  c18642e2 f7868000 c19a5960 00000000 c199feb8 c10653b1 f7868000 00800b00
> [    0.047999] <0> 00000000 c199fed4 c1065771 f7868000 00000000 f7868000 00000000 00000000
> [    0.047999] <0> c199ff04 c104c8d8 f7868000 c199ff84 00000000 00800b00 00000001 00000000
> [    0.047999] Call Trace:
> [    0.047999]  [<c10653b1>] ? prepare_creds+0x1e/0xb1
> [    0.047999]  [<c1065771>] ? copy_creds+0x85/0x1cc
> [    0.047999]  [<c104c8d8>] ? copy_process+0x18b/0xc75
> [    0.047999]  [<c104d4d5>] ? do_fork+0x113/0x28d
> [    0.047999]  [<c106faef>] ? __lock_release+0x15e/0x164
> [    0.047999]  [<c16ccd91>] ? __mutex_unlock_slowpath+0xf8/0x107
> [    0.047999]  [<c1017b13>] ? kernel_thread+0x80/0x88
> [    0.047999]  [<c1a15331>] ? kernel_init+0x0/0xa6
> [    0.047999]  [<c1a15331>] ? kernel_init+0x0/0xa6
> [    0.047999]  [<c1019ab0>] ? kernel_thread_helper+0x0/0x10
> [    0.047999]  [<c169c241>] ? rest_init+0x19/0x5f
> [    0.047999]  [<c1a158c7>] ? start_kernel+0x310/0x315
> [    0.047999]  [<c1a15098>] ? __init_begin+0x98/0x9d
> [    0.047999] Code: ff 8b 86 dc 02 00 00 83 c4 10 3b 86 d8 02 00 00 74 0e 89 f1 ba b0 42 86 c1 e8 55 fe ff ff eb 0b 68 ba 42 86 c1 e8 d9 6f 66 00 58 <0f> 0b eb fe 81 7b 0c 64 65 73 43 75 9f e9 58 ff ff ff 81 79 0c 
> [    0.047999] EIP: [<c1064f9c>] __validate_process_creds+0xd6/0xfe SS:ESP 0068:c199fe94

[adding the creds guy even though it isn't in MAINTAINERS]

This had to come from e0e817392b9acf2c98d3be80c233dddb1b52003d
    CRED: Add some configurable debugging [try #6]

static inline bool creds_are_invalid(const struct cred *cred)
{
[snip]
#ifdef CONFIG_SECURITY_SELINUX
        if ((unsigned long) cred->security < PAGE_SIZE)
                return true;
        if ((*(u32*)cred->security & 0xffffff00) ==
            (POISON_FREE << 24 | POISON_FREE << 16 | POISON_FREE << 8))
                return true;
#endif 

cred->security could be NULL with CONFIG_SECURITY_SELINUX but when
SELinux is disabled at run time (which obviously you are doing).  I
think the checks are generally good, but they need to also look for
if(selinux_enabled)

If I don't hear anything today I'll patch it tonight along with the
other bug....

-Eric

