Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbZC1Jyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbZC1Jyz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 05:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZC1Jyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 05:54:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51693 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbZC1Jyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 05:54:45 -0400
Message-ID: <49CDF3CB.8070000@redhat.com>
Date: Sat, 28 Mar 2009 12:54:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 1/2] x86/mm: maintain a percpu "in get_user_pages_fast"
 flag
References: <49CD37B8.4070109@goop.org> <49CD9E25.2090407@redhat.com> <49CDAF17.5060207@goop.org>
In-Reply-To: <49CDAF17.5060207@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>> @@ -255,6 +260,10 @@ int get_user_pages_fast(unsigned long start, 
>>> int nr_pages, int write,
>>>      * address down to the the page and take a ref on it.
>>>      */
>>>     local_irq_disable();
>>> +
>>> +    cpu = smp_processor_id();
>>> +    cpumask_set_cpu(cpu, in_gup_cpumask);
>>> +
>>
>> This will bounce a cacheline, every time.  Please wrap in CONFIG_XEN 
>> and skip at runtime if Xen is not enabled.
>
> Every time?  Only when running successive gup_fasts on different cpus, 
> and only twice per gup_fast. (What's the typical page count?  I see 
> that kvm and lguest are page-at-a-time users, but presumably direct IO 
> has larger batches.)

Databases will often issue I/Os of 1 or 2 pages.  But not regressing kvm 
should be sufficient motivation.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

