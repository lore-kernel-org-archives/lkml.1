Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZJAA4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZJAA4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 20:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZJAA4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 20:56:45 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38392 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbZJAA4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 20:56:44 -0400
Date: Thu, 1 Oct 2009 09:45:14 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] memcg: replace memcg's per cpu status counter
 with array counter like vmstat
Message-Id: <20091001094514.c9d2b3d9.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090930190417.8823fa44.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090930190417.8823fa44.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 19:04:17 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Hi,
> 
> In current implementation, memcg uses its own percpu counters for counting
> evetns and # of RSS, CACHES. Now, counter is maintainer per cpu without
> any synchronization as vm_stat[] or percpu_counter. So, this is
>  update-is-fast-but-read-is-slow conter.
> 
> Because "read" for these counter was only done by memory.stat file, I thought
> read-side-slowness was acceptable. Amount of memory usage, which affects
> memory limit check, can be read by memory.usage_in_bytes. It's maintained
> by res_counter.
> 
> But in current -rc, root memcg's memory usage is calcualted by this per cpu
> counter and read side slowness may be trouble if it's frequently read.
> 
> And, in recent discusstion, I wonder we should maintain NR_DIRTY etc...
> in memcg. So, slow-read-counter will not match our requirements, I guess.
> I want some counter like vm_stat[] in memcg.
> 
I see your concern.

But IMHO, it would be better to explain why we need a new percpu array counter
instead of using array of percpu_counter(size or consolidation of related counters ?),
IOW, what the benefit of percpu array counter is.


Thanks,
Daisuke Nishimura.

> This 2 patches are for using counter like vm_stat[] in memcg.
> Just an idea level implementaion but I think this is not so bad.
> 
> I confirmed this patch works well. I'm now thinking how to test performance...
> 
> Any comments are welcome. 
> This patch is onto mmotm + some myown patches...so...this is just an RFC.
> 
> Regards,
> -Kame
> 
