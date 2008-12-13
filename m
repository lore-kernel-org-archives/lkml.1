Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbYLMDtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbYLMDtT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 22:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYLMDtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 22:49:09 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:34269 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbYLMDtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 22:49:08 -0500
Date: Sat, 13 Dec 2008 09:18:50 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Jay Lan <jlan@sgi.com>,
       Jiri Pirko <jpirko@redhat.com>, Jonathan Lim <jlim@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RESEND] introduce get_mm_hiwater_xxx(), fix
	taskstats->hiwater_xxx accounting
Message-ID: <20081213034850.GE4365@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hugh@veritas.com>, Jay Lan <jlan@sgi.com>,
	Jiri Pirko <jpirko@redhat.com>, Jonathan Lim <jlim@sgi.com>,
	linux-kernel@vger.kernel.org
References: <20081212140524.GA29488@redhat.com> <2f11576a0812121834n4125d053xcc85a5aa87264b66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <2f11576a0812121834n4125d053xcc85a5aa87264b66@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2008-12-13 11:34:53]:

> > (changes: update the changelog/comments)
> >
> > xacct_add_tsk() relies on do_exit()->update_hiwater_xxx() and uses
> > mm->hiwater_xxx directly, this leads to 2 problems:
> >
> >        - taskstats_user_cmd() can call fill_pid()->xacct_add_tsk()
> >          at any moment before the task exits, so we should check the
> >          current values of rss/vm anyway.
> >
> >        - do_exit()->update_hiwater_xxx() calls are racy. An exiting
> >          thread can be preempted right before mm->hiwater_xxx = new_val,
> >          and another thread can use A_LOT of memory and exit in between.
> >          When the first thread resumes it can be the last thread in the
> >          thread group, in that case we report the wrong hiwater_xxx
> >          values which do not take A_LOT into account.
> >
> > Introduce get_mm_hiwater_rss() and get_mm_hiwater_vm() helpers and
> > change xacct_add_tsk() to use them. The first helper will also be
> > used by rusage->ru_maxrss accounting.
> >
> > Kill do_exit()->update_hiwater_xxx() calls. Unless we are going to
> > decrease rss/vm there is no point to update mm->hiwater_xxx, and
> > nobody can look at this mm_struct when exit_mmap() actually unmaps
> > the memory.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> Thanks! looks good to me.
>    Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Me too, I am acking it, but you already have all the acks you need :)

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
