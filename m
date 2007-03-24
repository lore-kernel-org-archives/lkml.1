Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbXCXQQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbXCXQQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 12:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXCXQQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 12:16:18 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38118 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbXCXQQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 12:16:17 -0400
Date: Sat, 24 Mar 2007 21:53:26 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       linux-kernel@vger.kernel.org, rohitseth@google.com, pj@sgi.com,
       ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070324162326.GC11794@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070324050537.GA27040@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070324050537.GA27040@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2007 at 10:35:37AM +0530, Srivatsa Vaddagiri wrote:
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

I should clarify that I am referring to unshare thr' clone here (and not
thr' sys_unshare)

> clone(.., CLONE_NEWUTS, ..)->copy_namespaces()->ns_container_clone()->
> 	->container_clone()-> .. -> container_create() -> ns_create()
> 
> Earlier, one could unshare his uts namespace w/o CAP_SYS_ADMIN
> capabilities. Now it is required. Is that fine? Don't know.
> 
> I feel we can avoid this check totally and let the directory permissions
> take care of these checks.
> 
> Serge, what do you think?

-- 
Regards,
vatsa
