Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZEMT5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZEMT5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZEMT4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:56:49 -0400
Received: from waste.org ([66.93.16.53]:45261 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbZEMT4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:56:48 -0400
Date: Wed, 13 May 2009 14:55:19 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Chris Peterson <cpeterso@cpeterso.com>, linux-kernel@vger.kernel.org,
       NetDev <netdev@vger.kernel.org>
Subject: Re: [PATCH] [resend] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Message-ID: <20090513195519.GL31071@waste.org>
References: <alpine.DEB.2.00.0905130118140.15823@ubuntu-desktop> <20090513060850.GZ31071@waste.org> <a24804730905130017t545b7645x71ab7a1c8ab4af78@mail.gmail.com> <20090513142535.GB31071@waste.org> <4A0B21DF.9050702@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0B21DF.9050702@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 03:39:11PM -0400, Jeff Garzik wrote:
> Matt Mackall wrote:
> >On Wed, May 13, 2009 at 12:17:29AM -0700, Chris Peterson wrote:
> >>>The future model will continue to sample network
> >>>devices on theory that they -might- be less than 100% observable and
> >>>that can only increase our total (unmeasurable) amount of entropy.
> >>That sounds reasonable to me. So should all net drivers now specify
> >>IRQF_SAMPLE_RANDOM?
> >>
> >>Or even simpler: could request_irq() assume IRQF_SAMPLE_RANDOM for any
> >>interrupt that is not (say) IRQF_IRQPOLL or IRQF_PERCPU?
> >
> >Maybe. We don't want IRQ latency to suffer. So before we turn on
> >sampling of -all- sources, we need to make sampling lighter weight and
> >we need a way to say 'we have enough' so that we're not consuming CPU
> >when our pools are 'full'. We could turn it on now and rely on the
> >current trickle logic, but it's nice to have the water main off when
> >doing significant plumbing.
> 
> So, until such time, let's be consistent in net driver land and not 
> IRQF_SAMPLE_RANDOM.
> 
> 	Jeff

If you want. I was also looking to avoid the fight that happened when
I submitted an equivalent patch a couple years back.

-- 
Mathematics is the supreme nostalgia of our time.
