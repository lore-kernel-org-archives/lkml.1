Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYCNOfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYCNOfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYCNOfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:35:37 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40615 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbYCNOfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:35:36 -0400
Date: Fri, 14 Mar 2008 09:35:34 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org, Greg KH <greg@kroah.com>,
       Stephen Smalley <sds@epoch.ncsc.mil>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC] cgroups: implement device whitelist lsm (v2)
Message-ID: <20080314143534.GD9741@sergelap.austin.ibm.com>
References: <20080313032749.GA13258@sergelap.austin.ibm.com> <6599ad830803140216k1a04ce4ej4779bf10ec6ef4f9@mail.gmail.com> <20080314140523.GG8744@sergelap.austin.ibm.com> <6599ad830803140715i5532f02ag6a93f028ab88d57f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830803140715i5532f02ag6a93f028ab88d57f@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On Fri, Mar 14, 2008 at 7:05 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >  > >  A task may only be moved to another devcgroup if it is moving to
> >  > >  a direct descendent of its current devcgroup.
> >  >
> >  > What's the rationale for that?
> >
> >  To prevent it escaping to laxer device permissions, which of course only
> >  makes sense if we do what you recommend above :)
> >
> 
> That makes it impossible for a root process to enter a child cgroup,
> do something, and then go back to its own cgroup.

Yes, but it can fire off a child in the child cgroup to do something,
and go on on its own cgroup when the child finishes.

> Why aren't the
> existing cgroup security semantics sufficient?

Because the point of this is to provide some restrictions to otherwise
privileged users, and cgroups only provides dac-based permissions.

But that doesn't mean that I'm not doing too much.  I could just add a
CAP_SYS_ADMIN or CAP_CONT_OVERRIDE+CAP_SYS_ADMIN check, and not restrict
which cgroups a task can move to.  Does that sound good?

-serge
