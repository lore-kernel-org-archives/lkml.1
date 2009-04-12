Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbZDLMnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbZDLMnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 08:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760599AbZDLMnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 08:43:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36299 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760584AbZDLMnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 08:43:10 -0400
Date: Sun, 12 Apr 2009 14:42:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Luis Henriques <henrix@sapo.pt>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Problem with kvm on -tip
Message-ID: <20090412124243.GA20281@elte.hu>
References: <20090409210738.GA4566@hades.domain.com> <49E08857.2090503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E08857.2090503@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> index a1ecec5..b556b6a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -630,10 +630,12 @@ static void kvm_write_guest_time(struct kvm_vcpu *v)
>  	if ((!vcpu->time_page))
>  		return;
>  
> +	preempt_disable();
>  	if (unlikely(vcpu->hv_clock_tsc_khz != __get_cpu_var(cpu_tsc_khz))) {
>  		kvm_set_time_scale(__get_cpu_var(cpu_tsc_khz), &vcpu->hv_clock);
>  		vcpu->hv_clock_tsc_khz = __get_cpu_var(cpu_tsc_khz);
>  	}
> +	preempt_enable();

fix look good, but note that this is an open-coded get_cpu_var() 
sequence - please use get_cpu_var()/put_cpu_var() instead.

	Ingo
