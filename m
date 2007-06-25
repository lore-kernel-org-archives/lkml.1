Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbXFYBdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbXFYBdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 21:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbXFYBct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 21:32:49 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:39735
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbXFYBcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 21:32:48 -0400
Date: Sun, 24 Jun 2007 18:33:15 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: Adrian Bunk <bunk@stusta.de>, Benjamin LaHaise <bcrl@kvack.org>,
       Oleg Verych <olecom@flower.upol.cz>, rae l <crquan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: -Os versus -O2
In-Reply-To: <1182734240.26621.2.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0706241824080.10397@asgard.lang.hm>
References: <467cac85.081b600a.5b88.457f@mx.google.com>  <E1I20Wr-00064i-T0@flower>
  <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com> 
 <20070624222518.GA10398@flower.upol.cz>  <1182723318.6819.5.camel@laptopd505.fenrus.org>
  <20070624232314.GA971@kvack.org>  <1182730156.6819.8.camel@laptopd505.fenrus.org>
  <20070625001203.GB971@kvack.org>  <1182731022.6819.10.camel@laptopd505.fenrus.org>
  <20070625004106.GA1094@stusta.de>  <1182733127.6819.13.camel@laptopd505.fenrus.org>
  <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm>
 <1182734240.26621.2.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007, Arjan van de Ven wrote:

> On Sun, 2007-06-24 at 18:08 -0700, david@lang.hm wrote:
>>>
>>> on a system level, size can help performance because you have more
>>> memory available for other things.  It also reduces download size and
>>> gives you more space on the live CD....
>>>
>>> if you want to make things bigger again, please do this OUTSIDE the
>>> "optimize for size" option. Because that TELLS you to go for size.
>>
>> then do we need a new option 'optimize for best overall performance' that
>> goes for size (and the corresponding wins there) most of the time, but is
>> ignored where it makes a huge difference?
>
> that isn't so easy. Anything which doesn't have a performance tradeoff
> is in -O2 already. So every single thing in -Os costs you performance on
> a micro level.

this has not been true in the past (assuming that it's true today)

ok, if you look at a micro-enough level this may be true, but completely 
ignoring things like download times, the optimizations almost always boil 
down to trying to avoid jumps, loops, and decision logic at the expense of 
space.

however recent cpu's are significantly better as handling jumps and loops, 
and the cost of cache misses is significantly worse.

is the list of what's included in -O2 vs -Os different for different 
CPU's? what about within a single family of processors? (even in the x86 
family the costs of jumps, loops, and cache misses varies drasticly)

my understanding was that the optimizations for O2 were pretty fixed.

> The translation to macro level depends greatly on how things are used
> (you even have to factor in download times etc)... so that is a fair
> question to leave up to the user... which is what there is today.

ignore things like download time for the moment. it's not significant to 
most people as they don't download things that often, and when they do 
they are almost always downloading lots of stuff they don't need (drivers 
for example)

users are trying to get better performance 90+% of the time when they 
select -Os. That's why it got moved out of CONFIG_EMBEDDED.

David Lang

