Return-Path: <linux-kernel-owner+w=401wt.eu-S1752067AbXLCKQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbXLCKQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 05:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbXLCKPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 05:15:55 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:38865 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751909AbXLCKPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 05:15:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bNR4Dv+/M0mMAcAEBCSjk+DbrfqL9kUsD1V5wVkZ8kC/N1Rz4YramKjGEMdtj+jZ/cQilnoCtecd0ddHss4GLuNr6cy5O2KIiOKMiEl3pYucKlF5ejokM4JlcbenwyEmAwiC2EFBXS0PPclC3Xutf20pi1WFsn7TAH9YoVnCi+A=  ;
X-YMail-OSG: QPiTlAcVM1kEDWNqqUzPpsmz_F4WXYLaspylusenFnxPLp3rfV70Swrw7wWMmBa5KzrqimGoSA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Date: Mon, 3 Dec 2007 21:15:43 +1100
User-Agent: KMail/1.9.5
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1196155985.25646.31.camel@ymzhang> <200712032017.19661.nickpiggin@yahoo.com.au> <20071203095719.GA23106@elte.hu>
In-Reply-To: <20071203095719.GA23106@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712032115.43275.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 December 2007 20:57, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > as far as desktop apps such as firefox goes, the exact opposite is
> > > true. We had two choices basically: either a "more agressive" yield
> > > than before or a "less agressive" yield. Desktop apps were reported
> > > to hurt from a "more agressive" yield (firefox for example gets some
> > > pretty bad delays), so we defaulted to the less agressive method.
> > > (and we defaulted to that in v2.6.23 already)
> >
> > Yeah, I doubt the 2.6.23 scheduler will be usable for distros
> > though...
>
> ... which is a pretty gross exaggeration belied by distros already
> running v2.6.23. Sure, "enterprise" distros might not run .23 (or .22 or

Yeah, that's what I mean of course. And it's because of the performance
and immediate upstream divergence issues with 2.6.23. Specifically I'm
talking about the scheduler: they may run a base 2.6.23, but it would
likely have most or all subsequent scheduler patches.


> > I was just talking about the default because I didn't know the reason
> > for the way it was set -- now that I do, we should talk about trying
> > to improve the actual code so we don't need 2 defaults.
>
> I've got the patch below queued up: it uses the more agressive yield
> implementation for SCHED_BATCH tasks. SCHED_BATCH is a natural
> differentiator, it's a "I dont care about latency, it's all about
> throughput for me" signal from the application.

First and foremost, do you realize that I'm talking about existing
userspace working well on future kernels right? (ie. backwards
compatibility).


> But first and foremost, do you realize that there will be no easy
> solutions to this topic, that it's not just about 'flipping a default'?

Of course ;) I already answered that in the email that you're replying
to:

> > I was just talking about the default because I didn't know the reason
> > for the way it was set -- now that I do, we should talk about trying
> > to improve the actual code so we don't need 2 defaults.

Anyway, I'd hope it can actually be improved and even the sysctl
removed completely.
