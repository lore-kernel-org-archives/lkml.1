Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbZHMP6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbZHMP6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 11:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZHMP6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 11:58:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbZHMP6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 11:58:54 -0400
Message-ID: <4A8437CF.7060007@zytor.com>
Date: Thu, 13 Aug 2009 08:57:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Wang, Shane" <shane.wang@intel.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Subject: Re: [PATCH 1/1] intel_txt: to fix build errors of CONFIG_ACPI_SLEEP
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu> <20090812145321.GA11347@elte.hu> <037F493892196B458CD3E193E8EBAD4F01EAB64402@pdsmsx502.ccr.corp.intel.com> <20090813064634.GA12143@elte.hu> <4A842C5B.7050100@zytor.com> <20090813154610.GB21002@elte.hu>
In-Reply-To: <20090813154610.GB21002@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2009 08:46 AM, Ingo Molnar wrote:
> 
>> Consider the attached instead patch, which abstracts some of the 
>> (way more complex than it should be) open-coded stuff and 
>> therefore makes it stick out less.
> 
> it's better, but why not put these:
> 
>> +#ifdef CONFIG_ACPI_SLEEP
>>  	tboot->acpi_sinfo.kernel_s3_resume_vector = acpi_wakeup_address;
>> +#endif
> 
> into a helper inline in a header file and let the #ifdefs be there, 
> or something like that. That way the .c file stays readable.
> 

That would probably be a good thing, *but* I think that that is more
cleaner done as a pass over the entire ACPI code and its dependencies.

acpi_wakeup_address is arguably wrong interface, in the first place:
it's exported as a physical address, but we actually need the virtual
address in several places, and so there is a lot of back-and-forth (if
we had the va interface this wouldn't be the only place in the case
which would be cleaner.)  However, again, this is an ACPI-global issue.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

