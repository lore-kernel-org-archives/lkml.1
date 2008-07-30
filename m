Return-Path: <linux-kernel-owner+w=401wt.eu-S1761305AbYG3MQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305AbYG3MQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYG3MQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:16:16 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:21412 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbYG3MQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:16:16 -0400
Subject: Re: memory hotplug: hot-remove fails on lowest chunk in
	ZONE_MOVABLE
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@shadowen.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080730110444.27DE.E1E9C6FF@jp.fujitsu.com>
References: <20080723105318.81BC.E1E9C6FF@jp.fujitsu.com>
	 <1217347653.4829.17.camel@localhost.localdomain>
	 <20080730110444.27DE.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 14:16:01 +0200
Message-Id: <1217420161.4545.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 12:16 +0900, Yasunori Goto wrote:
> Well, I didn't mean changing pages_min value. There may be side effect as
> you are saying.
> I meant if some pages were MIGRATE_RESERVE attribute when hot-remove are
> -executing-, their attribute should be changed.
> 
> For example, how is like following dummy code?  Is it impossible?
> (Not only here, some places will have to be modified..)

Right, this should be possible. I was somewhat wandering from the subject,
because I noticed that there may be a bigger problem with MIGRATE_RESERVE
pages in ZONE_MOVABLE, and that we may not want to have them in the first
place.

The more memory we add to ZONE_MOVABLE, the less reserved pages will
remain to the other zones. In setup_per_zone_pages_min(), min_free_kbytes
will be redistributed to a zone where the kernel cannot make any use of
it, effectively reducing the available min_free_kbytes. This just doesn't
sound right. I believe that a similar situation is the reason why highmem
pages are skipped in the calculation and I think that we need that for
ZONE_MOVABLE too. Any thoughts on that problem?

Setting pages_min to 0 for ZONE_MOVABLE, while not capping pages_low
and pages_high, could be an option. I don't have a sufficient memory
managment overview to tell if that has negative side effects, maybe
someone with a deeper insight could comment on that.

Thanks,
Gerald


