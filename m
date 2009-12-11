Return-Path: <linux-kernel-owner+w=401wt.eu-S1762002AbZLKAmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762002AbZLKAmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760532AbZLKAme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:42:34 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37041 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018AbZLKAme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:42:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Dec 2009 09:39:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mingo@elte.hu
Subject: Re: [RFC mm][PATCH 4/5] add a lowmem check function
Message-Id: <20091211093938.70214f9c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0912101155490.5481@router.home>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com>
	<20091210170036.dde2c147.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0912101155490.5481@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009 11:59:11 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 10 Dec 2009, KAMEZAWA Hiroyuki wrote:
> 
> > This patch adds an integer lowmem_zone, which is initialized to -1.
> > If zone_idx(zone) <= lowmem_zone, the zone is lowmem.
> 
> There is already a policy_zone in mempolicy.h. lowmem is if the zone
> number is  lower than policy_zone. Can we avoid adding another zone
> limiter?
> 
My previous version (one month ago) does that. In this set, I tried to use
unified approach for all CONFIG_NUMA/HIGHMEM/flat ones.

Hmm, How about adding following kind of patch after this

#define policy_zone (lowmem_zone + 1)

and remove policy_zone ? I think the name of "policy_zone" implies
"this is for mempolicy, NUMA" and don't think good name for generic use.


Thanks,
-Kame

