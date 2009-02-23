Return-Path: <linux-kernel-owner+w=401wt.eu-S1756580AbZBWSzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbZBWSzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:55:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZBWSyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:54:52 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:3359 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbZBWSyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:54:52 -0500
X-Greylist: delayed 1023 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Feb 2009 13:54:51 EST
Message-ID: <49A2ECF5.80104@phoenixsoftware.de>
Date: Mon, 23 Feb 2009 19:37:41 +0100
From: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [2.6.28.7] BUG: using smp_processor_id() in preemptible [00000000]
 code: pageattr-test/207
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Spam-Score: -0.423 () AWL,BAYES_50,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Booting the most recent stable kernel 2.6.28.7 on my workhorse machine
(Pentium D, openSUSE 10.3 32 bit userspace) produces rather a lot of
the following BUG messages:

<3>BUG: using smp_processor_id() in preemptible [00000000] code: pageattr-test/207
<4>caller is paravirt_get_lazy_mode+0xe/0x1b
<4>Pid: 207, comm: pageattr-test Not tainted 2.6.28.7-testing #1
<4>Call Trace:
<4> [<c0204760>] debug_smp_processor_id+0xac/0xc0
<4> [<c011ad90>] paravirt_get_lazy_mode+0xe/0x1b
<4> [<c011c925>] arch_flush_lazy_mmu_mode+0x8/0x19
<4> [<c011d07c>] change_page_attr_set_clr+0x283/0x28e
<4> [<c011d152>] change_page_attr_set+0xf/0x11
<4> [<c011d347>] do_pageattr_test+0x1f3/0x3e3
<4> [<c01247f1>] ? finish_task_switch+0xa0/0xa8
<4> [<c032f799>] ? schedule+0x462/0x472
<4> [<c0331353>] ? _spin_unlock_irqrestore+0x40/0x74
<4> [<c011d154>] ? do_pageattr_test+0x0/0x3e3
<4> [<c0139f1d>] kthread+0x3b/0x62 
<4> [<c0139ee2>] ? kthread+0x0/0x62
<4> [<c0104a43>] kernel_thread_helper+0x7/0x10

They occur regularly in bursts of ten, separated by 30 second break.
The previous kernel:

ts@xenon:~> uname -a
Linux xenon 2.6.28.6-testing #1 SMP PREEMPT Wed Feb 18 21:05:30 CET 2009 i686 i686 i386 GNU/Linux

with identical config and userspace (double-checked this time ;-)
runs quite BUG-free.

HTH
Tilman

-- 
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)


