Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbXFYBIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbXFYBIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 21:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbXFYBHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 21:07:52 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:37577
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbXFYBHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 21:07:51 -0400
Date: Sun, 24 Jun 2007 18:08:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arjan van de Ven <arjan@infradead.org>
cc: Adrian Bunk <bunk@stusta.de>, Benjamin LaHaise <bcrl@kvack.org>,
       Oleg Verych <olecom@flower.upol.cz>, rae l <crquan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: -Os versus -O2
In-Reply-To: <1182733127.6819.13.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm>
References: <467cac85.081b600a.5b88.457f@mx.google.com>  <E1I20Wr-00064i-T0@flower>
  <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com> 
 <20070624222518.GA10398@flower.upol.cz>  <1182723318.6819.5.camel@laptopd505.fenrus.org>
  <20070624232314.GA971@kvack.org>  <1182730156.6819.8.camel@laptopd505.fenrus.org>
  <20070625001203.GB971@kvack.org>  <1182731022.6819.10.camel@laptopd505.fenrus.org>
  <20070625004106.GA1094@stusta.de> <1182733127.6819.13.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007, Arjan van de Ven wrote:

>> I wouldn't care if CONFIG_CC_OPTIMIZE_FOR_SIZE was hidden behind
>> CONFIG_EMBEDDED, but as long as it's available as a general purpose
>> option we have to consider it's performance.
>
> I think you are missing the point. You tell the kernel to
> OPTIMIZE_FOR_SIZE. *over performance*. Sure. Performance shouldn't be
> EXTREMELY pathetic, but it's not; and if it were, it's a problem with
> the gcc version you have (and if you are a distro, you can surely fix
> that)
>
>>
>> The interesting questions are:
>> Does -Os still sometimes generate faster code with gcc 4.2?
>> If yes, why?
>
> on a system level, size can help performance because you have more
> memory available for other things.  It also reduces download size and
> gives you more space on the live CD....
>
> if you want to make things bigger again, please do this OUTSIDE the
> "optimize for size" option. Because that TELLS you to go for size.

then do we need a new option 'optimize for best overall performance' that 
goes for size (and the corresponding wins there) most of the time, but is 
ignored where it makes a huge difference?

I started useing Os several years ago, even when it was hidden in the 
embedded menu becouse in many cases the smaller binary ended up being 
faster.

in reality this was a flaw in gcc that on modern CPU's with the larger 
difference between CPU speed and memory speed it still preferred to unroll 
loops (eating more memory and blowing out the cpu cache) when it shouldn't 
have.

if that has been fixed on later versions of gcc this would be a good 
thing. if it hasn't (possibly in part due to gcc optimizations being 
designed to be cross platform) then either the current 'go for size' or a 
hybrid 'performance' option is needed.

David Lang
