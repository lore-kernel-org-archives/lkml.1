Return-Path: <linux-kernel-owner+w=401wt.eu-S1764055AbXGULVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764055AbXGULVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 07:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760795AbXGULVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 07:21:36 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:33820 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761228AbXGULVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 07:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BcgXokc9opH5yEEzI8fGjuMXHnPM3OaWtS24aOvk28wHoqQnefxxS5aAXHTWNhA8PaiDcYVsqSb/tVW+ShaRBQciCZJiEFScGyTwtUnL4hhdpKo/+VPgWwrC84RHGAEWdoVVolCuJas9NLngytVulQZYThf+TMcxsa/YY8b7Hus=
Message-ID: <86802c440707210421h33a4fa50n9856bfe95e5b386f@mail.gmail.com>
Date: Sat, 21 Jul 2007 04:21:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] x86_64: use apic core id bits for core nums
Cc: "Andrew Morton" <akpm@linux-foundation.org>, joachim.deguara@amd.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <200707211022.47859.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440707210056s745d44f1jc6437064741299eb@mail.gmail.com>
	 <200707211022.47859.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Andi Kleen <ak@suse.de> wrote:
> On Saturday 21 July 2007 09:56:15 Yinghai Lu wrote:
> > please check my version, we should use core id bits instead.
> >
> > it should replace
> > [PATCH for review] [37/48] x86_64: make k8topology multi-core aware
>
> Yes, you're right the patch is not good. It should probably use
> information from the regular CPU setup code, not touch cpuid
> directly

need move some code into early_identify_cpu from identify_cpu in
arch/x86_64/kernel/setup.c
then could use that bits in bsp cpu info.

BTW:
it seems for BSP only early_identify_cpu is called, and identify_cpu
is only use in smp_callin for AP. Do i miss sth.

YH
