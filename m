Return-Path: <linux-kernel-owner+w=401wt.eu-S1765807AbYEHSnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765807AbYEHSnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbYEHSmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:42:54 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52033 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbYEHSmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:42:53 -0400
Subject: Re: [PATCH] x86: fix PAE pmd_bad bootup warning
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, Hugh Dickins <hugh@veritas.com>,
       Ingo Molnar <mingo@elte.hu>, Jeff Chua <jeff.chua.linux@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080508171657.GO23990@us.ibm.com>
References: <Pine.LNX.4.64.0805062043580.11647@blonde.site>
	 <20080506202201.GB12654@escobedo.amd.com>
	 <1210106579.4747.51.camel@nimitz.home.sr71.net>
	 <20080508143453.GE12654@escobedo.amd.com>
	 <1210258350.7905.45.camel@nimitz.home.sr71.net>
	 <20080508151145.GG12654@escobedo.amd.com>
	 <1210261882.7905.49.camel@nimitz.home.sr71.net>
	 <20080508161925.GH12654@escobedo.amd.com>
	 <20080508163352.GN23990@us.ibm.com>
	 <20080508165111.GI12654@escobedo.amd.com>
	 <20080508171657.GO23990@us.ibm.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 11:42:44 -0700
Message-Id: <1210272164.7905.66.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 10:16 -0700, Nishanth Aravamudan wrote:
> 
> Dunno, seems quite clear that the bug is in pagemap_read(), not any
> hugepage code, and that the simplest fix is to make pagemap_read() do
> what the other walker-callers do, and skip hugepage regions.

Agreed, this certainly isn't a huge page bug.

But, I do think it is absolutely insane to have pmd_clear_bad() going
after perfectly good hugetlb pmds.  The way it is set up now, people are
bound to miss the hugetlb pages because just about every single
pagetable walk has to be specially coded to handle or avoid them.  We
obviously missed it, here, and we had two good examples in the same
file! :)

-- Dave

