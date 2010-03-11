Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277Ab0CKFFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 00:05:04 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:48299 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab0CKFFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 00:05:00 -0500
Date: Thu, 11 Mar 2010 13:58:47 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org,
       Andrea Righi <arighi@develer.com>, linux-kernel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH mmotm 2.5/4] memcg: disable irq at page cgroup lock (Re:
 [PATCH -mmotm 3/4] memcg: dirty pages accounting and limiting
 infrastructure)
Message-Id: <20100311135847.990eee62.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100311134908.48d8b0fc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100308105641.e2e714f4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100308111724.3e48aee3.nishimura@mxp.nes.nec.co.jp>
	<20100308113711.d7a249da.kamezawa.hiroyu@jp.fujitsu.com>
	<20100308170711.4d8b02f0.nishimura@mxp.nes.nec.co.jp>
	<20100308173100.b5997fd4.kamezawa.hiroyu@jp.fujitsu.com>
	<20100309001252.GB13490@linux>
	<20100309091914.4b5f6661.kamezawa.hiroyu@jp.fujitsu.com>
	<20100309102928.9f36d2bb.nishimura@mxp.nes.nec.co.jp>
	<20100309045058.GX3073@balbir.in.ibm.com>
	<20100310104309.c5f9c9a9.nishimura@mxp.nes.nec.co.jp>
	<20100310035624.GP3073@balbir.in.ibm.com>
	<20100311133123.ab10183c.nishimura@mxp.nes.nec.co.jp>
	<20100311134908.48d8b0fc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 13:49:08 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 11 Mar 2010 13:31:23 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > On Wed, 10 Mar 2010 09:26:24 +0530, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > * nishimura@mxp.nes.nec.co.jp <nishimura@mxp.nes.nec.co.jp> [2010-03-10 10:43:09]:
> 
> > I made a patch(attached) using both local_irq_disable/enable and local_irq_save/restore.
> > local_irq_save/restore is used only in mem_cgroup_update_file_mapped.
> > 
> > And I attached a histogram graph of 30 times kernel build in root cgroup for each.
> > 
> >   before_root: no irq operation(original)
> >   after_root: local_irq_disable/enable for all
> >   after2_root: local_irq_save/restore for all
> >   after3_root: mixed version(attached)
> > 
> > hmm, there seems to be a tendency that before < after < after3 < after2 ?
> > Should I replace save/restore version to mixed version ?
> > 
> 
> IMHO, starting from after2_root version is the easist.
> If there is a chance to call lock/unlock page_cgroup can be called in
> interrupt context, we _have to_ disable IRQ, anyway.
> And if we have to do this, I prefer migration_lock rather than this mixture.
> 
I see.

> BTW, how big your system is ? Balbir-san's concern is for bigger machines.
> But I'm not sure this change is affecte by the size of machines.
> I'm sorry I have no big machine, now.
> 
My test machine have 8CPUs, and I run all the test with "make -j8".
Sorry, I don't have easy access to huge machine either.

> I'll consider yet another fix for race in account migration if I can.
> 
me too.


Thanks,
Daisuke Nishimura.
