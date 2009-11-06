Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbZKFA6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbZKFA6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbZKFA6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:58:36 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58234 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbZKFA6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:58:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 6 Nov 2009 09:56:05 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       akpm@linux-foundation.org,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] lib: generic percpu counter array
Message-Id: <20091106095605.0cc96ab5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0911051017310.25718@V090114053VZO-1>
References: <20091104152426.eacc894f.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.10.0911041414560.7409@V090114053VZO-1>
	<20091105090659.9a5d17b1.kamezawa.hiroyu@jp.fujitsu.com>
	<20091105141653.132d4977.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.10.0911051017310.25718@V090114053VZO-1>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009 10:20:18 -0500 (EST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 5 Nov 2009, KAMEZAWA Hiroyuki wrote:
> 
> > Anothter major percpu coutner is vm_stat[]. This patch implements
> > vm_stat[] style counter array in lib/percpu_counter.c
> > This is designed for introducing vm_stat[] style counter to memcg,
> > but maybe useful for other people. By using this, counter array
> > using percpu can be implemented easily in compact structure.
> 
> 
> Note that vm_stat support was written that way because we have extreme
> space constraints due to the need to keep statistics per zone and per cpu
> and avoid cache line pressure that would result through the use of big
> integer arrays per zone and per cpu. For a large number of zones and cpus
> this is desastrous.
> 
> If you only need to keep statistics per cpu for an entity then the vmstat
> approach is overkill. A per cpu allocation of a counter is enough.
> 
counter per memcg is required.
Memcg uses its own one but I want to remove it. (it doesn't consider memory
placement.)
What I can use under /lib is percpu_counter, but it's really overkill.

My concern on pure percpu counter is "read" side.
Now, we read counters only via status file and sometimes vmscan will read it.
For supporting dirty_ratio, we need to read them more.
I'll check I can move it to pure percpu counter as you do in mm_counters and
see how read side is affected by for_each_possible_cpu(). Anyway, it's
better than current one.

Thanks,
-Kame

