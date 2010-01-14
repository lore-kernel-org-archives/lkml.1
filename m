Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032Ab0ANHOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0ANHOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 02:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970Ab0ANHOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 02:14:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55765 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051Ab0ANHOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 02:14:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [resend][PATCH] mm: Restore zone->all_unreclaimable to independence word
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Huang Shijie <shijie8@gmail.com>
In-Reply-To: <alpine.DEB.2.00.1001132229250.15428@chino.kir.corp.google.com>
References: <20100114103332.D71B.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1001132229250.15428@chino.kir.corp.google.com>
Message-Id: <20100114161311.673B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 Jan 2010 16:14:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 14 Jan 2010, KOSAKI Motohiro wrote:
> 
> > commit e815af95 (change all_unreclaimable zone member to flags) chage
> > all_unreclaimable member to bit flag. but It have undesireble side
> > effect.
> > free_one_page() is one of most hot path in linux kernel and increasing
> > atomic ops in it can reduce kernel performance a bit.
> > 
> > Thus, this patch revert such commit partially. at least
> > all_unreclaimable shouldn't share memory word with other zone flags.
> > 
> 
> I still think you need to quantify this; saying you don't have a large 
> enough of a machine that will benefit from it isn't really a rationale for 
> the lack of any data supporting your claim.  We should be basing VM 
> changes on data, not on speculation that there's a measurable impact 
> here.
> 
> Perhaps you could ask a colleague or another hacker to run a benchmark for 
> you so that the changelog is complete?

ok, fair. although I dislike current unnecessary atomic-ops.
I'll pending this patch until get good data.

thanks.


