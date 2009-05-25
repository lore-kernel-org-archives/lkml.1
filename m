Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZEYGGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZEYGGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 02:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbZEYGF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 02:05:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbZEYGF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 02:05:56 -0400
Date: Mon, 25 May 2009 08:05:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: kvm/paging_tmpl.h intialize the variable
	before using it
Message-ID: <20090525060531.GA16990@elte.hu>
References: <1242793775.3260.2.camel@localhost.localdomain> <4A193BCE.90307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A193BCE.90307@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> Jaswinder Singh Rajput wrote:
>> May be in some cases paging64_fetch() and paging32_fetch() will return sptep
>> without initialization.
>>
>> Also fixes compilation warning:
>>   CC      arch/x86/kernel/io_delay.o
>>  arch/x86/kvm/paging_tmpl.h: In function ‘paging64_fetch’:
>>  arch/x86/kvm/paging_tmpl.h:279: warning: ‘sptep’ may be used uninitialized in this function
>>  arch/x86/kvm/paging_tmpl.h: In function ‘paging32_fetch’:
>>  arch/x86/kvm/paging_tmpl.h:279: warning: ‘sptep’ may be used uninitialized in this function
>>
>> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
>> ---
>>  arch/x86/kvm/paging_tmpl.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
>> index 6bd7020..99cb10d 100644
>> --- a/arch/x86/kvm/paging_tmpl.h
>> +++ b/arch/x86/kvm/paging_tmpl.h
>> @@ -276,7 +276,7 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
>>  {
>>  	unsigned access = gw->pt_access;
>>  	struct kvm_mmu_page *shadow_page;
>> -	u64 spte, *sptep;
>> +	u64 spte, *sptep = NULL;
>>  	int direct;
>>  	gfn_t table_gfn;
>>  	int r;
>>   
>
> It's a false alarm.  Isn't there a macro to shut up the warning?

there's uninitialized_var(), but that will shut up the warning and 
any _correct_ future warning - so it's dangerous. Initialize it to 
NULL and be done with it? We dont want stray warnings in the kernel.

	Ingo
