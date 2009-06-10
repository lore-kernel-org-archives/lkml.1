Return-Path: <linux-kernel-owner+w=401wt.eu-S1756206AbZFJGoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206AbZFJGoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 02:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZFJGoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 02:44:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47079 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZFJGoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 02:44:03 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] Reintroduce zone_reclaim_interval for when zone_reclaim() scans and fails to avoid CPU spinning at 100% on NUMA
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <cl@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090609222301.8da002ae.akpm@linux-foundation.org>
References: <20090608151151.GI15070@csn.ul.ie> <20090609222301.8da002ae.akpm@linux-foundation.org>
Message-Id: <20090610154016.DDC3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 10 Jun 2009 15:44:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Mon, 8 Jun 2009 16:11:51 +0100 Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > On Mon, Jun 08, 2009 at 10:55:55AM -0400, Christoph Lameter wrote:
> > > On Mon, 8 Jun 2009, Mel Gorman wrote:
> > > 
> > > > > The tmpfs pages are unreclaimable and therefore should not be on the anon
> > > > > lru.
> > > > >
> > > >
> > > > tmpfs pages can be swap-backed so can be reclaimable. Regardless of what
> > > > list they are on, we still need to know how many of them there are if
> > > > this patch is to be avoided.
> > > 
> > > If they are reclaimable then why does it matter? They can be pushed out if
> > > you configure zone reclaim to be that aggressive.
> > > 
> > 
> > Because they are reclaimable by kswapd or normal direct reclaim but *not*
> > reclaimable by zone_reclaim() if the zone_reclaim_mode is not configured
> > appropriately.
> 
> Ah.  (zone_reclaim_mode & RECLAIM_SWAP) == 0.  That was important info.
> 
> Couldn't the lack of RECLAIM_WRITE cause a similar problem?

Old kernel can makes easily. but currenly we have proper dirty page limit.
Thus all pages can't become dirty and zone-reclaim can found cleaner page.

In the other hand, plenty tmpfs pages can be mede easily.



