Return-Path: <linux-kernel-owner+w=401wt.eu-S1761933AbYCXQgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761933AbYCXQgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYCXQgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:36:47 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:35529 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbYCXQgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:36:46 -0400
Date: Mon, 24 Mar 2008 19:40:59 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080324164059.GA4767@tv-sign.ru>
References: <20080323135110.GA294@tv-sign.ru> <20080324160102.GB4069@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324160102.GB4069@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24, Pavel Machek wrote:
> 
> > Ptracing of /sbin/init is not allowed. Of course, this is dangerous, but may
> > be useful. Introduce the kernel boot parameter to allow this, so that we can't
> > surprise some special/secured systems.
> > 
> > Afaics, with the recent changes there is no kernel problems with ptracing init,
> > it can't lose SIGNAL_UNKILLABLE flag and be killed by accident. However, admin
> > should know what it does, "gdb /sbin/init 1" stops init, it can't
> > reap zombies
> 
> It can't be killed, but you can stop it and not ever restart it. From
> that point on, zombies will accumulate until we OOM, right?

Right (only re-parented ones and init's childs but still right),

> > @@ -803,6 +803,8 @@ and is between 256 and 4096 characters. 
> >  			Run specified binary instead of /sbin/init as init
> >  			process.
> >  
> > +	init_ptrace	[KNL] Allows to ptrace init.
> > +
> 
> No words about it being dangerous, but I believe it is.

it is, admin should know what he does,

> If it is not, lets do the patch, but not optional.

This will change the default historical behaviour, I can't predict
does this matter for (say) SELinux or not. Otherwise I'd personally
prefer to always allow to ptrace init.

> If it is dangerous, option does not make it better.

ptrace() is always dangerous. ptracer can crash oracle and lose data.

/sbin/init is important, but there are other important (and sometimes
much more important) services. Why it is so special so that we can't
debug/strace it?

(how many times did you try to figure out why init does _not_ work
 as expected ?)

Oleg.

