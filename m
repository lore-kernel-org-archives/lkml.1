Return-Path: <linux-kernel-owner+w=401wt.eu-S965449AbXDBOJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965449AbXDBOJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 10:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965472AbXDBOJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 10:09:45 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47869 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965449AbXDBOJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 10:09:44 -0400
Date: Mon, 2 Apr 2007 09:09:39 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: menage@google.com, akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com,
       dev@sw.ru, xemul@sw.ru, serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070402140938.GF17710@sergelap.austin.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com> <20070212085105.170265000@menage.corp.google.com> <20070331024722.GA808@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070331024722.GA808@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Srivatsa Vaddagiri (vatsa@in.ibm.com):
> On Mon, Feb 12, 2007 at 12:15:28AM -0800, menage@google.com wrote:
> > +int ns_container_clone(struct task_struct *tsk)
> > +{
> > +	return container_clone(tsk, &ns_subsys);
> > +}
> 
> This function is a no-op if ns hierarchy is not mounted at this point.
> This would mean that we will miss out on some directories in ns
> hierarchy if it happened to be mounted later. It would be nice to
> recreate such missing directories upon mount. However I suspect it would
> not be easy ..Maybe we need to scan the task list and (re-)invoke
> ns_container_clone() for every new tsk->nsproxy we find in the list.
> Alternately perhaps we could auto mount (kern_mount) ns hierarchy very early at
> bootup? On the flip side that would require remount support so that additional
> controllers (like cpuset, mem) can be bound to (non-empty) ns hierarchy after
> bootup.

Losing the directory isn't a big deal though.  And both unsharing a
namespace (which causes a ns_container_clone) and mounting the hierarchy
are done by userspace, so if for some installation it is a big deal,
the init scripts on initrd can mount the hierarchy before doing any
unsharing.

Can you think of a reason why losing a few directories matters?

-serge
