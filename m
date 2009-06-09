Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZFIH3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZFIH3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbZFIH3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:29:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54828 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbZFIH3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:29:45 -0400
Date: Tue, 9 Jun 2009 16:28:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH mmotm] vmscan: handle may_swap more strictly (Re: [PATCH
 mmotm] vmscan: fix may_swap handling for memcg)
Message-Id: <20090609162813.4bd1c1f2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090609161330.fcd5facb.nishimura@mxp.nes.nec.co.jp>
References: <20090608121848.4370.A69D9226@jp.fujitsu.com>
	<20090608153916.3ccaeb9a.nishimura@mxp.nes.nec.co.jp>
	<20090608154634.437F.A69D9226@jp.fujitsu.com>
	<20090608165457.fa8d17e6.nishimura@mxp.nes.nec.co.jp>
	<20090609161330.fcd5facb.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009 16:13:30 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > > and, too many recliaming pages is not only memcg issue. I don't think this
> > > patch provide generic solution.
> > > 
> > Ah, you're right. It's not only memcg issue.
> > 
> How about this one ?
> 
> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> Commit 2e2e425989080cc534fc0fca154cae515f971cf5 ("vmscan,memcg: reintroduce
> sc->may_swap) add may_swap flag and handle it at get_scan_ratio().
> 
> But the result of get_scan_ratio() is ignored when priority == 0,
> so anon lru is scanned even if may_swap == 0 or nr_swap_pages == 0.
> IMHO, this is not an expected behavior.
> 
> As for memcg especially, because of this behavior many and many pages are
> swapped-out just in vain when oom is invoked by mem+swap limit.
> 
> This patch is for handling may_swap flag more strictly.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Thanks,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

