Return-Path: <linux-kernel-owner+w=401wt.eu-S1763424AbZEARwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763424AbZEARwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZEARv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:51:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:7699 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbZEARv6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:51:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,280,1239001200"; 
   d="scan'208";a="686727406"
From: "Luck, Tony" <tony.luck@intel.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 1 May 2009 10:51:57 -0700
Subject: RE: [RFC][PATCH 33/35] asm-generic/ptemap.h for HIGHPTE users
Thread-Topic: [RFC][PATCH 33/35] asm-generic/ptemap.h for HIGHPTE users
Thread-Index: AcnKa5perj1MKvsyQm+Ay1OOHmucbwAGZliQ
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39EF467E5@orsmsx505.amr.corp.intel.com>
References: <20090501144201.D31EF417@kernel> <20090501144252.A2BDDE6B@kernel>
In-Reply-To: <20090501144252.A2BDDE6B@kernel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff -puN include/asm-generic/ptemap.h~asm-generic-ptemap-h-highpte include/asm-generic/ptemap.h
> +#ifdef CONFIG_HIGHPTE
> +#include <asm/highmem.h>
> +#define pte_offset_map(dir, address) \
> +     ((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
> +#define pte_offset_map_nested(dir, address) \
> +     ((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
> +#define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
> +#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
> +
> +#else /* !CONFIG_HIGHPTE */
> +
> #define pte_offset_map(dir,addr)      pte_offset_kernel((dir),(addr))
> #define pte_offset_map_nested(dir,addr)       pte_offset_kernel((dir),(addr))
> #define pte_unmap(pte)                        do { } while (0)

You need to add a closing #endif here.

-Tony
