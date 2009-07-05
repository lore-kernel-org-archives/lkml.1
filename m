Return-Path: <linux-kernel-owner+w=401wt.eu-S1751758AbZGEF1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbZGEF1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 01:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbZGEF13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 01:27:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50399 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbZGEF12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 01:27:28 -0400
Message-ID: <4A5039BA.7030100@redhat.com>
Date: Sun, 05 Jul 2009 08:27:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v5] enable x2APIC without interrupt remapping under KVM
References: <20090701133007.GC27539@redhat.com>	<1246482017.27006.10670.camel@localhost.localdomain>	<20090703082905.GF21833@elte.hu> <m1r5wwbxjx.fsf@fess.ebiederm.org>	<20090704095556.GB24641@redhat.com> <m1r5wwa56k.fsf@fess.ebiederm.org>	<20090704155002.GC24641@redhat.com> <m1prcgyo5y.fsf@fess.ebiederm.org>
In-Reply-To: <m1prcgyo5y.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2009 03:22 AM, Eric W. Biederman wrote:
> Gleb Natapov<gleb@redhat.com>  writes:
>
>    
>>> Therefore I don't see the point of supporting one without the other.
>>>        
>> x2apic provide us with other benefits as commit message explains, and
>> doesn't add any problems that we don't have now already.
>>      
>
> If this code has a legitimate place on real hardware I am all for it.
>    

As I understood it, x2apic without interrupt remapping will work but is 
not a validated configuration.  Interrupt remapping is only necessary if 
you have > 255 hardware threads + ioapics.  The features are logically 
separate and are only tied together by the vendor's validation practices.


> If this is just a hack to make virtualization faster I don't like the
> extra code paths in the middle core architecture code.  That will
> be a support burden for the foreseeable future.  More code to
> test etc.
>    

There aren't any extra code paths.  The patch separates a long function 
into two smaller ones that each do one thing, and adds a check for kvm.

Maybe it should be split into two to makes that clear.  The first patch 
simplifies the code, the second adds a kvm check.

> Quickly skimming the patch it just appears to stir a mess.
> Plus it adds weird paravirtualization checks, ???
>    

It adds exactly one "weird paravirtualization check ???", then one 
described in the patch description.

> If we are going to have a special code path for virtual hardware
> can we do it right and have something nice to use that makes life
> simpler?

You mean, instead of adding one check in an initialization code path, 
create a new irqchip, a way of describing the topology to the guest, 
support code in kvm (as host)?

> For what we want to do with ioapics they suck and are
> really not suitable.  The only thing that recommends them is that
> they are standard.  But you are deviating from the standard so
> what is the point.
>    

All of the code continues to work.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

