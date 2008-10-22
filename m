Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbYJVWET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbYJVWET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYJVWEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:04:09 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:46814 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752807AbYJVWEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:04:08 -0400
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
	set.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
In-Reply-To: <20081022201743.GR12825@one.firstfloor.org>
References: <1224552902.2640.88.camel@alok-dev1>
	 <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1>
	 <20081021174008.GH12825@one.firstfloor.org>
	 <1224612294.6161.43.camel@alok-dev1>
	 <20081021181536.GI12825@one.firstfloor.org>
	 <1224616236.6161.60.camel@alok-dev1>
	 <20081021192746.GJ12825@one.firstfloor.org>
	 <1224703427.13953.8.camel@alok-dev1> <20081022192622.GA30930@elte.hu>
	 <20081022201743.GR12825@one.firstfloor.org>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 22 Oct 2008 15:04:06 -0700
Message-Id: <1224713046.13953.40.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 13:17 -0700, Andi Kleen wrote:
> > the sync check is there to check the _offset_ between CPUs. CONSTANT_TSC
> > is not a guarantee that the TSC will be coherent across all CPUs.
> 
> I cannot find a quote for it in the docs now, but iirc the AMD
> definition of the bit guarantees offset, aka full synchronization
> over the system.

I found this mail,
http://lkml.org/lkml/2005/11/4/173

If you look for,

-------------------------------------------------------------
Future TSC Directions and Solutions
===================================
Future AMD processors will provide a TSC that is P-state and
C-State invariant and unaffected by STPCLK-throttling.  This
will make  the TSC immune  to drift.  Because using  the TSC
for  fast  timer APIs  is  a  desirable  feature that  helps
performance,  AMD  has  defined  a CPUID  feature  bit  that
software   can   test   to   determine   if   the   TSC   is
invariant. Issuing a CPUID instruction with an %eax register
value of  0x8000_0007, on a  processor whose base  family is
0xF, returns "Advanced  Power Management Information" in the
%eax, %ebx, %ecx,  and %edx registers.  Bit 8  of the return
%edx is  the "TscInvariant" feature  flag which is  set when
TSC is P-state, C-state, and STPCLK-throttling invariant; it
is clear otherwise.
--------------------------------------------------------------

The third line does mention about invariant TSC being immune to drift.

Thanks,
Alok

