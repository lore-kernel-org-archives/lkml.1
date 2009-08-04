Return-Path: <linux-kernel-owner+w=401wt.eu-S932204AbZHDBUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbZHDBUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 21:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbZHDBUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 21:20:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:37543 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbZHDBUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 21:20:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,317,1246863600"; 
   d="scan'208";a="538330846"
Subject: Re: [tip:x86/urgent] x86: Make 64-bit efi_ioremap use ioremap on
 MMIO regions
From: Huang Ying <ying.huang@intel.com>
To: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "paulus@samba.org" <paulus@samba.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <tip-19157af82cf0575032386f60378527904dbb7b8f@git.kernel.org>
References: <19062.55858.533494.471153@cargo.ozlabs.ibm.com>
	 <tip-19157af82cf0575032386f60378527904dbb7b8f@git.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 09:20:07 +0800
Message-Id: <1249348807.24238.24.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 01:12 +0800, tip-bot for Paul Mackerras wrote:
> Commit-ID:  19157af82cf0575032386f60378527904dbb7b8f
> Gitweb:     http://git.kernel.org/tip/19157af82cf0575032386f60378527904dbb7b8f
> Author:     Paul Mackerras <paulus@samba.org>
> AuthorDate: Mon, 3 Aug 2009 22:38:10 +1000
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Mon, 3 Aug 2009 08:09:59 -0700
> 
> x86: Make 64-bit efi_ioremap use ioremap on MMIO regions
> 
> Booting current 64-bit x86 kernels on the latest Apple MacBook
> (MacBook5,2) via EFI gives the following warning:
> 
> [    0.182209] ------------[ cut here ]------------
> [    0.182222] WARNING: at arch/x86/mm/pageattr.c:581 __cpa_process_fault+0x44/0xa0()

This patch does not really fix the issue. __cpa_process_fault will warn
if target memory area is beyond max_pfn_mapped. EFI runtime RAM area
beyond max_pfn_mapped will trigger the warning too.

To fix the issue. I think we can loose the restriction of
__cpa_process_fault a little. Add a global variable max_pfn, which is
max pfn of all memory type (including RAM, RESERVED, etc, mapped or
unmapped), and __cpa_process_fault warns for memory area beyond max_pfn
only.

Best Regards,
Huang Ying

