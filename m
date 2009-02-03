Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZBCVGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZBCVGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 16:06:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZBCVGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 16:06:46 -0500
Received: from gate.crashing.org ([63.228.1.57]:51725 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZBCVGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 16:06:46 -0500
Subject: Re: [Linux-fbdev-devel] [PATCH] atyfb: fix distorted image on
 PowerMacs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
Cc: Risto Suominen <risto.suominen@gmail.com>, Alex Kern <alex.kern@gmx.de>,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <20090203185624.GC22401@sci.fi>
References: <46e1c7760901221022p697f1689ubf03c909cdf1b99b@mail.gmail.com>
	 <20090122201204.GD4996@sci.fi>  <20090203185624.GC22401@sci.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Feb 2009 08:06:12 +1100
Message-Id: <1233695172.16867.91.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 20:56 +0200, Ville Syrjälä wrote:
> On Thu, Jan 22, 2009 at 10:12:04PM +0200, Ville Syrjälä wrote:
> > On Thu, Jan 22, 2009 at 08:22:48PM +0200, Risto Suominen wrote:
> > > Since the complete re-write in 2.6.10, some PowerMacs (At least PowerMac 5500
> > > and PowerMac G3 Beige rev A) with ATI Mach64 chip have suffered from unstable
> > > columns in their framebuffer image. This seems to depend on a value (4) read
> > > from PLL_EXT_CNTL register, which leads to incorrect DSP config parameters to
> > > be written to the chip. This patch uses a value calculated by aty_init_pll_ct
> > > instead, as a starting point.
> > 
> > AFAICS it should be the right thing to do on other systems too. I have
> > a good collection of mach64 pci cards and laptops so I'll try to find
> > some time next week to test that theory on x86.
> 
> Well, the experiment failed on the first Mobility I tried. The FIFO
> calculations aren't obvious from the code and there's no mention how
> to actually calculate them in the programming guide. So I guess special
> casing powermacs is the best way forward.

There's one powermac with a M1 (the first clamshell ibook). I don't have
such a machine however, it would be useful if somebody who did could
test if the patch caused a regression there...

It's possible that we should instead base the code on the chip variant.

Ben.


