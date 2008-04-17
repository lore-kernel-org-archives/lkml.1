Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYDQFQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYDQFQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 01:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbYDQFQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 01:16:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbYDQFQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 01:16:43 -0400
Date: Wed, 16 Apr 2008 22:16:02 -0700
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
Message-Id: <20080416221602.0a13b94b.akpm@linux-foundation.org>
In-Reply-To: <4806DBC9.3090607@cn.fujitsu.com>
References: <4806C5EB.3040102@cn.fujitsu.com>
	<20080416211144.a38f6fc0.akpm@linux-foundation.org>
	<6599ad830804162117w14364b7cg20d3694ffdfeb867@mail.gmail.com>
	<20080416215907.63d71409.akpm@linux-foundation.org>
	<4806DBC9.3090607@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 13:10:33 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> Andrew Morton wrote:
> > On Wed, 16 Apr 2008 21:17:34 -0700 "Paul Menage" <menage@google.com> wrote:
> > 
> >> On Wed, Apr 16, 2008 at 9:11 PM, Andrew Morton
> >> <akpm@linux-foundation.org> wrote:
> >>>  I don't fully understand the race.  Both paths hold css_set_lock.
> >>>
> >>>  Can you describe it in more detail please?
> >> Task A starts exiting, passes the check for unlinking current->cg_list.
> > 
> > So cgroup_exit() sees !list_empty(tsk->cg_list)
> > 
> 
> cgroup_exit() sees list_empty(tsk->cg_list), then cgroup_enable_task_cg_list()
> links the task to the list, and then the task exited, so the list entry won't
> get deleted.

OK.
