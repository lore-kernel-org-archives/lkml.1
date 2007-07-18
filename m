Return-Path: <linux-kernel-owner+w=401wt.eu-S1763720AbXGRWYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763720AbXGRWYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759098AbXGRWYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:24:23 -0400
Received: from rudolph.anywherehost.net ([66.209.70.169]:59989 "EHLO
	rudolph.anywherehost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759085AbXGRWYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:24:23 -0400
From: "Or Sagi" <ors@tutis.com>
To: "'Dor Laor'" <dor.laor@qumranet.com>,
       "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: <kvm-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
References: <005901c7c921$79c006c0$6d401440$@com><20070718123040.615795b7@the-village.bc.nu><64F9B87B6B770947A9F8391472E032160CC16C92@ehost011-8.exch011.intermedia.net><20070718174736.0baf6d0e@the-village.bc.nu><469E43D5.70802@qumranet.com><64F9B87B6B770947A9F8391472E032160CC16D06@ehost011-8.exch011.intermedia.net> <20070718183358.0a0886aa@the-village.bc.nu> <64F9B87B6B770947A9F8391472E032160CC16F3C@ehost011-8.exch011.intermedia.net>
In-Reply-To: <64F9B87B6B770947A9F8391472E032160CC16F3C@ehost011-8.exch011.intermedia.net>
Subject: RE: [kvm-devel] [RFC] Deferred interrupt handling.
Date: Thu, 19 Jul 2007 01:23:09 +0300
Message-ID: <002601c7c98a$49ab9580$dd02c080$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcfJYOTJIKvWN1iWTES0RmzKhTSfSwAGbBaQAAO2/ZA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hope it should work like the following [Please correct me if I'm
> wrong]:
> - Make the device the last irqaction in the list
> - Our dummy handler will always return IRQ_HANDLED in case any other
> previous
>   irqaction did not return such. It will also issue the timer and mask
> the irq in this case.
>   The line is temporarily jammed but not disabled - note_interrupt()
> will not consider
>   our irq unhandled and won't disable it.
>   btw, if I'm not mistaken only after bad 99900/100000 the irq is
> disabled.
> - If the timer pops before the guest acks the irq, the timer handler
> will
>   ack the irq and unmask it. The timer's job is only to prevent
> deadlocks.
> 
> Maybe it's better to code it first then send RFC.

Definitely. We've already agreed that it's correct for the (rare, 
unfortunately) non shared scenario. Let's see how much do we have to bend 
reality to fit once it's in code form.

-- Ors.


