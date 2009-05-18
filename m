Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZERPhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZERPhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZERPhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:37:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:39386 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbZERPhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:37:32 -0400
Date: Mon, 18 May 2009 08:33:32 -0700
From: Greg KH <gregkh@suse.de>
To: Kurt Garloff <garloff@suse.de>,
       Linux kernel list <linux-kernel@vger.kernel.org>,
       Norbert Eicker <N.Eicker@fz-juelich.de>,
       Alexey Starikovskiy <AStarikovskiy@suse.cz>,
       Len Brown <LenB@kernel.org>
Subject: Re: [PATCH 0/3]: Discard reserved PXM bits for SRAT v1
Message-ID: <20090518153332.GA16817@suse.de>
References: <20090518093352.GC15531@tpkurt2.garloff.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090518093352.GC15531@tpkurt2.garloff.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 11:33:52AM +0200, Kurt Garloff wrote:
> Hi,
> 
> ACPI specification says that the OS must disregard reserved bits.
> The x86_64 SRAT parser does not discard the upper 24 bits of the
> proximity_domain (pxm) in the acpi_srat_mem_affinity entries for
> SRAT v1 tables. (v2 has 32 bits wide fields.)
> This can lead to problems with poor BIOS implementations that failed
> to set resreved bytes to zero. (The ACPI spec is a bit vague here
> unfortunately.)
> 
> This was also inconsistent: On x86-64 (srat_64.c), the 
> _cpu_affinity does only use the low 8 bits of pxm, while the
> full 32 bits of _mem_affinity are consumed.
> In srat_32.c (x86), only 8bits are used (which is OK, a 32bit system
> with >256 PXMs does not seem reasonable at all).
> On ia64, the support of more than 8 bits was consistent between
> mem and cpu affinity entries, however it dependent on "sn2" platform.
> 
> The patch series has the following goals:
> * Make the kernel support consistently 8bits or 32bits for the
>   proximity domain
> * Make this dependent on the SRAT version; v1 => 8bits, v2 => 32bits.
> 
> Overview over the patches:
> - [1/3] Store the SRAT table version value in acpi_srat_revision 
> - [2/3] x86-64: Discard the upper 24 bits in mem_affinity if rev <= 1
>         and use upper 24bits in cpu_affinity if rev >= 2
> - [3/3] ia64: Also use upper 8/24bits if rev >= 2 (but leave logic to
>         enable on sn2 as well -- I don't know if sn2 reports v1 or v2
>         SRAT) Also add two __init decls in ia64 pxm accessors.
> 
> Patch has been tested on x86-64 against an 2.6.27.x kernel.
> (Patch is against current git.)
> 
> Thanks for James, Greg, Alexey, Norbert for comments, review and testing.
> 
> Please review and apply!
> 
> Greg, I believe this is a candidate for -stable.

Does it meet the rules at described in
Documentation/stable_kernel_rules.txt?  If so, add a
	Cc: stable <stable@kernel.org>
to the signed-off-by: area in the patch, and when it goes into Linus's
tree, it will be automatically queued up to be added to the next -stable
release.

thanks,

greg k-h
