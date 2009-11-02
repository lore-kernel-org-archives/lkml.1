Return-Path: <linux-kernel-owner+w=401wt.eu-S932512AbZKBXL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbZKBXL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 18:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932378AbZKBXL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 18:11:27 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40936 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292AbZKBXL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 18:11:26 -0500
Message-ID: <244dc9813cd8dbb5e1ce1eafa61e9e2b.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0911021209180.2028@V090114053VZO-1>
References: <20091102162244.9425e49b.kamezawa.hiroyu@jp.fujitsu.com>
    <20091102162617.9d07e05f.kamezawa.hiroyu@jp.fujitsu.com>
    <alpine.DEB.1.10.0911021209180.2028@V090114053VZO-1>
Date: Tue, 3 Nov 2009 08:11:29 +0900 (JST)
Subject: Re: [RFC][-mm][PATCH 3/6] oom-killer: count lowmem rss
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Christoph Lameter" <cl@linux-foundation.org>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       aarcange@redhat.com, akpm@linux-foundation.org, minchan.kim@gmail.com,
       rientjes@google.com, vedran.furac@gmail.com,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>
> I dont think this patch will work in !NUMA but its useful there too. Can
> you make this work in general?
>
for NUMA
==
+static inline int is_lowmem_page(struct page *page)
+{
+	if (unlikely(page_zonenum(page) < policy_zone))
+		return 1;
+	return 0;
+}
==

is used. Doesn't this work well ?
This check means
It enough memory:
   On my ia64 box ZONE_DMA(<4G), x86-64 box(GFP_DMA32) is caught
If small memory (typically < 4G)
   ia64 box no lowmem, x86-64 box GPF_DMA is caught
If all zones are policy zone (ppc)
   no lowmem zone.

Because "amount of memory" changes the situation "which is lowmem?",
I used policy zone. If this usage is not appropriate, I'll add some new.

BTW, is it better to export this value from somewhere ?

Thanks,
-Kame


