Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbYF0FmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbYF0FmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYF0FmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:42:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60381 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYF0FmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:42:14 -0400
Date: Fri, 27 Jun 2008 14:41:00 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "MinChan Kim" <minchan.kim@gmail.com>
Subject: Re: [-mm][PATCH 8/10] fix shmem page migration incorrectness on memcgroup
Cc: kosaki.motohiro@jp.fujitsu.com,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <28c262360806262208i6791d67at446f7323ded16206@mail.gmail.com>
References: <20080625190750.D864.KOSAKI.MOTOHIRO@jp.fujitsu.com> <28c262360806262208i6791d67at446f7323ded16206@mail.gmail.com>
Message-Id: <20080627142950.7A83.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > mem_cgroup_uncharge() against old page is done after radix-tree-replacement.
> > And there were special handling to ingore swap-cache page. But, shmem can
> > be swap-cache and file-cache at the same time. Chekcing PageSwapCache() is
> > not correct here. Check PageAnon() instead.
> 
> When/How shmem can be both swap-cache and file-cache ?
> I can't understand that situation.

Hi

see, 

shmem_writepage()
   -> add_to_swap_cache()
      -> SetPageSwapCache()


BTW: his file-cache mean !Anon, not mean !SwapBacked.


