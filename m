Return-Path: <linux-kernel-owner+w=401wt.eu-S1760915AbXKNWIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbXKNWIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbXKNWIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:08:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:44881 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbXKNWIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:08:22 -0500
Subject: Re: [patch 3/3] arch_rebalance_pgtables call
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: schwidefsky@de.ibm.com
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <1195040986.9446.23.camel@localhost>
References: <20071112143009.425807965@de.ibm.com>
	 <20071112144010.052155135@de.ibm.com>
	 <200711132333.38086.nickpiggin@yahoo.com.au>
	 <1195032394.9446.6.camel@localhost>  <1195034796.28865.36.camel@pasglop>
	 <1195040986.9446.23.camel@localhost>
Content-Type: text/plain
Date: Thu, 15 Nov 2007 09:07:33 +1100
Message-Id: <1195078053.28865.47.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-11-14 at 12:49 +0100, Martin Schwidefsky wrote:
> 
> They all either have an arch override, call get_unmapped_area again or
> are not relevant. So it should be possible to do the upgrade in
> arch_get_unmapped_area. I still have my doubts though, all future uses
> of the get_unmapped_area pointer have to be checked and I feel it is
> easier to understand to do the upgrade / rebalance of the page table
> at
> the end of get_unmapped_area where every caller of mmap is guaranteed
> to
> pass through.

Well, if something does what you are worried about, then it would be
broken on powerpc as well (among others). We have various constraints on
the address space layout that must be handled by our arch g_u_a (or our
hugetlb one).

Ben.


