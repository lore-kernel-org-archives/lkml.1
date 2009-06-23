Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbZFWEq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbZFWEq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbZFWEqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:46:49 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:39591 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbZFWEqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:46:48 -0400
Subject: Re: [PATCH] Hugepages should be accounted as unevictable pages.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <20090623093459.2204.A69D9226@jp.fujitsu.com>
References: <1245705941.26649.19.camel@alok-dev1>
	 <20090623093459.2204.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 22 Jun 2009 21:46:51 -0700
Message-Id: <1245732411.18339.6.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-06-22 at 20:25 -0700, KOSAKI Motohiro wrote:
> > Looking at the output of /proc/meminfo, a user might get confused in thinking
> > that there are zero unevictable pages, though, in reality their can be
> > hugepages which are inherently unevictable. 
> > 
> > Though hugepages are not handled by the unevictable lru framework, they are
> > infact unevictable in nature and global statistics counter should reflect that. 
> > 
> > For instance, I have allocated 20 huge pages on my system, meminfo shows this 
> > 
> > Unevictable:           0 kB
> > Mlocked:               0 kB
> > HugePages_Total:      20
> > HugePages_Free:       20
> > HugePages_Rsvd:        0
> > HugePages_Surp:        0
> > 
> > After the patch:
> > 
> > Unevictable:       81920 kB
> > Mlocked:               0 kB
> > HugePages_Total:      20
> > HugePages_Free:       20
> > HugePages_Rsvd:        0
> > HugePages_Surp:        0
> 
> At first, We should clarify the spec of unevictable.
> Currently, Unevictable field mean the number of pages in unevictable-lru
> and hugepage never insert any lru.
> 
> I think this patch will change this rule.

I agree, and that's why I added a comment to the documentation file to
that effect. If you think its not explicit or doesn't explain what its
supposed to we can add something more there.

IMO, the proc output should give the total number of unevictable pages
in the system and, since hugepages are also in fact unevictable so I
don't see a reason why they shouldn't be accounted accordingly.
What do you think ? 

Thanks,
Alok
> 
> 
> 

