Return-Path: <linux-kernel-owner+w=401wt.eu-S1752519AbXJWQCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbXJWQCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbXJWQCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:02:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39891 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbXJWQCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:02:24 -0400
Date: Tue, 23 Oct 2007 09:00:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, Miklos Szeredi <miklos@szeredi.hu>,
       linux-kernel@vger.kernel.org, raven@themaw.net
Subject: Re: futex strangeness in 2.6.23-mm1/UML
Message-Id: <20071023090039.94e1717a.akpm@linux-foundation.org>
In-Reply-To: <20071023095208.06c62f59@bree.surriel.com>
References: <E1Ik15P-0001wg-00@dorka.pomaz.szeredi.hu>
	<20071022145321.195d929b@bree.surriel.com>
	<E1Ik4Ch-000273-00@dorka.pomaz.szeredi.hu>
	<20071022172926.03ca122a@bree.surriel.com>
	<20071022200742.6f3acbb2@bree.surriel.com>
	<20071022171624.0c00f8da.akpm@linux-foundation.org>
	<E1IkEJP-0004Qp-00@dorka.pomaz.szeredi.hu>
	<471DB710.1060603@openvz.org>
	<20071023095208.06c62f59@bree.surriel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 09:52:08 -0400 Rik van Riel <riel@redhat.com> wrote:

> On Tue, 23 Oct 2007 12:55:44 +0400
> Pavel Emelyanov <xemul@openvz.org> wrote:
> 
> > I look at the 2.6.23-mm1 and see that there's one hunk lost. This
> > is the one Oleg re-sent some days ago (the mail thread subject was
> > 2.6.23-mm1 thread exit_group issue). Here it is (sent 13 oct 2007):
> > 
> > --- kernel/fork.c~	2007-10-13 15:41:35.000000000 +0400
> > +++ kernel/fork.c	2007-10-13 15:41:41.000000000 +0400
> > @@ -1443,6 +1443,9 @@ long do_fork(unsigned long clone_flags,
> >  			task_pid_nr_ns(p, current->nsproxy->pid_ns) :
> >  				task_pid_vnr(p);
> >  
> > +		if (clone_flags & CLONE_PARENT_SETTID)
> > +			put_user(nr, parent_tidptr);
> > +
> >  		if (clone_flags & CLONE_VFORK) {
> >  			p->vfork_done = &vfork;
> >  			init_completion(&vfork);
> > 
> > Please, try with this patch.
> 
> The patch above fixes the issue for me.
> 
> Autofs works again as expected.

argh.  Sorry guys, I'd completely forgotten that that bug was present in
-mm1 and I didn't upload the fix into hot-fixes/.  Bad me.
