Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbZIDPzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbZIDPzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 11:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZIDPzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 11:55:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbZIDPzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 11:55:46 -0400
Date: Fri, 4 Sep 2009 17:49:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Tom Horsley <tom.horsley@att.net>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/1] exec: do not sleep in TASK_TRACED under
	->cred_guard_mutex
Message-ID: <20090904154947.GA17048@redhat.com>
References: <20090904133956.GA9232@redhat.com> <20090903160514.GA23646@redhat.com> <20090903200924.E46DF47C94@magilla.sf.frob.com> <32710.1252075656@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32710.1252075656@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > -
> > -	/* cred_guard_mutex must be held at least to this point to prevent
> > -	 * ptrace_attach() from altering our determination of the task's
> > -	 * credentials; any time after this it may be unlocked */
> > -
>
> Why are you removing this comment, btw?  In what way does your patch
> invalidate it?

No, the comment is fine. Except, now we have more users of this mutex,
but it only mentions ptrace_attach(). Tried to improve it, but failed
to make the concise and understandable comment,

I tried to collect all comments aboout cred_guard_mutex in one place,
above prepare_bprm_creds()... OK, agreed. Will revert this bit and
resend.

Oleg.

