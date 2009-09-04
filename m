Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZIDGwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZIDGwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbZIDGwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:52:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48710 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZIDGwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:52:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Sep 2009 15:50:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [mmotm][experimental][PATCH] coalescing charge
Message-Id: <20090904155029.ef544d5f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090904154050.25873aa5.nishimura@mxp.nes.nec.co.jp>
References: <20090902093438.eed47a57.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902134114.b6f1a04d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090902182923.c6d98fd6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090903141727.ccde7e91.nishimura@mxp.nes.nec.co.jp>
	<20090904131835.ac2b8cc8.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904141157.4640ec1e.nishimura@mxp.nes.nec.co.jp>
	<20090904142143.15ffcb53.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904142654.08dd159f.kamezawa.hiroyu@jp.fujitsu.com>
	<20090904154050.25873aa5.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009 15:40:50 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Fri, 4 Sep 2009 14:26:54 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Fri, 4 Sep 2009 14:21:43 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > On Fri, 4 Sep 2009 14:11:57 +0900
> > > Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > > 
> > > > > > > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > > > > It looks basically good. I'll do some tests with all patches applied.
> > > > > > 
> > > > > thanks.
> > > > > 
> > > > it seems that these patches make rmdir stall again...
> > > > This batched charge patch seems not to be the (only) suspect, though.
> > > > 
> > > Ouch, no probelm with the latest mmotm ? I think this charge-uncharge-offload
> > > patch set doesn't use css_set()/get()...
> > > Hm, softlimit related parts ?
> > > 
> hmm, these patches(including softlimit cleanup) seems not to be guilt.
> Current(I'm using mmotm-2009-08-27-16-51) mmotm seems to be broken about memcg's rmdir.
> 
> I must admit I've not tested mmotm for several months because I have been working
> on stabilizing mainline for a long time...
> 
> > Ah, one more question. What memory.usage_in_bytes shows in that case ?
> > If not zero, charge/uncharge coalescing is guilty.
> > 
> usage_in_bytes is 0.
> I've confirmed by crash command that the mem_cgroup has extra ref counts.
> 
> I'll dig more..
> 
Ok, then, I and you see different problem...
Hmm..css refcnt leak. I'll dig, too. I hope we can catch it before sneaking
into mainline.

Thanks,
-Kame

> 
> Thanks,
> Daisuke Nishimura.
> 

