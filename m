Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYAIMx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYAIMx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYAIMxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:53:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYAIMxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:53:20 -0500
Date: Wed, 9 Jan 2008 07:53:12 -0500
From: Rik van Riel <riel@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 07/19] (NEW) add some sanity checks to get_scan_ratio
Message-ID: <20080109075312.2246d6bb@bree.surriel.com>
In-Reply-To: <20080109131642.56b3fa91.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080108205939.323955454@redhat.com>
	<20080108210005.558041779@redhat.com>
	<20080109131642.56b3fa91.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008 13:16:42 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > +
> > +	free = zone_page_state(zone, NR_FREE_PAGES);
> > +
> > +	/*
> > +	 * If we have no swap space, do not bother scanning anon pages
> > +	 */
> > +	if (nr_swap_pages <= 0)
> > +		percent[0] = 0;
> Doesn't this mean that swap-cache in ACTIVE_ANON_LIST is not scanned ?
> Or swap-cache is in File-Cache list ?

You are right, the swap cache will not be scanned once we run
completely out of swap space.  To compensate for that, this
patch series has a patch that does scanning of swap cache and
freeing of swap space used by pages on the LRU list while there
is still space free.

Scanning all of the anon LRU lists could be a lot of work for
very little gain.  A typical large server will have 32GB or
more of RAM, but only the default 2GB of swap.

All we accomplish by scanning the anonymous memory on a system
like that (once swap is full) is eating up CPU time and causing
lock contention.

-- 
All rights reversed.
