Return-Path: <linux-kernel-owner+w=401wt.eu-S1030316AbXBTRR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316AbXBTRR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 12:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030318AbXBTRR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 12:17:56 -0500
Received: from mail.screens.ru ([213.234.233.54]:53402 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030316AbXBTRRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 12:17:55 -0500
Date: Tue, 20 Feb 2007 20:20:49 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       roland@redhat.com, Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: [PATCH] fix handling of SIGCHILD from reaped child
Message-ID: <20070220172049.GA67@tv-sign.ru>
References: <20070220183220.41b3f1ca.kamezawa.hiroyu@jp.fujitsu.com> <20070220142257.GA155@tv-sign.ru> <20070221002526.c6b7edb0.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070221002526.c6b7edb0.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21, KAMEZAWA Hiroyuki wrote:
>
> On Tue, 20 Feb 2007 17:22:57 +0300
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> >
> > I'd suggest to make a separate function, but not complicate collect_signal().
> >
> okay. I'll try again if people admit me to go ahead.

Yes, it would be nice to know what maintainers think. This is a user visible
change, even if good.

> > > +		clear_stale_sigchild(current, retval);
> > 
> > But we are not checking that SIGCHLD is blocked?
> > 
> I'm sorry if I don't read SUSv3 correctly. SUSv3 doesn't define how we should
> do if SIGCHLD is not blocked.(so I don't check not-blocked case.)

Probably it is me who misunderstands SUSv3. Could you point me the reference
to authoritative document? My understanding: if blocked AND wait() succeeds.

> IMHO, user's sig-child-handler is tend to call wait()/waitpid() and expects
> successful return. So removing stale signal here may be good.

Yes. But sig-child-handler should do

	while (wait() >= 0)
		....

anyway, because SIGCHLD is not a realtime signal.

> If this breaks assumptions of applications on Linux, I'll not go eagerly.

I just don't know... (Michael Kerrisk cc'ed).

Oleg.

