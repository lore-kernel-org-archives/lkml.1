Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbZGGXdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbZGGXdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 19:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZGGXdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 19:33:04 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:50407 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754222AbZGGXdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 19:33:04 -0400
Date: Tue, 7 Jul 2009 19:32:41 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Rik van Riel <riel@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
In-Reply-To: <4A5384A4.7060108@redhat.com>
Message-ID: <alpine.DEB.1.10.0907071931160.17422@gentwo.org>
References: <20090707090120.1e71a060.minchan.kim@barrios-desktop> <20090707090509.0C60.A69D9226@jp.fujitsu.com> <20090707101855.0C63.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907071248560.5124@gentwo.org> <4A5384A4.7060108@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jul 2009, Rik van Riel wrote:

> Christoph Lameter wrote:
> > On Tue, 7 Jul 2009, KOSAKI Motohiro wrote:
> >
> > > +++ b/include/linux/mmzone.h
> > > @@ -100,6 +100,8 @@ enum zone_stat_item {
> > >  	NR_BOUNCE,
> > >  	NR_VMSCAN_WRITE,
> > >  	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
> > > +	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
> > > +	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
> >
> > LRU counters are rarer in use then the counters used for dirty pages etc.
> >
> > Could you move the counters for reclaim into a separate cacheline?
>
> I don't get the point of that - these counters are
> per-cpu anyway, so why would they need to be in a
> separate cacheline?

Because there are so many counters now that they spread multiple
cachelines. PCP data is very performance sensitive. Putting them in a
separate cacheline so that the most important counters are in the
first one will reduce the cache footprint of many core VM functions.
