Return-Path: <linux-kernel-owner+w=401wt.eu-S1759865AbYGQB0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759865AbYGQB0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 21:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYGQBZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 21:25:59 -0400
Received: from hs-out-0708.google.com ([64.233.178.249]:45041 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbYGQBZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 21:25:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HPzEvoZU26cCnx/Pr412/u1MdxZ6ITgJoTZEEQsFmxbawg9yq6yahbK1EwuqsJykgo
         W13StAUjkgk+/QzCGS23wfPeBJaeL4i0lq10iqF5aFdpRGlkhKoMAjRUARKB0cN9FrMP
         ca8xvD6iFczolY7Z6TUfP/nbbVWjDWE1GfJ0s=
Message-ID: <dd18b0c30807161825o45cfaf9fr5462d3dfbf7d22ad@mail.gmail.com>
Date: Thu, 17 Jul 2008 01:25:52 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Jack Howarth" <howarth@bromo.msbb.uc.edu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080716012427.GA27398@bromo.msbb.uc.edu>
	 <dd18b0c30807152230u39ef9c18v78b48d1c7b9ddd17@mail.gmail.com>
	 <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com>
	 <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com>
	 <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com>
	 <20080716140810.GA2861@bromo.msbb.uc.edu>
	 <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com>
	 <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com>
	 <20080717004004.GA17792@bromo.msbb.uc.edu>
	 <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 12:49 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Wed, Jul 16, 2008 at 5:40 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
>> On Wed, Jul 16, 2008 at 03:35:17PM -0700, Yinghai Lu wrote:
>>> please check latest linus tree.
>>>
>>> the commit could be related.
>>>
>>> commit c91d924e3af08d4f98eab6ebf81f2b8ce132448f
>>> Author: Bob Moore <robert.moore@intel.com>
>>> Date:   Tue Jun 10 12:38:10 2008 +0800
>>>
>>>     ACPICA: Fix for hang on GPE method invocation
>>>
>>>     Fixes problem where the new method argument count validation mechanism
>>>     will enter an infinite loop when a GPE method is dispatched.
>>>     Problem fixed be removing the obsolete code that passes GPE block
>>>     information to the notify handler via the control method parameter pointer.
>>>
>>> YH
>>
>> Yinghai,
>>   The latest linus tree doesn't eliminate the hangs in 2.6.26 with your
>> mmconfig patch. Also, I've been unable to repeat the boot with pci=noacpi using
>> the mmconfig patch under 2.6.26. I've uploaded a dmesg file though from
>> the 2.6.25.10 kernel booted with apic=verbose in case that sheds any light
>> on these problems.
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=11087
>>
>> Also, I assume you meant earlier that is bad that with your mmconfig patch
>> that I only see 0 - 63 buses. Any idea how we might fix that (in case it
>> is related to the hang)?
>
> please boot with
> debug initcall_debug apic=verbose pci=routeirq?
>
> and try pci=nommconf
>
> I suspect that could be pci bridge is using 0xf0000000-0xf400000 too
> after Linus merge pci tree, please try to boot with
> pci=early_config_dump
> to see if it is true.
>
> please don't drop the cc list.
>
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

No I have not tried the .iso yet. I am more concerned with the PCI
option i.g. I'm using Direct, if I change to MMCONFIG will it cause
this same bug?
right now I'm occupied with drinking at the moment, but tomorrow I am curious
as to see if this occurs. keep in mind if I'm going to have to deal
with having a stuck system
this means I need to use a live cd to recover the system, the problem
is SELinux why: chrooting into the hardive and then compiling is going
to kind of mess
my policy a little bit(avc's)., but anyways easily resolved within a few hours.
regards;

-- 
Justin P. Mattock
