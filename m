Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbYHLKmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbYHLKmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 06:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYHLKmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 06:42:37 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:20114 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750737AbYHLKmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 06:42:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lIQg4orgIOK1XKlNkM8nwzLGhNVMEH5VuArLCtXbxGmN1MOzcyJUJ4ZyhcrAwLN5WIz44fTLO44l7uxG5oC/nFd2GP1fLjXdC/DjLCHzHWZgrJdG8tUm9/fXeF7sgoDX/lRkR1kGQG8xfUauaGtm6IXiAI8P5gnk0LTleVDWTFM=  ;
X-YMail-OSG: YAw7fVwVM1k.WUx5mI5yfHBS_dXnakn56LWpwW1sIAbpuUSnWRH3YxgqG.bBQVilby1Jxr5dz73PzQCnSkuppFjWBqXpaicjaZ3GmQMY9oExpgdBcgK0u8_K8QXtMw7dKwFlo83kIeXk9OyGBm5gpdN3
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] core fixes
Date: Tue, 12 Aug 2008 20:42:21 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
References: <20080811222026.GA20579@elte.hu> <200808121805.14009.nickpiggin@yahoo.com.au> <20080812092534.GA7177@elte.hu>
In-Reply-To: <20080812092534.GA7177@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808122042.21482.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2008 19:25, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Tuesday 12 August 2008 16:13, Nick Piggin wrote:
> > > On Tuesday 12 August 2008 08:20, Ingo Molnar wrote:
> > > > Nick Piggin (1):
> > > >       generic-ipi: fix stack and rcu interaction bug in
> > > > smp_call_function_mask()
> > >
> > > I'm still not 100% sure that I have this patch right... I might have
> > > seen a lockup trace implicating the smp call function path... which
> > > may have been due to some other problem or a different bug in the
> > > new call function code, but if some more people can take a look at
> > > it before merging?
> >
> > OK indeed it did have a couple of bugs. Firstly, I wasn't freeing the
> > data properly in the alloc && wait case. Secondly, I wasn't resetting
> > CSD_FLAG_WAIT in the for each cpu loop (so only the first CPU would
> > wait).
> >
> > After those fixes, the patch boots and runs with the kmalloc commented
> > out (so it always executes the slowpath).
>
> thanks! I've applied the delta fix below to tip/core/urgent. In my
> testing the previous version didnt cause problems either because we
> seldom excercise this slowpath. (Jeremy had trouble reproducing the
> on-stack corruption even with targeted tests.)
>
> We'll soon start using the generic-ipi facilities for TLB flushes on x86
> and perhaps even reuse the IPI itself for the reschedule IPI - that
> should put it all under heavier scrutiny.

Well, hopefully. At the moment it is significantly slower though.
