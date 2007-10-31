Return-Path: <linux-kernel-owner+w=401wt.eu-S1757321AbXJaMmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbXJaMmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 08:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbXJaMmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 08:42:45 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:43425 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753128AbXJaMmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 08:42:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6nRzuk/YqPMUt5LxBl5oR4vEqqPYg4Vyhfd0whOldKalI52Bpi/mU+tgFMrBLbB6zA7wPmGk2+arzESnT0xvYWwlihJMGh9WP/EdUovrYGouORta3vDr6OceKOEeURJRrTGSkRtX0GVHBl8y47wyP0s4AAswdaMeKM6UVXe1210=  ;
X-YMail-OSG: BOYaA1sVM1nHKRa1mZJEZDqMgpROoa5UzY4QoC8PAA.gDYqrNs5aeTfhRsAf2ZM4noJoBUEnZA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 03/33] mm: slub: add knowledge of reserve pages
Date: Wed, 31 Oct 2007 22:25:06 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
References: <20071030160401.296770000@chello.nl> <200710312146.03351.nickpiggin@yahoo.com.au> <1193833072.27652.167.camel@twins>
In-Reply-To: <1193833072.27652.167.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710312225.07249.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 23:17, Peter Zijlstra wrote:
> On Wed, 2007-10-31 at 21:46 +1100, Nick Piggin wrote:

> > And I'd prevent these ones from doing so.
> >
> > Without keeping track of "reserve" pages, which doesn't feel
> > too clean.
>
> The problem with that is that once a slab was allocated with the right
> allocation context, anybody can get objects from these slabs.

[snip]

I understand that.


> So we either reserve a page per object, which for 32 byte objects is a
> large waste, or we stop anybody who doesn't have the right permissions
> from obtaining objects. I took the latter approach.

What I'm saying is that the slab allocator slowpath should always
just check watermarks against the current task. Instead of this
->reserve stuff.
