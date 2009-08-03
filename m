Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbZHCXVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbZHCXVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 19:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932267AbZHCXVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 19:21:34 -0400
Received: from ozlabs.org ([203.10.76.45]:52193 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbZHCXVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 19:21:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] next-20090730 lguest build breaks with pfn_pmd()
Date: Tue, 4 Aug 2009 08:51:31 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, lguest@ozlabs.org,
       sfr@canb.auug.org.au
References: <20090729173611.b82478cd.sfr@canb.auug.org.au> <20090730120533.GB4955@linux.vnet.ibm.com> <20090731110356.cd0bc550.randy.dunlap@oracle.com>
In-Reply-To: <20090731110356.cd0bc550.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908040851.31556.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Aug 2009 03:33:56 am Randy Dunlap wrote:
> On Thu, 30 Jul 2009 17:35:33 +0530 Kamalesh Babulal wrote:
> > @@ -984,14 +984,14 @@ static unsigned long setup_pagetables(struct lguest *lg,
> >  	for (i = j = 0; i < mapped_pages && j < PTRS_PER_PMD;
> >  	     i += PTRS_PER_PTE, j++) {
> >  		pmd = pfn_pmd(((unsigned long)&linear[i] - mem_base)/PAGE_SIZE,
> > -			      _PAGE_PRESENT | _PAGE_RW | _PAGE_USER);
> > +			      __pgrot(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER));
> 
> s/__pgrot/__pgprot/

Damn, sorry.  I threw this patch in linux-next and went skiing.

Kamalesh said:

"I have tested the patch for the build failure only."

This was clearly untrue.  Don't do that again, or I'll just ignore your
emails.

Rusty.
