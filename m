Return-Path: <linux-kernel-owner+w=401wt.eu-S1753797AbZDYK5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbZDYK5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 06:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZDYK5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 06:57:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50995 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZDYK5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 06:57:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090424163949.GA12035@redhat.com>
References: <20090424163949.GA12035@redhat.com> <20090423212250.GA22537@redhat.com> <20090423232717.975ABFC3C7@magilla.sf.frob.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Hugh Dickins <hugh@veritas.com>
Subject: Re: ptrace && cred_exec_mutex (Was: [PATCH] ptrace: tracehook_unsafe_exec: remove the stale comment)
Date: Sat, 25 Apr 2009 11:54:13 +0100
Message-ID: <31842.1240656853@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Yes. Except it looks like ->cred_exec_mutex is never used in fact.

I must to be missing something...  I see that:

	int ptrace_attach(struct task_struct *task)
	{
	...
		/* Protect exec's credential calculations against our interference;
		 * SUID, SGID and LSM creds get determined differently under ptrace.
		 */
		retval = mutex_lock_interruptible(&current->cred_exec_mutex);
	...
	}

And:

	int do_execve(...)
	{
	...
		retval = mutex_lock_interruptible(&current->cred_exec_mutex);
		if (retval < 0)
			goto out_free;
	...
	}

So how is it not used?

David
