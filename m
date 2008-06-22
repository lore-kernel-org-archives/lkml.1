Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbYFVM4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbYFVM4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 08:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbYFVM4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 08:56:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:8405 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYFVM4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 08:56:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=VF2BTbaSJdzaXDz4hzJHaQEUvrFhNDolF6OXGv8vI0odfUz86wEFEZ0k9ce+wUysg4
         es1zie5clZQED8ee87QKoECJcAMNhlRmltLM5AxmN0wyKny27aAcdB8T6ZwLtLdlYlbV
         rdbsjtQVOjYEdBYcAuRT+CZX1WWkBGAT9jkAM=
Date: Sun, 22 Jun 2008 14:56:34 +0200
To: Rusty Russell <rusty@rustycorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
Message-ID: <20080622125633.GA8166@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

More cpu-hotplug-related fun... ;-)

I know the kernel version says dirty, but the only thing I applied was my
softirq-debugging patch, which is completely unrelated.


Vegard


Initializing CPU#1
APIC error on CPU0: 00(40)
Stuck ??
Inquiring remote APIC #1...
... APIC #1 ID: failed
... APIC #1 VERSION: failed
... APIC #1 SPIV: failed
BUG: unable to handle kernel NULL pointer dereference at 00000024
IP: [<c01e0f06>] sysfs_remove_group+0x16/0xc0
*pde = 00000000
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC

Pid: 3994, comm: bash Not tainted (2.6.26-rc7-00002-g8b2e474-dirty #29)
EIP: 0060:[<c01e0f06>] EFLAGS: 00010282 CPU: 0
EIP is at sysfs_remove_group+0x16/0xc0
EAX: 00000008 EBX: 00000001 ECX: 00000004 EDX: c0694c14
ESI: 00000004 EDI: c07015fc EBP: f3cbfe9c ESP: f3cbfe80
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process bash (pid: 3994, ti=f3cbe000 task=f3cb4f60 task.ti=f3cbe000)
Stack: c0302262 f4bcda40 f3cbfe98 00000008 00000001 00000004 00000000 f3cbfea8
       c05880b2 c07576c4 f3cbfec8 c014f567 00000001 00000004 c0753c90 0000001f
       00000001 fffffffb f3cbfedc c014f5d9 0000001f 00000000 00000004 f3cbff00
Call Trace:
 [<c0302262>] ? device_unregister+0x12/0x20
 [<c05880b2>] ? topology_cpu_callback+0x32/0x70
 [<c014f567>] ? notifier_call_chain+0x37/0x70
 [<c014f5d9>] ? __raw_notifier_call_chain+0x19/0x20
 [<c0586f6e>] ? _cpu_up+0xee/0x100
 [<c0586fc9>] ? cpu_up+0x49/0x70
 [<c05678d8>] ? store_online+0x58/0x80
 [<c0567880>] ? store_online+0x0/0x80
 [<c0302a6b>] ? sysdev_store+0x2b/0x40
 [<c01df0f2>] ? sysfs_write_file+0xa2/0x100
 [<c01a0d06>] ? vfs_write+0x96/0x130
 [<c01df050>] ? sysfs_write_file+0x0/0x100
 [<c01a13cd>] ? sys_write+0x3d/0x70
 [<c010831b>] ? sysenter_past_esp+0x78/0xd1
 =======================
Code: 8b 43 04 83 c3 04 85 c0 75 ed 5b 5e 5d c3 8d b4 26 00 00 00 00 55 89 e5 83 ec 1c 89 7d fc 89 d7 89 5d f4 89 75 f8 89 45 f0 8b 12 <8b> 70 1c 85 d2 74 53 89 f0 e8 bc f5 ff ff 85 c0 89 c3 74 59 8b
EIP: [<c01e0f06>] sysfs_remove_group+0x16/0xc0 SS:ESP 0068:f3cbfe80

