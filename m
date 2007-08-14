Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbXHNWSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbXHNWSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936472AbXHNWEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:04:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:55247 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936464AbXHNWD4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:03:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 6/24] make atomic_read() behave consistently on frv
Date: Wed, 15 Aug 2007 00:01:54 +0200
User-Agent: KMail/1.9.6
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>, csnook@redhat.com,
       dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
References: <20070811042943.GA13410@linux.vnet.ibm.com> <46C13EE1.1000707@yahoo.com.au> <20070814170128.GA8243@linux.vnet.ibm.com>
In-Reply-To: <20070814170128.GA8243@linux.vnet.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708150001.58217.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19eX0TjAJAFwnNu0KVfchpb/XVLC/wNUkjx63z
 yo1mhKwHQN18NJLyhq5m/qz0F6a4QnDXn5feO5bfCm6T43tF1W
 mQ8ZX4tULi0UF/ftej4yA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 August 2007, Paul E. McKenney wrote:
> > #define order(x) asm volatile("" : "+m" (x))
> 
> There was something very similar discussed earlier in this thread,
> with quite a bit of debate as to exactly what the "m" flag should
> look like.  I suggested something similar named ACCESS_ONCE in the
> context of RCU (http://lkml.org/lkml/2007/7/11/664):
> 
>         #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
> 
> The nice thing about this is that it works for both loads and stores.
> Not clear that order() above does this -- I get compiler errors when
> I try something like "b = order(a)" or "order(a) = 1" using gcc 4.1.2.

Well, it serves a different purpose: While your ACCESS_ONCE() macro is
an lvalue, the order() macro is a statement that can be used in place
of the barrier() macro. order() is the most lightweight barrier as it
only enforces ordering on a single variable in the compiler, but does
not have any side-effects visible to other threads, like the cache
line access in ACCESS_ONCE has.

	Arnd <><
