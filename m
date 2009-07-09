Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbZGIVAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbZGIVAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 17:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754960AbZGIVAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 17:00:13 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:59970 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754951AbZGIVAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 17:00:12 -0400
Date: Thu, 9 Jul 2009 17:00:01 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
In-Reply-To: <20090709111458.238C.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907091647350.17835@gentwo.org>
References: <20090707101855.0C63.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907071248560.5124@gentwo.org> <20090709111458.238C.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jul 2009, KOSAKI Motohiro wrote:

> >
> > Could you move the counters for reclaim into a separate cacheline?
> >
>
> Current definition is here.
>
> dirty pages and other frequently used counter stay in first cache line.
> NR_ISOLATED_(ANON|FILE) and other unfrequently used counter stay in second
> cache line.
>
> Do you mean we shouldn't use zone_stat_item for it?

No there is really no alternative to it.

Just be aware that what you may increases the cache footprint of key
functions in the vm. Some regression tests would be useful (do a page
fault test etc).
