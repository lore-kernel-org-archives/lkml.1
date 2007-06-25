Return-Path: <linux-kernel-owner+w=401wt.eu-S1752233AbXFYIWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbXFYIWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 04:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbXFYIWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 04:22:34 -0400
Received: from 1wt.eu ([62.212.114.60]:3163 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbXFYIWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 04:22:33 -0400
Date: Mon, 25 Jun 2007 10:19:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@stusta.de>,
       david@lang.hm, Oleg Verych <olecom@flower.upol.cz>,
       rae l <crquan@gmail.com>
Subject: Re: -Os versus -O2
Message-ID: <20070625081905.GA15209@1wt.eu>
References: <1182730156.6819.8.camel@laptopd505.fenrus.org> <20070625001203.GB971@kvack.org> <1182731022.6819.10.camel@laptopd505.fenrus.org> <20070625004106.GA1094@stusta.de> <1182733127.6819.13.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241801320.10397@asgard.lang.hm> <1182734240.26621.2.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0706241824080.10397@asgard.lang.hm> <20070625050424.GZ943@1wt.eu> <e6d26e7ee86cc527095de2716f285aff@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6d26e7ee86cc527095de2716f285aff@kernel.crashing.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 09:08:23AM +0200, Segher Boessenkool wrote:
> >In my experience, -Os produced faster code on gcc-2.95 than -O2 or -O3.
> 
> On what CPU?  The effect of different optimisations varies
> hugely between different CPUs (and architectures).

x86

> >It was not only because of cache considerations, but because gcc used
> >different tricks to avoid poor optimizations, and at the end, the CPU
> >ended executing the alternative code faster.
> 
> -Os is "as fast as you can without bloating the code size",
> so that is the expected result for CPUs that don't need
> special hand-holding around certain performance pitfalls.
> 
> >With gcc-3.3, -Os show roughly the same performance as -O2 for me on
> >various programs. However, with gcc-3.4, I noticed a slow down with
> >-Os. And with gcc-4, using -Os optimizes only for size, even if the
> >output code is slow as hell. I've had programs whose speed dropped
> >by 70% using -Os on gcc-4.
> 
> Well you better report those!  <http://gcc.gnu.org/bugzilla>

No, -Os is for size only :

       -Os Optimize for size.  -Os enables all -O2 optimizations
           that do not typically increase code size.  It also
           performs further optimizations designed to reduce code
           size.

So it is expected that speed can be reduced using -Os. I won't report
a thing which is already documented !

> >But in some situtations, it's desirable to have the smallest possible
> >kernel whatever its performance. This goes for installation CDs for
> >instance.
> 
> There are much better ways to achieve that.

Optimizing is not a matter of choosing *one* way, but cumulating
everything you have. For instance, on a smart boot loader, I have
a kernel which is about 300 kB, or 700 kB with the initramfs. Among
the tricks I used :
  - -Os
  - -march=i386
  - align everything to 0
  - replace gzip with p7zip

Even if each of them reduces overall size by 5%, the net result is
0.95^4 = 0.81 = 19% gain, for the same set of features. This is
something to consider.

Regards,
Willy

