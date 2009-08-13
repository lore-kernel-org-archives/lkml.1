Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbZHMNsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbZHMNsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 09:48:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZHMNsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 09:48:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49772 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbZHMNsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 09:48:03 -0400
Date: Thu, 13 Aug 2009 09:38:46 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Kurt Garloff <garloff@suse.de>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>,
       Norbert Eicker <N.Eicker@fz-juelich.de>,
       Greg Kroah-Hartman <GregKH@suse.de>,
       Alexey Starikovskiy <AStarikovskiy@suse.cz>,
       Len Brown <LenB@kernel.org>, <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 0/3]: Discard reserved PXM bits for SRAT v1
Message-ID: <20090813093846.6acbbf57@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20090518093352.GC15531@tpkurt2.garloff.de>
References: <20090518093352.GC15531@tpkurt2.garloff.de>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 11:33:52 +0200
Kurt Garloff <garloff@suse.de> wrote:

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

Did this patchset get lost or something? I don't see it anywhere, not even
in the ACPI 'testing' tree...
