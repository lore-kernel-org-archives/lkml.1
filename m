Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbYE0O4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbYE0O4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755790AbYE0O4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:56:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57492 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660AbYE0O4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:56:31 -0400
Date: Tue, 27 May 2008 16:56:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@qumranet.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
Subject: Re: Question about interrupt routing and irq allocation
Message-ID: <20080527145606.GB24457@elte.hu>
References: <483B34CA.8000600@goop.org> <20080527083729.GF29246@elte.hu> <483BD843.5080009@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483BD843.5080009@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> So the most intelligent method would be to reserve the Linux irq 
>> itself but not the vector, i.e. allocate from irq_cfg[] in 
>> arch/x86/kernel/io_apic_64.c so that the irq number does not get 
>> reused - setting irq_cfg[irq].vector to -1 will achieve that.
>
> I'm initially targeting 32-bit, though obviously I'd like something 
> that works for both 32 and 64 bit.  irq_cfg[] is missing in 
> io_apic_32.c; would I achieve the same effect by setting 
> irq_vector[irq] = 0xff or something?

ok, here comes the next phase of a rather cunning plan: please unify 
these vector allocators first! ;-)

it's nontrivial but would result in rather nice code. I dont know 
whether we want to extend per-CPU vectors to 32-bit as well ... but 
might be worth an attempt and we could give any exploratory patches a 
try in -tip. Eric, what do you think about the general approach?

this would also pave the way towards unified APIC code. Hm?

	Ingo
