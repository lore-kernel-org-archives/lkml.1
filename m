Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899AbYHEET1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbYHEET1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755539AbYHEETF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:19:05 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:42183 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755428AbYHEETD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:19:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3YrFUqV5Mu+nPPxDURNmF3Sg0Tz5iOtq2b3+wc67hkAExYKkJRQEddfn2MSuhtkOBBOiKYwct7rwEehBeceESFWplQMjXrkw4JMJ3DPpL7EcNFX+kKMPA3VIG6JFBZhuPvgaHQiuAr7ZRcCouxgfTNgLh5TRg4wGx56EyO+YYgM=  ;
X-YMail-OSG: GIZbliQVM1nFoUN0kP5Wu21.Z4oMV8C4aYlejV9IN1gP8n4nkKKUtwe9AR0Y52DVgL8OZtJDKbgZGU7wCdQB5mjs84vE0bgy7Y30e8BSQXUm7XtyOtfttiJrvfX6xpV2UTk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: benh@kernel.crashing.org
Subject: Re: Switching TestSetPageLocked to trylock_page
Date: Tue, 5 Aug 2008 14:18:55 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200807311726.51816.nickpiggin@yahoo.com.au> <20080804205754.b05c8aa9.akpm@linux-foundation.org> <1217908919.24157.148.camel@pasglop>
In-Reply-To: <1217908919.24157.148.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051418.55470.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 August 2008 14:01, Benjamin Herrenschmidt wrote:
> > Yup.  A mechanical rename-foo-to-bar can be prepared and merged late -
> > there's little payback for the pain of maintaining it for a couple of
> > months.
> >
> > Would prefer either that we hold off until after 2.6.27 is released or
> > just do it now.
>
> I'd like to have the performance improvement on powerpc in 2.6.27 :-)

Well I would too, but I won't push the actual performance improvements
this time (maybe the lockdep work, though, if it is working).

I will try to get the rename in, and then get the performance
improvements into -mm and let Andrew merge when he's ready. To be honest,
I'm satisfied that 2.6.27 contains enough potential for npiggin to have
spectacularly broken the kernel...


> I've always hated the way we abused bitops as locks, it's terribly
> inefficient for us, so that's a nice cleanup as far as I'm concerned.

I agree, especially for widely used locks like page and buffer lock.
If *nothing* else it is much more readable...
