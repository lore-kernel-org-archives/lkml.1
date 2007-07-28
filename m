Return-Path: <linux-kernel-owner+w=401wt.eu-S1761330AbXG1LPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbXG1LPT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 07:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbXG1LPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 07:15:08 -0400
Received: from [212.12.190.100] ([212.12.190.100]:33319 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754614AbXG1LPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 07:15:06 -0400
From: Al Boldi <a1426z@gawab.com>
To: Chris Snook <csnook@redhat.com>
Subject: Re: How can we make page replacement smarter (was: swap-prefetch)
Date: Sat, 28 Jul 2007 14:11:57 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <200707272243.02336.a1426z@gawab.com> <200707280717.41250.a1426z@gawab.com> <46AAEFC4.8000006@redhat.com>
In-Reply-To: <46AAEFC4.8000006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707281411.57823.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Al Boldi wrote:
> > Because it is hard to quantify the expected swap-in speed for random
> > pages, let's first tackle the swap-in of consecutive pages, which should
> > be at least as fast as swap-out.  So again, why is swap-in so slow?
>
> If I'm writing 20 pages to swap, I can find a suitable chunk of swap and
> write them all in one place.  If I'm reading 20 pages from swap, they
> could be anywhere.  Also, writes get buffered at one or more layers of
> hardware.

Ok, this explains swap-in of random pages.  Makes sense, but it doesn't 
explain the awful tmpfs performance degradation of consecutive read-in runs 
from swap, which should have at least stayed constant

> At best, reads can be read-ahead and cached, which is why
> sequential swap-in sucks less.  On-demand reads are as expensive as I/O
> can get.

Which means that it should be at least as fast as swap-out, even faster 
because write to disk is usually slower than read on modern disks.  But 
linux currently shows a distinct 2x slowdown for sequential swap-in wrt 
swap-out.  And to prove this point, just try suspend to disk where you can 
see sequential swap-out being reported at about twice the speed of 
sequential swap-in on resume.  Why is that?


Thanks!

--
Al

