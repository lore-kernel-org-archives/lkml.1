Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbYH2O3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbYH2O3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbYH2O3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:29:08 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:49195 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbYH2O3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lGMI5FeVsywCmtfUJKJXPWb9hWaAXQ/IDEzL0gp7Pn196S5QW2z51XFTgGyDqdNXq4
         SWV4w28OtCIZv8DCfMrBYKXIzENPQpOeWBeUJY8vYz14O2rlPYjoTLQ1WwSEFm1Cy4Pk
         oCE/M4jrsOqM3jtTBbsxNdFoly1CF9htj789g=
Message-ID: <520f0cf10808290729q1d99b915s1543256796c8eeb7@mail.gmail.com>
Date: Fri, 29 Aug 2008 16:29:03 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Carsten Emde" <Carsten.Emde@osadl.org>
Subject: Re: 2.6.26.3-rt3 bug report
Cc: "Jon Masters" <jonathan@jonmasters.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <48B39969.8060501@osadl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <520f0cf10808241551x2fe64e9esadf66634b3790c54@mail.gmail.com>
	 <520f0cf10808251615r5953794x9816bd58ea771ab3@mail.gmail.com>
	 <1219724080.25366.13.camel@perihelion> <48B39969.8060501@osadl.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 7:49 AM, Carsten Emde <Carsten.Emde@osadl.org> wrote:
> Jon Masters wrote:
>> On Tue, 2008-08-26 at 01:15 +0200, John Kacur wrote:
>>> Slightly different form today.
>>> Bad page state in process 'firefox-bin'
>>> page:ffffe20000daa360 flags:0x0100000000000000
>>> mapping:ffffe20000daa378 mapcount:0 count:0
>>> Trying to fix it up, but a reboot is needed
>>> Backtrace:
>>> Pid: 16955, comm: firefox-bin Not tainted 2.6.26.3-rt3 #3
>> Er, does firefox run reliably on a non-RT 2.6.26.3 kernel? This many
>> random calls to bad_page suggests more of a RAM problem.
> Don't think so. Same problem here:
> Bad page state in process 'bonobo-activati'
> page:c18f66fc flags:0x40000000 mapping:c18f670c mapcount:0 count:0
> Trying to fix it up, but a reboot is needed
> Backtrace:
> Pid: 4169, comm: bonobo-activati Not tainted 2.6.26.3-rt3 #2
> [<c0438e52>] ? printk+0x14/0x1a
> [<c026e8ef>] bad_page+0x4e/0x79
> [<c026f3d3>] free_hot_cold_page+0x5b/0x1dc
> [<c026f5a1>] free_hot_page+0xf/0x11
> [<c026f5c3>] __free_pages+0x20/0x2b
> [<c02789a0>] __pte_alloc+0x6f/0x77
> [<c0278a4d>] handle_mm_fault+0xa5/0x56c
> [<c0243a1c>] ? rt_mutex_down_read+0x15c/0x164
> [<c0218759>] do_page_fault+0x2c1/0x674
> [<c021b21d>] ? enqueue_task+0x5a/0x66
> [<c043bb66>] ? __spin_unlock_irqrestore+0x24/0x42
> [<c0241e4f>] ? rt_mutex_adjust_prio+0x1a/0x31
> [<c043bc92>] ? __spin_lock_irqsave+0x1e/0x38
> [<c021f37d>] ? try_to_wake_up+0x176/0x180
> [<c043bb5a>] ? __spin_unlock_irqrestore+0x18/0x42
> [<c0241e4f>] ? rt_mutex_adjust_prio+0x1a/0x31
> [<c0241e61>] ? rt_mutex_adjust_prio+0x2c/0x31
> [<c0241e61>] ? rt_mutex_adjust_prio+0x2c/0x31
> [<c043a8f7>] ? rt_write_slowunlock+0x1cd/0x1d5
> [<c027ccb0>] ? mprotect_fixup+0x238/0x282
> [<c0259384>] ? audit_syscall_exit+0x2b6/0x2d1
> [<c0204a4e>] ? resume_userspace+0x6/0x1c
> [<c0218498>] ? do_page_fault+0x0/0x674
> [<c043bf02>] error_code+0x72/0x78
>

Hi Carsten

Any progress or ideas here?

Thank you

John
