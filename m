Return-Path: <linux-kernel-owner+w=401wt.eu-S1757517AbYDQF2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbYDQF2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 01:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYDQF2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 01:28:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53745 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYDQF2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 01:28:30 -0400
Message-ID: <4806DFAB.8050307@cn.fujitsu.com>
Date: Thu, 17 Apr 2008 13:27:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Jackson <pj@sgi.com>
Subject: Re: [PATCH] cgroup: fix a race condition in manipulating tsk->cg_list
References: <4806C5EB.3040102@cn.fujitsu.com>	 <6599ad830804162118g6b24d8ebq26b0d72133b0e19e@mail.gmail.com>	 <4806DA6F.3000405@cn.fujitsu.com>	 <20080416221655.c73d219f.akpm@linux-foundation.org> <6599ad830804162224s42ba221vea981fe34b30636a@mail.gmail.com>
In-Reply-To: <6599ad830804162224s42ba221vea981fe34b30636a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Apr 16, 2008 at 10:16 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>>  > > Maybe it would be better to not do a cgroup_exit() until we're
>>  > > unhashed, so that cgroup_enable_task_cg_list() can't find the exiting
>>  > > task?
>>
>>  So we won't be doing what Paul suggested?
>>
> 
> It's not as high a priority as Li's bug fix (which may be a good
> candidate for 2.6.25.1) but for the future I think I'll implement this
> distinguished css_set pointer for tasks that have finished
> cgroup_exit(), since I think it will make the similar synchronization
> in attach_task() cleaner, as well as cgroup_enable_task_cg_list().
> 

Yes, this approach sounds good to me. :)

> Paul
> 
