Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYKQAjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYKQAjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 19:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYKQAjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 19:39:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59297 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYKQAjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 19:39:15 -0500
Date: Mon, 17 Nov 2008 09:38:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -mm] vmscan: bail out of page reclaim after
 swap_cluster_max pages
Message-Id: <20081117093832.f383bd61.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081116163316.F205.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081113171208.6985638e@bree.surriel.com>
	<20081116163316.F205.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 16:38:56 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> One more point.
> 
> > Sometimes the VM spends the first few priority rounds rotating back
> > referenced pages and submitting IO.  Once we get to a lower priority,
> > sometimes the VM ends up freeing way too many pages.
> > 
> > The fix is relatively simple: in shrink_zone() we can check how many
> > pages we have already freed and break out of the loop.
> > 
> > However, in order to do this we do need to know how many pages we already
> > freed, so move nr_reclaimed into scan_control.
> 
> IIRC, Balbir-san explained the implemetation of the memcgroup 
> force cache dropping feature need non bail out at the past reclaim 
> throttring discussion.
> 
> I am not sure about this still right or not (iirc, memcgroup implemetation
> was largely changed).
> 
> Balbir-san, Could you comment to this patch?
> 
> 
I'm not Balbir-san but there is no "force-cache-dropping" feature now.
(I have no plan to do that.)

But, mem+swap controller will need to modify reclaim path to do "cache drop
first" becasue the amount of "mem+swap" will not change when "mem+swap" hit
limit. It's now set "sc.may_swap" to 0.

Hmm, I hope memcg is a silver bullet to this kind of special? workload in
long term.


Thanks,
-Kame



