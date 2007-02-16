Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbXBPWlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbXBPWlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 17:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXBPWlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 17:41:12 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:54359 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbXBPWlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 17:41:11 -0500
Message-ID: <45D63255.2070801@vmware.com>
Date: Fri, 16 Feb 2007 14:38:13 -0800
From: Dan Hecht <dhecht@vmware.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Keir Fraser <keir@xensource.com>, Chris Wright <chrisw@sous-sol.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Christian Limpach <Christian.Limpach@xensource.com>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Hand <steven.hand@cl.cam.ac.uk>, linux-kernel@vger.kernel.org,
       Ian Pratt <Ian.Pratt@xensource.com>
Subject: Re: [Xen-devel] Re: [patch 14/21] Xen-paravirt: Add XEN config	options
 and disableunsupported config options.
References: <C1FBAFD7.99AB%keir@xensource.com> <45D62759.7080006@vmware.com>
In-Reply-To: <45D62759.7080006@vmware.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2007 22:38:38.0931 (UTC) FILETIME=[33C23A30:01C7521B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2007 01:51 PM, Zachary Amsden wrote:
> Keir Fraser wrote:
>> On 16/2/07 17:46, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:
>>
>>   
>>> Keir Fraser wrote:
>>>     
>>>> This initial patchset does not include save/restore support anyway, so in
>>>> fact it would be consistent to have CONFIG_PREEMPT configurable. I'm sure
>>>> that we are going to have some nasty bugs to fix up as a result, but we
>>>> can't fix them until we find them! Then we can convert our save/restore code
>>>> to use the freezer before submitting it for inclusion.
>>>>       
>>> OK.  So that makes the only config restriction the 100Hz ticks.
>>>     
>> We can extend the Xen timer interface quite easily and get rid of this one
>> too. In fact it doesn't *much* matter if the CONFIG_HZ differs from the Xen
>> ticker rate -- we modified the Linux timer ISR to handle timer interrupts at
>> arbitrary times already. The only drawback is that jiffies updates in burts
>> if CONFIG_HZ is higher than the actual tick rate, and this can affect some
>> calibration constants and cause Linux to print out some weird values at
>> start-of-day.
>>   
> 
> That's why we'd very much like to get a get_cpu_speed paravirt-op 
> implemented.  I think this would be useful to work around these problems 
> for Xen as well.
> 
>

Yes, and regardless of whether you run your periodic timer slower than 
HZ, calibrating time in a VM is always difficult due to the fact the 
kernel is time sharing the physical cpu.  Why not just ask the 
underlying hypervisor?

Really, Time is one of those areas where paravirtualization makes a lot 
of sense, no matter how much virtualization hardware you have crammed 
into your cpu....
