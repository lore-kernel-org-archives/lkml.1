Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbYKUPOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbYKUPOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 10:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbYKUPOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 10:14:30 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60116 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbYKUPO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:14:28 -0500
Date: Fri, 21 Nov 2008 09:07:10 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, Subrata Modak <subrata@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       clg@fr.ibm.com, herbert@13thfloor.at, dev@sw.ru
Subject: Re: Current state of CLONE_NEWUSER?
Message-ID: <20081121150710.GA10705@us.ibm.com>
References: <cfd18e0f0811191204r4ccaeaf4m4145e67f408543e0@mail.gmail.com> <m1vdujdvi6.fsf@frodo.ebiederm.org> <cfd18e0f0811200349q788c2767i5164dc1c47e67925@mail.gmail.com> <m1zlju9u9z.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zlju9u9z.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Michael Kerrisk" <mtk.manpages@googlemail.com> writes:
> 
> > Hi Eric,
> >
> > On Wed, Nov 19, 2008 at 8:41 PM, Eric W. Biederman
> > <ebiederm@xmission.com> wrote:
> >> "Michael Kerrisk" <mtk.manpages@googlemail.com> writes:
> >>
> >>> Hi Serge,
> >>>
> >>> What is the current status of CLONE_NEWUSER?  I'm currently trying to
> >>> test this flag in preparation for documenting it in the clone(2) man
> >>> page, but am running into an ENOMEM error from the clone() call, which
> >>> seems to occur after a failure in kobject_init_and_add() in the
> >>> following call sequence:
> >>>
> >>> clone_user_ns() --> alloc_uid() --> uids_user_create() -->
> >>> kobject_init_and_add()
> >>>
> >>> Are there already some test programs somewhere?  Is there any
> >>> documentation already available for this flag?
> >>
> >> This code is definitely still under development.
> >>
> >> When complete it should be able to create a new uid namespace,
> >> as an unprivileged user.  Creating a new process with uid == gid == 0.
> >> Have a full set of caps.  And have permission to do nothing on the system
> >> except read world readable files and write world writable files.
> >
> > Thanks for the info,
> >
> > So the error I described is expected?
> 
> I don't think so.  Serge?

I suspect you have the fair scheduler compiled in
(CONFIG_FAIR_GROUP_SCHED).  So when you create a new user namespace, it
tries to create a new /sys/kernel/uids/0 (or thereabouts) directory
which sysfs refuses.

The fix for this was rolled in as the last patch in the rejected large
network namespace/sysfs rework.  So we'll need another fix.  I suspect
following the same path as we did for making network namespaces work is
the best path for now.  (This being my last day of a week-long vacation
I won't be sending a patch today :)

-serge
