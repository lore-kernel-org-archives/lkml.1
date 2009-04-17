Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbZDQIui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbZDQIui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbZDQIu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:50:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50518 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbZDQIu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:50:28 -0400
Date: Fri, 17 Apr 2009 17:48:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, yoshikawa.takuya@oss.ntt.co.jp,
       righi.andrea@gmail.com, menage@google.com, balbir@linux.vnet.ibm.com,
       guijianfeng@cn.fujitsu.com, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       chlunde@ping.uio.no, dave@linux.vnet.ibm.com, dpshah@google.com,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp, taka@valinux.co.jp,
       lizf@cn.fujitsu.com, matt@bluehost.com, dradford@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       s-uchida@ap.jp.nec.com, subrata@linux.vnet.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] bio-cgroup controller
Message-Id: <20090417174854.07aeec9f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090417170016.5c7268f1.kamezawa.hiroyu@jp.fujitsu.com>
References: <1239740480-28125-4-git-send-email-righi.andrea@gmail.com>
	<49E7E037.9080004@oss.ntt.co.jp>
	<20090417112433.085ed604.kamezawa.hiroyu@jp.fujitsu.com>
	<20090417.162201.183038478.ryov@valinux.co.jp>
	<20090417170016.5c7268f1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009 17:00:16 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Fri, 17 Apr 2009 16:22:01 +0900 (JST)
> Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> 
> > In the case where the bio-cgroup data is allocated dynamically,
> >    - Sometimes quite a large amount of memory get marked dirty.
> >      In this case it requires more kernel memory than that of the
> >      current implementation.
> >    - The operation is expansive due to memory allocations and exclusive
> >      controls by such as spinlocks.
> > 
> > In the case where the bio-cgroup data is allocated by delayed allocation, 
> >   - It makes the operation complicated and expensive, because
> >     sometimes a bio has to be created in the context of other
> >     processes, such as aio and swap-out operation.
> > 
> > I'd prefer a simple and lightweight implementation. bio-cgroup only
> > needs 4bytes unlike memory controller. The reason why bio-cgroup chose
> > this approach is to minimize the overhead.
> > 
> My point is, plz do your best to reduce memory usage here. You increase
> size of page_cgroup just because you cannot increase size of struct page.
> It's not be sane reason to increase size of this object.
> It's a cheat in my point of view.
> 

Can't this work sanely ?
Hmm, endian is obstacle ?
==
	sturct page_cgroup {
		union {
			struct {
				unsigned long memcg_field:16;
				unsigned long blockio_field:16;
			} field;
			unsigned long flags; /* unsigned long is not 32bits */
		} flags;
	}
==

Thanks,
-Kame





