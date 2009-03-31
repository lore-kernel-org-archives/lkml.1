Return-Path: <linux-kernel-owner+w=401wt.eu-S1761463AbZCaFCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463AbZCaFCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 01:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbZCaFCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 01:02:13 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48502 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZCaFCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 01:02:12 -0400
Date: Tue, 31 Mar 2009 10:31:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH] memcg soft limit (yet another new design) v1
Message-ID: <20090331050143.GG16497@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com> <20090328181100.GB26686@balbir.in.ibm.com> <20090328182747.GA8339@balbir.in.ibm.com> <20090331090607.7ebc44c5.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090331090607.7ebc44c5.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-31 09:06:07]:

> On Sat, 28 Mar 2009 23:57:47 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * Balbir Singh <balbir@linux.vnet.ibm.com> [2009-03-28 23:41:00]:
> > 
> > > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-03-27 13:59:33]:
> > > 
> > > > ==brief test result==
> > > > On 2CPU/1.6GB bytes machine. create group A and B
> > > >   A.  soft limit=300M
> > > >   B.  no soft limit
> > > > 
> > > >   Run a malloc() program on B and allcoate 1G of memory. The program just
> > > >   sleeps after allocating memory and no memory refernce after it.
> > > >   Run make -j 6 and compile the kernel.
> > > > 
> > > >   When vm.swappiness = 60  => 60MB of memory are swapped out from B.
> > > >   When vm.swappiness = 10  => 1MB of memory are swapped out from B    
> > > > 
> > > >   If no soft limit, 350MB of swap out will happen from B.(swapiness=60)
> > > >
> > > 
> > > I ran the same tests, booted the machine with mem=1700M and maxcpus=2
> > > 
> > > Here is what I see with
> > 
> > I meant to say, Here is what I see with my patches (v7)
> > 
> 
> your malloc program is like this ?
> 
> int main(int argc, char *argv[])
> {
>     c = malloc(1G);
>     memset(c, 0, 1G);
>     getc();
> }
>

Very similar, instead of memset, we go integer by integer and set it
to 0, do two loops of touching and wait for user input before exiting.
 

-- 
	Balbir
