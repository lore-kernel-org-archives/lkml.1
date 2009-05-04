Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZEDTmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZEDTmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbZEDTlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:41:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39686 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849AbZEDTlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:41:51 -0400
Date: Mon, 4 May 2009 21:36:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Dike <jdike@addtoit.com>,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace: do not use task_lock() for attach
Message-ID: <20090504193624.GB17076@redhat.com>
References: <20090503185549.GA17087@redhat.com> <20090504190935.A0FD4FC32F@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090504190935.A0FD4FC32F@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04, Roland McGrath wrote:
>
> This looks good to me overall.  It might be worth slicing it into two or
> more patches, just for bisect paranoia.  (e.g. PF_KTHREAD; task_lock in
> ptrace_attach; task_lock in ptrace_traceme.)

OK,

> I think it merits a comment that the PF_KTHREAD check does not need any
> interlock because daemonize() will detach ptrace via reparent_to_kthreadd()
> after it sets PF_KTHREAD.  (vs the old ->mm check under task_lock.)

Agreed, but actually the patch doesn't make the difference wrt daemonize().
currently ptrace_attach() can take task_lock() just before daemonize() calls
exit_mm().

> It is worth noting that this changes the security_ptrace_traceme() call so
> it's no longer under task_lock().  I can't see any way the LSM hooks care,
> but it is a change.

Yes, good point.

> You also didn't mention the s/|=/=/ changes.  Those are correct, we've
> already agreed, but the commit log should mention that this subtle change
> was intentional.

Yes! Forgot to mention, thanks.

Oleg.

