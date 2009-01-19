Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZASHQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZASHQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 02:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbZASHQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 02:16:19 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38770 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbZASHQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 02:16:19 -0500
Date: Mon, 19 Jan 2009 16:15:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] memcg: update document to mention swapoff should be
 test.
Message-Id: <20090119161508.f8b9d342.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090119071220.GE6039@balbir.in.ibm.com>
References: <20090119155748.acc60988.kamezawa.hiroyu@jp.fujitsu.com>
	<20090119071220.GE6039@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 12:42:20 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-19 15:57:48]:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Considering recently found problem:
> >  memcg-fix-refcnt-handling-at-swapoff.patch
> > 
> > It's better to mention about swapoff behavior in memcg_test document.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > ---
> >  Documentation/cgroups/memcg_test.txt |   24 ++++++++++++++++++++++--
> >  1 file changed, 22 insertions(+), 2 deletions(-)
> > 
> > Index: mmotm-2.6.29-Jan16/Documentation/cgroups/memcg_test.txt
> > ===================================================================
> > --- mmotm-2.6.29-Jan16.orig/Documentation/cgroups/memcg_test.txt
> > +++ mmotm-2.6.29-Jan16/Documentation/cgroups/memcg_test.txt
> > @@ -1,6 +1,6 @@
> >  Memory Resource Controller(Memcg)  Implementation Memo.
> > -Last Updated: 2008/12/15
> > -Base Kernel Version: based on 2.6.28-rc8-mm.
> > +Last Updated: 2009/1/19
> > +Base Kernel Version: based on 2.6.29-rc2.
> > 
> >  Because VM is getting complex (one of reasons is memcg...), memcg's behavior
> >  is complex. This is a document for memcg's internal behavior.
> > @@ -340,3 +340,23 @@ Under below explanation, we assume CONFI
> >  	# mount -t cgroup none /cgroup -t cpuset,memory,cpu,devices
> > 
> >  	and do task move, mkdir, rmdir etc...under this.
> > +
> > + 9.7 swapoff.
> > +	Besides management of swap is one of complicated parts of memcg,
> > +	call path of swap-in at swapoff is not same as usual swap-in path..
> > +	It's worth to be tested explicitly.
> > +
> > +	For example, test like following is good.
> > +	(Shell-A)
> > +	# mount -t cgroup none /cgroup -t memory
> > +	# mkdir /cgroup/test
> > +	# echo 40M > /cgroup/test/memory.limit_in_bytes
> > +	# echo 0 > /cgroup/test/tasks
> 
> 0? shouldn't this be pid? Potentially echo $$
> 

0 is handled as $$ in cgroup/tasks file.

-Kame

