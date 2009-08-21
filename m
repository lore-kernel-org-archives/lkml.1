Return-Path: <linux-kernel-owner+w=401wt.eu-S1751588AbZHUEiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbZHUEiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 00:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbZHUEiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 00:38:07 -0400
Received: from RELAY-02.ANDREW.CMU.EDU ([128.2.10.85]:55809 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbZHUEiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 00:38:07 -0400
X-Greylist: delayed 805 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Aug 2009 00:38:06 EDT
Date: Fri, 21 Aug 2009 00:24:03 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 7/8] Adds functionality to read/write lock CLONE_THREAD fork()ing per-threadgroup
Message-ID: <20090821042403.GA25865@andrew.cmu.edu>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com> <20090818235843.22531.57310.stgit@menage.mtv.corp.google.com> <4A8CB750.7040509@cn.fujitsu.com> <6599ad830908191945k7c5f86b6j3ea4194f0dffa9ce@mail.gmail.com> <20090820141356.1bec84ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820141356.1bec84ed.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 02:13:56PM -0700, Andrew Morton wrote:
> On Wed, 19 Aug 2009 19:45:11 -0700
> Paul Menage <menage@google.com> wrote:
> 
> > On Wed, Aug 19, 2009 at 7:39 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> > >
> > >> + __ __ __ __ __ __ list_for_each_entry_rcu(p, &tsk->thread_group, thread_group) {
> > >> + __ __ __ __ __ __ __ __ __ __ if (p->sighand) {
> > >> + __ __ __ __ __ __ __ __ __ __ __ __ __ __ sighand = tsk->sighand;
> 
> (^^ who did that?)
> 

The tsk->sighand? Likely me. I'm surprised it took that many pairs of eyes
to catch it.

> > >
> > > s/tsk->sighand/p->sighand
> > 
> > Good catch, thanks. Fixed.
> > 
> 
> I see no fix anywhere so I did this:
> 
> --- a/kernel/cgroup.c~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix
> +++ a/kernel/cgroup.c
> @@ -1557,7 +1557,7 @@ struct sighand_struct *threadgroup_fork_
>  		rcu_read_lock();
>  		list_for_each_entry_rcu(p, &tsk->thread_group, thread_group) {
>  			if (p->sighand) {
> -				sighand = tsk->sighand;
> +				sighand = p->sighand;
>  				break;
>  			}
>  		}
> 
> 
