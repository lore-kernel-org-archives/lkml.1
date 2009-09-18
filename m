Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZIRPic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZIRPic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 11:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZIRPic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 11:38:32 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:45425 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbZIRPib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 11:38:31 -0400
Subject: Re: [PATCH 1/2] ARM: Pass IFSR register to do_PrefetchAbort()
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Aaro Koskinen <aaro.koskinen@nokia.com>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       Russell King <linux@arm.linux.org.uk>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       Aaro Koskinen <aakoskin@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <cc557aab0909180808p675c182eke41b23019a609b9a@mail.gmail.com>
References: <f00f1348d91d2403ea0f1c5f05b3ac713664fe7b.1253281256.git.kirill@shutemov.name>
	 <alpine.DEB.1.00.0909181422370.11448@ak-desktop>
	 <cc557aab0909180445o33b6792ewf62a4f5e7589547@mail.gmail.com>
	 <4AB39EC3.4050202@nokia.com>
	 <cc557aab0909180808p675c182eke41b23019a609b9a@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 18 Sep 2009 16:38:18 +0100
Message-Id: <1253288298.9567.45.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2009 15:38:19.0901 (UTC) FILETIME=[0C6962D0:01CA3876]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 18:08 +0300, Kirill A. Shutemov wrote:
> On Fri, Sep 18, 2009 at 5:52 PM, Aaro Koskinen <aaro.koskinen@nokia.com> wrote:
> > Hello,
> >
> > Kirill A. Shutemov wrote:
> >>>
> >>>  #ifdef CONFIG_CPU_PABRT_NOIFAR
> >>> -# ifdef CPU_PABORT_HANDLER
> >>> +# ifdef CPU_PABORT_HANDLER_IFAR
> >>>  #  define MULTI_PABORT 1
> >>>  # else
> >>> -#  define CPU_PABORT_HANDLER(reg, insn)        mov reg, insn
> >>> +#  define CPU_PABORT_HANDLER_IFAR(reg, insn)   mov reg, insn
> >>> +#  define CPU_PABORT_HANDLER_IFSR(reg)         mrc p15, 0, reg, cr5,
> >>> cr0, 1
> >>
> >> It's incorrect. We have IFSR only on ARMv7.
> >
> > It seems my assumption on the availability of that register was wrong, but I
> > think it's available at least on ARMv6, and also that IFAR can be
> > optional...
> 
> I can't find anything in ARMv6-M Architecture Reference Manual by
> keywords "ifar" or "ifsr".

ARMv6-M is for the M-profile CPUs (Thumb or Thumb-2 only ISA, no MMU ,
it doesn't even have CP15).

You would need to check the A profile. Try the ARMv7-AR reference manual
(now freely available, though it needs a click-through) which has a
section on differences with the ARMv6 as well.

-- 
Catalin

