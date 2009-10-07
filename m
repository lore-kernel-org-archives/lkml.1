Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbZJGDbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbZJGDbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 23:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZJGDbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 23:31:03 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:37977 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbZJGDbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 23:31:02 -0400
Date: Tue, 6 Oct 2009 22:30:06 -0500
From: David Fries <david@fries.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Joao Ramos <joao.ramos@inov.pt>, d.stussy@yahoo.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] two ide fixes for -rc4
Message-ID: <20091007033005.GE21612@spacedout.fries.net>
References: <200910070027.30377.bzolnier@gmail.com> <alpine.LFD.2.01.0910061534040.3432@localhost.localdomain> <200910070246.05283.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910070246.05283.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Tue, 06 Oct 2009 22:30:11 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 02:46:05AM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 07 October 2009 00:35:24 Linus Torvalds wrote:
> > 
> > David, can you test these on the sis5513 system that had problems with the 
> > original pio0 mode setting?
> > 
> > 	Thanks,
> > 		Linus
> > 
> > On Wed, 7 Oct 2009, Bartlomiej Zolnierkiewicz wrote:
> > > 
> > > patch #1 fixes old bug in sis5513 (uncovered by 2.6.30 device probing
> > > changes but it could be also triggered in earlier kernels on warm-plug
> > > operation)
> 
> patch #1 contained a stupid mistake preventing it from working (thanks to
> David Fries for letting me know quickly), I guess that is what one gets for
> the late night hacking..
> 
> The corrected version below, David please try it instead:
> 
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH take 2] sis5513: fix PIO setup for ATAPI devices

2.6.31 plus this patch fixed the hang on IDE initialization with the
SIS5513.

That's with my testing mode, I'm rebuilding a kernel and will try some
benchmarks tomorrow.  I've been testing by hibernating to disk,
booting the test kernel with a bad root and resume partition (so if it
worked it wouldn't modify the suspended image), then rebooting to
resume from disk with the good kernel.  That let me more quickly
bisect and test kernels, I just haven't ran this kernel much past the
initialization is all.

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
