Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYE0LY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYE0LY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 07:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbYE0LYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 07:24:20 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43319 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbYE0LYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 07:24:20 -0400
Date: Tue, 27 May 2008 05:24:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Daniel Walker <dwalker@mvista.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Michal Schmidt <mschmidt@redhat.com>, linville@tuxdriver.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH] net: wireless: airo semaphore to mutex
Message-ID: <20080527112403.GI30894@parisc-linux.org>
References: <20080522232103.120033152@mvista.com> <20080526192914.31045d09@brian.englab.brq.redhat.com> <200805271117.23051.rusty@rustcorp.com.au> <20080527021503.GH30894@parisc-linux.org> <1211862881.18130.243.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211862881.18130.243.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 09:34:41PM -0700, Daniel Walker wrote:
> 
> On Mon, 2008-05-26 at 20:15 -0600, Matthew Wilcox wrote:
> > On Tue, May 27, 2008 at 11:17:22AM +1000, Rusty Russell wrote:
> > > On Tuesday 27 May 2008 03:29:14 Michal Schmidt wrote:
> > > > Mutexes are not allowed in interrupt context, not even mutex_trylock.
> > > 
> > > As an aside, does anyone know why?  I know the documentation says so, but it 
> > > wasn't immediately obvious to me.  I asked before to no response...
> > 
> > Because mutexes have an owner.  In interrupt context, there is no owner.
> > This owner is used to do priority boosts as well as debugging.
> 
> I don't think regular mutexes do boosting, the rtmutex does tho .. I
> think it's more a issue with lockdep complaining about the context, but
> that exists to just plain disallow this type of usage on principal .

You're right, I got confused, it's only rtmutexes that do priority
inheritance.

I suppose we could have a special 'interrupt context' owner for
the purposes of LOCKDEP.  Ingo?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
