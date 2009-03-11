Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbZCKJd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbZCKJd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 05:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZCKJdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 05:33:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44713 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbZCKJds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 05:33:48 -0400
Date: Wed, 11 Mar 2009 10:33:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: 2.6.29 pat issue
Message-ID: <20090311093338.GC12814@elte.hu>
References: <1233856988.4286.83.camel@localhost.localdomain> <498B5ADE.3090602@vmware.com> <m1tz78pdwy.fsf@fess.ebiederm.org> <498C062C.201@vmware.com> <20090304060857.GA18318@linux-os.sc.intel.com> <130CA3A191875048A0624FB523A55EC7075DA7CA@PA-EXMBX51.vmware.com> <20090310013953.GA11312@linux-os.sc.intel.com> <49B6232B.4050503@vmware.com> <1236706959.4529.56.camel@localhost.localdomain> <49B781B6.3060704@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B781B6.3060704@vmware.com>
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


* Thomas Hellstrom <thellstrom@vmware.com> wrote:

> Pallipadi, Venkatesh wrote:
>> On Tue, 2009-03-10 at 01:22 -0700, Thomas Hellstrom wrote:
>>   
>>> Pallipadi, Venkatesh wrote:
>>>     
>>>> On Fri, Mar 06, 2009 at 03:44:07PM -0800, Thomas Hellstrom wrote:
>>>>         
>>>>> We get the warning when we insert RAM pages using vm_insert_pfn().
>>>>> Having normal RAM pages backing a PFN papping is a valid thing.
>>>>>
>>>>>             
>>>> OK. Below is the updated patch that should fix this fully. Can you confirm?
>>>>
>>>> Thanks,
>>>> Venki
>>>>
>>>>         
>>> Yes, this patch should fix the problem. I'm still concerned about the 
>>> overhead of going through the
>>> RAM test for each inserted page.
>>>
>>> Why can't a pfn_valid() test be used in vm_insert_pfn()?
>>>
>>>     
>>
>> Because we may have to track the RAM pages as well in future. We are
>> changing the e820 RAM check and making it use pfn_valid. But, for that
>> we have to change more things in tracking of RAM pages. Today we use one
>> bit in page struct without any refcounting. But, more changes there are
>> on ts way. This change here should keep the current kernel fine without
>> any regression.
>>
>> Thanks,
>> Venki
>>
>>   
> Ok, I understand.
> and yes, the regression should be fixed with the patch.

Good. Venki, mind resending the patch against tip:master, with a 
proper subject line, changelog and Acked-by in place? Thanks,

	Ingo
