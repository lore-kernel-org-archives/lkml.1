Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZL3NOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZL3NOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 08:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZL3NOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 08:14:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48726 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbZL3NOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 08:14:35 -0500
Date: Wed, 30 Dec 2009 22:13:42 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] vmstat: add anon_scan_ratio field to zoneinfo
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091229140825.GQ3601@balbir.in.ibm.com>
References: <20091228164816.A68D.A69D9226@jp.fujitsu.com> <20091229140825.GQ3601@balbir.in.ibm.com>
Message-Id: <20091230220704.1A16.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-12-28 16:48:51]:
> 
> > Vmscan folks was asked "why does my system makes so much swap-out?"
> > in lkml at several times.
> > At that time, I made the debug patch to show recent_anon_{scanned/rorated}
> > parameter at least three times.
> > 
> > Thus, its parameter should be showed on /proc/zoneinfo. It help
> > vmscan folks debugging.
> >
> 
> Hmmm.. I think this should come under DEBUG_VM, a lot of tools use
> /proc/zoneinfo, the additional overhead may be high.. no? Also,
> I would recommend adding the additional details to the end, so
> as to not break existing tools (specifically dump line # based
> tools).

Thanks, I have three answer. 1)  I really hope to don't enclose DEBUG_VM. otherwise 
my harm doesn't solve. 2) but your performance worry is fair enough. I plan to remove 
to grab zone->lru_lock in reading /proc/zoneinfo. 3)  append new line doesn't break 
existing tools. because zoneinfo show vmstat and we often append new vmstat in past 
years. but I haven't seen zoneinfo breakage bug report. because zoneinfo file show 
multiple zone information, then nobody access it by line number.





