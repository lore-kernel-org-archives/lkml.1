Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYHXWva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYHXWva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 18:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbYHXWvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 18:51:15 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:18280 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663AbYHXWvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 18:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=wp4ZuefShoVQScE1PjcUU6yz5RcsdNXr/zuKmUJNrDisFvxorHfQW/VRYYZZsXldUL
         9Zc4zhaa9Y085LbO9GUaQWdaDEL442NQXYq+9RaN+X61x5s6lB3QlRuDjsRWQiocKM3g
         /iRcHYSuagfS7irhaKshOJNg0ZD1FqTdspjIY=
Message-ID: <520f0cf10808241551x2fe64e9esadf66634b3790c54@mail.gmail.com>
Date: Mon, 25 Aug 2008 00:51:11 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Subject: 2.6.26.3-rt3 bug report
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't seen this one before.

Bad page state in process 'firefox-bin'
page:ffffe20001011f00 flags:0x0100000000000000
mapping:ffffe20001011f18 mapcount:0 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 4180, comm: firefox-bin Tainted: G        W 2.6.26.3-rt3 #3

Call Trace:
 [<ffffffff80287a72>] bad_page+0x6f/0x9d
 [<ffffffff8029184c>] ? inc_zone_page_state+0x5f/0x6b
 [<ffffffff80289046>] free_hot_cold_page+0x88/0x1e6
 [<ffffffff8028920b>] free_hot_page+0x10/0x12
 [<ffffffff8028922a>] __free_pages+0x1d/0x26
 [<ffffffff80294b95>] __pte_alloc+0x8e/0x99
 [<ffffffff80294cff>] handle_mm_fault+0x15f/0x766
 [<ffffffff8045f2d6>] ? rt_mutex_down_read_trylock+0x1ee/0x1f9
 [<ffffffff804629d9>] do_page_fault+0x51d/0x92c
 [<ffffffff8021251c>] ? native_sched_clock+0x2a/0x72
 [<ffffffff8027c930>] ? ftrace_now+0x9/0xb
 [<ffffffff80281548>] ? tracing_hist_preempt_start+0xf1/0x10d
 [<ffffffff8021251c>] ? native_sched_clock+0x2a/0x72
 [<ffffffff8027c930>] ? ftrace_now+0x9/0xb
 [<ffffffff804602f9>] error_exit+0x0/0x56

---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------
