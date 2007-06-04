Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbXFDODR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbXFDODR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbXFDODD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:03:03 -0400
Received: from mx2.zouh.org ([81.57.42.108]:60340 "EHLO zouh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbXFDODA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:03:00 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 10:03:00 EDT
Date: Mon, 4 Jun 2007 15:55:14 +0200
From: Benjamin Pineau <benjamin_pineau@zouh.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc3 : "BUG: scheduling while atomic: swapper/0x00000100/0"
Message-ID: <20070604135514.GA14426@zouh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
The stock 2.6.22-rc3 (with no alien modules or patchs) on my i386 desktops
fired this message in loop like a mad (thousands of times/second) until
reboot, for no evident reason (I mean, I don't know what I did to get this, 
from an end-user perspective : I was just editing text on vim and surfing 
the web with firefox). 

The same kernel worked for several days without exposing surch a problem
and this never occured with the olders kernels I used (2.6.17, 2.6.21).

Beside the log presure, the only symptom I noted is that reboot didn't work:
it killed X and probably most userland, but got silently stuck on the console,
without actually restarting the machine. Then, on the console, everytime I 
typed a key, 2 new "BUG: scheduling ..." lines appeared. Typing ctrl-alt-del 
finaly forced it to physically reboot.

I've got more details in dmesg. Sample (full dmesg plus more
at http://oshima.zouh.org/~ben/2.6.23-rc3_bug_details.txt):

[333259.145874]  =======================
[333259.145894] BUG: scheduling while atomic: swapper/0x00000100/0
[333259.145906]  [<c03f254c>] schedule+0x4dc/0x860
[333259.145915]  [<c0141c76>] getnstimeofday+0x36/0xd0
[333259.145932]  [<c013fcc6>] ktime_get_ts+0x16/0x50
[333259.145941]  [<c013a358>] rcu_pending+0x38/0x50
[333259.145949]  [<c013a3a2>] rcu_needs_cpu+0x32/0x40
[333259.145964]  [<c01022d0>] mwait_idle+0x0/0x20
[333259.145974]  [<c010245c>] cpu_idle+0x9c/0xe0
[333259.145985]  [<c0558a7f>] start_kernel+0x31f/0x3b0
[333259.145994]  [<c05581f0>] unknown_bootoption+0x0/0x260
[333259.146007]  =======================
[334129.061709] BUG: scheduling while atomic: swapper/0x00000100/0
[334129.061735]  [<c03f254c>] schedule+0x4dc/0x860
[334129.061760]  [<c013f96b>] enqueue_hrtimer+0x6b/0x110
[334129.061773]  [<c0140245>] hrtimer_start+0xc5/0x130
[334129.061785]  [<c01459e1>] tick_nohz_restart_sched_tick+0xf1/0x140
[334129.061796]  [<c01022d0>] mwait_idle+0x0/0x20
[334129.061806]  [<c010245c>] cpu_idle+0x9c/0xe0
[334129.061817]  [<c0558a7f>] start_kernel+0x31f/0x3b0
[334129.061827]  [<c05581f0>] unknown_bootoption+0x0/0x260
[333259.148510]  =======================

Since I see the word "time" there : note I have NO_HZ, HIGH_RES_TIMERS,
TIMER_STATS and HPET (but according to /proc/timer_list, hpet is not active),
but no IRQ_BALANCE.
And for the boot options (?), /proc/cmdline is :
root=UUID=349f275c-a633-4d1d-8ab7-b3a75d67dc51 ro locale=fr_FR

lspci -vv, lspci -vn, /proc/config.gz, /proc/timer_list, lsmod,
/proc/interrupts, /proc/vmstat, ps auxf, and dmesg (with and 
without the bug's logs) outputs at
http://oshima.zouh.org/~ben/2.6.23-rc3_bug_details.txt

Thank you.
Benjamin Pineau

