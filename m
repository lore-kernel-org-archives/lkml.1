Return-Path: <linux-kernel-owner+w=401wt.eu-S933338AbZIDOtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbZIDOtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbZIDOtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:49:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136AbZIDOti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:49:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090904133956.GA9232@redhat.com>
References: <20090904133956.GA9232@redhat.com> <20090903160514.GA23646@redhat.com> <20090903200924.E46DF47C94@magilla.sf.frob.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Tom Horsley <tom.horsley@att.net>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/1] exec: do not sleep in TASK_TRACED under ->cred_guard_mutex
Date: Fri, 04 Sep 2009 15:47:36 +0100
Message-ID: <32710.1252075656@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> 	- install_exec_creds() drops the mutex after commit_creds(),
> 	  and thus before tracehook_report_exec()->ptrace_stop().

Thanks!

> -
> -	/* cred_guard_mutex must be held at least to this point to prevent
> -	 * ptrace_attach() from altering our determination of the task's
> -	 * credentials; any time after this it may be unlocked */
> -

Why are you removing this comment, btw?  In what way does your patch
invalidate it?

David
