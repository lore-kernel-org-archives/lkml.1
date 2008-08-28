Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbYH1Awb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbYH1Awb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYH1AwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:52:22 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34191 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbYH1AwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:52:22 -0400
Date: Wed, 27 Aug 2008 19:52:18 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/3] user namespaces: introduce
	user_struct->user_namespace relationship
Message-ID: <20080828005218.GD16607@us.ibm.com>
References: <20080826185341.GA338@us.ibm.com> <20080827170740.c50cacf7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827170740.c50cacf7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Tue, 26 Aug 2008 13:53:41 -0500
> "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > When a task does clone(CLONE_NEWNS), the task's user is the 'creator' of the
> > new user_namespace, and the user_namespace is tacked onto a list of those
> > created by this user.
> > 
> > Changelog:
> > 	Aug 25: make free_user not inlined as it's not trivial.  (Eric
> > 		Biederman suggestion)
> > 	Aug 1: renamed user->user_namespace to user_ns, as the next
> > 		patch did anyway.
> > 	Aug 1: move put_user_ns call in one free_user() definition
> > 		to move it outside the lock in free_user.  put_user_ns
> > 		calls free_user on the user_ns->creator, which in
> > 		turn would grab the lock again.
> > 
> > Signed-off-by: Serge Hallyn <serue@us.ibm.com>
> > ---
> >  include/linux/sched.h          |    1 +
> >  include/linux/user_namespace.h |    1 +
> >  kernel/user.c                  |   11 +++++++++--
> >  kernel/user_namespace.c        |   20 +++++++++++---------
> 
> The credentials code in linux-next is changing the same code which
> you're changing, in more-than-trivially-textual ways.

Ok, I knew that was coming eventually.  I'll rebase.

> I'd suggest a dhowells cc on these changes, as he's also working
> in this area, and as you touch the keyring code a bit.

Ok.

> And, of course, please remove that almost-always-wrong
> extern-declaration-in-C which checkpatch told you about.  init_groups
> is already declared in include/linux/init_task.h anyway...

Sorry, will do with the rebase.

Thanks, Andrew.

-serge
