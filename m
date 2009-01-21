Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbZAUNrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbZAUNrT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 08:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZAUNrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 08:47:09 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53036 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbZAUNrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 08:47:08 -0500
Date: Wed, 21 Jan 2009 14:44:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coda: alloc_upcall: s/task_pgrp_nr/task_pgrp_vnr/
Message-ID: <20090121134431.GA15457@redhat.com>
References: <20090118073453.GA714@redhat.com> <20090121050311.GD15771@cs.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121050311.GD15771@cs.cmu.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21, Jan Harkes wrote:
>
> On Sun, Jan 18, 2009 at 08:34:53AM +0100, Oleg Nesterov wrote:
> > Needs an ack from maintaner, I do not know where coda_in_hdr->pgid is used.
>
> It is used to uniquely identify a process and any of it children during
> conflict resolution.
>
> When a conflict is detected, all accesses to the inconsistent object are
> blocked. A special resolver process is forked off by the cache manager
> and this is run in a new process group and only accesses from processes
> in this group are allowed. The resolver process (or any of it's children)
> compare the conflicting replicas, and ideally resolve the inconsistency
> after which normal accesses are unblocked.
>
> So yes this should not a per namespace thing, but also not a process
> specific pid, the resolver forks off different helper processes
> depending on the type of files that are involved in the conflict, i.e.
> mbox files require different merge strategy compared to opendocument
> files.

OK, thanks, please ignore this patch then.

> I'm not sure what you are trying to do.

Please look at http://marc.info/?l=linux-kernel&m=123240297918186

And I'd like to kill task_pgrp_nr(). Can't alloc_upcall() use
task_pgrp_nr_ns(current, &init_pid_ns) instead? This is equivalent.


But if this pid_t is used in the user-space to identify the process,
then I think Eric is right.

Oleg.

