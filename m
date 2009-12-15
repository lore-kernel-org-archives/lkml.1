Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZLOEqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZLOEqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbZLOEqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:46:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40234 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbZLOEqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:46:30 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Dec 2009 13:43:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with
 nodemask v4.2
Message-Id: <20091215134327.6c46b586.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0912142025090.29243@chino.kir.corp.google.com>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com>
	<20091110170338.9f3bb417.nishimura@mxp.nes.nec.co.jp>
	<20091110171704.3800f081.kamezawa.hiroyu@jp.fujitsu.com>
	<20091111112404.0026e601.kamezawa.hiroyu@jp.fujitsu.com>
	<20091111134514.4edd3011.kamezawa.hiroyu@jp.fujitsu.com>
	<20091111142811.eb16f062.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911102155580.2924@chino.kir.corp.google.com>
	<20091111152004.3d585cee.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911102224440.6652@chino.kir.corp.google.com>
	<20091111153414.3c263842.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911171609370.12532@chino.kir.corp.google.com>
	<20091118095824.076c211f.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911171725050.13760@chino.kir.corp.google.com>
	<20091214171632.0b34d833.akpm@linux-foundation.org>
	<20091215103202.eacfd64e.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0912142025090.29243@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 20:30:37 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Tue, 15 Dec 2009, KAMEZAWA Hiroyuki wrote:
> 
> >     I'm now preparing more counters for mm's statistics. It's better to
> >     wait  and to see what we can do more. And other patches for total
> >     oom-killer improvement is under development.
> > 
> >     And, there is a compatibility problem.
> >     As David says, this may break some crazy software which uses
> >     fake_numa+cpuset+oom_killer+oom_adj for resource controlling.
> >    (even if I recommend them to use memcg rather than crazy tricks...)
> >     
> 
> That's not at all what I said.  I said using total_vm as a baseline allows 
> users to define when a process is to be considered "rogue," that is, using 
> more memory than expected.  Using rss would be inappropriate since it is 
> highly dynamic and depends on the state of the VM at the time of oom, 
> which userspace cannot possibly keep updated.
> 
> You consistently ignore that point: the power of /proc/pid/oom_adj to 
> influence when a process, such as a memory leaker, is to be considered as 
> a high priority for an oom kill.  It has absolutely nothing to do with 
> fake NUMA, cpusets, or memcg.
> 
You also ignore that it's not sane to use oom kill for resource control ;)

Anyway, rss patch was dropped as you want.
I'll prepare other ones.

Thanks,
-Kame

