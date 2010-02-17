Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab0BQPlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 10:41:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab0BQPlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 10:41:44 -0500
Date: Wed, 17 Feb 2010 16:40:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: set_personality_ia32() abuses TS_COMPAT
Message-ID: <20100217154041.GA7446@redhat.com>
References: <4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com> <4B79B202.5090006@zytor.com> <20100216101903.GA1057@redhat.com> <20100216102332.GL21783@one.firstfloor.org> <20100216140126.GA16448@redhat.com> <20100216140242.GC16448@redhat.com> <alpine.LFD.2.00.1002160738530.18830@localhost.localdomain> <20100216174437.GA28323@redhat.com> <4B7ADB07.1050500@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7ADB07.1050500@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, H. Peter Anvin wrote:
>
> On 02/16/2010 09:44 AM, Oleg Nesterov wrote:
> >
> > and, following this logic, shouldn't set_personality_64bit() clear
> > TS_COMPAT ?
>
> It's quite possible it should... I haven't dug into if that isn't either
> done elsewhere or isn't done for some other reason.  This would be worth
> looking into.

OK. This was another source of confusion for me...

> > OK, in any case I do not claim we need fixes. Just I am confused.
>
> Trying to understand the code is good.  However, you seem to have
> started out with a point of view that we should have the minimal set of
> state changes possible

Well, I must admit... the only point of this patch was "please change
your code so that I could convince myself I understand what it does" ;)

> instead of keeping state as self-consistent as
> possible.  Invariants are a Very Good Thing.  Documented invariants are
> even better ;)

Agreed! But to me it looks as if TS_COMPAT breaks invariants.
In particular, because set_personality_64bit() didn't clear this flag.


Anyway. At least I can assume there is no "hard" reason to set this
bit currently, and this was my main question.

Thanks to all for your explanations!

Oleg.

