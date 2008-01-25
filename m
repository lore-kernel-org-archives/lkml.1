Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbYAYIs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbYAYIs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765741AbYAYIja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:39:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:15342 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762204AbYAYIj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:39:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Bvo45wcgAGfc/ztsF5wC0ev1S4vBIIbubE53uVnaGHDepDS7VsBvhKcBy+Jb6W6O3xw6CX6buiS2+PnG49pxd7BJDHhItC1vwS3joA4PL8TggRv68k+NbKj/WdWldDg/MytIbLUUCqpIeBrIb7nMD9xzYPMzF16zR+hr/UJaio4=
Message-ID: <86802c440801250039m3db374em458b1f15c8a71ad5@mail.gmail.com>
Date: Fri, 25 Jan 2008 00:39:25 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v2
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440801250013p1a35b126l30fb7479b110e97d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47993F1A.5070408@goop.org> <4799400C.1060102@zytor.com>
	 <200801241947.55223.yinghai.lu@sun.com> <4799930B.40006@goop.org>
	 <86802c440801250013p1a35b126l30fb7479b110e97d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 12:13 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Jan 24, 2008 11:43 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >
> > Yinghai Lu wrote:
> > > [PATCH] x86: trim ram need to check if mtrr is there v2
> > >
> > >
> > >>> Jeremy Fitzhardinge wrote:
> > >>> When booting a current x86.git kernel under kvm, I get this:
> > >>>
> > >>> (qemu) Linux version 2.6.24-rc8 (jeremy@ezr) (gcc version 4.1.2 20070925
> > >>> (Red Hat 4.1.2-33)) #1928 SMP PREEMPT Thu Jan 24 17:09:04 PST 2008
> > >>> early_ioremap_init()
> > >>> BIOS-provided physical RAM map:
> > >>> BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> > >>> BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> > >>> BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
> > >>> BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
> > >>> BIOS-e820: 000000001fff0000 - 0000000020000000 (ACPI data)
> > >>> BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
> > >>> console [earlyser0] enabled
> > >>> 0MB HIGHMEM available.
> > >>> 511MB LOWMEM available.
> > >>> Scan SMP from c0000000 for 1024 bytes.
> > >>> Scan SMP from c009fc00 for 1024 bytes.
> > >>> Scan SMP from c00f0000 for 65536 bytes.
> > >>> Scan SMP from c009fc00 for 1024 bytes.
> > >>> ***************
> > >>> **** WARNING: likely BIOS bug
> > >>> **** MTRRs don't cover all of memory, trimmed 131056 pages
> > >>> ***************
> > >>>
> > >> H. Peter Anvin wrote:
> > >> Looks like the code doesn't check that the CPU *has* MTRRs...
> > >>
> > >
> > > so check it mtrr is there, also check if mem less 4G and is AMD as early
> > >
> >
> > Thanks, this gets me to usermode under kvm.
>
> i think the is 0xffffffff to 0xffffffffUL make the difference.
>
> the cpu mode in KVM/qemu may cpu_has_mtrr, but doesn't really have
> return mtrr msr with correct value.
>
> is_cpu(INTEL) already make sure we have mtrr_if got assigned and cpu_has_mtrr.
>
> may need to fix qemu instead...
>
> Can you try post /proc/mtrr for your guest in kvm/qemu?

jeremy,

can you try v3 patch?

Thanks

YH
