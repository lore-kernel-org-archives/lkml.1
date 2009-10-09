Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZJIHxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZJIHxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 03:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZJIHxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 03:53:52 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:42018 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbZJIHxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 03:53:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TnYzuqJn3lTge6v5LCNi+cTgbHPO7B01OQz9gkXOeu+IR4JFWGiGz+rrSJwUxdUcZM
         ZyWFneBm97gx2e86OZLMKu3d84A1bmcZB2SHkct+FSpU8EeGaFdgVNreBoYMmuBwYtQ9
         +XTqlEGGx6S5ipfvtQqPo7ZVMeWlGB3NKaz+U=
Date: Fri, 9 Oct 2009 09:53:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: hw-breakpoints: Actually flush thread
	breakpoints in flush_thread().
Message-ID: <20091009075311.GA5036@nowhere>
References: <20091005102306.GA7889@linux-sh.org> <20091005104955.GA14852@in.ibm.com> <20091009034003.GA7747@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009034003.GA7747@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 12:40:04PM +0900, Paul Mundt wrote:
> On Mon, Oct 05, 2009 at 04:19:55PM +0530, K.Prasad wrote:
> > On Mon, Oct 05, 2009 at 07:23:06PM +0900, Paul Mundt wrote:
> > > [ I noticed this whilst hacking up SH support, applies to the current
> > >   tracing/hw-breakpoints topic branch. ]
> > > 
> > > flush_thread() tries to do a TIF_DEBUG check before calling in to
> > > flush_thread_hw_breakpoint() (which subsequently clears the thread flag),
> > > but for some reason, the x86 code is manually clearing TIF_DEBUG
> > > immediately before the test, so this path will never be taken.
> > > 
> > > This kills off the erroneous clear_tsk_thread_flag() and lets
> > > flush_thread_hw_breakpoint() actually get invoked.
> > > 
> > 
> > Yes, this is wrong and we missed it. Thanks for fixing!
> > 
> > > Presumably folks were getting lucky with testing and the
> > > free_thread_info() -> free_thread_xstate() path was taking care of the
> > > flush there.
> > > 
> > > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> > 
> > Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > 
> > 
> Ingo, are you planning on picking this up? Or is there a hw-breakpoints
> tree somewhere outside of -tip that I'm unaware of?


Joining: Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Even if a rewrite on top of perf event is planned, this is still a fix
on the current state. Something that the rewrite won't need to handle.

Thanks.

