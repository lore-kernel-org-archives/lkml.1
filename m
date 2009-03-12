Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbZCLNal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbZCLNal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbZCLNab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:30:31 -0400
Received: from ottmail.xandros.com ([142.46.212.35]:57259 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZCLNaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:30:30 -0400
Date: Thu, 12 Mar 2009 09:22:07 -0400
From: Woody Suwalski <woodys@xandros.com>
To: Len Brown <lenb@kernel.org>
cc: "Youquan,Song" <youquan.song@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <49B90C7F.3080608@xandros.com>
In-Reply-To: <alpine.LFD.2.00.0812120029260.27968@localhost.localdomain>
References: <3606.172.16.183.72.1227236916.squirrel@linux.intel.com>
References: <20081121150839.58dbedfa.akpm@linux-foundation.org>
References: <20081124230208.GA21491@youquan-linux.bj.intel.com>
References: <alpine.LFD.2.00.0812120029260.27968@localhost.localdomain>
Subject: Re: [PATCH]  ACPI: Check _PSS invalidation when BIOS report _PSS with all 0x80000000
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> On Mon, 24 Nov 2008, Youquan,Song wrote:
>
>   
>> On Fri, Nov 21, 2008 at 03:08:39PM -0800, Andrew Morton wrote:
>>     
>>> On Thu, 20 Nov 2008 19:08:36 -0800 (PST)
>>> youquan_song@linux.intel.com wrote:
>>>
>>>       
>>>> Subject: Check _PSS invalidation when BIOS report _PSS with 0x80000000
>>>>
>>>> When cpu frequencey scaling disable,some BIOS report _PSS with all
>>>> 0x80000000.
>>>> If kernel treat this case as valid, the kernel will boot crash when load
>>>> cpufreq govenors.
>>>>
>>>> So in order to cover more buggy BIOSs, the patch just check _PSS core
>>>> frequencey invalidtion.
>>>>
>>>>         
>>> It's unclear how many machines this will affect, and what the effects
>>> of not having the patch are upon those machines.  That is useful
>>> information for people who are deciding whcih kernel versions this
>>> patch should be merged into.
>>>       
>> I meet 2 machines that if the P-states is disabled in BIOS, the kernel
>> will boot crash at loading cpufreq_userspace governor because kernel
>> consider that P-states validate. I know there are some other machines
>> also exist this bug.
>>     
>
> What does _PPC say when P-states are disabled on these machines?
> If it is disabling the _PSS, maybe we should not be looking at the _PSS?
>
> This would be a good patch if 0x80000000 were actually documented
> in the ACPI spec as disabling P-states, but it isn't.
>
> Can you open a bugzilla and attach the acpidump output for
> the two failing machines?  Are those machines shipped with
> P-states enabled by default, or disabled by default?
>
> Also, how, exactly, do we crash when we see these values?
>
>   
>>> Do you think this fix is needed in 2.6.28?  2.6.27.x?  2.6.26.x?  etc?
>>>
>>>       
>> I know that the bug exists in kernel as old as 2.6.18 and also exits on
>> 2.6.28, 2.6.27 etc. 
>>     
>
> So we've been exposed to this BIOS bug for more than 10 releases
> and the world has not ended.  Unless we're about to be exposed to
> a raft of new machines with this BIOS issue, and they have P-states
> disabled by default, I'd say this workaround in not urgent.
>
>   
On Dell Latitude E4300 and E4600 I had to add processor.nocst=1
Otherwise system will become disfunctional after modprobing processor, 
typically on start of X or on exit from X...
Do not have any of the systems on hand, but if useful can provide dmesg 
dump...
I have not tried with 2.6.28 or earlier, so can not say if this is a 
regression or not.

Woody

-- 
Woody Suwalski, Xandros, Ottawa, Canada, 1-613-842-3498 x414

