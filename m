Return-Path: <linux-kernel-owner+w=401wt.eu-S1761600AbZBMGPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761600AbZBMGPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 01:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbZBMGPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 01:15:01 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47295 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZBMGPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 01:15:00 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] clean up for early_pfn_to_nid
Cc: kosaki.motohiro@jp.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       davem@davemlloft.net, heiko.carstens@de.ibm.com,
       Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20090212162203.db3f07cb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090212161920.deedea35.kamezawa.hiroyu@jp.fujitsu.com> <20090212162203.db3f07cb.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090213151406.77CB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 13 Feb 2009 15:14:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Declaration of early_pfn_to_nid() is scattered over per-arch include files,
> and it seems it's complicated to know when the declaration is used.
> I think it makes fix-for-memmap-init not easy.
> 
> This patch moves all declaration to include/linux/mm.h
> 
> After this,
>   if !CONFIG_NODES_POPULATES_NODE_MAP && !CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
>      -> Use static definition in include/linux/mm.h
>   else if !CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
>      -> Use generic definition in mm/page_alloc.c
>   else
>      -> per-arch back end function will be called.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

at least, this patch works fine on my ia64 box.

	Tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



