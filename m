Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbYDQFRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYDQFRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 01:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYDQFRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 01:17:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbYDQFRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 01:17:11 -0400
Date: Wed, 16 Apr 2008 22:16:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cgroup: fix a race condition in manipulating
 tsk->cg_list
Message-Id: <20080416221655.c73d219f.akpm@linux-foundation.org>
In-Reply-To: <4806DA6F.3000405@cn.fujitsu.com>
References: <4806C5EB.3040102@cn.fujitsu.com>
	<6599ad830804162118g6b24d8ebq26b0d72133b0e19e@mail.gmail.com>
	<4806DA6F.3000405@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 13:04:47 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> > 
> > Yes, that looks like it could be the same one - great. But this
> > corruption can only be triggered the first time you cat a tasks file
> > after a reboot, right? That would partly explain why it was hard to
> > reproduce (at least, I had trouble).
> > 
> 
> Right. I was lucky to trigger this and thus knew how to reproduce.
> 
> > My only thought about the downside of this is that an exiting task
> > that gets stuck somewhere  between setting PF_EXITING and calling
> > cgroup_exit() won't show up in its cgroup's tasks file, since we'll
> > enable cgroup links but skip it. I guess that's not a big deal.
> > 
> 
> Agree. I think it won't be a problem.
> 
> > Maybe it would be better to not do a cgroup_exit() until we're
> > unhashed, so that cgroup_enable_task_cg_list() can't find the exiting
> > task?

So we won't be doing what Paul suggested?
