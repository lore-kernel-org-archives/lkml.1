Return-Path: <linux-kernel-owner+w=401wt.eu-S1751584AbZJKXhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbZJKXhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZJKXg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:36:58 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:51692 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbZJKXg6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:36:58 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Mon, 12 Oct 2009 01:36:18 +0200
User-Agent: KMail/1.9.9
Cc: David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>, linux-mm@kvack.org
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910050851.02056.elendil@planet.nl> <200910120110.28061.elendil@planet.nl>
In-Reply-To: <200910120110.28061.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910120136.20390.elendil@planet.nl>
X-OriginalArrivalTime: 11 Oct 2009 23:36:20.0743 (UTC) FILETIME=[A306D170:01CA4ACB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 October 2009, Frans Pop wrote:
> BISECTION of akpm (mm) MERGE
> ----------------------------
> So here I went looking for "where does the test start failing on the
> first try". Again, I was unable to narrow it down to a single commit.

Note that this merge is based on mainline at v2.6.30-5415-g03347e2, so a
number of merges "drop out" once I  started bisecting into this merge. But
that point is still *after* the net-next-2.6 merge, which is all that's
really relevant for this issue.

> For a good overview of the area, use 'gitk f83b1e61..517d0869'.
>
> v2.6.30-5466-ga1dd268   mm: use alloc_pages_exact in alloc_large_system_hash
>	2.3     +- 
> v2.6.30-5478-ge9bb35d   mm: setup_per_zone_inactive_ratio - fix comment and..
>	2.5     +- 
> v2.6.30-5486-g35282a2   migration: only migrate_prep() once per move_pages()
>	2.6     -|+|-   not quite conclusive... 
> v2.6.30-5492-gbce7394   page-allocator: reset wmark_min and inactive ratio..
>	2.4     -|- 
