Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZHTMgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZHTMgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZHTMge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:36:34 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:57936 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbZHTMgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:36:33 -0400
Date: Thu, 20 Aug 2009 06:36:34 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org,
       Faidon Liambotis <paravoid@debian.org>,
       Matt Domsch <Matt_Domsch@dell.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       bero@arklinux.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-iommu: Work around yet another BIOS bug
Message-ID: <20090820123634.GG11966@parisc-linux.org>
References: <bug-14003-10286@http.bugzilla.kernel.org/> <20090819142634.0fc550d1.akpm@linux-foundation.org> <1250754748.8974.17.camel@macbook.infradead.org> <1250755318.8974.26.camel@macbook.infradead.org> <20090820024453.dd9909a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820024453.dd9909a2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 02:44:53AM -0700, Andrew Morton wrote:
> On Thu, 20 Aug 2009 09:01:58 +0100 David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > +	if (iommu->cap == (uint64_t)-1 && iommu->ecap == (uint64_t)-1) {
> > +		/* Promote an attitude of violence to a BIOS engineer today */
> > +		WARN(1, "Your BIOS is broken; DMAR reported at address %llx returns all ones!\n"
> > +		     "BIOS vendor: %s; Ver: %s; Product Version: %s\n",
> > +		     drhd->reg_base_addr,
> 
> Printing a u64 with %ll will (still) generate a warning on four architectures.

We've got them all now.

$ grep -l int-l64 arch/*/include/asm/types.h
arch/alpha/include/asm/types.h
arch/ia64/include/asm/types.h
arch/mips/include/asm/types.h
arch/powerpc/include/asm/types.h
$ grep -l int-ll64 $(grep -l int-l64 arch/*/include/asm/types.h)
arch/alpha/include/asm/types.h
arch/ia64/include/asm/types.h
arch/mips/include/asm/types.h
arch/powerpc/include/asm/types.h

ie all architectures which use int-l64 only do so for the benefit of
userspace, and use int-ll64 within the kernel.  I did check this by hand
too ;-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
