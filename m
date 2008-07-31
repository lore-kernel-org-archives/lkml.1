Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbYGaSVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbYGaSVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYGaSVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:21:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:51423 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbYGaSVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:21:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ORWgqboMVyVuG90A3OUEyjMpkFZANzFBQ+lmVRzI0xNoM3zputzUq1lZGsqFO3Rtwp
         Et40VrN8KQaiiokrhzMEffQd1Sxmtb0I+VKcKQ6zhaf98r+KZ3v2+o0P9pkrr83aLeDC
         Ouk2OZ15/noVZbsQesSYFJbjqUgMIvmsPnzwI=
Message-ID: <86802c440807311121t47671674i356266d068f7e76a@mail.gmail.com>
Date: Thu, 31 Jul 2008 11:21:08 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 0/3] dyn_array support #2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Jack Steiner" <steiner@sgi.com>
In-Reply-To: <4891E938.40708@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807291414.55479.yhlu.kernel@gmail.com>
	 <200807300311.48510.yhlu.kernel@gmail.com>
	 <200807301210.31511.yhlu.kernel@gmail.com>
	 <200807302109.21519.yhlu.kernel@gmail.com> <4891E938.40708@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 9:32 AM, Mike Travis <travis@sgi.com> wrote:
> Yinghai Lu wrote:
>> please check the patches adding dyn_array and nr_irqs #2
>>
>> Thanks
>>
>> YH
>
>
> It appears that the primary difference between your patch and Eric's
> is that you estimate the number of IRQ's required based on the number
> of cpus present, while Eric's patch grows the list based on the IRQ's
> being requested.  For soon to be "power" desktop systems (say dual 8 core
> Nahalem's w/HT), you're reserving IRQ's for 32 cpus on a system which
> probably has one I/O bus (or maybe two).  A dual socket Larabbee system
> will have 256 cpus.  An SGI UV system has more of a "building block"
> approach, where you can grow all three (cpus, memory, I/O) independently.
>
> One other very nice feature of Eric's approach is that the new "IRQ"
> struct being requested can be created in "node local" memory, cutting
> down significantly the number of "cross node" accesses.

where is Eric's patch? I didn't get it...

>
> Plus, I still like Ingo's suggestion to not change NR_IRQS ==> nr_irqs.
> CONFIG_ARCH_HAS_DYNAMIC_IRQS spells out exactly what NR_IRQS means.
> (Even more accurate would be CONFIG_ARCH_HAS_DYNAMIC_NR_IRQS.)

not every array need to be changed to dyn_array, if the static array
is not big enough.
and some DEFINE_BIT map is using NR_IRQS.

>
> The DEFINE_DYN_ARRAY could be the following.  (Changing general purpose
> DYN_ARRAY to specifically purposed IRQ_ARRAY.)

dyn_array is some more generic, and nr_irqs is one of it's user

>
> #ifdef CONFIG_ARCH_HAS_DYNAMIC_IRQS
> #define DEFINE_IRQ_ARRAY <new variable irq array [or list] definition>
> #else
> #define DEFINE_IRQ_ARRAY <old static irq array>
> #endif
>
> For the immediate problem, unraveling the code merge back to IRQ's based
> on NR_IOAPICS would seem to be the least intrusive.

less intrusive way could be use dyn_array and make nr_irqs to be set
via acpi_madt_oem_check...

YH
