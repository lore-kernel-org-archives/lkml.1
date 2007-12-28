Return-Path: <linux-kernel-owner+w=401wt.eu-S1752665AbXL1T6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbXL1T6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXL1T56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:57:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:22631 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbXL1T56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:57:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,217,1196668800"; 
   d="scan'208";a="352374525"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] x86: export 'leave_mm' symbol
Date: Fri, 28 Dec 2007 11:57:54 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE4FBEEE@orsmsx423.amr.corp.intel.com>
In-Reply-To: <200712281658.05958.mboton@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86: export 'leave_mm' symbol
Thread-Index: AchJaookgmnR5P16TKOg7U39A8w4YwAIVqPg
References: <200712281658.05958.mboton@gmail.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: =?iso-8859-1?Q?Miguel_Bot=F3n?= <mboton.lkml@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 28 Dec 2007 19:57:15.0395 (UTC) FILETIME=[D80B2530:01C8498B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

 

>-----Original Message-----
>From: Miguel Botón [mailto:mboton.lkml@gmail.com] 
>Sent: Friday, December 28, 2007 7:58 AM
>To: Linux Kernel Mailing List
>Cc: Ingo Molnar; Thomas Gleixner; Pallipadi, Venkatesh
>Subject: [PATCH] x86: export 'leave_mm' symbol
>
>This patch fixes a linking error if CONFIG_ACPI_PROCESSOR=m
>(this error occurs in the 'mm' branch of linux-2.6-x86.git).
>
>We need to export the 'leave_mm' symbol so it can be accessible
>for the ACPI processor module.
>
>Signed-off-by: Miguel Botón <mboton@gmail.com>
>
>diff --git a/arch/x86/kernel/smp_32.c b/arch/x86/kernel/smp_32.c
>index 596d002..dc0cde9 100644
>--- a/arch/x86/kernel/smp_32.c
>+++ b/arch/x86/kernel/smp_32.c
>@@ -263,6 +263,7 @@ void leave_mm(int cpu)
> 	cpu_clear(cpu, per_cpu(cpu_tlbstate, 
>cpu).active_mm->cpu_vm_mask);
> 	load_cr3(swapper_pg_dir);
> }
>+EXPORT_SYMBOL(leave_mm);
> 
> /*
>  *
>diff --git a/arch/x86/kernel/smp_64.c b/arch/x86/kernel/smp_64.c
>index 1334afe..2fd74b0 100644
>--- a/arch/x86/kernel/smp_64.c
>+++ b/arch/x86/kernel/smp_64.c
>@@ -76,6 +76,7 @@ void leave_mm(int cpu)
> 	cpu_clear(cpu, read_pda(active_mm)->cpu_vm_mask);
> 	load_cr3(swapper_pg_dir);
> }
>+EXPORT_SYMBOL(leave_mm);
> 
> /*
>  *
>
>-- 
>	Miguel Botón
>
