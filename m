Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbYJQDri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbYJQDri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 23:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYJQDra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 23:47:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:50381 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbYJQDr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 23:47:29 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <86802c440810162039v7c347888i34e26058b70f37d5@mail.gmail.com>
References: <48F409E9.3030501@zytor.com>
	 <20081013.223811.174710738.davem@davemloft.net>
	 <Pine.LNX.4.64.0810161030120.9022@vixen.sonytel.be>
	 <20081016.013850.85183428.davem@davemloft.net>
	 <1224212533.7654.60.camel@pasglop> <1224212791.7654.63.camel@pasglop>
	 <86802c440810162039v7c347888i34e26058b70f37d5@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 17 Oct 2008 14:46:32 +1100
Message-Id: <1224215192.7654.70.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >
> > +static char *resource_string(char *buf, char *end, struct resource *res, int field_width, int precision, int flags)
> > +{
> > +       /* room for the actual numbers, the two "0x", -, [, ] and the final zero */
> > +       char sym[4*sizeof(resource_size_t) + 8];
> > +       char *p = sym, *pend = sym + sizeof(sym);
> > +
> > +       *p++ = '[';
> > +       p = number(p, pend, res->start, 16, -1, -1, SPECIAL | SMALL);
> > +       *p++ = '-';
> > +       p = number(p, pend, res->end, 16, -1, -1, SPECIAL | SMALL);
> > +       *p++ = ']';
> > +       *p = 0;
> > +
> > +       return string(buf, end, sym, field_width, precision, flags);
> 
> so x64 64bit,io ports will be print out 8 digital?

With that patch, it will use just as many digits as necessary to display
a given number. The question I'm asking in the comments is whether we
want to instead use fixed digits with zero padding, and in that case,
do we want a hook or something for archs to decide how many digits
for IO vs. memory.

But at least with that in, we can start converting callers. I have a
patch converting PCI that I'll post once that goes in and I'll start
scrubbing arch/powerpc soon.

Cheers,
Ben.

