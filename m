Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbXBDBtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbXBDBtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 20:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXBDBtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 20:49:32 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:50503 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751846AbXBDBtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 20:49:32 -0500
Date: Sat, 3 Feb 2007 17:49:13 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
In-Reply-To: <20070203172242.e5bf2534.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
 <20070203005316.eb0b4042.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
 <1170525860.3073.1054.camel@laptopd505.fenrus.org>
 <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com>
 <20070203172242.e5bf2534.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Feb 2007, Andrew Morton wrote:

> Do we actually need NR_MLOCK?  Page reclaim tends to care more about the
> size of the LRUs and doesn't have much dependency on ->present_pages,

Yes, we'd be fine with general reclaim I think. But the calculation of the 
dirty ratio based on ZVCs would need it if we take the mlocked pages off. 
Otherwise we may have dirty ratios > 100%.

> I guess we could use NR_MLOCK for writeback threshold calculations, to
> force writeback earlier if there's a lot of mlocked memory in the affected
> zones.  But that code isn't zone-aware anyway, and we don't know how to make
> it zone aware in any sane fashion and making it cpuset-aware isn't very
> interesting or useful..

Exclusion or inclusion of NR_MLOCK number is straightforward for the dirty 
ratio calcuations. global_page_state(NR_MLOCK) f.e. would get us totals on 
mlocked pages per zone. node_page_state(NR_MLOCK) gives a node specific 
number of mlocked pages. The nice thing about ZVCs is that it allows
easy access to counts on different levels.

> So..  Why do we want NR_MLOCK?

Rik also had some uses in mind for allocation?
