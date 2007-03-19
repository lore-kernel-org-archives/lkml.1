Return-Path: <linux-kernel-owner+w=401wt.eu-S1030586AbXCSV4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030586AbXCSV4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030628AbXCSV4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:56:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56580 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030587AbXCSV4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:56:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Ian Kent <raven@themaw.net>, Cedric Le Goater <clg@fr.ibm.com>,
       sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>,
       Dave Hansen <haveblue@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
References: <20070313045100.GC8993@us.ibm.com>
	<Pine.LNX.4.64.0703161300520.4188@raven.themaw.net>
	<m1ird1o243.fsf@ebiederm.dsl.xmission.com>
	<1174055467.3397.17.camel@raven.themaw.net>
	<45FAAD4F.4000204@fr.ibm.com>
	<1174063618.3397.58.camel@raven.themaw.net>
	<m1hcslm1tc.fsf@ebiederm.dsl.xmission.com>
	<20070319200839.GB19449@sergelap.austin.ibm.com>
	<m1odmpvuft.fsf@ebiederm.dsl.xmission.com>
	<20070319211959.GA23538@sergelap.austin.ibm.com>
Date: Mon, 19 Mar 2007 15:43:27 -0600
In-Reply-To: <20070319211959.GA23538@sergelap.austin.ibm.com> (Serge
	E. Hallyn's message of "Mon, 19 Mar 2007 16:19:59 -0500")
Message-ID: <m1fy80x62o.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> True, current->pid can probably always be legitimately taken as the pid
> number in the current task's cloning namespace.  But task->pid is
> wrong.

Agreed.

> So if as you say it's worth caching (not saying I doubt you, just that I
> haven't verified), then ideally we could cache current->pid but only
> access it using current_pid().  Does that seem worth doing?

Doing current_pid() and friends certainly seem to be worth doing.
Mostly for the secondary effect that we can then breaking any code we
miss in our conversion.  I don't know if the caching is worth it but
it is so easy to implement I don't see a reason to avoid it.

> In any case, certainly adding a task_pid_nr() helper which for starters
> returns pid_nr(task_pid(task)) seems reasonable.  Note that Suka's about
> ready to send a new iteration of the pidns patchset, so I'd like this to
> be considered something to clean up on top of that patchset.

I will keep it in mind.  As long a we keep patches that actually change the
code separate from patches that change the set of helper functions I think
we will be ok.  Hopefully Suka has learned enough by now that reviewing
his patches will be easier than just writing them myself.  There were
so many silly little issues to clean up in the last round of review
by the time the patch was clean enough to look at the meat I missed the
deep issues :(  At least things were clear enough that Oleg managed to
catch some of the deeper issues.

Eric
