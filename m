Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZFHSkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZFHSkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbZFHSks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:40:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48816 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZFHSks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:40:48 -0400
Date: Mon, 8 Jun 2009 20:36:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: PTRACE_ATTACH && -EINTR
Message-ID: <20090608183627.GA14734@redhat.com>
References: <20090608161204.GA3986@redhat.com> <20090608173944.B57EBFC3C6@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608173944.B57EBFC3C6@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08, Roland McGrath wrote:
>
> > Or even -ERESTARTNOINTR ? Or just mutex_lock() ?
>
> -ERESTARTNOINTR is right.
>
> There is nothing wrong with making it interruptible, and that might help
> something or other overall, or even be important to avoid a deadlock or
> something in some strange situation.

Agreed.

> But since the call could never return
> -EINTR before, we can't make it start now.

Yes. -EINTR just wrong.

> > Or ignore this problem since nobody complained?
>
> There has barely been time for anyone to do something strange enough to hit
> it, and they would probably not have realized what was going on even if it
> did hit.  We know we broke the ABI contract, we have to fix it.
>
> Note that every use of mutex_lock_interruptible and also down_interruptible
> can return -EINTR.  This means these really should never be used in the way
> where their return value is returned directly from some system call.  Every
> user-visible call that gets interrupted needs to return some -ERESTART*
> code and never -EINTR directly.

Sure. And we have other users of mutex_lock_interruptible() which deserve
a fix.

As for ->cred_exec_mutex, I think do_execve() needs a fix as well.

It was renamed in -next. Should I send these fixes now for 2.6.20, or we can
wait for 2.6.31 ?

Oleg.

