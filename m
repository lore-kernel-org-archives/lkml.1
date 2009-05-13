Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZEMOZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZEMOZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbZEMOZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:25:45 -0400
Received: from waste.org ([66.93.16.53]:44317 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbZEMOZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:25:44 -0400
Date: Wed, 13 May 2009 09:25:38 -0500
From: Matt Mackall <mpm@selenic.com>
To: Chris Peterson <cpeterso@cpeterso.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [resend] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Message-ID: <20090513142535.GB31071@waste.org>
References: <alpine.DEB.2.00.0905130118140.15823@ubuntu-desktop> <20090513060850.GZ31071@waste.org> <a24804730905130017t545b7645x71ab7a1c8ab4af78@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a24804730905130017t545b7645x71ab7a1c8ab4af78@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 12:17:29AM -0700, Chris Peterson wrote:
> > The future model will continue to sample network
> > devices on theory that they -might- be less than 100% observable and
> > that can only increase our total (unmeasurable) amount of entropy.
> 
> That sounds reasonable to me. So should all net drivers now specify
> IRQF_SAMPLE_RANDOM?
> 
> Or even simpler: could request_irq() assume IRQF_SAMPLE_RANDOM for any
> interrupt that is not (say) IRQF_IRQPOLL or IRQF_PERCPU?

Maybe. We don't want IRQ latency to suffer. So before we turn on
sampling of -all- sources, we need to make sampling lighter weight and
we need a way to say 'we have enough' so that we're not consuming CPU
when our pools are 'full'. We could turn it on now and rely on the
current trickle logic, but it's nice to have the water main off when
doing significant plumbing.

-- 
Mathematics is the supreme nostalgia of our time.
