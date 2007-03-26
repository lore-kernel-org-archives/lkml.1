Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbXCZVzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbXCZVzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXCZVzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:55:43 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38054 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840AbXCZVzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:55:36 -0400
Date: Mon, 26 Mar 2007 16:55:30 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: menage@google.com, akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com,
       dev@sw.ru, xemul@sw.ru, serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070326215530.GB10492@sergelap.austin.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070324050537.GA27040@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070324050537.GA27040@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Srivatsa Vaddagiri (vatsa@in.ibm.com):
> On Mon, Feb 12, 2007 at 12:15:28AM -0800, menage@google.com wrote:
> > +/*
> > + * Rules: you can only create a container if
> > + *     1. you are capable(CAP_SYS_ADMIN)
> > + *     2. the target container is a descendant of your own container
> > + */
> > +static int ns_create(struct container_subsys *ss, struct container *cont)
> > +{
> > +	struct nscont *ns;
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return -EPERM;
> 
> Does this check break existing namespace semantics in a subtle way?
> It now requires that unshare() of namespaces by any task requires
> CAP_SYS_ADMIN capabilities.
> 
> clone(.., CLONE_NEWUTS, ..)->copy_namespaces()->ns_container_clone()->
> 	->container_clone()-> .. -> container_create() -> ns_create()
> 
> Earlier, one could unshare his uts namespace w/o CAP_SYS_ADMIN
> capabilities.

Not so, CAP_SYS_ADMIN is required.  Depending on your tree, check
kernel/utsname.c or kernel/nsproxy.c.

Mind you, whether there is a reason to require CAP_SYS_ADMIN for utsname
I'm not sure.  But if there is any way of finding privileged software
which would behave differently based on utsname information, then we
should.

> Now it is required. Is that fine? Don't know.
> 
> I feel we can avoid this check totally and let the directory permissions
> take care of these checks.
> 
> Serge, what do you think?

There is no way we can think about doing that until we determine that
every kernel will have the ns container subsystem compiled in and
mounted, right?

-serge
