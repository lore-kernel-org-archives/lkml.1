Return-Path: <linux-kernel-owner+w=401wt.eu-S1762370AbXJZDeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762370AbXJZDeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXJZDeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:34:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:18643 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbXJZDeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:34:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,331,1188802800"; 
   d="scan'208";a="255914564"
Subject: Re: [PATCH 1/3 -v4] x86_64 EFI runtime service support: EFI basic
	runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
References: <1193295473.23935.202.camel@caritas-dev.intel.com>
	 <alpine.LFD.0.9999.0710251800250.3186@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Oct 2007 11:36:32 +0800
Message-Id: <1193369792.23935.283.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 26 Oct 2007 03:33:42.0714 (UTC) FILETIME=[01B861A0:01C81781]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 18:09 +0200, Thomas Gleixner wrote:
> On Thu, 25 Oct 2007, Huang, Ying wrote:
> 
> > This patch adds basic runtime services support for EFI x86_64
> > system. The main file of the patch is the addition of efi.c for
> > x86_64. This file is modeled after the EFI IA32 avatar.
> 
> modeled means copied and modified, right?
> 
> This is wrong. I compared efi_32.c and efi_64.c and a large amount of
> the code is simply the same. The small details can be sorted out by
> two sets of macros/inline functions easily.
> 
> Please fix this up.

Yes. There are many duplicated code between efi_32.c and efi_64.c, and
they should be merged. But there are some code that is different between
efi_32.c and efi_64.c. For example, there is different implementations
of efi_call_phys_prelog in both files, and there is an implementation of
efi_memmap_walk only in efi_32.c not in efi_64.c.

3 possible schemes are as follow:

- One efi.c, with EFI 32/64 specific code inside corresponding
#ifdef/#endif.

- 3 files: efi.c, efi_32.c, efi_64.c, common code goes in efi.c, EFI
32/64 specific code goes in efi_32/64.c. This will make some variable,
function external instead of static.

- 3 files: efi.c, efi_32.c, efi_64.c, common code goes in efi.c, EFI
32/64 specific code goes in efi_32/64.c. efi.c include efi_32/64.c
according to architecture.

Which one is preferred? Or I should take another scheme?

Best Regards,
Huang Ying
