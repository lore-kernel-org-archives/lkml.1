Return-Path: <linux-kernel-owner+w=401wt.eu-S1765266AbYESWob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765266AbYESWob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764885AbYESWoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:44:16 -0400
Received: from sous-sol.org ([216.99.217.87]:51048 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764879AbYESWoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:44:13 -0400
Date: Mon, 19 May 2008 15:42:04 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: James Morris <jmorris@namei.org>,
       lsm <linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] security:  split proc ptrace checking into read vs.
	attach
Message-ID: <20080519224204.GL30402@sequoia.sous-sol.org>
References: <1211200369.7486.38.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211200369.7486.38.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Smalley (sds@tycho.nsa.gov) wrote:
> Enable security modules to distinguish reading of process state via
> proc from full ptrace access by renaming ptrace_may_attach to
> ptrace_may_access and adding a mode argument indicating whether only
> read access or full attach access is requested.  This allows security
> modules to permit access to reading process state without granting
> full ptrace access.  The base DAC/capability checking remains unchanged.
> 
> Read access to /proc/pid/mem continues to apply a full ptrace attach
> check since check_mem_permission() already requires the current task
> to already be ptracing the target.  The other ptrace checks within
> proc for elements like environ, maps, and fds are changed to pass the
> read mode instead of attach.
> 
> In the SELinux case, we model such reading of process state as a
> reading of a proc file labeled with the target process' label.  This
> enables SELinux policy to permit such reading of process state without
> permitting control or manipulation of the target process, as there are
> a number of cases where programs probe for such information via proc
> but do not need to be able to control the target (e.g. procps,
> lsof, PolicyKit, ConsoleKit).  At present we have to choose between
> allowing full ptrace in policy (more permissive than required/desired)
> or breaking functionality (or in some cases just silencing the denials
> via dontaudit rules but this can hide genuine attacks).
> 
> This version of the patch incorporates comments from Casey Schaufler
> (change/replace existing ptrace_may_attach interface, pass access
> mode), and Chris Wright (provide greater consistency in the checking).
> 
> Note that like their predecessors __ptrace_may_attach and
> ptrace_may_attach, the __ptrace_may_access and ptrace_may_access
> interfaces use different return value conventions from each other (0
> or -errno vs. 1 or 0).  I retained this difference to avoid any
> changes to the caller logic but made the difference clearer by
> changing the latter interface to return a bool rather than an int and
> by adding a comment about it to ptrace.h for any future callers.
> 
> Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>

Acked-by: Chris Wright <chrisw@sous-sol.org>
