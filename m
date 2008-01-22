Return-Path: <linux-kernel-owner+w=401wt.eu-S1752181AbYAVOn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbYAVOn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 09:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYAVOnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 09:43:50 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:41108
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbYAVOnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:43:49 -0500
Date: Tue, 22 Jan 2008 15:43:32 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Izik Eidus <izike@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, holt@sgi.com,
       Hugh Dickins <hugh@veritas.com>, clameter@sgi.com
Subject: Re: [kvm-devel] [PATCH] mmu notifiers #v3
Message-ID: <20080122144332.GE7331@v2.random>
References: <20080113162418.GE8736@v2.random> <20080116124256.44033d48@bree.surriel.com> <478E4356.7030303@qumranet.com> <20080117162302.GI7170@v2.random> <478F9C9C.7070500@qumranet.com> <20080117193252.GC24131@v2.random> <20080121125204.GJ6970@v2.random> <4795F9D2.1050503@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4795F9D2.1050503@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 04:12:34PM +0200, Avi Kivity wrote:
> Andrea Arcangeli wrote:
>> diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
>> --- a/include/asm-generic/pgtable.h
>> +++ b/include/asm-generic/pgtable.h
>> @@ -44,8 +44,10 @@
>>  ({									\
>>  	int __young;							\
>>  	__young = ptep_test_and_clear_young(__vma, __address, __ptep);	\
>> -	if (__young)							\
>> +	if (__young) {							\
>>  		flush_tlb_page(__vma, __address);			\
>> +		mmu_notifier(age_page, (__vma)->vm_mm, __address);	\
>> +	}								\
>>  	__young;							\
>>  })
>>   
>
> I think that unconditionally doing
>
>  __young |= mmu_notifier(test_and_clear_young, ...);
>
> allows hardware with accessed bits more control over what is going on.

Agreed, likely it'll have to be mmu_notifier_age_page().
