Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZHTVOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZHTVOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbZHTVOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:14:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754895AbZHTVOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:14:44 -0400
Date: Thu, 20 Aug 2009 14:13:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: lizf@cn.fujitsu.com, bblum@andrew.cmu.edu, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 7/8] Adds functionality to read/write lock CLONE_THREAD
 fork()ing per-threadgroup
Message-Id: <20090820141356.1bec84ed.akpm@linux-foundation.org>
In-Reply-To: <6599ad830908191945k7c5f86b6j3ea4194f0dffa9ce@mail.gmail.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	<20090818235843.22531.57310.stgit@menage.mtv.corp.google.com>
	<4A8CB750.7040509@cn.fujitsu.com>
	<6599ad830908191945k7c5f86b6j3ea4194f0dffa9ce@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 19:45:11 -0700
Paul Menage <menage@google.com> wrote:

> On Wed, Aug 19, 2009 at 7:39 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> >
> >> + __ __ __ __ __ __ list_for_each_entry_rcu(p, &tsk->thread_group, thread_group) {
> >> + __ __ __ __ __ __ __ __ __ __ if (p->sighand) {
> >> + __ __ __ __ __ __ __ __ __ __ __ __ __ __ sighand = tsk->sighand;

(^^ who did that?)

> >
> > s/tsk->sighand/p->sighand
> 
> Good catch, thanks. Fixed.
> 

I see no fix anywhere so I did this:

--- a/kernel/cgroup.c~cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix
+++ a/kernel/cgroup.c
@@ -1557,7 +1557,7 @@ struct sighand_struct *threadgroup_fork_
 		rcu_read_lock();
 		list_for_each_entry_rcu(p, &tsk->thread_group, thread_group) {
 			if (p->sighand) {
-				sighand = tsk->sighand;
+				sighand = p->sighand;
 				break;
 			}
 		}

