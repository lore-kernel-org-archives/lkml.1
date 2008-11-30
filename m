Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbYK3MqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbYK3MqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 07:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYK3Mp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 07:45:59 -0500
Received: from ik-out-1112.google.com ([66.249.90.183]:16988 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYK3Mp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 07:45:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LuOUF9Y1arAPMYfQl9Jjs2JWw6rD2sqzr0vSBKCdQLsPOVeHROP2+8CJJadwJ9Ra+d
         Wr8RugIm+bhYPQGR/6i/6TzcPIH24GJoa7nd0OlxkJUkjA+bXc5tt34EpNjv9Ou9lWMZ
         2WCqg8p3Yq+SKHIBcGdFjMn/9TBM2N0NceGsg=
Date: Sun, 30 Nov 2008 15:50:01 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/branch-tracer: include missing irqflags.h
Message-ID: <20081130125001.GA4239@x200.localdomain>
References: <4930B32E.6060403@gmail.com> <20081129091647.GA25109@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129091647.GA25109@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2008 at 10:16:47AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Impact: fix build error on branch tracer
> > 
> > This should fix a build error reported on alpha in linux-next:
> > 
> >  CC      kernel/trace/trace_branch.o
> > kernel/trace/trace_branch.c: In function 'probe_likely_condition':
> > kernel/trace/trace_branch.c:44: error: implicit declaration of function 'raw_local_irq_save'
> > kernel/trace/trace_branch.c:76: error: implicit declaration of function 'raw_local_irq_restore'
> 
> applied to tip/tracing
> 
> > Unfortunately, I can't test it since I don't have any Alpha build 
> > environment.
> 
> it does not trigger with an Alpha defconfig - we do test that.
> 
> And the thing is, lockdep (which introduced irqflags tracing) has been 
> introduced upstream two years ago - and Alpha still does not have it 
> implemented. The architecture should be marked CONFIG_BROKEN if it 
> continues to cause problems like this.

Or people can, horror, cross-compile stuff in relevant configurations.

> Alexey, you seem to be using and relying on the Alpha architecture,

No, just alpha is first on the list ('a'), so nastygrams get sent first.

> could you please have a shot at this and implement the missing irqflags
> infrastructure?

Maybe. Should be interesting.
