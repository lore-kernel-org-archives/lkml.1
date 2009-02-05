Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbZBECQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbZBECQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756443AbZBECQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:16:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbZBECQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:16:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] reparent_thread: fix the "is it traced" check
In-Reply-To: Oleg Nesterov's message of  Thursday, 29 January 2009 09:05:58 +0100 <20090129080558.GA26871@redhat.com>
References: <20090129080558.GA26871@redhat.com>
X-Zippy-Says: I can't decide which WRONG TURN to make first!!  I wonder if BOB
    GUCCIONE has these problems!
Message-Id: <20090205021618.8738FFC381@magilla.sf.frob.com>
Date: Wed,  4 Feb 2009 18:16:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> reparent_thread() uses ptrace_reparented() to check whether this thread
> is ptraced, in that case we should not notify the new parent.

I think at some point in the past, ptracedness could sometimes transfer to
the new parent, so this made sense then (before it had that name).

> But ptrace_reparented() is not exactly correct when the reparented thread
> is traced by /sbin/init, because forget_original_parent() has already
> changed ->real_parent.

Heh.  Ok.  I think the !p->ptrace check is fine.

Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland
