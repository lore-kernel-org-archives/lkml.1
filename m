Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136AbZEKOPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbZEKOPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZEKOPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:15:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44271 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbZEKOPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:15:10 -0400
Date: Mon, 11 May 2009 16:15:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMD
	SVM
Message-ID: <20090511141503.GC6175@elte.hu>
References: <200905050909.58583.mark.langsdorf@amd.com> <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com> <4A02FECC.6060609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A02FECC.6060609@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

>>  +static int pause_interception(struct vcpu_svm *svm, struct kvm_run 
>> *kvm_run)
>> +{
>> +	/* Simple yield */
>> +	vcpu_put(&svm->vcpu);
>> +	schedule();
>> +	vcpu_load(&svm->vcpu);
>> +	return 1;
>> +
>
> Ingo, will this do anything under CFS, or will CFS note that 
> nothing has changed in the accounting and reschedule us 
> immediately?

The scheduler will yield to another task only if the current task 
has become ineligible. I.e schedule() is largely a NOP on 
TASK_RUNNING tasks (i.e. here).

I.e. this is a somewhat poor solution as far as scheduling goes. But 
i'm wondering what the CPU side does. Can REP-NOP really take 
thousands of cycles? If yes, under what circumstances?

	Ingo
