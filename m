Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYDKEna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYDKEna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 00:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbYDKEnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 00:43:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55799 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbYDKEnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 00:43:20 -0400
Date: Fri, 11 Apr 2008 13:47:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm] Add an owner to the mm_struct (v9)
Message-Id: <20080411134739.1aae8bae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47FEE89A.1010102@linux.vnet.ibm.com>
References: <20080410091602.4472.32172.sendpatchset@localhost.localdomain>
	<20080411123339.89aea319.kamezawa.hiroyu@jp.fujitsu.com>
	<47FEE89A.1010102@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 09:57:06 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > maybe I don't undestand correctlly...
> > 
> > On Thu, 10 Apr 2008 14:46:02 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >>  
> >> +config MM_OWNER
> >> +	bool
> >> +
> > no default is ok here  ? what value will this have if not selected ?
> > I'm sorry if I misunderstand Kconfig.
> > 
> 
> The way this works is
> 
> If I select memory resource controller, CONFIG_MM_OWNER is set to y, else it
> does not even show up in the .config
> 
ok, sorry for noise.

> > 
> >> +	/*
> >> +	 * Search through everything else. We should not get
> >> +	 * here often
> >> +	 */
> >> +	do_each_thread(g, c) {
> >> +		if (c->mm == mm)
> >> +			goto assign_new_owner;
> >> +	} while_each_thread(g, c);
> >> +
> > 
> > Again, do_each_thread() is suitable here ?
> > for_each_process() ?
> > 
> 
> do_each_thread(), while_each_thread() walks all processes and threads of those
> processes in the system. It is a common pattern used in the kernel (see
> try_to_freeze_tasks() or oom_kill_task() for example).
> 

What you want is finding a thread which has the "mm_struct". Why search all
threads ? I think you only have to search processes(i.e. thread-group-leaders).

try_to_freeze_tasks()/oom_kill_task() have to chase all threads because
it have to check flags in task_structs in a process.


Thanks,
-Kame



