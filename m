Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbYFTHIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbYFTHIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 03:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYFTHIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 03:08:24 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:14872 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYFTHIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 03:08:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GDx4EKTBtDvTJRQWsIkB6KjGhp+sc69VxwCp2BKx2N0GgpQebViE/bmrvB+iZisAMr
         DSgXufGJnZ9afxlEg7YpmHLcH/thlNFVeMW29n5c1/C96J4HgF3oRF9knWUqRc+UHG6G
         wNkUBb4giHmcsnq6PgoOem1foaf/01knVLXyY=
Message-ID: <86802c440806200008y23f7029bg9e254f3b17349bad@mail.gmail.com>
Date: Fri, 20 Jun 2008 00:08:18 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: make 64bit identify_cpu use cpu_dev v2
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Dave Jones" <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Thomas Petazzoni" <thomas.petazzoni@free-electrons.com>
In-Reply-To: <20080620062958.GA31182@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806180215.53755.yhlu.kernel@gmail.com>
	 <200806191530.32354.yhlu.kernel@gmail.com>
	 <20080620062958.GA31182@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 11:29 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> v2: fix early_panic on some conf
>>     reason : struct cpu_vendor_dev size is 16, need to make table to be 16
>>              byte alignment
>>     also print out the cpu supported...
>
> applied to tip/x86/cpu, thanks Yinghai.
>
>> --- linux-2.6.orig/arch/x86/kernel/vmlinux_64.lds.S
>> +++ linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
>> @@ -168,6 +168,7 @@ SECTIONS
>>       *(.con_initcall.init)
>>    }
>>    __con_initcall_end = .;
>> +  . = ALIGN(16);
>>    __x86cpuvendor_start = .;
>>    .x86cpuvendor.init : AT(ADDR(.x86cpuvendor.init) - LOAD_OFFSET) {
>>       *(.x86cpuvendor.init)
>
> ah, nice one!
>
> we broke that via v2.6.25-37-g03ae576 "x86: use ELF section to list CPU
> vendor specific code" - should we backport your fix to mainline right
> now? I'm wondering why it only triggered now - did alignment change in
> this section due to your changes and thus this dormant bug became
> triggerable?

don't need,  that section is not used before this patch.
we my add some building check to verify those kind info to avoid same kind bug.

YH
