Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZFWDZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZFWDZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 23:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZFWDZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 23:25:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48153 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbZFWDZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 23:25:46 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: akataria@vmware.com
Subject: Re: [PATCH] Hugepages should be accounted as unevictable pages.
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org
In-Reply-To: <1245705941.26649.19.camel@alok-dev1>
References: <1245705941.26649.19.camel@alok-dev1>
Message-Id: <20090623093459.2204.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 23 Jun 2009 12:25:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Looking at the output of /proc/meminfo, a user might get confused in thinking
> that there are zero unevictable pages, though, in reality their can be
> hugepages which are inherently unevictable. 
> 
> Though hugepages are not handled by the unevictable lru framework, they are
> infact unevictable in nature and global statistics counter should reflect that. 
> 
> For instance, I have allocated 20 huge pages on my system, meminfo shows this 
> 
> Unevictable:           0 kB
> Mlocked:               0 kB
> HugePages_Total:      20
> HugePages_Free:       20
> HugePages_Rsvd:        0
> HugePages_Surp:        0
> 
> After the patch:
> 
> Unevictable:       81920 kB
> Mlocked:               0 kB
> HugePages_Total:      20
> HugePages_Free:       20
> HugePages_Rsvd:        0
> HugePages_Surp:        0

At first, We should clarify the spec of unevictable.
Currently, Unevictable field mean the number of pages in unevictable-lru
and hugepage never insert any lru.

I think this patch will change this rule.



