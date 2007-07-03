Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbXGCNJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbXGCNJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbXGCNJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:09:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55893 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbXGCNJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:09:15 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070703094831.GA13413@enneenne.com>
References: <20070628084003.GQ13886@enneenne.com>
	 <1183031060.1170.145.camel@pmac.infradead.org>
	 <20070628161450.GD13886@enneenne.com>
	 <1183117082.1170.308.camel@pmac.infradead.org>
	 <20070629150813.GM13886@enneenne.com>
	 <1183132548.1170.360.camel@pmac.infradead.org>
	 <20070629163422.GP13886@enneenne.com>
	 <1183135253.17622.5.camel@shinybook.infradead.org>
	 <20070630171340.GT13886@enneenne.com>
	 <1183291392.2828.17.camel@shinybook.infradead.org>
	 <20070703094831.GA13413@enneenne.com>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 09:09:50 -0400
Message-Id: <1183468191.29081.17.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 11:48 +0200, Rodolfo Giometti wrote:
> On Sun, Jul 01, 2007 at 01:03:11PM +0100, David Woodhouse wrote:
> > 
> > Seems reasonable enough in principle -- but whatever you do, don't use
> > "long" for it. That would definitely need different behaviour for 32-bit
> > vs. 64-bit. Use explicitly sized types such as uint32_t or uint64_t.
> 
> Here the patch to convert LinuxPPS data structs into fixed ones.
> 
> Please, take a look at it and report possible modifications.

Looks relatively sane at first glance; busy this week so haven't looked
very hard yet. Two thing though... you're mixing proper C types
(uint32_t) and the Linux-specific legacy crap types (__u32). Pick one. I
won't recommend _which_ one, because if I do I'll make Andrew unhappy.
But pick one; don't use both at the same time.

Also read Documentation/volatile-considered-harmful.txt and ponder
deeply your use of 'volatile' on certain members of struct pps_s.

-- 
dwmw2

