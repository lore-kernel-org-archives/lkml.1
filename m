Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbXFDOjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbXFDOjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbXFDOj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:39:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:35988 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755446AbXFDOj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:39:27 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19/CCRxYPx/GK6G/mhSs1IPU46DJLR5AsJ5sWtaSI
	39mpLeIKTmhazv
Date: Mon, 4 Jun 2007 16:39:25 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Benjamin Pineau <benjamin_pineau@zouh.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3 : "BUG: scheduling while atomic: swapper/0x00000100/0"
Message-ID: <20070604143925.GA3363@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Benjamin Pineau <benjamin_pineau@zouh.org>,
	linux-kernel@vger.kernel.org
References: <20070604135514.GA14426@zouh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070604135514.GA14426@zouh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.04 15:55:14 +0200, Benjamin Pineau wrote:
> Hi,
> The stock 2.6.22-rc3 (with no alien modules or patchs) on my i386 desktops
> fired this message in loop like a mad (thousands of times/second) until
> reboot, for no evident reason (I mean, I don't know what I did to get this, 
> >from an end-user perspective : I was just editing text on vim and surfing 
> the web with firefox). 
> 
> The same kernel worked for several days without exposing surch a problem
> and this never occured with the olders kernels I used (2.6.17, 2.6.21).
> 
> Beside the log presure, the only symptom I noted is that reboot didn't work:
> it killed X and probably most userland, but got silently stuck on the console,
> without actually restarting the machine. Then, on the console, everytime I 
> typed a key, 2 new "BUG: scheduling ..." lines appeared. Typing ctrl-alt-del 
> finaly forced it to physically reboot.
> 
> I've got more details in dmesg. Sample (full dmesg plus more
> at http://oshima.zouh.org/~ben/2.6.23-rc3_bug_details.txt):
> 
> [333259.145874]  =======================
> [333259.145894] BUG: scheduling while atomic: swapper/0x00000100/0
> [333259.145906]  [<c03f254c>] schedule+0x4dc/0x860
> [333259.145915]  [<c0141c76>] getnstimeofday+0x36/0xd0
> [333259.145932]  [<c013fcc6>] ktime_get_ts+0x16/0x50
> [333259.145941]  [<c013a358>] rcu_pending+0x38/0x50
> [333259.145949]  [<c013a3a2>] rcu_needs_cpu+0x32/0x40
> [333259.145964]  [<c01022d0>] mwait_idle+0x0/0x20
> [333259.145974]  [<c010245c>] cpu_idle+0x9c/0xe0
> [333259.145985]  [<c0558a7f>] start_kernel+0x31f/0x3b0
> [333259.145994]  [<c05581f0>] unknown_bootoption+0x0/0x260
> [333259.146007]  =======================
> [334129.061709] BUG: scheduling while atomic: swapper/0x00000100/0
> [334129.061735]  [<c03f254c>] schedule+0x4dc/0x860
> [334129.061760]  [<c013f96b>] enqueue_hrtimer+0x6b/0x110
> [334129.061773]  [<c0140245>] hrtimer_start+0xc5/0x130
> [334129.061785]  [<c01459e1>] tick_nohz_restart_sched_tick+0xf1/0x140
> [334129.061796]  [<c01022d0>] mwait_idle+0x0/0x20
> [334129.061806]  [<c010245c>] cpu_idle+0x9c/0xe0
> [334129.061817]  [<c0558a7f>] start_kernel+0x31f/0x3b0
> [334129.061827]  [<c05581f0>] unknown_bootoption+0x0/0x260
> [333259.148510]  =======================
> 
> Since I see the word "time" there : note I have NO_HZ, HIGH_RES_TIMERS,
> TIMER_STATS and HPET (but according to /proc/timer_list, hpet is not active),
> but no IRQ_BALANCE.
> And for the boot options (?), /proc/cmdline is :
> root=UUID=349f275c-a633-4d1d-8ab7-b3a75d67dc51 ro locale=fr_FR
> 
> lspci -vv, lspci -vn, /proc/config.gz, /proc/timer_list, lsmod,
> /proc/interrupts, /proc/vmstat, ps auxf, and dmesg (with and 
> without the bug's logs) outputs at
> http://oshima.zouh.org/~ben/2.6.23-rc3_bug_details.txt

To save somebody else from guessing, that's HIRoshima, i.e. the correct
URL is http://hiroshima.zouh.org/~ben/2.6.23-rc3_bug_details.txt

;-)

Björn
