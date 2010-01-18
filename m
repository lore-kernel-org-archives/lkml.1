Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186Ab0ARAZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0ARAZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 19:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168Ab0ARAZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 19:25:35 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56157 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab0ARAZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 19:25:33 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 18 Jan 2010 09:22:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-Id: <20100118092217.98885b43.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100118090549.6d3af93b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
	<20100106070150.GL3059@balbir.in.ibm.com>
	<20100106161211.5a7b600f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107071554.GO3059@balbir.in.ibm.com>
	<20100107163610.aaf831e6.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107083440.GS3059@balbir.in.ibm.com>
	<20100107174814.ad6820db.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107180800.7b85ed10.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107092736.GW3059@balbir.in.ibm.com>
	<20100108084727.429c40fc.kamezawa.hiroyu@jp.fujitsu.com>
	<661de9471001171130p2b0ac061he6f3dab9ef46fd06@mail.gmail.com>
	<20100118090549.6d3af93b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 09:05:49 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > 
> > Kamezawa-San,
> > 
> > I implemented the same in user space and I get really bad results, here is why
> > 
> > 1. I need to hold and walk the tasks list in cgroups and extract RSS
> > through /proc (results in worse hold times for the fork() scenario you
> > menioned)
> > 2. The data is highly inconsistent due to the higher margin of error
> > in accumulating data which is changing as we run. By the time we total
> > and look at the memcg data, the data is stale
> > 
> > Would you be OK with the patch, if I renamed "shared_usage_in_bytes"
> > to "non_private_usage_in_bytes"?
> > 
> > Given that the stat is user initiated, I don't see your concern w.r.t.
> > overhead. Many subsystems like KSM do pay the overhead cost if the
> > user really wants the feature or the data. I would be really
> > interested in other opinions as well (if people do feel strongly
> > against or for the feature)
> > 
> 
> Please add that featuter to global VM before memcg.
> If VM guyes admits its good, I have no objections more.
> 

I don't want to say any more but...one point.

If the status of memory changes so frequently as the user land check program
can't calculate stable data, what the management daemon can react agasinst
it...the stale data ? So, I think it's nonsense anyway.

Thanks,
-Kame

