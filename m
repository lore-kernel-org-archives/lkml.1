Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbZFWFF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbZFWFF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 01:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbZFWFFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 01:05:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37874 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZFWFFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 01:05:49 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: akataria@vmware.com
Subject: Re: [PATCH] Hugepages should be accounted as unevictable pages.
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <1245732411.18339.6.camel@alok-dev1>
References: <20090623093459.2204.A69D9226@jp.fujitsu.com> <1245732411.18339.6.camel@alok-dev1>
Message-Id: <20090623135017.220D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Jun 2009 14:05:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Unevictable:           0 kB
> > > Mlocked:               0 kB
> > > HugePages_Total:      20
> > > HugePages_Free:       20
> > > HugePages_Rsvd:        0
> > > HugePages_Surp:        0
> > > 
> > > After the patch:
> > > 
> > > Unevictable:       81920 kB
> > > Mlocked:               0 kB
> > > HugePages_Total:      20
> > > HugePages_Free:       20
> > > HugePages_Rsvd:        0
> > > HugePages_Surp:        0
> > 
> > At first, We should clarify the spec of unevictable.
> > Currently, Unevictable field mean the number of pages in unevictable-lru
> > and hugepage never insert any lru.
> > 
> > I think this patch will change this rule.
> 
> I agree, and that's why I added a comment to the documentation file to
> that effect. If you think its not explicit or doesn't explain what its
> supposed to we can add something more there.
> 
> IMO, the proc output should give the total number of unevictable pages
> in the system and, since hugepages are also in fact unevictable so I
> don't see a reason why they shouldn't be accounted accordingly.
> What do you think ? 

ummm...

I'm not sure this unevictable definition is good idea or not. currently
hugepage isn't only non-account memory, but also various kernel memory doesn't
account.

one of drawback is that zone_page_state(UNEVICTABLE) lost to mean #-of-unevictable-pages.
e.g.  following patch is wrong?

fs/proc/meminfo.c meminfo_proc_show()
----------------------------
-                K(pages[LRU_UNEVICTABLE]),
+                K(pages[LRU_UNEVICTABLE]) + hstate->nr_huge_pages,


Plus, I didn't find any practical benefit in this patch. do you have it?
or You only want to natural definition?

I don't have any strong oppose reason, but I also don't have any strong
agree reason.


Lee, What do you think?




