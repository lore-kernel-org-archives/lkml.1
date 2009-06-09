Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbZFIH64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbZFIH64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbZFIH6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:58:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56521 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758460AbZFIH6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:58:40 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH mmotm] vmscan: handle may_swap more strictly (Re: [PATCH  mmotm] vmscan: fix may_swap handling for memcg)
Cc: kosaki.motohiro@jp.fujitsu.com,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262360906090048x792fb3f9i6678298b693f6c5a@mail.gmail.com>
References: <20090609161925.DD70.A69D9226@jp.fujitsu.com> <28c262360906090048x792fb3f9i6678298b693f6c5a@mail.gmail.com>
Message-Id: <20090609164850.DD73.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Jun 2009 16:58:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, KOSAKI.
> 
> As you know, this problem caused by if condition(priority) in shrink_zone.
> Let me have a question.
> 
> Why do we have to prevent scan value calculation when the priority is zero ?
> As I know, before split-lru, we didn't do it.
> 
> Is there any specific issue in case of the priority is zero ?

Yes. 

example:

get_scan_ratio() return anon:80%, file=20%. and the system have
10000 anon pages and 10000 file pages.

shrink_zone() picked up 8000 anon pages and 2000 file pages.
it mean 8000 file pages aren't scanned at all.

Oops, it can makes OOM-killer although system have droppable file cache.



