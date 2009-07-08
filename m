Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbZGHWeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbZGHWeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbZGHWcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:32:04 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:61698 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758361AbZGHWcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:32:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tKu1+E3gKV+gflj4Qb8qQiKCLG9gCiJR+8UGiHvnl1013FB4ofFSRNgnhnd9AhbCpU
         Pu5yFtujvW5IXjFrLqLC3K4dIzisi6U2ErJn1eLWP7ArLZPhWEPfTG5wdNWD5MIV665s
         K8o/60so5H9TExluC7c4Fd+8GT5HAozcwLeoM=
MIME-Version: 1.0
In-Reply-To: <20090707220640.5352ac94@infradead.org>
References: <817ecb6f0907051623l46ad93e9uc24d8d61669c938e@mail.gmail.com>
	 <200907061043.11793.rusty@rustcorp.com.au>
	 <817ecb6f0907071747g1d3455cdy9eb84102c17c5ad0@mail.gmail.com>
	 <20090707220640.5352ac94@infradead.org>
Date: Wed, 8 Jul 2009 18:31:59 -0400
Message-ID: <817ecb6f0907081531u2f63c3c6y9b1cbc7bf8ff653@mail.gmail.com>
Subject: Re: [PATCH v4] RO/NX protection for loadable kernel modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I like it, you can already put
>
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>

Thanks, I will add this to V5.

...
>> +             /*Set text RO if there are still pages between begin
>> and end*/
>> +             if (end_addr > begin_addr) {
>> +                     pg_count = PFN_DOWN(end_addr - 1) -
>> +                                     PFN_DOWN(begin_addr) + 1;
>> +                     DEBUGP("  RO: 0x%lx %lu\n", begin_addr,
>> pg_count);
>> +                     set_memory_ro(begin_addr, pg_count);
>> +             } else {
...
> I *think* this can be done as
>
> begin_pfn = PFN_UP( (base);
> end_pfn = PFN_DOWN(base + ro_size);
>
> if (end_pfn > begin_pfn)
>        set_memory_ro(begin_pfn >> PAGE_SHIFT, end_pfn - begin_pfn);
>
> (note that I think the +1 you have might be buggy)

The +1 is necessary because of (end_addr - 1). However, I like your
way better, so I will incorporate it in V5.
