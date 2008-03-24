Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbYCXV61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbYCXV61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 17:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYCXV6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 17:58:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40856 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYCXV6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 17:58:11 -0400
Date: Mon, 24 Mar 2008 22:58:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Wouter Verhelst <w@uter.be>
Cc: Paul Clements <paul.clements@steeleye.com>,
       nbd-general@lists.sourceforge.net,
       Laurent Vivier <Laurent.Vivier@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Nbd] [PATCH 1/1] NBD: allow nbd to be used locally
Message-ID: <20080324215846.GA4494@elf.ucw.cz>
References: <47D468F0.8000506@steeleye.com> <20080310102917.GA27751@elf.ucw.cz> <47D56F4A.5070208@steeleye.com> <20080311100904.GA807@elf.ucw.cz> <20080324203744.GA13603@goa.grep.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324203744.GA13603@goa.grep.be>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >>> This patch allows a Network Block Device to be mounted locally 
> > >>> (nbd-client to nbd-server over 127.0.0.1).
> > >>>
> > >>> It creates a kthread to avoid the deadlock described in NBD tools 
> > >>> documentation. So, if nbd-client hangs waiting for pages, the kblockd 
> > >>> thread can continue its work and free pages.
> > >>
> > >> What happens if your new kthread blocks on memory allocation?
> > >
> > > Well, we expect that. The reason for the new thread is so that it hangs, 
> > > rather than kblockd hanging (which on a UP system brings all I/O to a 
> > > halt). As long as kblockd can continue making progress, we eventually free 
> > > up memory and then NBD can finish its requests, too.
> > 
> > ....unless all the memory is in dirty buffers for nbd, and nbd server
> > is swapped out or something?
> 
> Note that I'm not a kernel hacker, so might be terribly mistaken here...
> 
> but I feel I should point out that this patch solves the issue that no
> two block devices can flush their dirty buffers at the same time.
> Without this patch, you can't write to a _filesystem_ on an NBD device
> if that's connected to a server on the localhost. You are correct that
> this does not solve the deadlock in swapping to NBD devices, but that's
> not the only existing deadlock issue in NBD to localhost...

Same issue with swapping probably exists with dirty block
writeout... swapoff -a, and filesystem becomes very similar to swap.

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
