Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbXIWQIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbXIWQIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 12:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbXIWQIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 12:08:05 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:5910 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbXIWQID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 12:08:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:x-url:organization:user-agent:sender;
        b=BDLCws7bwa1Tpyt7W2FEcHNhMZoIqnhflCmn3MIrPNgGB5JwCvdpfLkEoAXVqRSJBdybEVJuUMH65BUBtEh9Mut3yuk22dbEHvws8bAnemEL6+eoBWczsK4e4BykCFwVrjZWBe5rtmBf6WjB4+iXJWdM8n5lp39fJh26PL5IxBk=
Date: Sun, 23 Sep 2007 13:07:50 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: memset as memzero
Message-ID: <20070923160750.GO4887@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>
References: <20070922083355.GA7226@cvg> <20070922124659.741cca42@laptopd505.fenrus.org> <alpine.LFD.0.999.0709221149480.16478@woody.linux-foundation.org> <20070923153243.GE8127@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070923153243.GE8127@redhat.com>
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Sep 23, 2007 at 11:32:43AM -0400, Dave Jones escreveu:
> On Sat, Sep 22, 2007 at 11:53:53AM -0700, Linus Torvalds wrote:
>  > 
>  > 
>  > On Sat, 22 Sep 2007, Arjan van de Ven wrote:
>  > > 
>  > > it doesn't add value.... memset with a constant 0 is just as fast
>  > > (since the compiler knows it's 0) than any wrapper around it, and the
>  > > syntax around it is otherwise the same.
>  > 
>  > Indeed.
>  > 
>  > The reason we have "clear_page()" is not because the value we're writing 
>  > is constant - that doesn't really help/change anything at all. We could 
>  > have had a "fill_page()" that sets the value to any random byte, it's just 
>  > that zero is the only value that we really care about.
>  > 
>  > So the reason we have "clear_page()" is because the *size* and *alignment* 
>  > is constant and known at compile time, and unlike the value you write, 
>  > that actually matters.
>  > 
>  > So "memzero()" would never really make sense as anything but a syntactic 
>  > wrapper around "memset(x,0,size)". 
> 
> There is one useful argument for memzero (or bzero to give it its proper
> name), and that's that it's impossible to screw up.
> I'm still amazed at how many times I see
> 
> 	memset (x,size,0);
> 
> in various code. So much so, that my editor highlights it now to spot
> it during code review.  As does my mail client.  To be on the safe
> side, I also have a cron job grepping for it in my ~/Mail/commits
> for all the projects I'm interested in.
> 
> It's tragic really just how easy it is to screw it up.

bzero! That is it, its nothing new, just a sane name to something that
is useful to humans, even being of sheer arrogant disdain for machines
as a useless stuff only humans couldn't get right. Yeah, us screw up
pretty much more than them.

- Arnaldo
