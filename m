Return-Path: <linux-kernel-owner+w=401wt.eu-S1759078AbXLAAA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078AbXLAAA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 19:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbXLAAAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 19:00:42 -0500
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:53409
	"EHLO QMTA02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357AbXLAAAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 19:00:41 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2007 19:00:41 EST
X-Authority-Analysis: v=1.0 c=1 a=DVJqRJfkT4s3hOcjSRcA:9 a=wP8zy9ft34lpijhXR-UA:7 a=JIGQLiCUGozhRnmYcQf4SueLUukA:4 a=si9q_4b84H0A:10 a=WuK_CZDBSqoA:10
Subject: Re: Kernel Development & Objective-C
From: Nicholas Miell <nmiell@comcast.net>
To: "J.A." =?ISO-8859-1?Q?Magall=F3n?= <jamagallon@ono.com>
Cc: =?ISO-8859-1?Q?Lo=EFc_Greni=E9?= <loic.grenie@gmail.com>,
       Ben.Crowhurst@stellatravel.co.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20071201001950.11100a32@werewolf>
References: <474EAD18.6040408@stellatravel.co.uk>
	 <9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com>
	 <20071201001950.11100a32@werewolf>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 30 Nov 2007 15:53:38 -0800
Message-Id: <1196466818.18231.40.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.0.njm.3) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-01 at 00:19 +0100, J.A. Magallón wrote:

> An vtable in C++ takes exactly the same space that the function
> table pointer present in every driver nowadays... and probably
> the virtual method call that C++ does itself with
> 
> 	thing->do_something(with,this)
> 
> like
> 	push thing
> 	push with
> 	push this
> 	call THING_vtable+indexof(do_something) // constants at compile time
> 
> is much more efficient that what gcc can mangle to do with
> 
> 	thing->do_something(with,this,thing)
> 
> 	push with
> 	push this
> 	push thing
> 	get thing+offsetof(do_something) // not constant at compile time
> 	dereference it
> 	call it
> 
> (that is, get a generic field on a structure and use it as jump address)
> 
> In short, the kernel is object oriented, implements OO programming by
> hand, but the compiler lacks the knowledge that it is object oriented
> programming so it could do some optimizations.

        struct test;
        struct testVtbl
        {
        	int (*fn1)(struct test *t, int x, int y);
        	int (*fn2)(struct test *t, int x, int y);
        };
        struct test
        {
        	struct testVtbl *vtbl;
        	int x, y;
        };
        void testCall(struct test *t, int x, int y)
        {
        	t->vtbl->fn1(t, x, y);
        	t->vtbl->fn2(t, x, y);
        }

and

        struct test
        {
        	virtual int fn1(int x, int y);
        	virtual int fn2(int x, int y);
        
        	int x, y;
        };
        
        void testCall(struct test *t, int x, int y)
        {
        	t->fn1(x, y);
        	t->fn2(x, y);
        }
        
generate instruction-for-instruction identical code.

-- 
Nicholas Miell <nmiell@comcast.net>

