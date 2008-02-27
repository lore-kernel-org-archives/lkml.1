Return-Path: <linux-kernel-owner+w=401wt.eu-S1765273AbYB0E7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765273AbYB0E7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 23:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYB0E7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 23:59:09 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48500 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbYB0E7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 23:59:08 -0500
Date: Wed, 27 Feb 2008 14:00:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC][PATCH] page reclaim throttle take2
Message-Id: <20080227140042.66abb805.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080227133850.4249.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080227131939.4244.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<47C4E6CD.6090401@linux.vnet.ibm.com>
	<20080227133850.4249.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 13:45:18 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi
> 
> > One more thing, I would request you to add default heuristics (number of
> > reclaimers), based on the number of cpus in the system. Letting people tuning it
> > is fine, but defaults should be related to number of cpus, nodes and zones on
> > the system. Zones can be reaped in parallel per node and cpus allow threads to
> > run in parallel. So please use that to come up with good defaults, instead of a
> > number like "3".
> 
> I don't think so.
> all modern many cpu machine stand on NUMA.
> it mean following,
>  - if cpu increases, then zone increases, too.
> 
> if default value increase by #cpus, lock contension dramatically increase
> on large numa.
> 
> Have I overlooked anything?
> 
> 
How about adding something like..
== 
CONFIG_SIMULTANEOUS_PAGE_RECLAIMERS 
int
default 3
depends on DEBUG
help
  This value determines the number of threads which can do page reclaim
  in a zone simultaneously. If this is too big, performance under heavy memory
  pressure will decrease.
  If unsure, use default.
==

Then, you can get performance reports from people interested in this
feature in test cycle.

Thanks,
-Kame


