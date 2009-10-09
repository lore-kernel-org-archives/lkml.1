Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbZJILmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbZJILmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 07:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZJILmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 07:42:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32808 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbZJILmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 07:42:15 -0400
Subject: Re: [regressions] Re: kbuild: save ARCH & CROSS_COMPILE when
 building a kernel
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1255078731.17055.39.camel@laptop>
References: <20091003103441.GA10874@elte.hu>
	 <1255078731.17055.39.camel@laptop>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 13:41:24 +0200
Message-Id: <1255088484.8802.55.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 10:58 +0200, Peter Zijlstra wrote:
> On Sat, 2009-10-03 at 12:34 +0200, Ingo Molnar wrote:
> > 
> > that arch-cache thing introduced in:
> > 
> >  5755433: kbuild: save ARCH & CROSS_COMPILE when building a kernel
> > 
> > isnt working very well in my experience.
> 
> Its breaking things for me too. When I build a .config using distcc and
> cross compilers on my build farm, and then try a make install on another
> machine which doesn't have either it utterly shits itself.

It also wrecks the online/offline workflow I have.

When connected with 10gbe I use the build cluster from my laptop, when
wireless or offline I clearly cannot use distcc.

My scripts automagically do this right, except now they barf.

It basically means I have to now script around this crap by trap'ing the
build script and always deleting the $BUILD_DIR/include/generated crap.

Is there really anybody out there who hasn't scripted their distcc/cross
build stuff and types that incredibly long make line every time?

