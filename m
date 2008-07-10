Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYGJIEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYGJIEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYGJIE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:04:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:17094 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbYGJIE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:04:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fzd2SDuU1Qr3TCsDgy2BhR3DNmk3HU+7/ZCP52hv0vphfe1V61nGNBv+QRrY4YJ2hn
         uSSVSmImnMJEg/dwjhfo5gD6lOLjWBOWEaWZJwXLaUmrk6iXOwOAO8Ojk7AINna4aPao
         iI6f8yazyloB6tu1SK1uVWRQyjbr4U/RbBSdo=
Message-ID: <86802c440807100104s1e1f1cdeg421be2dbeffdcb75@mail.gmail.com>
Date: Thu, 10 Jul 2008 01:04:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 05/05] x86: Rename paravirtualized TSC functions
Cc: akataria@vmware.com, "Thomas Gleixner" <tglx@linutronix.de>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Daniel Hecht" <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <20080710075030.GA27361@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214937816.20191.34.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080709061336.GG9760@elte.hu>
	 <86802c440807090020q516b6332qf8e0d65918e7001e@mail.gmail.com>
	 <1215624603.3930.8.camel@alok-dev1>
	 <86802c440807091038m6c14f165xede8b2b0316d0225@mail.gmail.com>
	 <20080710072201.GE14377@elte.hu>
	 <86802c440807100034w3a3ee192k8e565b75fd2df608@mail.gmail.com>
	 <20080710075030.GA27361@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 12:50 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> > that would be the tip/xen64 stuff, right? Does this revert:
>> >
>> > |    Revert "x86_64: there's no need to preallocate level1_fixmap_pgt"
>> > |
>> > |    This reverts commit 033786969d1d1b5af12a32a19d3a760314d05329.
>> > |
>> > |    Suresh Siddha reported that this broke booting on his 2GB testbox.
>> >
>> > solve your problems, or are there other problems still?
>>
>> still is bisecting it now...
>
> ok. I have no mystery crash on my test-systems.
>
> by the looks of it, your crashes seem to be pagetable related. If it's
> in the tip/xen-64bit branch, my candidates would be:
>
>  0f38c08: x86: use __page_aligned_data/bss
>  0337869: x86_64: there's no need to preallocate level1_fixmap_pgt
>  89d7bb5: x86_64: add workaround for no %gs-based percpu
>
> 0337869 is reverted already.
>
> Or if it's an older commit, two candidates would be:
>
>  b50efd2: x86: introduce page_size_mask for 64bit
>  3a9e189: x86: map UV chipset space - pagetable
>
> do you know the sha1 of the first broken tree? We know that
> tip-history-2008-07-08_16.08_Tue is known-good.

first round bisect all works..

it seems make oldconfig change setting between different setting...

diff .config config.full.good
4c4
< # Thu Jul 10 00:52:52 2008
---
> # Thu Jul 10 00:40:03 2008
295,296c295
< CONFIG_CC_STACKPROTECTOR_ALL=y
< CONFIG_CC_STACKPROTECTOR=y
---
> # CONFIG_CC_STACKPROTECTOR is not set

it seems some recent change doesn't like stackprotector.

YH
