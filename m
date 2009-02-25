Return-Path: <linux-kernel-owner+w=401wt.eu-S1758960AbZBYVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758960AbZBYVYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbZBYVYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:24:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56816 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbZBYVYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:24:22 -0500
Date: Wed, 25 Feb 2009 22:20:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>,
       David Howells <dhowells@redhat.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] copy_process: fix CLONE_PARENT && ->exit_signal
	interaction
Message-ID: <20090225212039.GA11883@redhat.com>
References: <20090225190211.GA7445@redhat.com> <20090225193927.1ED25FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902251156160.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902251156160.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Linus Torvalds wrote:
>
> > As I think I said before, I don't really know what the actual use case is
> > for CLONE_PARENT without CLONE_THREAD.  So it's easy to approve changing
> > its behavior, but I do vaguely worry about who expected what behavior before.
>
> I think changing it is wrong.

Perhaps. As I said, I don't know what is the expected behaviour. And in fact
I can't think of the "obviously good" behaviour.

> I can easily see somebody using CLONE_PARENT to get the correct getppid
> semantics in the thread, and then setting the signal to zero to not make
> the parent see the thread go away.

->exit_signal == 0 doesn't mean the thread silently goes away, it becomes
a zombie (even if ->parent ignores SIGCHLD). We don't send the signal, but
that is all.

And if ->parent execs, we reset ->exit_signal to SIGCHLD anyway.

> So at the very least it should accept zero for "no signal".

perhaps. I don't know. But I am not sure this is always right.

> And quite
> frankly, it would be good to try to see if there are other alternatives.

Agreed. I thought about checking ->xxx_exec_id's in copy_process(),
but doesn't look very nice...


(can't resist... hopefully now it is clear this should have beeen discussed
 outside of the closed lists from the very beginning ;)

Oleg.

