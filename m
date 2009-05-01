Return-Path: <linux-kernel-owner+w=401wt.eu-S1764033AbZEASLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764033AbZEASLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 14:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760900AbZEASKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 14:10:55 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48774 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759822AbZEASKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 14:10:54 -0400
Subject: RE: [RFC][PATCH 33/35] asm-generic/ptemap.h for HIGHPTE users
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA39EF467E5@orsmsx505.amr.corp.intel.com>
References: <20090501144201.D31EF417@kernel>
	 <20090501144252.A2BDDE6B@kernel>
	 <57C9024A16AD2D4C97DC78E552063EA39EF467E5@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain
Date: Fri, 01 May 2009 11:10:52 -0700
Message-Id: <1241201452.29485.206.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 10:51 -0700, Luck, Tony wrote:
> > diff -puN include/asm-generic/ptemap.h~asm-generic-ptemap-h-highpte include/asm-generic/ptemap.h
> > +#ifdef CONFIG_HIGHPTE
> > +#include <asm/highmem.h>
> > +#define pte_offset_map(dir, address) \
> > +     ((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
> > +#define pte_offset_map_nested(dir, address) \
> > +     ((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
> > +#define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
> > +#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
> > +
> > +#else /* !CONFIG_HIGHPTE */
> > +
> > #define pte_offset_map(dir,addr)      pte_offset_kernel((dir),(addr))
> > #define pte_offset_map_nested(dir,addr)       pte_offset_kernel((dir),(addr))
> > #define pte_unmap(pte)                        do { } while (0)
> 
> You need to add a closing #endif here.

Fixed, thanks.

-- Dave

