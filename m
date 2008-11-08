Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYKHWR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYKHWR5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 17:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbYKHWRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 17:17:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:44916 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYKHWRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 17:17:49 -0500
Subject: Re: [PATCH 1/1] irq: Maintain user set affinity
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Yinghai Lu <yinghai@kernel.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Andrew Morton <akpm@osdl.org>, linuxppc-dev@ozlabs.org
In-Reply-To: <86802c440811081412u6d54beaam143801ce83225f40@mail.gmail.com>
References: <Pine.LNX.4.64.0811041030520.25054@blarg.am.freescale.net>
	 <86802c440811081412u6d54beaam143801ce83225f40@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 09 Nov 2008 09:17:24 +1100
Message-Id: <1226182645.13603.90.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-08 at 14:12 -0800, Yinghai Lu wrote:
> On Tue, Nov 4, 2008 at 8:31 AM, Kumar Gala <galak@kernel.crashing.org> wrote:
> > From 819ad3ed4660f4238e053728a8b5aa93d22b13d7 Mon Sep 17 00:00:00 2001
> > From: Kumar Gala <galak@kernel.crashing.org>
> > Date: Tue, 4 Nov 2008 10:13:53 -0600
> > Subject: [PATCH 1/1] irq: Maintain user set affinity
> >
> > This addresses a regression in that if a user specified an affinity
> > for an interrupt that affinity information would get reset between
> > a request_irq(), free_irq() and request_irq() for the same irq.
> >
> > On example of this is bringing up an ethernet interface, taking
> > it down and bringing it back up again.
> >
> > Instead of always using the irq_default_affinity we use the
> > previous setting of the IRQs affinity with the assumption that
> > at boot the IRQs affinity will be set to irq_default_affinity.
> 
> why ?, the default_affinity is expected behavior...
> 
> for example: when MSI is used, second driver could get same irq if
> first driver is unloaded.

The default affinity should be set when the irq is allocated / assigned
to a device, not when it's requested.

Ben.


