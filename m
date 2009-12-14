Return-Path: <linux-kernel-owner+w=401wt.eu-S1757731AbZLNQTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbZLNQTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 11:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757719AbZLNQTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 11:19:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41881 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716AbZLNQTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 11:19:50 -0500
Date: Mon, 14 Dec 2009 17:19:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Larry Woodman <lwoodman@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
Message-ID: <20091214161944.GB16474@basil.fritz.box>
References: <20091210185626.26f9828a@cuia.bos.redhat.com> <87pr6hya86.fsf@basil.nowhere.org> <1260800599.6666.4.camel@dhcp-100-19-198.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260800599.6666.4.camel@dhcp-100-19-198.bos.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 09:23:19AM -0500, Larry Woodman wrote:
> On Mon, 2009-12-14 at 14:08 +0100, Andi Kleen wrote:
> > Rik van Riel <riel@redhat.com> writes:
> > 
> > > +max_zone_concurrent_reclaim:
> > > +
> > > +The number of processes that are allowed to simultaneously reclaim
> > > +memory from a particular memory zone.
> > > +
> > > +With certain workloads, hundreds of processes end up in the page
> > > +reclaim code simultaneously.  This can cause large slowdowns due
> > > +to lock contention, freeing of way too much memory and occasionally
> > > +false OOM kills.
> > > +
> > > +To avoid these problems, only allow a smaller number of processes
> > > +to reclaim pages from each memory zone simultaneously.
> > > +
> > > +The default value is 8.
> > 
> > I don't like the hardcoded number. Is the same number good for a 128MB
> > embedded system as for as 1TB server?  Seems doubtful.
> > 
> > This should be perhaps scaled with memory size and number of CPUs?
> 
> Remember this a per-zone number.

A zone could be 64MB or 32GB. And the system could have 1 or 1024 CPUs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
