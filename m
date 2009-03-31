Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZCaG57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZCaG57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZCaG5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:57:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51832 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZCaG5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:57:49 -0400
Date: Tue, 31 Mar 2009 15:56:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH] memcg soft limit (yet another new design) v1
Message-Id: <20090331155614.8ad0c9b2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090331064901.GK16497@balbir.in.ibm.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090328181100.GB26686@balbir.in.ibm.com>
	<20090328182747.GA8339@balbir.in.ibm.com>
	<20090331085538.2aaa5e2b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090331050055.GF16497@balbir.in.ibm.com>
	<20090331140502.813993cc.kamezawa.hiroyu@jp.fujitsu.com>
	<20090331061010.GJ16497@balbir.in.ibm.com>
	<20090331152843.e1db942b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090331064901.GK16497@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 12:19:02 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > 
> > > > Nothing special boot options. My test was on VMware 2cpus/1.6GB memory.
> > > > 
> > > > I wonder why swapout can be 0 on your test. Do you add some extra hooks to
> > > > kswapd ?
> > > >
> > > 
> > > Nope.. no special hooks to kswapd. B never enters the RB-Tree and thus
> > > never hits the memcg soft limit reclaim path. kswapd can reclaim from
> > > it, but it grows back quickly.
> > Why grows back ? tasks in B sleeps ?
> 
> Since B continuously consumes memory
> 
Not sleep ?

In my test
 1. malloc 1GB and touch all and sleep in B. Wait until the memory usage in B
    goes up to 1024MB. This never wake up until 3. 
 2. run make in group A.
 3. kill malloc program.

Then why why continuously consumes memory ?

Thanks,
-Kame

