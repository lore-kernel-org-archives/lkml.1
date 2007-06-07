Return-Path: <linux-kernel-owner+w=401wt.eu-S966366AbXFGWsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966366AbXFGWsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 18:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936592AbXFGWrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 18:47:49 -0400
Received: from havoc.gtf.org ([69.61.125.42]:55179 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765977AbXFGWrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 18:47:48 -0400
Date: Thu, 7 Jun 2007 18:47:46 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Gregor Jasny <gjasny@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: Linux v2.6.22-rc3
Message-ID: <20070607224746.GA23290@havoc.gtf.org>
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org> <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com> <466196AD.3090502@garzik.org> <9d2cd630706031046n2bd77585o7c0df1c5fea5167f@mail.gmail.com> <46667466.4010500@gmail.com> <9d2cd630706062322v2d73b32dp1da56f97e2069fff@mail.gmail.com> <4667B347.9040900@gmail.com> <alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706071352440.4205@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2007 at 01:56:11PM -0700, Linus Torvalds wrote:
> On Thu, 7 Jun 2007, Tejun Heo wrote:
> > Ah.. okay.  Now I see what's going on.  Jeff, this is another device
> > which doesn't set nsect and lbal to 1 after reset.  Gregor, please try
> > the attached patch.

> Tejun, since Jeff is apparently traveling this week, and Gregor tested the 
> patch successfully (and it looks sane anyway - why in Gods name _would_ we 
> care what the initial setting of nsect/lbal is?), can you send this in 
> with the changelog and sign-off?

Ack'ing the sata_promise change was easy, but with this one it would
be nice to wait a bit before changing the core probe code that [now]
every ATA setup goes through, based on a single bug report.

The values assist in detecting ghost devices (same device appearing
on both master and slave) and TF register malfunctions, and I would
appreciate not breaking _that_ so late in 2.6.22-rc for a single
report.  Thankfully we have -some- ghost device prevention code
elsewhere, but this is part of it.

Fedora 7 reports are starting to come in, and those will help point
us in the right direction too.

I'll be home for a bit in 36 hours (->net driver fixes go then)
and for good on Tuesday, so I'm hoping you can wait until then.

	Jeff



