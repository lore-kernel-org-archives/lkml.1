Return-Path: <linux-kernel-owner+w=401wt.eu-S964861AbZKYOX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964861AbZKYOX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 09:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934707AbZKYOX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 09:23:58 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:44248 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934706AbZKYOX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 09:23:57 -0500
Date: Wed, 25 Nov 2009 19:53:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/9] ksm: mem cgroup charge swapin copy
Message-ID: <20091125142355.GD2970@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
 <Pine.LNX.4.64.0911241648520.25288@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911241648520.25288@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hugh Dickins <hugh.dickins@tiscali.co.uk> [2009-11-24 16:51:13]:

> But ksm swapping does require one small change in mem cgroup handling.
> When do_swap_page()'s call to ksm_might_need_to_copy() does indeed
> substitute a duplicate page to accommodate a different anon_vma (or a
> different index), that page escaped mem cgroup accounting, because of
> the !PageSwapCache check in mem_cgroup_try_charge_swapin().
> 

The duplicate page doesn't show up as PageSwapCache or are we optimizing
for the race condition where the page is not in SwapCache? I should
probably look at the full series.

> That was returning success without charging, on the assumption that
> pte_same() would fail after, which is not the case here.  Originally I
> proposed that success, so that an unshrinkable mem cgroup at its limit
> would not fail unnecessarily; but that's a minor point, and there are
> plenty of other places where we may fail an overallocation which might
> later prove unnecessary.  So just go ahead and do what all the other
> exceptions do: proceed to charge current mm.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>


Thanks for the patch!
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
-- 
	Balbir
