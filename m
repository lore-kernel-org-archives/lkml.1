Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYAYUF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYAYUF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYAYUFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:05:14 -0500
Received: from gw.goop.org ([64.81.55.164]:41691 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYAYUFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:05:13 -0500
Message-ID: <479A40F6.1050006@goop.org>
Date: Fri, 25 Jan 2008 12:05:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] x86: fix NX bit handling in change_page_attr
References: <1201240493.15972.43.camel@caritas-dev.intel.com> <47999089.5080609@goop.org> <20080125084633.GA23708@elte.hu> <20080125103256.GR23708@elte.hu>
In-Reply-To: <20080125103256.GR23708@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> ...
>> +       ref_prot = pte_pgprot(pte_mkexec(pte_clrhuge(*kpte)));
>>
>> i.e. it now goes through all the proper accessors.
>>     
>
> i guess it would be nicer to have the proper accessors to just clear the 
> NX bit from ref-prot - instead of re-constructing the *kpte from 
> scratch. But i see no other way to do it right now than to access 
> pgprot_val() as an lvalue. Jeremy, what would be the best approach here?

The pte_* accessors are really just helpers, so they're not mandatory.  
Something like this would be fine:

	refprot = __pgprot(pgprot_val(refprot) & ~_PAGE_NX);

This is identical to the lvalue form, but avoids using it as an lvalue.

    J
