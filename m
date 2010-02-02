Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab0BBAM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 19:12:27 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49816 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab0BBAM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 19:12:26 -0500
Date: Tue, 2 Feb 2010 09:12:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Magnus Damm <magnus.damm@gmail.com>,
       linux@arm.linux.org.uk, eric.y.miao@gmail.com, tony@atomide.com,
       linux-kernel@vger.kernel.org, khilman@deeprootsystems.com,
       ben-linux@fluff.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/06] ARM: SuperH Mobile ARM, sh7367 and G3EVM support
Message-ID: <20100202001217.GC13428@linux-sh.org>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se> <20100128124038.8982.82995.sendpatchset@rxone.opensource.se> <20100201141057.GB1340@ucw.cz> <20100201142605.GB13428@linux-sh.org> <63386a3d1002010819r63aae9edn2f5bc7e7f08a5fdf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d1002010819r63aae9edn2f5bc7e7f08a5fdf@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 05:19:21PM +0100, Linus Walleij wrote:
> 2010/2/1 Paul Mundt <lethal@linux-sh.org>:
> 
> > SH-Mobile (G series, in this case) is a line of SH/ARM multi-cores. They
> > contain both SH and ARM MPUs and are built up almost entirely on SH IP
> > blocks.
> 
> Jaysis, that's one odd bird. There must be some upside to designing
> things like this, is there some paper or conference presentation on the idea
> behind this thing somewhere out there? I just get very curious!
> 
Most of it comes down to customer requirements, where the application
stack is primarily running on a single MPU and the other is primarily
used as a co-processor. In the Japanese cellular market (what this series
was designed for) many people have a lot of existing ITRON code tied to
one architecture or the other that they don't wish to part with, are
unable to port, etc. a lot of that ends up being multimedia bits, but
people have done other things with it, too. We've also done SH/M32R
multi-cores in the past for similar reasons, although those had a limited
production run.

The multiple kernels on multiple CPUs thing is pretty standard for the
Japanese market at least, we face similar issues on SH SMP where we have
a need for lightweight CPU and memory hotplug/unplug in order to offline
different CPUs temporarily for one-shot ITRON/uITRON applications (which
gets to be tricky if that CPUs memory is an active NUMA node that we've
already spread allocations to), this is something quite common in
automotive at least.

The real problem with ITRON is that many of the existing applications
do fairly questionable things with register accesses, which can cause
troubles for things like dynamic clock gating and the like. On the other
hand, it only runs in a single address space, so simply paravirtualizing
the parts we care about should be lightweight enough. Outside of the
Japanese market, ITRON and its variants are much more of an unknown, so
providing Linux for both cores is becoming gradually more important. The
previous generations all contained an integrated cellular baseband which
largely restricted it to the domestic market, although this has been
changing over the last couple of years with multi-band FOMA becoming more
commonplace. In any event, things like AP4 are more intended for general
use and decouple the baseband completely.

The domestic market will likely gradually transition over to Linux on
both cores, but it will take some time, and even then we'll likely never
be rid of ITRON completely (and especially not uITRON). These CPUs have
been in the majority of Japanese cell phones for almost a decade, with a
lot of the underlying code changing very little. The ARM MPU itself is a
new addition on the side that was only added a couple of years ago, but
we still have to wait and see if people are able to make effective use of
both.

As far as public information, there's very little in either english or
japanese. I couldn't really point you at anything specific that you
couldn't find with google. In any event, now that these sorts of things
are no longer restricted to the Japanese domestic market we'll hopefully
be able to employ a greater degree of transparency.
