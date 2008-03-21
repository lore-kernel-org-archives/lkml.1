Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYCUBRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYCUBRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 21:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbYCUBQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 21:16:51 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46349 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbYCUBQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 21:16:50 -0400
Date: Fri, 21 Mar 2008 04:15:54 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ptrace: it is fun to strace /sbin/init
Message-ID: <20080321011554.GA121@tv-sign.ru>
References: <20080316155455.GA20848@tv-sign.ru> <20080320162718.GA4397@ucw.cz> <20080320165756.GA11197@tv-sign.ru> <20080320232503.GG17431@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320232503.GG17431@elf.ucw.cz>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Pavel Machek wrote:
>
> On Thu 2008-03-20 19:57:56, Oleg Nesterov wrote:
> > On 03/20, Pavel Machek wrote:
> > > 
> > > > Ptracing of /sbin/init is not allowed. Of course, this is very dangerous, but
> > > > may be useful. Introduce the kernel boot parameter to allow this.
> > > ...
> > > > @@ -803,6 +803,8 @@ and is between 256 and 4096 characters. 
> > > >  			Run specified binary instead of /sbin/init as init
> > > >  			process.
> > > >  
> > > > +	init_ptrace	[KNL] Allows to ptrace init. Very dangerous. Don't use.
> > > > +
> > > 
> > > I don't know what ptracing init is good for, and I believe people
> > > wanting to do this kind of special stuff can patch their own kernel...
> > 
> > Yes sure. But could you explain why this can be bad given that ptracing
> > init needs the explicit boot parameter? IOW, could you explain why you
> > don't like this small and trivial change which adds a minimal impact?
> 
> "It can't be bad, its optional".
> 
> It is bad exactly _because_ it is optional. Anything that adds boot
> parameter is *not* trivial... 

You are right. I'd prefer to make /sbin/init ptraceable unconditionally,
the root should know what it does. But this will change the historical
behaviour.

> Why not add
> 
> please_randomly_corrupt_memory boot parameter? It may be useful for
> something...
> 								Pavel

Nice argument.

Oleg.

