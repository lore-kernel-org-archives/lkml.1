Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbXFYIlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbXFYIlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 04:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751093AbXFYIln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 04:41:43 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:37464 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbXFYIlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 04:41:42 -0400
In-Reply-To: <20070625081905.GA15209@1wt.eu>
References: <1182730156.6819.8.camel@laptopd505.fenrus.org> <20070625001203.GB971@kvack.org> <1182731022.6819.10.camel@laptopd505.fenrus.org> <20070625004106.GA1094@stusta.de> <1182733127.6819.13.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm> <1182734240.26621.2.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241824080.10397@asgard.lang.hm> <20070625050424.GZ943@1wt.eu> <e6d26e7ee86cc527095de2716f285aff@kernel.crashing.org> <20070625081905.GA15209@1wt.eu>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <0b1029a9b2de1679f6361557ad703c03@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       david@lang.hm, Oleg Verych <olecom@flower.upol.cz>,
       rae l <crquan@gmail.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: -Os versus -O2
Date: Mon, 25 Jun 2007 10:41:22 +0200
To: Willy Tarreau <w@1wt.eu>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> In my experience, -Os produced faster code on gcc-2.95 than -O2 or 
>>> -O3.
>>
>> On what CPU?  The effect of different optimisations varies
>> hugely between different CPUs (and architectures).
>
> x86

That's not a CPU, that's an architecture.  I hope you
understand there are very big differences between different
members of the x86 family and you don't compare 2.95 on a
Pentium class CPU to 3.x on an Opteron or 4.x on a Pentium4
or something like that.

>>> With gcc-3.3, -Os show roughly the same performance as -O2 for me on
>>> various programs. However, with gcc-3.4, I noticed a slow down with
>>> -Os. And with gcc-4, using -Os optimizes only for size, even if the
>>> output code is slow as hell. I've had programs whose speed dropped
>>> by 70% using -Os on gcc-4.
>>
>> Well you better report those!  <http://gcc.gnu.org/bugzilla>
>
> No, -Os is for size only :
>
>        -Os Optimize for size.  -Os enables all -O2 optimizations
>            that do not typically increase code size.  It also
>            performs further optimizations designed to reduce code
>            size.

That is not "for size only".  Please read again.

A 70% speed decrease is something that should be at least
investigated, even if then perhaps it is decided GCC already
does the "right thing".

> So it is expected that speed can be reduced using -Os. I won't report
> a thing which is already documented !

A few percent points slower is expected, 20% would be
explainable, but 70%?

-O2 and -Os are supposed to differ in _minor_ ways.  Such
a huge performance drop is unexpected.  If you file the PR,
feel free to blame me for reporting it at all.

>>> But in some situtations, it's desirable to have the smallest possible
>>> kernel whatever its performance. This goes for installation CDs for
>>> instance.
>>
>> There are much better ways to achieve that.
>
> Optimizing is not a matter of choosing *one* way, but cumulating
> everything you have.

Yes of course.  I'm just saying -Os is a pretty minor step
in the overall making-things-smaller game.  Leaving out XFS
helps a whole megabyte on my default target, for example.

> For instance, on a smart boot loader, I have
> a kernel which is about 300 kB, or 700 kB with the initramfs. Among
> the tricks I used :
>   - -Os
>   - -march=i386
>   - align everything to 0
>   - replace gzip with p7zip
>
> Even if each of them reduces overall size by 5%, the net result is
> 0.95^4 = 0.81 = 19% gain, for the same set of features. This is
> something to consider.

Sure.  I don't think making -Os mean "as small as possible
in all cases" (or, rather, introducing a new option for that)
would help terribly much over the current -Os meaning -- a
few percent at most.  That's not to say that no such optimisations
are added anymore, but mostly they turn out not to decrease
speed at all and so are enabled at any -O level :-)


Segher

