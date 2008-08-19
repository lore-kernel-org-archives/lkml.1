Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYHSUw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYHSUw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYHSUwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:52:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:9795 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYHSUwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uuGwx8VKykWnqWvsXxxBQ4xxEukVCsjXWhAPTHBDxfYLnbR1rrbYAca6jbQM++iaoE
         xOFpfmzOV2EGzX5nKmz0JDkkBMB5c7HWUiJ+C7tzf/FL1k7W0BFh+ITNUGAj5t0BONRA
         IkFKMFjGhF4qHVEQR1pg1y9naz3KqU89p5Zwk=
Message-ID: <86802c440808191352g75c99737kcb8c9c20d59c8f7b@mail.gmail.com>
Date: Tue, 19 Aug 2008 13:52:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alex Nixon" <alex.nixon@citrix.com>
Subject: Re: [PATCH] X86: Change the default value of nr_irqs from 32 to NR_IRQs
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48AB241A.4030706@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AAFAE4.7070409@citrix.com>
	 <86802c440808191044h74871ba1u62330dae18599436@mail.gmail.com>
	 <0E902970173AF84089673FA54B7FE78A2CA11D@lonpexch01.citrite.net>
	 <86802c440808191124v39ce2aa9rb548d3bdd75ca25c@mail.gmail.com>
	 <48AB11A3.4060102@citrix.com>
	 <86802c440808191200u364ffd86h49af661e58d20ea3@mail.gmail.com>
	 <48AB241A.4030706@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 12:50 PM, Alex Nixon <alex.nixon@citrix.com> wrote:
> Yinghai Lu wrote:
>>
>> On Tue, Aug 19, 2008 at 11:32 AM, Alex Nixon <alex.nixon@citrix.com>
>> wrote:
>>>
>>> Yinghai Lu wrote:
>>>>
>>>> On Tue, Aug 19, 2008 at 11:13 AM, Alex Nixon (Intern)
>>>> <Alex.Nixon@citrix.com> wrote:
>>>>>
>>>>> Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>>>>>
>>>>>> On Tue, Aug 19, 2008 at 9:55 AM, Alex Nixon <alex.nixon@citrix.com>
>>>>>> wrote:
>>>>>>>
>>>>>>> If the number of discovered IRQs is suspiciously low, this patch
>>>>>>> causes
>>>>>>> the number reported to default to NR_IRQS, rather than 32.  NR_IRQS
>>>>>>> has
>>>>>>> already been defined to be a >sensible value for the current system
>>>>>>> (in
>>>>>>> particular, at least 224 when paravirtualisation is involved).
>>>>>>>
>>>>>> if only one ioapic, nr will be 24<<1, you will get 48. Does pv has io
>>>>>> apic
>>>>>> ?
>>>>>>
>>>>>> YH
>>>>>>
>>>>> I'm not sure about the general case, but Xen does not (Jeremy correct
>>>>> me
>>>>> if
>>>>> I'm wrong).
>>>>>
>>>>> Unless I'm missing something (which I may well be; I'm new to this area
>>>>> of
>>>>> code), it seems more logical anyway to default back to the calculated
>>>>> system-specific value (NR_IRQS), instead of 32, which seems rather
>>>>> arbitrary.
>>>>
>>>> can you try !CONFIG_HAVE_SPARSE_IRQ and CONFIG_HAVE_SPARSE_IRQ ?
>>>>
>>>> YH
>>>
>>> Sorry I should have mentioned originally - the bug occurs both with
>>> CONFIG_HAVE_SPARSE_IRQ enabled, and disabled.
>>
>> maybe we need special probe_nr_irqs for PV or not call that in
>> setup_arch for xen -- it will leave nr_irqs == NR_IRQS
>>
>> YH
>
> That would be one solution, but would be more involved than this trivial
> patch (although if considered more 'correct' then it is of course worth the
> effort).
>  But attempting to keep things simple, is there a reason it's preferable to
> fall back to 32 rather NR_IRQS?

when !CONFIG_HAVE_SPARSE_IRQ, with dyn_array, could allocate irq_desc
and etc as less as possible.
when CONFIG_HAVE_SPARESE_IRQ, no actually meaning for nr_irqs.

YH
