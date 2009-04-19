Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZDSGOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZDSGOU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 02:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755292AbZDSGOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 02:14:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58876 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbZDSGOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 02:14:09 -0400
Message-ID: <49EAC15E.7080702@cn.fujitsu.com>
Date: Sun, 19 Apr 2009 14:14:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/2 v3] [GIT PULL] tracing/events: add the __string field
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1240117295-6873-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Hi,
> 
> Here is the v3 of the __string() field patchset.
> It applies suggestions from Steven and Peter with some arrangements.
> 
> This time, filtering is not supported (though it is ready in a pending patch).
> I wanted to provide it but it looks like filtering has been broken recently.
> Once I set a usual string filter, no more traces appear, and clearing it
> doesn't change anything.
> 

I tried it, and triggered a WARNING, and ring buffers was
disabled permanently:

------------[ cut here ]------------
WARNING: at kernel/trace/ring_buffer.c:1501 ring_buffer_lock_reserve+0x78/0x122()
Hardware name: Aspire SA85
Modules linked in: autofs4 parport_pc parport button sg r8169 mii sata_sis pata_sis ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
Pid: 0, comm: swapper Not tainted 2.6.30-rc2-tip #84
Call Trace:
 [<c0431d8d>] warn_slowpath+0x79/0x8f
 [<c0468379>] ? __rcu_read_unlock+0x70/0x7f
 [<c045022b>] ? trace_hardirqs_off+0xb/0xd
 [<c0468379>] ? __rcu_read_unlock+0x70/0x7f
 [<c045022b>] ? trace_hardirqs_off+0xb/0xd
 [<c0468379>] ? __rcu_read_unlock+0x70/0x7f
 [<c063784b>] ? _spin_unlock_irqrestore+0x34/0x5d
 [<c0450200>] ? trace_hardirqs_off_caller+0x8f/0xaf
 [<c04718fa>] ring_buffer_lock_reserve+0x78/0x122
 [<c0473f17>] trace_buffer_lock_reserve+0x11/0x34
 [<c0474399>] trace_current_buffer_lock_reserve+0x19/0x1e
 [<c0465299>] ftrace_raw_event_irq_handler_exit+0x34/0x73
 [<c0464fdb>] handle_IRQ_event+0xcc/0x169
 [<c0466bc0>] handle_fasteoi_irq+0x77/0xb0
 [<c0466b49>] ? handle_fasteoi_irq+0x0/0xb0
 <IRQ>  [<c0637d76>] ? do_IRQ+0x4e/0xa3
 [<c04030ee>] ? common_interrupt+0x2e/0x34
 [<c045007b>] ? lockdep_init_map+0x2d5/0x39f
 [<c04092b3>] ? mwait_idle+0xab/0x100
 [<c0401b4e>] ? cpu_idle+0x53/0x85
 [<c0631fb5>] ? start_secondary+0x1aa/0x1b1
---[ end trace ab1a6955379aeb3f ]---


