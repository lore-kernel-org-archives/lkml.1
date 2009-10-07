Return-Path: <linux-kernel-owner+w=401wt.eu-S1758917AbZJGKso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917AbZJGKso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbZJGKsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:48:43 -0400
Received: from www.tglx.de ([62.245.132.106]:37151 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758827AbZJGKsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:48:42 -0400
Date: Wed, 7 Oct 2009 12:47:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: Using set_irq_handler in set_irq_type callback?
In-Reply-To: <20091007102836.GA27860@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0910071245190.9428@localhost.localdomain>
References: <20091007100756.GA5478@pengutronix.de> <20091007102836.GA27860@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1619488404-1254912478=:9428"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1619488404-1254912478=:9428
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 7 Oct 2009, Russell King wrote:
> On Wed, Oct 07, 2009 at 12:07:56PM +0200, Uwe Kleine-König wrote:
> When it comes to RT and its thread-based interrupt model, the assumptions
> which these handlers were designed around are no longer true.  What is
> now required is a different handling philosophy - rather than leaving
> the interrupt-time decision about what to do with a signalled interrupt
> to the flow handler, it should be immediately ack'ed and disabled, and
> the interrupt thread scheduled.

That's what the code does at least for the level handler. When the
thread has run then the irq line is reenabled.
 
> It is then up to the interrupt thread to determine how to handle the
> interrupt - if it's really a level interrupt, then the interrupt thread
> has to call the handlers before re-enabling the input.  If it's edge
> based, the input has to be re-enabled before running the handlers (so
> that new edges received during the running of those handlers are
> recognised.)

That's exaclty how the RT code works :) 
 
> So, the technical aspects of handling of interrupts between the RT and
> non-RT cases are quite different, and I feel that we shouldn't be
> re-using the same flow handlers between the two cases.

Why not. It works perfectly fine except for the case where a level
type interrupt uses the edge handler :)

Thanks,

	tglx
--8323328-1619488404-1254912478=:9428--
