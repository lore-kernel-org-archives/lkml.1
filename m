Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbXHNSOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbXHNSOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbXHNSOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:14:22 -0400
Received: from tayrelbas01.tay.hp.com ([161.114.80.244]:44423 "EHLO
	tayrelbas01.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749AbXHNSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:14:19 -0400
Subject: Re: Regression in 2.6.23-rc2-mm2, mounting cpusets causes a hang
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, clameter@sgi.com,
       bob.picco@hp.com, nacc@us.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       mel@skynet.ie, akpm@linux-foundation.org,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       ckrm-tech <ckrm-tech@lists.sourceforge.net>
In-Reply-To: <20070814180339.GA32553@vino.hallyn.com>
References: <20070812152126.GA26239@linux.vnet.ibm.com>
	 <20070813201215.GA16908@vino.hallyn.com>
	 <1187103831.6281.24.camel@localhost>
	 <20070814180339.GA32553@vino.hallyn.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 14 Aug 2007 14:13:44 -0400
Message-Id: <1187115224.6281.40.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-14 at 13:03 -0500, Serge E. Hallyn wrote:
> Quoting Lee Schermerhorn (Lee.Schermerhorn@hp.com):
> > On Mon, 2007-08-13 at 15:12 -0500, Serge E. Hallyn wrote:
> > > Quoting Dhaval Giani (dhaval@linux.vnet.ibm.com):
> > > > Hi,
> > > > 
> > > > On mounting cpusets using containers, I have been hitting the following
> > > > bug.
> > > > 
> > > > 
> > > > -----------[ cut here ]------------
> > > > kernel BUG at kernel/cpuset.c:331!
> > <snip>
> > > > CONFIG_HIGHMEM=y
> > > > CONFIG_X86_PAE=y
> > > > # CONFIG_NUMA is not set
> > > > CONFIG_ARCH_POPULATES_NODE_MAP=y
> > > > CONFIG_SELECT_MEMORY_MODEL=y
> > > > CONFIG_FLATMEM_MANUAL=y
> > > > # CONFIG_DISCONTIGMEM_MANUAL is not set
> > > > # CONFIG_SPARSEMEM_MANUAL is not set
> > > > CONFIG_FLATMEM=y
> > > > CONFIG_FLAT_NODE_MEM_MAP=y
> > > > # CONFIG_SPARSEMEM_STATIC is not set
> > > > CONFIG_SPLIT_PTLOCK_CPUS=4
> > > > CONFIG_RESOURCES_64BIT=y
> > > > CONFIG_ZONE_DMA_FLAG=1
> > <snip>
> > > 
> > > Yeah, I'm seeing the same thing.  Oddly, my node_states[N_NORMAL_MEMORY]
> > > and node_states[N_HIGH_MEMORY] are empty, while node_states[N_ONLINE]
> > > contains my single cpu (on i386 kvm image).
> > > 
> > > -serge
> > 
> > Yes, you'll definitely hit that BUG if the N_HIGH_MEMORY mask is empty.
> > So far, I can't see how this could be, tho'.  __build_all_zonelists()
> > should be called for non-NUMA as well as NUMA.  It iterates over "all
> 
> Yup, and it is, and some debug statements insist that
> node_set_state(nid, N_HIGH_MEMORY) is being called for cpu 0,
> and the state is in fact being correctly set.
> 
> So it must get cleared later...

OK.  That helps.  I'll see what I can find...

Thanks,
Lee


