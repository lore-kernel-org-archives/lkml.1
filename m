Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbYITJTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbYITJTe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 05:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbYITJTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 05:19:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59168 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbYITJTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 05:19:24 -0400
Date: Sat, 20 Sep 2008 18:25:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Hirokazu Takahashi <taka@valinux.co.jp>, righi.andrea@gmail.com,
       dm-devel@redhat.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, agk@sourceware.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       jens.axboe@oracle.com, fernando@oss.ntt.co.jp, xemul@openvz.org
Subject: Re: [dm-devel] Re: dm-ioband + bio-cgroup benchmarks
Message-Id: <20080920182541.0edb5ab5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48D48789.8000606@linux.vnet.ibm.com>
References: <48D267B5.20402@gmail.com>
	<20080918150634.GH20640@redhat.com>
	<48D2715A.6060002@gmail.com>
	<20080919.123405.91829935.taka@valinux.co.jp>
	<20080920132703.e74c8f89.kamezawa.hiroyu@jp.fujitsu.com>
	<48D48789.8000606@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 22:18:01 -0700
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Kamezawa-San, I am not dead against it, but I would provide a knob/control point
> for system administrator to decide if movement is important for applications,
> then let them do so (like force_empty).
> 
make sense.


> > Anyway what's next for me is
> >  1. fix current discussion to remove page->page_cgroup pointer.
> >  2. reduce locks.
> 
> Are you planning on reposting these. I've been trying other approaches at my end
> 
I'll post in next Monday. It's obvious that I should do more tests/fixes...
About performance, I'll give it up at some reasonable point.

> 1. Use radix tree per-node per-zone
> 2. Use radix trees only for 32 bit systems
> 3. Depend on CONFIG_HAVE_MEMORY_PRESENT and build a sparse data structure and
> use pre-allocation
> 
> I've posted (1) and I'll take a look at your patches as well
> 
My patch has (many) bugs. Severals are fixed but there will be still ;)
SwapCache beats me again because it easily reuse uncharged pages...

BTW why do you like radix-tree ? It's not very good for our purpose.
FLATMEM support for small system will be easy work.

> >  3. support swap and swap-cache.
> > 
> > I think algorithm for (1), (2) is now getting smart.
> > 
> 
> Yes, it is getting better
> 

Thanks,
-Kame

