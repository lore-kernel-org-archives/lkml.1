Return-Path: <linux-kernel-owner+w=401wt.eu-S1751410AbXAXTG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbXAXTG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 14:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbXAXTG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 14:06:57 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50346 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbXAXTG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 14:06:56 -0500
Date: Wed, 24 Jan 2007 13:06:33 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 4/8] user ns: hook permission
Message-ID: <20070124190633.GB597@sergelap.austin.ibm.com>
References: <20061219225902.GA25904@sergelap.austin.ibm.com> <20061219230051.GE25904@sergelap.austin.ibm.com> <m14pqg2w3o.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14pqg2w3o.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Subject: [PATCH 4/8] user ns: hook permission
> >
> > Hook permission to check vfsmnt->user_ns against current.
> 
> This looks wrong on several levels.
> - This should ultimately be inside generic_permission instead of
>   permission as there are some distributed filesystems that know how to cope with
>   multiple mount namespaces simultaneous.
> 
> - As implemented the test is not what I would expect.  I would
>   expect comparisons of uid X == uid Y and gid X == gid Y to
>   be replaced by comparing the tuples of uid namesspace and uid.
>   Which would allow access to world readable/writeable files,
>   and it would allow users with CAP_DAC_OVERRIDE to be able to access
>   everything.

Whoa - why on earth would we want that?

> All we are really saying as I understand a user namespace is that 
> instead of uid's uniquely identifying a user the pair the pair uidns,
> uid is uniquely identifies a user.

Ok that would be one way to interpret it, but it is insufficient for
preventing root in one vserver from messing with users in another
vserver.

> Because you didn't pick what I would consider the obvious choice
> you now need an extra mount flag to disable the uid namespace all
> together, so you can transition through the intermediate uid namespace
> state.  That really feels wrong.

Some bit of required bootstrapping seems both acceptable and expected
to me.

> All mounts should have an associated uid namespace and the only

check

> way you should be able to ignore that is to access filesystems
> that can cope with multiple uid namespaces simultaneously.

But it's my fs on my box, why shouldn't i be able to say all uid
namespaces can acces this subtree read-only, just bc you feel the
fs is inadequate?  :)

Note that the tiniest of trees, with just a statically compiled bash,
mount, pivot_mount, and initrc, should suffice, mounted readonly for
all uid namespaces to use to bootstrap.

-serge
