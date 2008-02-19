Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYBSNdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYBSNdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYBSNc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:32:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbYBSNc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:32:57 -0500
Date: Tue, 19 Feb 2008 08:31:24 -0500
From: Rik van Riel <riel@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] the proposal of improve page reclaim by throttle
Message-ID: <20080219083124.2daf94e9@bree.surriel.com>
In-Reply-To: <200802191735.00222.nickpiggin@yahoo.com.au>
References: <20080219134715.7E90.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<200802191735.00222.nickpiggin@yahoo.com.au>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 17:34:59 +1100
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 19 February 2008 16:44, KOSAKI Motohiro wrote:
> > background
> > ========================================
> > current VM implementation doesn't has limit of # of parallel reclaim.
> > when heavy workload, it bring to 2 bad things
> >   - heavy lock contention
> >   - unnecessary swap out

> I think it should maybe be a per-zone thing...
> 
> What happens if you make it a per-zone mutex, and allow just a single
> process to reclaim pages from a given zone at a time? I guess that is
> going to slow down throughput a little bit in some cases though...

I agree, doing things per zone will probably work better, because
that way one process can do page reclaim on every NUMA node at
the same time.

-- 
All rights reversed.
