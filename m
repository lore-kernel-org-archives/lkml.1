Return-Path: <linux-kernel-owner+w=401wt.eu-S1760340AbXJLMXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760340AbXJLMXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754048AbXJLMXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:23:21 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:31807 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753394AbXJLMXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:23:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Er3hjEyHUEFvc/Buft7G4uQPhRkzgqUhC9gRXNYgWiNv9gbaIJWxLctF5Y5iwFWj52aeASpl4NCKmQ1Wu+TQnEKHXSzBJ6xioYK4ZY+f5FhvtiL7MhkXOk8YRiLLnFoI9KsINPJTkJOZz6f8ZPDXy0AtT12731asA3VzdxVuviA=  ;
X-YMail-OSG: 7AiXDoAVM1m.r__tH959nl.tvhCNhebe_94IVNn48GKPI4XcEnkqc4ALlCkk9elG6rdWcFpOrQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] mm: avoid dirtying shared mappings on mlock
Date: Fri, 12 Oct 2007 22:23:01 +1000
User-Agent: KMail/1.9.5
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Suleiman Souhlal <suleiman@google.com>, linux-mm <linux-mm@kvack.org>,
       hugh <hugh@veritas.com>
References: <11854939641916-git-send-email-ssouhlal@FreeBSD.org> <200710120414.11026.nickpiggin@yahoo.com.au> <1192186222.27435.22.camel@twins>
In-Reply-To: <1192186222.27435.22.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710122223.02061.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2007 20:50, Peter Zijlstra wrote:
> On Fri, 2007-10-12 at 04:14 +1000, Nick Piggin wrote:
> > On Friday 12 October 2007 20:37, Peter Zijlstra wrote:

> > > The pages will still be read-only due to dirty tracking, so the first
> > > write will still do page_mkwrite().
> >
> > Which can SIGBUS, no?
>
> Sure, but that is no different than any other mmap'ed write. I'm not
> seeing how an mlocked region is special here.

Well it is a change in behaviour (admittedly, so was the change
to SIGBUS mmaped writes in the first place). It's a matter of
semantics I guess. Is the current behaviour actually a _problem_
for anyone? If not, then do we need to change it?

I'm not saying it does matter, just that it might matter ;)
