Return-Path: <linux-kernel-owner+w=401wt.eu-S1761002AbXJZAET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761002AbXJZAET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXJZAEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:04:11 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:44419 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751293AbXJZAEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:04:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BGru2PnkHrfbxRksuvwnkDYj0yTXww4LxlNBYkRjPXi/gK/B3HIvQ0qhJnAcBffFwfR4WpvbwLY5u8Pnac+n+fRiMww2GZlF9WF4KzoyOw6g5TGqirq64qaUOP5G8KnfmsWtM9XmwVO3eun/+/IC98reyiG1Pt2TYVgwiBsY+5o=  ;
X-YMail-OSG: cAWjt7gVM1kJpU.1.kFe7HNadi14bG8G5esFFaxcmjtNTzn8lAYYbzDY6mBy7BM06bBjGXYD4w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <ak@suse.de>
Subject: Re: Is gcc thread-unsafe?
Date: Fri, 26 Oct 2007 09:57:28 +1000
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710260943.44719.nickpiggin@yahoo.com.au> <200710260155.46339.ak@suse.de>
In-Reply-To: <200710260155.46339.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260957.28636.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 09:55, Andi Kleen wrote:
> > But we don't actually know what it is, and it could change with
> > different architectures or versions of gcc. I think the sanest thing
> > is for gcc to help us out here, seeing as there is this very well
> > defined requirement that we want.
> >
> > If you really still want the optimisation to occur,
>
> I don't think it makes sense for memory. It may may make sense for
> registers.
>
> But given that my kernel doesn't seem to contain any instances
> at all it's probably not too useful for it anyways.
>
> So I wouldn't have a problem disabling it, but it would
> be better if they fixed their heuristics to only apply it when
> it makes sense.

That's what I mean -- disabling it for memory. I mean, I am just
talking about the conditional => unconditional store to a shared
variable optimisation.

So for example, adc, sbb, and cmov are all still fine when they
are used for the right things. I don't want to turn them off
because they really are quite useful.

As far as it being theoretical... I hope it is. But we should
nip this in the "bud" (gcc 3.x does this too, sigh) before it
causes problems for us (and any and all other threaded programs
and libraries out there). And by that I mean ask them for a
compiler option rather than start adding volatile.

