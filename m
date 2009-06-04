Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZFDVZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZFDVZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbZFDVZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:25:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52283 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbZFDVZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:25:32 -0400
Date: Thu, 4 Jun 2009 17:24:54 -0400
From: Dave Jones <davej@redhat.com>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Harald Welte <HaraldWelte@viatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090604212454.GA20822@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Michael S. Zick" <lkml@morethan.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Duane Griffin <duaneg@dghda.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906041312.45847.lkml@morethan.org> <20090604203313.GA19286@redhat.com> <200906041601.33400.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041601.33400.lkml@morethan.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 04:01:30PM -0500, Michael S. Zick wrote:

 > But while your here, what is your opinion on this one,
 > in: int __init pcibios_init(void)
 > 
 > - - - - -
 >         pci_cache_line_size = 32 >> 2;
 >         if (c->x86 >= 6
 >         && (c->x86_vendor == X86_VENDOR_AMD) || (c->x86_vendor == X86_VENDOR_CENTAUR))
 >                 pci_cache_line_size = 64 >> 2;  /* K7 & K8 and VIA C7-M */
 >         else if (c->x86 > 6 && c->x86_vendor == X86_VENDOR_INTEL)
 >                 pci_cache_line_size = 128 >> 2; /* P4 */
 > 
 > Mike

C7's L1 cachelines are 64 bytes, so it's right in that case,
but the earlier Centaur CPUs are 32 bytes, so it should be checking steppings.

Or better yet, why not just set it to boot_cpu_data->x86_clflush_size ?

	Dave

