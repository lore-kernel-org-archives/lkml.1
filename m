Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZKBPMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZKBPMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbZKBPMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:12:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34010 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755241AbZKBPMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:12:39 -0500
Date: Mon, 2 Nov 2009 15:12:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd/mc13783: near complete rewrite
Message-ID: <20091102151242.GA26170@rakim.wolfsonmicro.main>
References: <1256330323-13300-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20091102115101.GF29351@sirena.org.uk>
 <20091102135827.GA4855@pengutronix.de>
 <20091102140925.GB6840@sirena.org.uk>
 <20091102143229.GB4855@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091102143229.GB4855@pengutronix.de>
X-Cookie: Nothing is but what is not.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 03:32:29PM +0100, Uwe Kleine-König wrote:

> On mc13783 the 1HZ irq triggers immediately after unmasking provided
> that it has power for more than 1s.  Because of locking the irq isn't
> recognized as 1HZ as the irqhandler tries to take the lock that the rtc
> probe function is holding and only releasing after the irq is masked.
> So for me it's just a spurious irq.

Hrm, I can't see that in the RTC driver code?  I'd have expected that if
there is a lock it'd ensure that the handler is in place before the
interrupt is unmasked.

Looking at the IRQ handler I do notice that you require all the handlers
to explicitly ack their interrupts - are there circumstances where a
handler wouldn't want to do the ack?  If there aren't it'd seem like
it'd save work to have the core driver do the acks.
