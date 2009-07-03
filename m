Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbZGCTxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbZGCTxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 15:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbZGCTxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 15:53:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbZGCTxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 15:53:13 -0400
Message-ID: <4A4E609C.5030608@zytor.com>
Date: Fri, 03 Jul 2009 12:48:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: lkml@morethan.org
CC: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
References: <200907031314.36243.lkml@morethan.org> <200907031403.34566.lkml@morethan.org> <4A4E58AC.7010905@zytor.com> <200907031441.04604.lkml@morethan.org>
In-Reply-To: <200907031441.04604.lkml@morethan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
> 
> Good point: (1<<(32-PAGE_SIFT)) would handle other than 4k pages.
> 
> I just hardcoded it as a working example of the change from setting
> the page table size by design rather than numeric error.
> 

As Jeremy pointed out, it's not wrong as written.  gas by design uses
arbitrary-precision arithmetic, and even if it didn't, it would still be
correct: (1 << 32) would collapse to 0, so all the rest of the
calculations would still be right.

Any way you can dump out this value from the vmlinux file (nm vmlinux |
grep MAPPING_BEYOND_END) in both cases?  What version of as/binutils do
you have installed?

> And yes, it has 512Mbyte of ram, so 1/2Mbyte page table sounds right to me.

/proc/cpuinfo, please?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

