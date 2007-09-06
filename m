Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbXIFWh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbXIFWh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 18:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbXIFWhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 18:37:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756669AbXIFWhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 18:37:50 -0400
Date: Thu, 6 Sep 2007 15:34:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       safari-kernel@safari.iki.fi
Subject: Re: [PATCH] prevent kswapd from freeing excessive amounts of lowmem
Message-Id: <20070906153426.a173f8e2.akpm@linux-foundation.org>
In-Reply-To: <46E02CF5.3020301@redhat.com>
References: <46DF3545.4050604@redhat.com>
	<20070905182305.e5d08acf.akpm@linux-foundation.org>
	<46E02CF5.3020301@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 06 Sep 2007 12:38:13 -0400 Rik van Riel <riel@redhat.com> wrote:
> Andrew Morton wrote:
> 

(What happened to the other stuff I said?)

> > I guess for a very small upper zone and a very large lower zone this could
> > still put the scan balancing out of whack, fixable by a smarter version of
> > "8*zone->pages_high" but it doesn't seem very likely that this will affect
> > things much.
> > 
> > Why doesn't direct reclaim need similar treatment?
> 
> Because we only go into the direct reclaim path once
> every zone is at or below zone->pages_low, and the
> direct reclaim path will exit once we have freed more
> than swap_cluster_max pages.
> 

hm.  Now I need to remember why direct-reclaim does that :(
