Return-Path: <linux-kernel-owner+w=401wt.eu-S1758512AbZD1Xhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758512AbZD1Xhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 19:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbZD1Xhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 19:37:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52602 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757088AbZD1Xhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 19:37:33 -0400
Date: Wed, 29 Apr 2009 01:33:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Message-ID: <20090428233305.GA14221@redhat.com>
References: <20090428223025.GA11997@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428223025.GA11997@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am totally confused and almost sleeping, so another question ;)

What if eligible_child()->security_task_wait() returns the error?

wait_consider_task:

	if (unlikely(ret < 0)) {
		/*
		 * If we have not yet seen any eligible child,
		 * then let this error code replace -ECHILD.
		 * A permission error will give the user a clue
		 * to look for security policy problems, rather
		 * than for mysterious wait bugs.
		 */
		if (*notask_error)
			*notask_error = ret;
	}

But shouldn't we return 0 in this case ?

The current code proceeds and either reaps the child or clears notask_error.

Oleg.

