Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbXESXzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbXESXzd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 19:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbXESXz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 19:55:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:38247 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbXESXzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 19:55:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XEKghGA1SM9bMxtr5u9UfBsSLQ3WDC3U0CJiZCZ5sz/ySzyxNKy79jlQfiK0TdNYi5HIhbn+WB4wi1i5yw0yydI+RarYkayAmRpOnMF/u30JXAQ0B7rP6bLMXmYN6a6h0/8t1WZ0ulkZmBm7hBb0QfINyCfIeiZ+6HssBJjcUU8=
Message-ID: <a781481a0705191655t8e305aage47fb063c55ab86a@mail.gmail.com>
Date: Sun, 20 May 2007 05:25:24 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>
In-Reply-To: <20070519234844.GN6291@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <20070519110944.2a52061e.akpm@linux-foundation.org>
	 <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com>
	 <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com>
	 <20070519230940.GJ6291@stusta.de>
	 <a781481a0705191617v901ac64nfa7040ff302d2da1@mail.gmail.com>
	 <20070519232542.GL6291@stusta.de>
	 <a781481a0705191636i371da96fxc0e9805778afad78@mail.gmail.com>
	 <20070519234844.GN6291@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Sun, May 20, 2007 at 05:06:33AM +0530, Satyam Sharma wrote:
> > On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> >>...
> >> Consider ATARI_KBD_CORE was used by 20 drivers.
> >>
> >> Using select for such not user visible helper variables is a really nice
> >> thing, and much more readable (and therefore much less likely to contain
> >> bugs) than dependencies with tons of "||"'s.
> >
> > Well, the "default .. if .." kind of idiom is fairly common (I could say
> > almost standard), in arch/.../config's. It's been used for some time,
> > and for several symbols over there. But you're right that if 20 drivers
> > used ATARI_KBD_CORE, we'd get tons of ugly "||"'s there, so
> > perhaps we do need some kind of fix for this.
>
> And the fix is to use select.
>
> Compare the handling of options like IRQ_CPU in arch/mips/Kconfig in
> current kernels with the handling in kernel 2.6.0 .
>
> Or as an exercise, change drivers/net/Kconfig to no longer use
> "select MII". When you are finished, ensure that you are handling it
> properly although the option is user visible...

"config MII" and "select MII" are _not_ equivalent to the case at hand.
MII is defined in drivers/net/Kconfig itself so does not print any "symbol
unknown kind of warnings" ... so clearly no probs in "select" for it ...

> There are cases where "default .. if .." is the right idiom, but there
> are also cases where "select" is the right idiom. And for helper code
> like ATARI_KBD_CORE, "select" is the right idiom.

ATARI_KBD_CORE, unlike MII, is defined only by some archs. And the
correct (most widely used or standard, in any case) idiom for that is
"default .. if ..". Or perhaps you can convert those helper code options in
arch/.../config's over to select too, as an exercise? :-)
