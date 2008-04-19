Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbYDSBTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbYDSBTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 21:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYDSBS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 21:18:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbYDSBS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 21:18:58 -0400
Date: Fri, 18 Apr 2008 18:17:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: rmk@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk,
       kernel@wantstofly.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] ARM minor irq handler cleanups
Message-Id: <20080418181741.d6f365c5.akpm@linux-foundation.org>
In-Reply-To: <48093AF3.2080807@garzik.org>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
	<20080418164411.b1e1628d.akpm@linux-foundation.org>
	<48093AF3.2080807@garzik.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 20:21:07 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> Andrew Morton wrote:
> > On Fri, 18 Apr 2008 19:22:45 -0400 (EDT)
> > Jeff Garzik <jeff@garzik.org> wrote:
> > 
> >> Avoid confusion by /not/ passing an unused pointer to
> >> arm_rtc_interrupt()
> >>
> >> This change's main purpose is to prepare for the patchset in
> >> jgarzik/misc-2.6.git#irq-remove, that explores removal of the
> >> never-used 'irq' argument in each interrupt handler.
> > 
> > #irq-remove doesn't seem to be included in the #ALL branch which
> > I'm grabbing?
> 
> I certainly welcome the exposure.......  but it would be a huge pain for 
> you IMO because of the constant breakage.
> 

wow.

 1084 files changed, 2363 insertions(+), 1934 deletions(-)

I didn't realise you'd changed all the interrupt handlers too.  Good luck
with that :)

Is it a flag day or do we have a migration plan?  I'd have thought that we
could do a request_irq_new(irqreturn_t (*)(void *d)) and keep things
compatible?



<checks>

Actually, that tree applies reasonably sanely to the full -mm lineup. 
There are rejects of course, but they're easily fixed and a lot are due to
file motion which git will handle anyway,

The bigger problem is newly-added irq handlers which your patch doesn't
know about:

y:/usr/src/25> grep '^+.*request_irq[(]' patches/*.patch | wc -l
74

If we had a migration plan (ie: request_irq_new(), above) then this of
course wouldn't be a problem.

