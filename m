Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbZEGAdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbZEGAdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753795AbZEGAdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:33:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbZEGAdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:33:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ptrace: cleanup check/set of PT_PTRACED during
	attach
In-Reply-To: Oleg Nesterov's message of  Thursday, 7 May 2009 01:30:27 +0200 <20090506233027.GB3756@redhat.com>
References: <20090505224727.GA958@redhat.com>
	<20090506074421.GE17457@elte.hu>
	<20090506233027.GB3756@redhat.com>
X-Shopping-List: (1) Apathetic ashes
   (2) Cenozoic Hydroelectric wigs
   (3) Nylon immunizations
   (4) Angelic helmet compassion
   (5) Complacent absent suicides
Message-Id: <20090507003159.73DE8FC39E@magilla.sf.frob.com>
Date: Wed,  6 May 2009 17:31:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The only case when a task owns (iow, can change it safely) its ->ptrace
> is: it is running _and_ traced. I think this is what the comment tried
> to say.

I think so.  I suspect it only ever referred to now-obsolete uses like
PT_DTRACE fiddling.

> But this doesn't really matter, because afaics the correct comment
> should say: the task should never touch its ->ptrace, ptracer always
> owns it.

To be clear, it should say something about how two potential ptracers
exclude each other touching it.

> There is only one exception afaics, de_thread() or do_wait() can call
> release_task()->ptrace_unlink() and clear ->ptrace on behalve of
> another (not ptracer) task.

And ptrace_traceme().  Both of these I'd call "on behalf of the tracer",
and that is close enough to "tracer owns it" if their rules are explained.
(That in contrast to the old comment's suggestion that the tracee could
touch its own unlocked.)


Thanks,
Roland
