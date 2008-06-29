Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbYF2IVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbYF2IVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 04:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbYF2IVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 04:21:31 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33574 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYF2IV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 04:21:29 -0400
Date: Sun, 29 Jun 2008 17:19:31 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH] splitlru: memcg swapbacked pages active
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0806290120270.21758@blonde.site>
References: <Pine.LNX.4.64.0806290117510.21758@blonde.site> <Pine.LNX.4.64.0806290120270.21758@blonde.site>
Message-Id: <20080629171251.37CA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> add_to_page_cache_lru puts PageSwapBacked pages on the active_anon lru,
> so shouldn't mem_cgroup_charge_common mirror that by setting FLAG_ACTIVE?
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

I don't think so.

in global lru, active vs inactive anon ratio is controlled by 
inactive_anon_is_low().
but memcg doesn't have any sililar things.

thus, this patch increase active anon. and too many active page cause
decrease reclaim throuput.

yes, We should implement SEQ replacement reclaim (like global reclaim)
for memcg.
I'm working on this.



