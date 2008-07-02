Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYGBDc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYGBDc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 23:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbYGBDcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 23:32:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40090 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbYGBDcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 23:32:15 -0400
Date: Wed, 02 Jul 2008 12:30:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Subject: Re: [resend][PATCH -mm] split_lru: fix pagevec_move_tail() doesn't treat unevictable page
Cc: kosaki.motohiro@jp.fujitsu.com, "Rik van Riel" <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <28c262360807011739w5668920buf7880de6ed30f912@mail.gmail.com>
References: <20080701093840.07b48ced@bree.surriel.com> <28c262360807011739w5668920buf7880de6ed30f912@mail.gmail.com>
Message-Id: <20080702122850.380B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim-san,

> Hi, Rik and Kosaki-san
> 
> I want to know exact race situation for remaining git log.
> As you know, git log is important for me who is newbie to understand source
> 
> There are many possibility in this race problem.
> 
> Did you use hugepage in this test ?
> I think that If you used hugepage, it seems to happen following race.

I don't use hugepage. but use SYSV-shmem.
so following scenario is very reasonable.

OK.
I resend my patch with following description.


> 
> --------------
> 
> CPU1                                                           CPU2
> 
> shm_unlock
> scan_mapping_unevictable_pages
> check_move_unevictable_page
> ClearPageUnevictable                                 rotate_reclaimable_page
> 
> PageUnevictable(page) return 0
> SetPageUnevictable
> list_move(LRU_UNEVICTABLE)
> 
> local_irq_save
> 
> pagevec_move_tail
> 
> Do you think it is possible ?


