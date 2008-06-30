Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbYF3TMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbYF3TMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbYF3TMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:12:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753870AbYF3TMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:12:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080630185318.GB30669@us.ibm.com>
References: <20080630185318.GB30669@us.ibm.com> <20080627205905.GB17415@us.ibm.com> <486357EC.5060205@kernel.org> <7852.1214837604@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, "Andrew G. Morgan" <morgan@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] security: filesystem capabilities bugfix2
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Mon, 30 Jun 2008 20:10:41 +0100
Message-ID: <14854.1214853041@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> > With Andrew's patch, capabilities are downgraded regardless of whether we
> > have CAP_SETPCAP or not.  I guess that means that if you're tracing a
> > binary whose filecaps say that it wants CAP_SETPCAP, then it retains
> > CAP_SETPCAP.
> 
> I don't understand where that last sentence comes from.  Why would it
> retain CAP_SETPCAP?

It seems I missed a bit out.  It should've read:

	I guess that means that if you're tracing a binary that has
	CAP_SETPCAP already, and whose filecaps say that it wants CAP_SETPCAP,
	then it retains CAP_SETPCAP.

If the debugger has CAP_SYS_PTRACE, then it can attach to a binary that has
CAP_SETPCAP according to cap_ptrace(), even if the debugger doesn't.

> > I wonder if the tracing task should be examined here, and any capability the
> > tracer isn't permitted should be denied the process doing the exec.
> 
> That sounds reasonable on its own, but it opens up a dangerous ability
> for the partially-privileged tracer to manipulate the capability set for
> the traced task.

Does it, though?  It would only reduce the capabilities of the inferior
process; it wouldn't allow the inferior process or the debugger to get
additional capabilities, apart from what's available under CAP_SETPCAP.

David
