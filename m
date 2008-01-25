Return-Path: <linux-kernel-owner+w=401wt.eu-S1762298AbYAYJU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762298AbYAYJU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:20:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759058AbYAYJTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:19:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756955AbYAYJTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:19:46 -0500
Date: Fri, 25 Jan 2008 10:19:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] x86: fix some bugs about EFI runtime code mapping
Message-ID: <20080125091923.GE23708@elte.hu>
References: <1201240501.15972.46.camel@caritas-dev.intel.com> <4799914C.5060709@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4799914C.5060709@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

>>  +#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
>> +static void __init runtime_code_page_mkexec(void)
>> +{
>> +	efi_memory_desc_t *md;
>> +	unsigned long end;
>> +	void *p;
>> +
>> +	if (!(__supported_pte_mask & _PAGE_NX))
>> +		return;
>>   
>
> On 32-bit non-PAE, _PAGE_NX == 0, so this if() statement should be 
> sufficient to disable the whole function at compile time without 
> needing the outer #if defined wrapper.

good point. The patch fixes bugs and the consolidation it does is very 
nice so i've applied it already, but we could indeed further consolidate 
it and make it a nice #ifdef-less function. Could one of you send an 
add-on patch for this?

	Ingo
