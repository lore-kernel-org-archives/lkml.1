Return-Path: <linux-kernel-owner+w=401wt.eu-S1757046AbXFYHDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbXFYHDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbXFYHDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:03:40 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:54153 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbXFYHDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:03:40 -0400
In-Reply-To: <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm>
References: <467cac85.081b600a.5b88.457f@mx.google.com>  <E1I20Wr-00064i-T0@flower> <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com>  <20070624222518.GA10398@flower.upol.cz>  <1182723318.6819.5.camel@laptopd505.fenrus.org> <20070624232314.GA971@kvack.org>  <1182730156.6819.8.camel@laptopd505.fenrus.org> <20070625001203.GB971@kvack.org>  <1182731022.6819.10.camel@laptopd505.fenrus.org> <20070625004106.GA1094@stusta.de> <1182733127.6819.13.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <d66e01c9d04540d058a93d5b70421985@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       Oleg Verych <olecom@flower.upol.cz>, rae l <crquan@gmail.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: -Os versus -O2
Date: Mon, 25 Jun 2007 09:03:35 +0200
To: david@lang.hm
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> then do we need a new option 'optimize for best overall performance' 
> that goes for size (and the corresponding wins there) most of the 
> time, but is ignored where it makes a huge difference?

That's -Os mostly.  Some awful CPUs really need higher
loop/label/function alignment though to get any
performance; you could add -falign-xxx options for those.

> in reality this was a flaw in gcc that on modern CPU's with the larger 
> difference between CPU speed and memory speed it still preferred to 
> unroll loops (eating more memory and blowing out the cpu cache) when 
> it shouldn't have.

You told it to unroll loops, so it did.  No flaw.  If you
feel the optimisations enabled by -O2 should depend on the
CPU tuning selected, please file a PR.

Also note that whether or not it is profitable to unroll
a particular loop depends largely on how "hot" that loop
is, and GCC doesn't know much about that if you don't feed
it profiling information (it can guess a bit, sure, but it
can guess wrong too).


Segher

