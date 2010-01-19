Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613Ab0ASVFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab0ASVFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755580Ab0ASVFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:05:49 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:48248 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab0ASVFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:05:49 -0500
Message-ID: <4B561D8D.1000003@nortel.com>
Date: Tue, 19 Jan 2010 15:01:01 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: issues with kmemleak backport
References: <4B55F3EF.9020408@nortel.com>
In-Reply-To: <4B55F3EF.9020408@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2010 21:05:44.0877 (UTC) FILETIME=[2A8A15D0:01CA994B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I realized that I could disable CONFIG_VT, and the previous issue went
away.  The system got further into the boot and started bringing up
userspace, but then gave the error below.


BUG: unable to handle kernel paging request at 83234000
IP: [<c048ad32>] scan_block+0xb2/0x100
Oops: 0000 [#1] SMP
Modules linked in: ipmi_serial_terminal_mode ipmi_serial ipmi_msghandler
ipmi_devintf

Pid: 506, comm: kmemleak Not tainted (2.6.27-pne #25)
EIP: 0060:[<c048ad32>] EFLAGS: 00010293 CPU: 1
EIP is at scan_block+0xb2/0x100
EAX: 00000001 EBX: 00000000 ECX: 00000000 EDX: 8323779c
ESI: 83234000 EDI: 83237799 EBP: f6f8bf90 ESP: f6f8bf80
 DS: 0068 ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kmemleak (pid: 506, ti=f6f8a000 task=f799da40 task.ti=f6f8a000)
Stack: 00000000 00000000 f60a5454 00000000 f6f8bfc0 c048affd 00000001
c0435330
       00000206 00000001 00000000 00000002 f6f8bfb8 000927c0 c048b6c0
00000000
       f6f8bfd0 c048b70e c08a66b0 00000000 f6f8bfe0 c043f6cc c043f690
00000000
Call Trace:
 [<c048affd>] ? kmemleak_scan+0x11d/0x3c0
 [<c0435330>] ? process_timeout+0x0/0x40
 [<c048b6c0>] ? kmemleak_scan_thread+0x0/0xc0
 [<c048b70e>] ? kmemleak_scan_thread+0x4e/0xc0
 [<c043f6cc>] ? kthread+0x3c/0x70
 [<c043f690>] ? kthread+0x0/0x70
 [<c0404737>] ? kernel_thread_helper+0x7/0x10
 =======================
Code: 15 50 7d 92 c0 c7 43 10 4c 7d 92 c0 89 43 14 89 10 89 ca 89 d8 e8
af c1 38 00 8d b4 26 00 00 00 00 83 c6 04 39 f7 7621 8b 45 08 <8b> 1e 85
c0 0f 84 6c ff ff ff e8 ff aa 38 00 e8 fa fe ff ff 85



Looking at the function offset it appears that kmemleak_scan() is
calling scan_block() for the per-cpu section.

I'll keep digging, but any suggestions would be appreciated.

Chris


