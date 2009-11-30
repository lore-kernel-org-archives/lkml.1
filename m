Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZK3Ksg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZK3Ksg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbZK3Ksf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:48:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:32802 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbZK3Kse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:48:34 -0500
Message-ID: <4B13A24E.1080100@kernel.org>
Date: Mon, 30 Nov 2009 19:45:34 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: WARNING: kernel/smp.c:292 smp_call_function_single [Was: mmotm
 2009-11-24-16-47 uploaded]
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>  <4B0FEA3E.5050108@gmail.com> <1259335036.6483.440.camel@laptop> <alpine.LFD.2.00.0911271730330.24119@localhost.localdomain> <4B1113C0.30505@redhat.com> <4B138950.9040905@kernel.org> <alpine.LFD.2.00.0911301055000.24119@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0911301055000.24119@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/30/2009 07:02 PM, Thomas Gleixner wrote:
> No, it _CANNOT_ be preempted at that point:
> 
> schedule()
> {
> 	preempt_disable();
> 
> 	switch_to();
> 
> 	preempt_enable();
> }

Yes, you're right.

>> For the time being, maybe it's best to back out the fix given that the
>> only architecture which may be affected by the original bug is ia64
>> which is the only one with both kvm and the unlocked context switch.
> 
> Do you have a pointer to the original bug report ?

Nope, I was referring to the imaginary race condition, so there's no
bug to worry about.  The only problem is the asymmetry between in and
out callbacks.  Then again, it's not really possible to match them on
unlocked ctxsw archs anyway, so I guess the only thing to do is to
document the context difference between in and out.

Sorry about the fuss.  I'll send out patch to revert it and document
the difference.

Thanks.

-- 
tejun
