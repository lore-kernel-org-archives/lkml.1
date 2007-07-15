Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbXGORgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbXGORgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 13:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760109AbXGORgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 13:36:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41408 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760050AbXGORgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 13:36:03 -0400
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
From: Arjan van de Ven <arjan@infradead.org>
To: 7eggert@gmx.de
Cc: Matt Mackall <mpm@selenic.com>, Rene Herman <rene.herman@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
In-Reply-To: <E1IA7j1-0000j9-I3@be1.lrz>
References: <8FO1e-2jW-35@gated-at.bofh.it> <8FYWD-2eS-7@gated-at.bofh.it>
	 <8GdsH-8dc-13@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>
	 <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it>
	 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>
	 <E1IA7j1-0000j9-I3@be1.lrz>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 15 Jul 2007 10:35:17 -0700
Message-Id: <1184520917.3153.4.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 19:17 +0200, Bodo Eggert wrote:
> Matt Mackall <mpm@selenic.com> wrote:
> > On Fri, Jul 13, 2007 at 03:20:54PM +0200, Rene Herman wrote:
> 
> >> As far as I'm aware, the actual reason for 4K stacks is that after the
> >> system has been up and running for some time getting "1 physically
> >> contiguous pages" becomes significantly easier than 2 which wouldn't be
> >> arbitrary.
> > 
> > If there are exactly two free pages in the system, the odds of them
> > being buddies (ie adjacent AND properly aligned) is quite small. The
> > available page pool has to grow quite a bit before the availability of
> > order-1 page pairs approaches 100%.
> 
> If there are exactly two free pages in a system, the odds of starting any
> program are not very good. You'll have to swap, and if you do, you can swap
> two more pages in order to free enough RAM for the stack.


even if you have several thousand pages the odds aren't good; or rather,
they start out reasonably ok until something starts eating very
deliberately at the 8k pages pool, for example the new app creating
about 10 threads....

The 4K issue is "tricky", only a few selected workload/compiler combos
seem to hit the dirt, yet distros like Fedora and RHEL use 4K stacks
since forever, and if it gave massive problems they wouldn't do that.
On the upside, especially on very-threaded workloads, it helps
reliability and the VM a lot...


