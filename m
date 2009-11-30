Return-Path: <linux-kernel-owner+w=401wt.eu-S1752903AbZK3LQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbZK3LQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZK3LQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:16:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbZK3LQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:16:30 -0500
Message-ID: <4B13A8C3.3010605@redhat.com>
Date: Mon, 30 Nov 2009 13:13:07 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH tip/sched/urgent] sched: revert 498657a478c60be092208422fefa9c7b248729c2
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>  <4B0FEA3E.5050108@gmail.com> <1259335036.6483.440.camel@laptop> <alpine.LFD.2.00.0911271730330.24119@localhost.localdomain> <4B1113C0.30505@redhat.com> <4B138950.9040905@kernel.org> <alpine.LFD.2.00.0911301055000.24119@localhost.localdomain> <4B13A24E.1080100@kernel.org> <4B13A654.8030306@kernel.org>
In-Reply-To: <4B13A654.8030306@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 01:02 PM, Tejun Heo wrote:
> 498657a478c60be092208422fefa9c7b248729c2 incorrectly assumed that
> preempt wasn't disabled around context_switch() and thus was fixing
> imaginary problem.  It also broke kvm because it depended on
> ->sched_in() to be called with irq enabled so that it can do smp calls
> from there.
>
> Revert the incorrect commit and add comment describing different
> contexts under with the two callbacks are invoked.
>
>    *    notifier: struct preempt_notifier for the task being preempted
>    *    next: the task that's kicking us out
> + *
> + * Please note that sched_in and out are called under different
> + * contexts.  sched_in is called with rq lock held and irq disabled
> + * while sched_out is called without rq lock and irq enabled.
>    */
>    

Is this transposed?  sched_in must be called with interrupts enabled for 
the kvm IPI to work.

-- 
error compiling committee.c: too many arguments to function

