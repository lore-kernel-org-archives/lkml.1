Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbXIKPne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbXIKPne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752850AbXIKPn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:43:27 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:57965 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbXIKPn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:43:26 -0400
Message-ID: <46E6B797.8050605@nortel.com>
Date: Tue, 11 Sep 2007 09:43:19 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, manfred@colorfullife.com
Subject: OOPS in __copy_user_zeroing_intel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2007 15:43:23.0258 (UTC) FILETIME=[7C5E7DA0:01C7F48A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

We're running a modified 2.6.10 on a dual-Xeon system.  We've had a 
number of instances where we've seen oopses in the pipe code.  I've 
included the most recent one below.  This bug left us with a hung 
process as the pipe code bailed out while pipe_writev() was holding a 
sema, and another process was blocked waiting for the sema.

Is anyone aware of bugs that were fixed in the pipe code since 2.6.10?

Thanks,

Chris


Unable to handle kernel paging request at virtual address 450004a2
  printing eip:
c028fb7a
*pde = 2a716001
Kcore timestamp : 1188871029.530900
Kcore HighResolution timestamp : 2B7FA3FD52C48
Oops: 0002 [#1]
SMP
Modules linked in: fuse tipc pmemfs bond2 bond1 bond0 fault 
ipmi_watchdog vmc vMCstub ipmibus ipmi_serial ipmi_devintf ipmi_msghandler

CPU:    3
EIP:    0060:[<c028fb7a>]    Not tainted VLI
EFLAGS: 00010206   (2.6.10-pne)
EIP is at __copy_user_zeroing_intel+0x28/0xac
eax: 20202020   ebx: 00000049   ecx: 00000049   edx: 74656e69
esi: b7e2c000   edi: 450004a2   ebp: f04f9eac   esp: f04f9ea4
ds: 007b   es: 007b   ss: 0068
Process grep (pid: 28955, threadinfo=f04f8000 task=f0420c70)
Stack: b7e2c000 450004a2 f04f9ec8 c028fcd0 450004a2 b7e2c000 00000049 
00000000
        450004a2 f04f9ee8 c028fd67 450004a2 b7e2c000 00000049 f04f9f48 
00000049
        babbb0bb f04f9f30 c01733c6 450004a2 b7e2c000 00000049 ea309ddc 
8ecc000e
        450004a2 babbb0bb f04f8000 00000049 00000001 00000049 00000000 
f72d83f0
        c01735f6 ea37b180 f04f9f94 f04f9f50 c0173629 ea37b180 f04f9f48 
00000001
        f04f9f94 b7e2c000 00000049 f04f9f7c c0167af3 ea37b180 b7e2c000 
00000049
        f04f9f94 00000003 0b000000 ea37b180 00000001 fffffff7 f04f9fbc 
c0167c4c
        ea37b180 b7e2c000 00000049 f04f9f94 00000000 00000000 00000000 
00000107
        00004900 00000000 b7e2c000 00000001 00000049 b7e2c000 f04f8000 
c0102554
        00000001 b7e2c000 00000049 00000049 b7e2c000 bfffe4d8 00000004 
0000007b
        0000007b 00000004 ffffe410 00000073 00000246 bfffe4a4 0000007b
Call Trace:
  [<c010340f>] show_stack+0x80/0x96
  [<c01035a2>] show_registers+0x15d/0x1d6
  [<c0103900>] die+0x106/0x194
  [<c0112602>] do_page_fault+0x594/0x8e9
  [<c01030bb>] error_code+0x2b/0x30
  [<c028fcd0>] __copy_from_user_ll+0x62/0x70
  [<c028fd67>] copy_from_user+0x3f/0x68
  [<c01733c6>] pipe_writev+0x107/0x337
  [<c0173629>] pipe_write+0x33/0x35
  [<c0167af3>] vfs_write+0xe0/0x11e
  [<c0167c4c>] sys_write+0x77/0xa4
  [<c0102554>] no_dpa_vsyscall_enter+0x8/0x1b
Code: c8 5d c3 55 89 e5 83 ec 08 89 34 24 89 7c 24 04 8b 75 0c 8b 7d 08 
8b 4d 10 8b 46 20 83 f9 43 76 04 8b 46 40 90 8b 46 00 8b 56 04 <89> 47 
00 89 57 04 8b 46 08 8b 56 0c 89 47 08 89 57 0c 8b 46 10

fuse tipc pmemfs bond2 bond1 bond0 fault ipmi_watchdog vmc vMCstub 
ipmibus ipmi_serial ipmi_devintf ipmi_msghandler
