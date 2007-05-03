Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbXECLd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbXECLd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 07:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXECLd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 07:33:26 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:27369 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbXECLdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 07:33:25 -0400
X-IronPort-AV: i="4.14,485,1170651600"; 
   d="scan'208"; a="28957236:sNHT23306290"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg Ungerer" <gerg@snapgear.com>
Subject: Re: [PATCH]: linux-2.6.21-uc0 (MMU-less updates)
Date: Thu, 3 May 2007 07:35:36 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <46382055.8030203@snapgear.com> <200705030655.36957.rgetz@blackfin.uclinux.org> <4639C164.5070908@snapgear.com>
In-Reply-To: <4639C164.5070908@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705030735.36879.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 03 May 2007 11:33:24.0191 (UTC) FILETIME=[DC1D3EF0:01C78D76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 3 May 2007 07:03, Greg Ungerer pondered:
> Robin Getz wrote:
> > On Wed 2 May 2007 07:32, Greg Ungerer pondered:
> >> Robin Getz wrote:
> >>> I was trying to understand why we don't want to do the same checking on
> >>> noMMU?
> >>
> >> The problem is on systems that have RAM mapped at high physical
> >> addresses. TASK_SIZE may well be a numerically smaller number
> >> than the address range that RAM sits in. So this test fails when
> >> it shouldn't.
> >
> > So, then this is a problem only on one or two architectures, not all
> > noMMU platforms?
>
> Its not an architecture problem. It can effect any board that
> has RAM mapped at a large numerical addresses (larger than TASK_SIZE).
> So it can effect any non-MMU platform.

Depending on how TASK_SIZE is defined - it looks like everyone else forces it 
to end of memory, except 68k[nommu].

asm-arm/memory.h:#define TASK_SIZE              (CONFIG_DRAM_SIZE)
asm-blackfin/processor.h:#define TASK_SIZE      (memory_end)
asm-frv/mem-layout.h:#define TASK_SIZE                  __UL(0xFFFFFFFFUL)

asm-m68k/processor.h:#define TASK_SIZE  (0xF0000000UL)
asm-m68k/processor.h:#define TASK_SIZE  (0x0E000000)
asm-m68k/processor.h:#define TASK_SIZE  (0x0E000000UL)
asm-m68knommu/processor.h:#define TASK_SIZE     (0xF0000000UL)

I'm happy to learn we are doing something wrong, but I think that we just 
copied the arm/frv setup.

-Robin
