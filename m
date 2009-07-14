Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZGNXIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZGNXIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 19:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbZGNXIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 19:08:47 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44932 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbZGNXIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 19:08:46 -0400
Date: Tue, 14 Jul 2009 16:08:41 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, Matt Helsley <matthltc@us.ibm.com>,
       balbir@linux.vnet.ibm.com, lizf@cn.fujitzu.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] CGroups: cgroup member list enhancement/fix
Message-ID: <20090714230841.GG5213@count0.beaverton.ibm.com>
References: <20090705063850.GX11273@balbir.in.ibm.com> <6599ad830907101658i13e4046br70377a487dd6b49b@mail.gmail.com> <20090713121138.GC5051@balbir.in.ibm.com> <6599ad830907130926v7788af12hdcd76e4ccb3ab6de@mail.gmail.com> <20090714055638.GI5051@balbir.in.ibm.com> <6599ad830907132349u6cf52060t4fafb6637cbe4ed1@mail.gmail.com> <20090714071617.GK5051@balbir.in.ibm.com> <2f86c2480907141034r5a985cfue9e8fdf64ad28465@mail.gmail.com> <6599ad830907141043s1c16d5c9saad9118c210ecef4@mail.gmail.com> <6599ad830907141338t794e60admf81807b381c46e41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830907141338t794e60admf81807b381c46e41@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 01:38:30PM -0700, Paul Menage wrote:
> On Tue, Jul 14, 2009 at 10:43 AM, Paul Menage<menage@google.com> wrote:
> >
> > I've been trying to think of a way to do that. AFAICS the only way to
> > do that reliably would be to move the call to cgroup_fork() that hooks
> > into the parent's cgroup inside the lock on the group leader's thread
> > list, and move the fork callbacks into cgroup_fork(). (Which would
> > mean that they'd not be able to sleep/fail, etc).
> 
> Currently the only user of the cgroup fork callbacks is the freezer cgroup.
> 
> Matt, if this callback was moved inside tasklist_lock, would that
> present any problems? Given that in other places you call
> freeze_task() from inside other low-level locks like css_set_lock
> (within a cgroup iteration) then hopefully it would be OK.

Yes, it should be OK.

> 
> The only question then would be whether anything between the point
> where cgroup_fork() is currently called, and the point where the new
> thread is added to its thread group list, cares about p->cgroups being
> valid. We can probably flush out any such assumptions by clearing
> tsk->cgroups in dup_task_struct, so that any attempts to reference it
> would immediately oops.

This is harder to verify the correctness of. You're probably right but
I'm not completely convinced yet.

Cheers,
	-Matt
