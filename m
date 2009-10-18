Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbZJRQoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbZJRQoB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 12:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZJRQoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 12:44:00 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:41130 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbZJRQn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 12:43:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KsxjkecpLTBUXg3C11A223tjMKfjoanOR69bbS7zJN7/6QdlUUPcpnuoS+2+CKrFp9
         ye5oFjlAq8Qg0I4RhCmC2onrEXnTVipvNFRUZzGJgwDkQGVVfz/vBOxysB/2erdQfDY9
         NwYR12f+3uhuqY6VeYVE2G5JGqTzZG+gy8+/E=
Date: Sun, 18 Oct 2009 18:43:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: hw-breakpoints: Actually flush thread
	breakpoints in flush_thread().
Message-ID: <20091018164356.GD10344@nowhere>
References: <20091005102306.GA7889@linux-sh.org> <20091005104955.GA14852@in.ibm.com> <20091009034003.GA7747@linux-sh.org> <20091017234250.GC10344@nowhere> <20091018062558.GA20535@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018062558.GA20535@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 18, 2009 at 03:25:58PM +0900, Paul Mundt wrote:
> On Sun, Oct 18, 2009 at 01:42:53AM +0200, Frederic Weisbecker wrote:
> > On Fri, Oct 09, 2009 at 12:40:04PM +0900, Paul Mundt wrote:
> > > On Mon, Oct 05, 2009 at 04:19:55PM +0530, K.Prasad wrote:
> > > > On Mon, Oct 05, 2009 at 07:23:06PM +0900, Paul Mundt wrote:
> > > > > [ I noticed this whilst hacking up SH support, applies to the current
> > > > >   tracing/hw-breakpoints topic branch. ]
> > > > > 
> > > > > flush_thread() tries to do a TIF_DEBUG check before calling in to
> > > > > flush_thread_hw_breakpoint() (which subsequently clears the thread flag),
> > > > > but for some reason, the x86 code is manually clearing TIF_DEBUG
> > > > > immediately before the test, so this path will never be taken.
> > > > > 
> > > > > This kills off the erroneous clear_tsk_thread_flag() and lets
> > > > > flush_thread_hw_breakpoint() actually get invoked.
> > > > > 
> > > > 
> > > > Yes, this is wrong and we missed it. Thanks for fixing!
> > > > 
> > > > > Presumably folks were getting lucky with testing and the
> > > > > free_thread_info() -> free_thread_xstate() path was taking care of the
> > > > > flush there.
> > > > > 
> > > > > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> > > > 
> > > > Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > > > 
> > > > 
> > > Ingo, are you planning on picking this up? Or is there a hw-breakpoints
> > > tree somewhere outside of -tip that I'm unaware of?
> > 
> > 
> > I'm picking it.
> > Thanks.
> > 
> Thanks. If you're setting up a tree somewhere can you let me know where
> it will be hosted? I'm pretty much done with the SH support for the
> existing topic branch in -tip, but if it's being reworked, then I'd like
> to get my changes reworked and integrated as soon as possible.


I'm working on the v2 of the hardware breakpoints through perf integration.
I've included your patch inside, I'll Cc you on the patches.

