Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbXFYHfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbXFYHfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXFYHfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:35:39 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:34422 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbXFYHfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:35:39 -0400
In-Reply-To: <Pine.LNX.4.64.0706250010360.6215@asgard.lang.hm>
References: <467cac85.081b600a.5b88.457f@mx.google.com>  <E1I20Wr-00064i-T0@flower> <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com>  <20070624222518.GA10398@flower.upol.cz>  <1182723318.6819.5.camel@laptopd505.fenrus.org> <20070624232314.GA971@kvack.org>  <1182730156.6819.8.camel@laptopd505.fenrus.org> <20070625001203.GB971@kvack.org>  <1182731022.6819.10.camel@laptopd505.fenrus.org> <20070625004106.GA1094@stusta.de> <1182733127.6819.13.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm> <d66e01c9d04540d058a93d5b70421985@kernel.crashing.org> <Pine.LNX.4.64.0706250010360.6215@asgard.lang.hm>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <caabc5ee6a77124d76d3489d82fb76dc@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       Oleg Verych <olecom@flower.upol.cz>, rae l <crquan@gmail.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: -Os versus -O2
Date: Mon, 25 Jun 2007 09:35:33 +0200
To: david@lang.hm
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Also note that whether or not it is profitable to unroll
>> a particular loop depends largely on how "hot" that loop
>> is, and GCC doesn't know much about that if you don't feed
>> it profiling information (it can guess a bit, sure, but it
>> can guess wrong too).
>
> actually, what you are saying is that the compiler can't know enough 
> to figure out how to optimize for speed. it will just do what you tell 
> it to, either unroll loops or not.

It bases its optimisation decisions on the options you give
it, the profile feedback information you either or not gave
it, and a whole bunch of heuristics.

> this argues that both O2 and Os are incorrect for a project to use and 
> instead the project needs to make it's own decisions on this.

For optimal performance, you need to fine-tune options yes,
per file (or per function even!)

> if this is the true feeling of the gcc team I'm very disappointed, it 
> feels like a huge step backwards.

I speak only for myself.  However this is the only way it _can_
be, the compiler isn't clairvoyant.  Some of the heuristics sure
could use some tuning, but they stay heuristics.


Segher

