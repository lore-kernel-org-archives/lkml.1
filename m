Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYLEQqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYLEQqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 11:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYLEQqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 11:46:14 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:60035 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYLEQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 11:46:13 -0500
Date: Fri, 5 Dec 2008 10:45:52 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH 2/2] user namespaces: require cap_set{ug}id for
	CLONE_NEWUSER
Message-ID: <20081205164552.GA16788@us.ibm.com>
References: <20081203191706.GA16433@us.ibm.com> <20081203191733.GA16652@us.ibm.com> <m1ej0mr3o9.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ej0mr3o9.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> > While ideally CLONE_NEWUSER will eventually require no
> > privilege, the required permission checks are currently
> > not there.  As a result, CLONE_NEWUSER has the same effect
> > as a setuid(0)+setgroups(1,"0").  While we already require
> > CAP_SYS_ADMIN, requiring CAP_SETUID and CAP_SETGID seems
> > appropriate.
> 
> This looks reasonable.  For the short term we will need a greater
> set of caps to be able to do all of the interesting things.

Could you ack the patch?  Stephen explicitly doesn't want patches
in linux-next which haven't been acked, and security-next feeds
into linux-next, so I don't want to ask James to take the patch
without an ack :)

> Personally the user namespace only becomes interesting when we
> start to be able to move in the other direction and remove the
> set of capabilities requires to create it.
> 
> Eric

Agreed.  Now the thing is I don't think we need full userns
support to get there.  We just need the targeted capabilities
and the basic dummy fs support - that is, init_user_ns owns
all vfsmounts, and anyone not in init_user_ns only gets
user other access to files under those mounts.

Of course complete support for targeted caps will in itself
be a huge effort :)

So my roadmap is: next address the per-user keyring, then
the targeted caps.

-serge
