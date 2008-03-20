Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYCTKYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYCTKYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 06:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYCTKY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 06:24:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200AbYCTKY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 06:24:26 -0400
Date: Thu, 20 Mar 2008 03:23:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Scott.Simpson@computer.org
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: Kernel stack trace in 2.6.24.3-34.fc8
Message-Id: <20080320032305.735329d7.akpm@linux-foundation.org>
In-Reply-To: <200803192049.02720.Scott.Simpson@computer.org>
References: <200803192049.02720.Scott.Simpson@computer.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 20:49:02 -0700 Scott Simpson <Scott.Simpson@computer.org> wrote:
>

(suitable cc added)

> I'm running Fedora 8 (MythTV) using 2.6.24.3-34.fc8 and I'm getting a stack 
> trace in the ivtv driver (not tainted!). My system was working fine under 
> 2.6.23.15-137.fc8. I'm enclosing the stack trace in ivtv. The exact system 
> setup is
> 
> vmlinuz-2.6.24.3-34.fc8
> ivtv-kmdl-2.6.24.3-34.fc8-1.0.3-136.fc8.i686.rpm (from ATRPMs)

Your kernel crashed.  It's a regression.

> 
> Also, if I add the wifi drivers (which I know taints the kernel), I get the 
> madwifi stack traces listed. This is using
> 
> madwifi-hal-kmdl-2.6.24.3-34.fc8-0.9.3.3-39.fc8.i686.rpm
> madwifi-kmdl-2.6.24.3-34.fc8-0.9.3.3-39.fc8.i686.rpm
> 
> from ATRPMs. I realize this is a tainted kernel and I'm on my own, but 
> hopefully someone has something insightful.
> 
> 
> [ivtv_stack_trace.txt  application/octet-stream (1.7KB)]
> Mar 18 20:50:41 mythtv kernel: 
> Mar 18 20:50:41 mythtv kernel: Pid: 2513, comm: modprobe Not tainted (2.6.24.3-34.fc8 #1)
> Mar 18 20:50:41 mythtv kernel: EIP: 0060:[<e1ca7319>] EFLAGS: 00210216 CPU: 0
> Mar 18 20:50:41 mythtv kernel: EIP is at ivtvfb_init_card+0x1c1/0x648 [ivtvfb]
> Mar 18 20:50:41 mythtv kernel: EAX: 00000000 EBX: ffe00000 ECX: 00068100 EDX: 001a0400
> Mar 18 20:50:41 mythtv kernel: ESI: df9c0000 EDI: 00510000 EBP: e1ca9400 ESP: d786ae38
> Mar 18 20:50:41 mythtv kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Mar 18 20:50:41 mythtv kernel: Process modprobe (pid: 2513, ti=d786a000 task=d79ee000 task.ti=d786a000)
> Mar 18 20:50:41 mythtv kernel: Stack: e1ca836b 00000000 01400000 01800000 00000681 00000137 00000000 00510000 
> Mar 18 20:50:41 mythtv kernel:        002c0800 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
> Mar 18 20:50:41 mythtv kernel:        00000000 00000000 00000000 00000000 00000000 00000000 00000000 df9c0000 
> Mar 18 20:50:41 mythtv kernel: Call Trace:
> Mar 18 20:50:41 mythtv kernel:  [<e088705a>] ivtvfb_init+0x5a/0xcc [ivtvfb]
> Mar 18 20:50:41 mythtv kernel:  [<c044d204>] sys_init_module+0x14d6/0x15f9
> Mar 18 20:50:41 mythtv kernel:  [<e0a8e876>] ivtv_udma_setup+0x0/0x26c [ivtv]
> Mar 18 20:50:41 mythtv kernel:  [<c04051da>] syscall_call+0x7/0xb
> Mar 18 20:50:41 mythtv kernel:  =======================
> Mar 18 20:50:41 mythtv kernel: Code: 89 4c 24 04 c7 04 24 6b 83 ca e1 89 54 24 0c 89 44 24 08 e8 54 84 78 de 8b 86 74 f4 00 00 8b 50 0c 8b 78 08 31 c0 89 d1 c1 e9 02 <f3> ab f6 c2 02 74 02 66 ab f6 c2 01 74 01 aa 83 3d 88 a5 ca e1 
> Mar 18 20:50:41 mythtv kernel: EIP: [<e1ca7319>] ivtvfb_init_card+0x1c1/0x648 [ivtvfb] SS:ESP 0068:d786ae38
> Mar 18 20:50:41 mythtv kernel: ---[ end trace df794ec1acd2a221 ]---
> 
