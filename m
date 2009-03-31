Return-Path: <linux-kernel-owner+w=401wt.eu-S1761460AbZCaFUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460AbZCaFUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 01:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbZCaFUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 01:20:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58832 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbZCaFUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 01:20:22 -0400
Date: Tue, 31 Mar 2009 14:18:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH] memcg soft limit (yet another new design) v1
Message-Id: <20090331141850.88473e2a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090331140502.813993cc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090328181100.GB26686@balbir.in.ibm.com>
	<20090328182747.GA8339@balbir.in.ibm.com>
	<20090331085538.2aaa5e2b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090331050055.GF16497@balbir.in.ibm.com>
	<20090331140502.813993cc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 14:05:02 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 31 Mar 2009 10:30:55 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-31 08:55:38]:
> > 
> > > On Sat, 28 Mar 2009 23:57:47 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > * Balbir Singh <balbir@linux.vnet.ibm.com> [2009-03-28 23:41:00]:
> > > > 
> > > > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-27 13:59:33]:
> > > > > 
> > > > > > ==brief test result==
> > > > > > On 2CPU/1.6GB bytes machine. create group A and B
> > > > > >   A.  soft limit=300M
> > > > > >   B.  no soft limit
> > > > > > 
> > > > > >   Run a malloc() program on B and allcoate 1G of memory. The program just
> > > > > >   sleeps after allocating memory and no memory refernce after it.
> > > > > >   Run make -j 6 and compile the kernel.
> > > > > > 
> > > > > >   When vm.swappiness = 60  => 60MB of memory are swapped out from B.
> > > > > >   When vm.swappiness = 10  => 1MB of memory are swapped out from B    
> > > > > > 
> > > > > >   If no soft limit, 350MB of swap out will happen from B.(swapiness=60)
> > > > > >
> > > > > 
> > > > > I ran the same tests, booted the machine with mem=1700M and maxcpus=2
> > > > > 
> > > > > Here is what I see with
> > > > 
> > > > I meant to say, Here is what I see with my patches (v7)
> > > > 
> > > Hmm, I saw 250MB of swap out ;) As I reported before.
> > 
> > Swapout for A? For A it is expected, but for B it is not. How many
> > nodes do you have on your machine? Any fake numa nodes?
> > 
> Of course, from B.
> 
> Nothing special boot options. My test was on VMware 2cpus/1.6GB memory.
> 
More precise.

the host equips 1576444kB of memory not 1700MB.


Thanks,
-Kame

