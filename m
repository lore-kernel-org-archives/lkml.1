Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYDCFBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYDCFBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 01:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751762AbYDCFBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 01:01:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49167 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbYDCFBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 01:01:39 -0400
Message-ID: <47F46436.3060607@cn.fujitsu.com>
Date: Thu, 03 Apr 2008 12:59:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH -mm 2/3] cgroup: simplify init_subsys()
References: <47F2EC94.8030707@cn.fujitsu.com> <6599ad830804020326o7947e3e5k25249e6b1c00e6b5@mail.gmail.com>
In-Reply-To: <6599ad830804020326o7947e3e5k25249e6b1c00e6b5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Apr 1, 2008 at 7:16 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>  -
>>  -       /* If this subsystem requested that it be notified with fork
>>  -        * events, we should send it one now for every process in the
>>  -        * system */
>>  -       if (ss->fork) {
>>  -               struct task_struct *g, *p;
>>  -
>>  -               read_lock(&tasklist_lock);
>>  -               do_each_thread(g, p) {
>>  -                       ss->fork(ss, p);
>>  -               } while_each_thread(g, p);
>>  -               read_unlock(&tasklist_lock);
>>  -       }
> 
> Should we maybe call ss->fork(ss, &init_task) ? Or just document that
> ss->fork() explicitly doesn't get called for init.
> 
> Maybe also add some BUG()s to confirm that no other tasks have in fact
> been forked by this point?
> 

At system boot, before all the subsystems have been registered, no processes
including init has been forked, am I right? So the fork callback will be
invoked when the init process is forked, so we don't need to call
ss->fork(ss, &init_task).

I'll add a BUG_ON(), and update the document about the fork callback.

Regards,
Li Zefan
