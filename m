Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYGRVOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYGRVOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 17:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYGRVOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 17:14:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:38437 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYGRVOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 17:14:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xDbXcWNyLVVH1ERd7uTGvE/AOU9JdmXlpSUf/YRrvXiDkmQCVNy3dq25DFWQmz4Wtu
         HRihToTclGuzzZl++iufmHhP89kI+H5F0fBC616uHoml9XZvXnoypwTdyhhia+NzSqBp
         YOjZF9LPFvFxvn9unvZpRdS2Z/kBCbtX83Mj0=
Message-ID: <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com>
Date: Fri, 18 Jul 2008 14:13:52 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Zachary Amsden" <zach@vmware.com>
In-Reply-To: <20080718210348.GB24373@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl>
	 <20080718105259.GY6875@elte.hu>
	 <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com>
	 <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com>
	 <20080718210348.GB24373@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 2:03 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> > git merge tip/x86/x2apic
>> CONFLICT (content): Merge conflict in arch/x86/kernel/Makefile
>> CONFLICT (content): Merge conflict in arch/x86/kernel/paravirt.c
>> CONFLICT (content): Merge conflict in arch/x86/kernel/smpboot.c
>> CONFLICT (content): Merge conflict in arch/x86/kernel/vmi_32.c
>> CONFLICT (content): Merge conflict in arch/x86/xen/enlighten.c
>> CONFLICT (content): Merge conflict in include/asm-x86/apic.h
>> CONFLICT (content): Merge conflict in include/asm-x86/paravirt.h
>
> that's due to the changes in tip/x86/apic and in tip/x86/uv.
>
> ok, i've just merged x86/apic into x86/x2apic and x86/uv as well, and
> pushed out the result.
>
> Note: it's a first raw merge and completely untested. It will now merge
> cleanly into tip/master. There are probably a few details missing.
>
> The smp-alternatives based trick that Maciej applied for write-around
> can stay in the mem_apic_* methods - modern APICs do not need any
> workaround in this area and can just use apic_ops.

  CC      arch/x86/kernel/apic_64.o
arch/x86/kernel/apic_64.c:170: error: unknown field 'write_atomic'
specified in initializer
arch/x86/kernel/apic_64.c:170: error: 'native_apic_mem_write_atomic'
undeclared here (not in a function)
arch/x86/kernel/apic_64.c:209: error: unknown field 'write_atomic'
specified in initializer
arch/x86/kernel/apic_64.c:209: warning: initialization from
incompatible pointer type
make[1]: *** [arch/x86/kernel/apic_64.o] Error 1
make: *** [arch/x86/kernel] Error 2


YH
