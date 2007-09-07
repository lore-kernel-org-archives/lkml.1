Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbXIHKAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbXIHKAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 06:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXIHKAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 06:00:09 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:20236 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752064AbXIHKAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 06:00:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=at7Ub0lR6yMzMtnmwUuifbvze+YqyA2jB6JSTrz5lfhFslCf6sYj3aqTHAhmSMiCJbYdm7e2ZJm+LmwA1eLmUlErbkVoIz6ORC42S1+dxNOo907a2uhsavQW7586XW/GbJwkcAsFFW41SR2YB8sY0AY8aswIMR/C8nGRefIFL9c=  ;
X-YMail-OSG: 4B5Qt6AVM1kQPDrQBOejuaGd4JU62tiQRC_r16oSAMjOXJaJlpAA1G6Yn4W5thho.fCDm_H3RQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <ak@suse.de>
Subject: Re: Intel Memory Ordering White Paper
Date: Sat, 8 Sep 2007 05:57:35 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
References: <200709071526.51169.jesse.barnes@intel.com> <200709080413.12282.nickpiggin@yahoo.com.au> <200709081053.36842.ak@suse.de>
In-Reply-To: <200709081053.36842.ak@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709080557.36021.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 September 2007 18:53, Andi Kleen wrote:
> On Friday 07 September 2007 20:13:12 Nick Piggin wrote:
> > On Sunday 09 September 2007 03:48, Nick Piggin wrote:
> > > There is some suggestion in the source code that non-temporal stores
> > > (movntq) are weakly ordered. But AFAIKS from the documents, it is
> > > ordered when operating on wb memory. What's the situation there?
> >
> > Sorry, it looks from the AMD document like nontemporal stores to wb
> > memory can go out of order.
>
> Yes, that is how NT stores are defined.
>
> > If this is the case, we can either retain the sfence in smp_wmb(), or
> > noop it, and put explicit sfences around any place that performs
> > nontemporal stores...
>
> We do this already, but in most cases it doesn't matter anyways. We AFAIK
> do not rely on any ordering for copy_*_user for example. There are not
> that many users of nt so it's not a huge issue.

OK, but we just don't want to be making lots of little exceptions. For
bulk copies, I don't see it being a big issue to always sfence around
them (it would be a relatively minor cost).


> > Anyway, the lfence should be able to go away without so much trouble.
>
> You mean sfence? lfence in rmb is definitely needed.

I mean lfence in smp_rmb().


> sfence on x86-64 is not strictly needed, but also shouldn't hurt very much
> so I always kept it in.
>
> -Andi
