Return-Path: <linux-kernel-owner+w=401wt.eu-S934108AbZLPOFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108AbZLPOFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934023AbZLPOFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:05:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38840 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934033AbZLPOFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:05:12 -0500
Date: Wed, 16 Dec 2009 15:04:27 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, xiyou.wangcong@gmail.com,
       x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: [PATCH] irq: handle irq0 special only on x86
Message-ID: <20091216140427.GD3674@pengutronix.de>
References: <1260350401-9858-1-git-send-email-u.kleine-koenig@pengutronix.de> <2375c9f90912090128k70f54ee1n99421caa81c53a8f@mail.gmail.com> <20091209.014151.140337246.davem@davemloft.net> <20091210082452.GA2420@pengutronix.de> <4B21246B.4070804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B21246B.4070804@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 08:40:11AM -0800, H. Peter Anvin wrote:
> On 12/10/2009 12:24 AM, Uwe Kleine-König wrote:
> > 
> > Note, I fully agree to use 0 for NO_IRQ if you have an int-sized value
> > that holds either NO_IRQ or a valid irq number.  But in practise I'd not
> > recommend to use this idiom.
> > 
> 
> You're tilting at windmills about something that was settled long ago,
> like it or not.
And what about the patch, not judging my comments about irq0 in general?

AFAICT the check in try_misrouted_irq for irq being not zero does only
make sense on x86, doesn't it?

The comment a few lines above the check reads:

	But for 'irqfixup == 2' we also do it for handled interrupts if
	they are marked as IRQF_IRQPOLL (or for irq zero, which is the
	traditional PC timer interrupt.. Legacy)

So I think the patch is justified.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
