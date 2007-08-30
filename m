Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbXH3HUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbXH3HUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 03:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXH3HUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 03:20:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47279 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbXH3HUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 03:20:35 -0400
Date: Thu, 30 Aug 2007 09:20:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@gmail.com>
Cc: keith.packard@intel.com, Al Boldi <a1426z@gawab.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       dri-devel@lists.sourceforge.net
Subject: Re: CFS review
Message-ID: <20070830072014.GB507@elte.hu>
References: <20070827204116.GA12495@elte.hu> <200708280737.53439.a1426z@gawab.com> <20070829041827.GA8733@elte.hu> <1188361749.21502.123.camel@koto.keithp.com> <20070829044614.GA13225@elte.hu> <1188374249.21502.155.camel@koto.keithp.com> <20070829080417.GB19386@elte.hu> <1188403075.21502.158.camel@koto.keithp.com> <46D5CF5F.6090505@gmail.com> <46D66C2D.3010900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D66C2D.3010900@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@gmail.com> wrote:

> Realised the BUGs may mean the kernel DRM people could want to be in CC...

and note that the schedule() call in there is not part of the crash 
backtrace:

> >Call Trace:
> > [<c10fa54b>] drm_lock+0x255/0x2de
> > [<c10ff28d>] mga_dma_buffers+0x0/0x2e3
> > [<c10f87fc>] drm_ioctl+0x142/0x18a
> > [<c1005973>] do_IRQ+0x97/0xb0
> > [<c10f86ba>] drm_ioctl+0x0/0x18a
> > [<c10f86ba>] drm_ioctl+0x0/0x18a
> > [<c105b0d7>] do_ioctl+0x87/0x9f
> > [<c105b32c>] vfs_ioctl+0x23d/0x250
> > [<c11b533e>] schedule+0x2d0/0x2e6
> > [<c105b372>] sys_ioctl+0x33/0x4d
> > [<c1003d1e>] syscall_call+0x7/0xb

it just happened to be on the kernel stack. Nor is the do_IRQ() entry 
real. Both are frequent functions (and were executed recently) that's 
why they were still in the stackframe.

	Ingo
