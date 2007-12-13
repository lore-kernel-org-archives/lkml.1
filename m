Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbXLMAWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbXLMAWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 19:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbXLMAWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 19:22:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36388 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbXLMAWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 19:22:12 -0500
Date: Thu, 13 Dec 2007 09:23:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
       clameter@sgi.com
Subject: Re: [PATCH 0/6] Use two zonelists per node instead of multiple
 zonelists v11r2
Message-Id: <20071213092338.8b10944c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1197495172.5029.62.camel@localhost>
References: <20071211202157.1961.27940.sendpatchset@skynet.skynet.ie>
	<1197495172.5029.62.camel@localhost>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 16:32:51 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> Just this afternoon, I hit a null pointer deref in
> __mem_cgroup_remove_list() [called from mem_cgroup_uncharge() if I can
> trust the stack trace] attempting to unmap a page for migration.  I'm
> just starting to investigate this.
> 
> I'll replace the series I have [~V10] with V11r2 and continue testing in
> anticipation of the day that we can get this into -mm.
> 
Hi, Lee-san.

Could you know what is the caller of page migration ?
system call ? hot removal ? or some new thing ?

Note: 2.6.24-rc4-mm1's cgroup/migration logic.

In 2.6.24-rc4-mm1, in page migration, mem_cgroup_prepare_migration() increments
page_cgroup's refcnt before calling try_to_unmap(). This extra refcnt guarantees 
the page_cgroup's refcnt will not drop to 0 in sequence of
unmap_and_move() -> try_to_unmap() -> page_remove_rmap() -> mem_cgroup_unchage(). 

Thanks,
-Kame

