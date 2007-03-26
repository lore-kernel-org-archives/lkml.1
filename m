Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbXCZV6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbXCZV6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXCZV6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:58:07 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51360 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbXCZV6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:58:05 -0400
Date: Mon, 26 Mar 2007 16:57:55 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: menage@google.com, containers@lists.osdl.org, pj@sgi.com,
       ebiederm@xmission.com, sekharan@us.ibm.com,
       ckrm-tech@lists.sourceforge.net, rohitseth@google.com,
       winget@google.com, linux-kernel@vger.kernel.org, xemul@sw.ru
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070326215755.GC10492@sergelap.austin.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070324050537.GA27040@in.ibm.com> <20070324162326.GC11794@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070324162326.GC11794@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Srivatsa Vaddagiri (vatsa@in.ibm.com):
> On Sat, Mar 24, 2007 at 10:35:37AM +0530, Srivatsa Vaddagiri wrote:
> > > +static int ns_create(struct container_subsys *ss, struct container *cont)
> > > +{
> > > +	struct nscont *ns;
> > > +
> > > +	if (!capable(CAP_SYS_ADMIN))
> > > +		return -EPERM;
> > 
> > Does this check break existing namespace semantics in a subtle way?
> > It now requires that unshare() of namespaces by any task requires
> > CAP_SYS_ADMIN capabilities.
> 
> I should clarify that I am referring to unshare thr' clone here (and not
> thr' sys_unshare)

That is still not true, see kernel/utsname:copy_utsname().

Now you might have run a userspace testcase in a kernel with
CONFIG_UTS_NS=n, which at the moment erroneously returns 0 rather than
-EINVAL when you clone(CLONE_NEWUTS).  But you didn't get a new uts
namespace, you were just lied to  :)

-serge
