Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbZBEWJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbZBEWJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbZBEWJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:09:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37297 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbZBEWJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:09:41 -0500
Date: Thu, 5 Feb 2009 23:06:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ptrace: reintroduce __ptrace_detach() as a callee
	of ptrace_exit()
Message-ID: <20090205220656.GA7660@redhat.com>
References: <20090129042920.GA5111@redhat.com> <20090205012334.9E60FFC381@magilla.sf.frob.com> <20090205143959.GA20953@redhat.com> <20090205203731.1E02BFC381@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205203731.1E02BFC381@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05, Roland McGrath wrote:
>
> > > Given its content, this function now better belongs in ptrace.c, I think.
> >
> > I don't completely agree... This helper imho has nothing to do with
> > ptracing, except it does __ptrace_unlink(). But OK, I will move it
> > if you prefer.
>
> Obviously where it goes is not a big deal.  But I think it's clear that it
> has everything to do with ptrace and nothing to do with anything else.
> It resolves a situation that can only arise because of ptrace magic.

OK, OK, I will move it.

> > In that case we should export task_detached().
>
> Or just recognize that this trivial wrapper around == -1 has little
> value two lines away from a place where = -1 is done explicitly.
> Really, the "abstraction" is more confusing than not in this function, IMHO.

Well, yes. The only problem it is not easy to grep for this check
without a helper.


(And I still hope we can change the rules sometimes, I think there
 is no good reason to have task_detached() or EXIT_DEAD tasks on
 ->children list. But this is offtopic.)

Oleg.

