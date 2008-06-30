Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbYF3UBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbYF3UBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYF3UBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:01:14 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37394 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbYF3UBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:01:12 -0400
Date: Mon, 30 Jun 2008 14:49:09 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] security: filesystem capabilities bugfix2
Message-ID: <20080630194909.GE30669@us.ibm.com>
References: <20080630185318.GB30669@us.ibm.com> <20080627205905.GB17415@us.ibm.com> <486357EC.5060205@kernel.org> <7852.1214837604@redhat.com> <14854.1214853041@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14854.1214853041@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > > With Andrew's patch, capabilities are downgraded regardless of whether we
> > > have CAP_SETPCAP or not.  I guess that means that if you're tracing a
> > > binary whose filecaps say that it wants CAP_SETPCAP, then it retains
> > > CAP_SETPCAP.
> > 
> > I don't understand where that last sentence comes from.  Why would it
> > retain CAP_SETPCAP?
> 
> It seems I missed a bit out.  It should've read:
> 
> 	I guess that means that if you're tracing a binary that has
> 	CAP_SETPCAP already, and whose filecaps say that it wants CAP_SETPCAP,
> 	then it retains CAP_SETPCAP.
> 
> If the debugger has CAP_SYS_PTRACE, then it can attach to a binary that has
> CAP_SETPCAP according to cap_ptrace(), even if the debugger doesn't.

Ah.  Yes.  I think that's the desirable behavior in all proposals.

> > > I wonder if the tracing task should be examined here, and any capability the
> > > tracer isn't permitted should be denied the process doing the exec.
> > 
> > That sounds reasonable on its own, but it opens up a dangerous ability
> > for the partially-privileged tracer to manipulate the capability set for
> > the traced task.
> 
> Does it, though?  It would only reduce the capabilities of the inferior
> process; it wouldn't allow the inferior process or the debugger to get
> additional capabilities, apart from what's available under CAP_SETPCAP.

And the uids won't change unless capable(CAP_SETUID)...  so I think
you're right, it does sound safe.

thanks,
-serge
