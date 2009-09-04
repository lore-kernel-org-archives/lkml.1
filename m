Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbZIDGtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbZIDGtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbZIDGtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:49:53 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:48673 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZIDGtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:49:51 -0400
Date: Fri, 4 Sep 2009 15:40:50 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [mmotm][experimental][PATCH] coalescing charge
Message-Id: <20090904154050.25873aa5.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090904142654.08dd159f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090902093438.eed47a57.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902134114.b6f1a04d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902182923.c6d98fd6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090903141727.ccde7e91.nishimura@mxp.nes.nec.co.jp>
	<20090904131835.ac2b8cc8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904141157.4640ec1e.nishimura@mxp.nes.nec.co.jp>
	<20090904142143.15ffcb53.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904142654.08dd159f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 14:26:54 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 4 Sep 2009 14:21:43 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > On Fri, 4 Sep 2009 14:11:57 +0900
> > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > 
> > > > > > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > > > It looks basically good. I'll do some tests with all patches applied.
> > > > > 
> > > > thanks.
> > > > 
> > > it seems that these patches make rmdir stall again...
> > > This batched charge patch seems not to be the (only) suspect, though.
> > > 
> > Ouch, no probelm with the latest mmotm ? I think this charge-uncharge-offload
> > patch set doesn't use css_set()/get()...
> > Hm, softlimit related parts ?
> > 
hmm, these patches(including softlimit cleanup) seems not to be guilt.
Current(I'm using mmotm-2009-08-27-16-51) mmotm seems to be broken about memcg's rmdir.

I must admit I've not tested mmotm for several months because I have been working
on stabilizing mainline for a long time...

> Ah, one more question. What memory.usage_in_bytes shows in that case ?
> If not zero, charge/uncharge coalescing is guilty.
> 
usage_in_bytes is 0.
I've confirmed by crash command that the mem_cgroup has extra ref counts.

I'll dig more..


Thanks,
Daisuke Nishimura.
