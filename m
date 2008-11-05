Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYKEEcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYKEEcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 23:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbYKEEci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 23:32:38 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38770 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbYKEEch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 23:32:37 -0500
Date: Wed, 5 Nov 2008 13:31:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, peterz@infradead.org,
       rientjes@google.com, npiggin@suse.de, menage@google.com, dfults@sgi.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       righi.andrea@gmail.com
Subject: Re: [patch 0/7] cpuset writeback throttling
Message-Id: <20081105133157.db8bae72.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081104190505.769b93ec.akpm@linux-foundation.org>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
	<20081104124753.fb1dde5a.akpm@linux-foundation.org>
	<1225831988.7803.1939.camel@twins>
	<20081104131637.68fbe055.akpm@linux-foundation.org>
	<1225833710.7803.1993.camel@twins>
	<20081104135004.f1717fcf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811041601100.5077@quilx.com>
	<20081104143534.b5c16147.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811041648350.6254@quilx.com>
	<20081104153610.bbfd5ed8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0811042036000.31167@quilx.com>
	<20081104190505.769b93ec.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2008 19:05:05 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:
> Generally, I worry that this is a specific fix to a specific problem
> encountered on specific machines with specific setups and specific
> workloads, and that it's just all too low-level and myopic.
> 
> And now we're back in the usual position where there's existing code and
> everyone says it's terribly wonderful and everyone is reluctant to step
> back and look at the big picture.  Am I wrong?
> 
> 
> Plus: we need per-memcg dirty-memory throttling, and this is more
> important than per-cpuset, I suspect.  How will the (already rather
> buggy) code look once we've stuffed both of them in there?
> 
> 
IIUC, Andrea Righ posted 2 patches around dirty_ratio. (added him to CC:)
in early October.

  (1) patch for adding dirty_ratio_pcm. (1/100000)
  (2) per-memcg dirty ratio. (maybe this..http://lkml.org/lkml/2008/9/12/121)
 
(1) should be just posted again.

Because we have changed page_cgroup implementation, (2) should be reworked.
"rework" itself will not be very difficult.
(.... we tend to be stick to "what interface is the best" discussion ;) 

But memcg itself is not so weak against dirty_pages because we don't call
try_to_free_pages() becasue of memory shortage but because of memory limitation.

BTW, in my current stack, followings are queued.
   a. handle SwapCache in proper way in memcg.
   b. handle swap_cgroup (if configured)
   c. make LRU handling easier

For making per-memcg dirty_ratio sane, (a) should go ahead. I do (a) now.
If Andrea seems to be too busy, I'll schedule dirty_ratio-for-memcg as my work.

Thanks,
-Kame

