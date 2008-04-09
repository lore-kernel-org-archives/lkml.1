Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYDIWT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYDIWT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 18:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYDIWTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 18:19:20 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:60964
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439AbYDIWTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 18:19:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgAAHzd/Ed8qMUt/2dsb2JhbAAIrEA
X-IronPort-AV: E=Sophos;i="4.25,631,1199631600"; 
   d="scan'208";a="313723613"
Subject: Re: [BUG, bisected] atmel_spi: hard lockups in transfer
From: Ben Nizette <bn@niasdigital.com>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       kernel <kernel@avr32linux.org>, slipszi@gmail.com,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200804091400.56727.marc.pignat@hevs.ch>
References: <1207438118.3319.8.camel@moss.renham>
	 <20080406181817.5824f962@siona.local>
	 <200804091400.56727.marc.pignat@hevs.ch>
Content-Type: text/plain
Organization: Nias Digital
Date: Thu, 10 Apr 2008 07:50:49 +1000
Message-Id: <1207777849.3327.6.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-09 at 14:00 +0200, Marc Pignat wrote:
> > Ben Nizette <bn@niasdigital.com> wrote:
> > 
> > As I say, this is present in .24+ so any fix will be a stable candidate
> > as well as .25 material (if we haven't missed the boat by then).
> mainline .24+ is not affected (linux-2.6.24.3.atmel.3.tar.bz2 is).
> 

Hmm, I was sure I'd seen reports on vanilla kernels too.  I've confirmed
it's present in avr32-2.6.git/master/HEAD and the patch is in mainline
so I would expect the bug to be there, even if the symptoms are lacking.
Adding #define DEBUG to the top of atmel_spi.c changed the point at
which the bug triggers, there may be a similar coincidental
alignment-of-the-planets in mainline which means this bug doesn't
trigger at all.

Hmm..

> > 
> > I'm afraid I don't have much time to look at this right now...but I'll
> > see what I can do. It's strange that I never noticed this problem
> > myself -- I did see some overrun issues, but I blamed it on the
> > throughput improvements and just reduced the speed slightly.
> This patch seems to have problems at least on avr32, since this is only
> a speed-up patch, we should revert them.

I would think that's a good move in the short term but obviously speed
is a good thing and I would really like to see us get to the bottom of
this :-)

--Ben.

