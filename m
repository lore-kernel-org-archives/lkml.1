Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbZATPDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbZATPDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbZATPC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:02:57 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50373 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZATPC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:02:57 -0500
Date: Tue, 20 Jan 2009 16:00:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Vitaliy Gusev <vgusev@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] kthread: Don't looking for a task in create_kthread()
	#2
Message-ID: <20090120150019.GA17399@redhat.com>
References: <200901201345.42054.vgusev@openvz.org> <20090120120642.GA9497@redhat.com> <200901201716.34842.vgusev@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901201716.34842.vgusev@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Vitaliy Gusev wrote:
>
> On 20 January 2009 15:06:42 Oleg Nesterov wrote:
> >
> > BTW. Perhaps it also makes sense to move sched_setscheduler/etc code
> > from create_kthread() to kthread_create(), what do you think?
>
> I don't thinks so. create_kthread() is executed in kthreadd process and
> sched_setscheduler/etc preparation things are reflected to kthreadd's CPU usage.
> In other words it is a kthreadd matter, start and setup a thread.

can't understand...

Perhaps I missed something, but from the correctness pov it doesn't
matter who does sched_setscheduler/etc (except _nocheck() would be
better). However it does matter from the scalability pov, we should
move as much as possible from create_kthread() because we have a
single process with executes the "create" requests.

OK, please forget. This reminds me kthread.c needs a major rework
anyway, hopefully I'll try to do this soon.

Oleg.

