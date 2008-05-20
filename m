Return-Path: <linux-kernel-owner+w=401wt.eu-S1764046AbYETRZC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764046AbYETRZC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 13:25:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbYETRYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 13:24:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:60435 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbYETRYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 13:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IaFznkpjJabQXazlwze0K9nK3BPCiJUBH1sXEDwRX2fTpv4QWOfcnN5P8PP7d8sXeR6/ZijpY+SCS+7jj7Lk7BwNkCpTHY9yxDOzTfokHHKcehVGY9ebRVdMu7El/sNkCj5FCJZ3do3fA2ort97olS7n5B3OrrpHfSEXmOwPK10=
Message-ID: <86802c440805201024g27c99de3m721dd157242dad70@mail.gmail.com>
Date: Tue, 20 May 2008 10:24:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] x86: process fam 10h like k8 with fixed mtrr setting
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080520125443.GA4052@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805051557.38556.yhlu.kernel@gmail.com>
	 <20080520125443.GA4052@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 5:54 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Mon 2008-05-05 15:57:38, Yinghai Lu wrote:
>>
>> otherwise fixed MTRR for family 10h may not be changed
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
>> +++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
>> @@ -342,7 +342,7 @@ static void set_fixed_range(int msr, boo
>>
>>       if (lo != msrwords[0] || hi != msrwords[1]) {
>>               if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
>> -                 boot_cpu_data.x86 == 15 &&
>> +                 (boot_cpu_data.x86 >= 0x0f && boot_cpu_data.x86 <= 0x11) &&
>>                   ((msrwords[0] | msrwords[1]) & K8_MTRR_RDMEM_WRMEM_MASK))
>>                       k8_enable_fixed_iorrs();
>>               mtrr_wrmsr(msr, msrwords[0], msrwords[1]);
>
> This also changes family 0x11. Is that ok?

Yes.

YH
