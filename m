Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbYBRUBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbYBRUBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYBRUBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:01:05 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:16717 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYBRUBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:01:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q69TMXMomLp1fVA2tFzBhGUP7s3pf0D6fSqGVY8a/JwsNUG+FHbYcPMJBCt4FHyorltTmJDL4GhW5rjEN7yUvbGWVm1Dsuh5ntP3TwG2ObbRCpYDEiUalCWW2sOiys1uIlps6GHLjKYS2NcZaq3aoCwmMNNoSCebr99r9Y4hEog=
Message-ID: <6101e8c40802181201t144bf5d9q5d31b7f6ab3abaed@mail.gmail.com>
Date: Mon, 18 Feb 2008 21:01:00 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y #2] quicklists: do not release off node pages early
Cc: "Oliver Pinter" <oliver.pntr@gmail.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Greg KH" <gregkh@suse.de>, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy. Dunlap" <rdunlap@xenotime.net>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Dave Jones" <davej@redhat.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Domenico Andreoli" <cavokz@gmail.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>
In-Reply-To: <6101e8c40802170918s65344622sb3de8bf6f9b031f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40802170918s65344622sb3de8bf6f9b031f4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From b5cf6be2dfcb4ae3885edec574526221c58f0216 Mon Sep 17 00:00:00 2001
 From: Christoph Lameter <clameter@sgi.com>
 Date: Sat, 22 Dec 2007 14:03:23 -0800
 Subject: [PATCH] quicklists: do not release off node pages early
 
 patch ed367fc3a7349b17354c7acef551533337764859 in mainline.
 
 quicklists must keep even off node pages on the quicklists until the TLB
 flush has been completed.
 
 Signed-off-by: Christoph Lameter <clameter@sgi.com>
 Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
 Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
 Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
 Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
 Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>
 
 diff --git a/include/linux/quicklist.h b/include/linux/quicklist.h
 index 9371c61..39b6671 100644
 --- a/include/linux/quicklist.h
 +++ b/include/linux/quicklist.h
 @@ -56,14 +56,6 @@ static inline void __quicklist_free(int nr, void
 (*dtor)(void *), void *p,
  	struct page *page)
  {
  	struct quicklist *q;
 -	int nid = page_to_nid(page);
 -
 -	if (unlikely(nid != numa_node_id())) {
 -		if (dtor)
 -			dtor(p);
 -		__free_page(page);
 -		return;
 -	}
 
  	q = &get_cpu_var(quicklist)[nr];
  	*(void **)p = q->page;
 
 
 -- 
 Thanks,
 Oliver
