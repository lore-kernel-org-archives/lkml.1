Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYFLAiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYFLAiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbYFLAiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:38:06 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49423 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbYFLAiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:38:04 -0400
Date: Wed, 11 Jun 2008 19:37:42 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Dan Smith <danms@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] cgroup_clone: use pid of newly created task for
	new cgroup
Message-ID: <20080612003742.GA14545@us.ibm.com>
References: <20080610212302.GA1946@us.ibm.com> <6599ad830806110024i495c5e65u82828b7237434052@mail.gmail.com> <20080611154606.GA23134@us.ibm.com> <6599ad830806110859j46d51444t27f60a75e9981968@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830806110859j46d51444t27f60a75e9981968@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On Wed, Jun 11, 2008 at 8:46 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >
> > From f0635c20e9e9643fa9a90dd7e29b7855ff32ad40 Mon Sep 17 00:00:00 2001
> > From: Serge Hallyn <serge@us.ibm.com>
> > Date: Wed, 11 Jun 2008 10:41:37 -0500
> > Subject: [PATCH 1/1] cgroup_clone: use pid of newly created task for new cgroup
> >
> > cgroup_clone creates a new cgroup with the pid of the task.  This works
> > correctly for unshare, but for clone cgroup_clone is called from
> > copy_namespaces inside copy_process, which happens before the new pid
> > is created.  As a result, the new cgroup was created with current's pid.
> > This patch:
> >
> >        1. Moves the call inside copy_process to after the new pid
> >           is created
> >        2. Passes the struct pid into ns_cgroup_clone (as it is not
> >           yet attached to the task)
> >        3. Passes a name from ns_cgroup_clone() into cgroup_clone()
> >           so as to keep cgroup_clone() itself simpler
> >        4. Uses pid_vnr() to get the process id value, so that the
> >           pid used to name the new cgroup is always the pid as it
> >           would be known to the task which did the cloning or
> >           unsharing.  I think that is the most intuitive thing to
> >           do.  This way, task t1 does clone(CLONE_NEWPID) to get
> >           t2, which does clone(CLONE_NEWPID) to get t3, then the
> >           cgroup for t3 will be named for the pid by which t2 knows
> >           t3.
> >
> > (Thanks to Dan Smith for finding the main bug)

Seems this bug was also reported on May 21 by Daniel Lezcano.  I'm going
to have to blame an over-active left middle finger for hitting the d key
without reading it...

-serge
