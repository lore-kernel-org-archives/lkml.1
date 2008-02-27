Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbYB0AsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbYB0AsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbYB0AsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:48:00 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36981 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYB0Ar7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:47:59 -0500
Date: Wed, 27 Feb 2008 09:50:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
Message-Id: <20080227095005.4058e109.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1204060718.6242.333.camel@lappy>
References: <20080226104647.FF26.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<1204060718.6242.333.camel@lappy>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 22:18:38 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > +out:
> > +	atomic_dec(&zone->nr_reclaimers);
> > +	wake_up_all(&zone->reclaim_throttle_waitq);
> > +
> > +	return ret;
> > +}
> 
> Would it be possible - and worthwhile - to make this FIFO fair?
> 
I think it doesn't make sense for fairness.

IMHO, this functionality is an unfair one in nature. While someone is
reclaiming pages, other processes can get a newly reclaimed page without
calling try_to_free_page.

For high-priority processes, 

1. avoiding diving into try_to_free_pages if it's congested.
2. just waiting for that someone relcaim pages and grab it ASAP

maybe good for quick work. 

Thanks,
-Kame

