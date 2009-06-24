Return-Path: <linux-kernel-owner+w=401wt.eu-S1759445AbZFXNgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445AbZFXNgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 09:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbZFXNgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 09:36:37 -0400
Received: from smtp.nokia.com ([192.100.105.134]:20833 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZFXNgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 09:36:37 -0400
Date: Wed, 24 Jun 2009 16:35:58 +0300
From: Imre Deak <imre.deak@nokia.com>
To: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       "Valkeinen Tomi (Nokia-D/Helsinki)" <Tomi.Valkeinen@nokia.com>
Subject: Re: [PATCH 16/20] omapfb: dispc: Allow multiple external IRQ
	handlers
Message-ID: <20090624133558.GB14577@localhost>
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com> <a9da40529f3dc3d0bf304c4d15cb45f1af8ae150.1245842329.git.imre.deak@nokia.com> <20090624121608.GA17604@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624121608.GA17604@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 24 Jun 2009 13:36:08.0370 (UTC) FILETIME=[BAF40920:01C9F4D0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 02:16:08PM +0200, Balbi Felipe (Nokia-D/Helsinki) wrote:
> On Wed, Jun 24, 2009 at 01:33:41PM +0200, Deak Imre (Nokia-D/Helsinki) wrote:
> > From: Daniel Stone <daniel.stone@nokia.com>
> > 
> > Previously, the only external (to dispc.c) IRQ handler was RFBI's
> > frame done handler.  dispc's IRQ framework was very dumb: you could only
> > have one handler, and the semantics of {request,free}_irq were odd, to
> > say the least.
> > 
> > The new framework allows multiple consumers to register arbitrary IRQ
> > masks.
> 
> No chance to use genirq ?
> 
> Then rfbi and others could simply request_irq() as usual

The problem with that is that we want to register handlers to take
care of - possibly - multiple interrupt events. We do this by passing
a mask of events to our IRQ register function, that the handler should
be called for.

With the current genirq interface this is not possible, thus we
need our own implementation.

--Imre

