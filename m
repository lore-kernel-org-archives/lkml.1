Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYLLDgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYLLDgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 22:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbYLLDgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 22:36:10 -0500
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:25394 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755521AbYLLDgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 22:36:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=Nrh0Y8A/Vb1dI58Eg9K/PPElh1I+JrPIXQRkvWNoTiUkQ3kvlCUF9aXboLP4RvkNTBS+a8jwYZdLBe5CX8M1VlBqNpC3E4dKUy797YkULSDicInK3KzL9tvMM1YQYKXyGzySUN4PzqKdi85r6n+SpG7nTrMpA2EbqOA7XTTP3xI=  ;
X-YMail-OSG: IQ1aiA4VM1nnbRsUhmln_QvlmfDQ39XNwYTowePg2cixwh3A7mVpT0Z9oyIUOKjpj1eTY4bvsM9i4N7g7VCl4ZJ8ftzbJqVJf3pjGolJjce35r0DQDh34CYSEwNZqRfa7OlhhNsKuzopMgxcrLNDz00LYhBhjWEXnqydeJcO6VaIXKe0n.4MaV7YjBgR
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][v2] fork_init: fix division by zero
Date: Fri, 12 Dec 2008 13:36:02 +1000
User-Agent: KMail/1.9.5
Cc: Al Viro <viro@zeniv.linux.org.uk>, yur@emcraft.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Geert.Uytterhoeven@sonycom.com, dhowells@redhat.com, miltonm@bga.com,
       wd@denx.de, dzu@denx.de, yanok@emcraft.com
References: <200812101950.51958.yur@emcraft.com> <200812121331.34602.nickpiggin@yahoo.com.au> <20081211184753.97d0db7a.akpm@linux-foundation.org>
In-Reply-To: <20081211184753.97d0db7a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812121436.03177.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2008 13:47, Andrew Morton wrote:
> On Fri, 12 Dec 2008 12:31:33 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > On Friday 12 December 2008 07:43, Andrew Morton wrote:
> > > On Thu, 11 Dec 2008 20:28:00 +0000
> > >
> > > >  Do they actually cross the page boundaries?
> > >
> > > Some flavours of slab have at times done an order-1 allocation for
> > > objects which would fit into an order-0 page (etc) if it looks like
> > > that will be beneficial from a packing POV.  I'm unsure whether that
> > > still happens - I tried to get it stamped out for reliability reasons.
> >
> > Hmph, SLUB uses order-3 allocations for 832 byte sized objects
> > by default here (mm struct).
>
> That sucks, but at least it's <= PAGE_ALLOC_COSTLY_ORDER.

Which is somewhat arbitrary a value. order-1 is costly compared to
order-0...

After running my system here for a while and doing various things
with it, I have the ability to allocate 898 order-0 pages (3592K),
or 36 order-3 pages (1152K).

Not as bad as I expected, but the system's only been up for an hour,
and not exactly doing anything unusual (and it has nearly 30MB free,
out of 4GB).


> It's fortunate that everyone has more than 128GB of memory.

And that SLAB still works quite well :)
