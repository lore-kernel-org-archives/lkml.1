Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbXI3XmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbXI3XmN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbXI3Xl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:41:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42871
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbXI3Xl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:41:58 -0400
Date: Sun, 30 Sep 2007 16:41:58 -0700 (PDT)
Message-Id: <20070930.164158.41661438.davem@davemloft.net>
To: mingo@elte.hu
Cc: schwidefsky@de.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, drepper@redhat.com,
       torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH] robust futex thread exit race
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070930195538.GA13881@elte.hu>
References: <20070930171121.GA10025@elte.hu>
	<1191173530.19010.6.camel@localhost>
	<20070930195538.GA13881@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 30 Sep 2007 21:55:38 +0200

> 
> * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > On Sun, 2007-09-30 at 19:11 +0200, Ingo Molnar wrote:
> > > > > > good catch! A quick preliminary review of your patch indicates it's 
> > > > > > fine - and it might be v2.6.23 material.
> > > > > 
> > > > > there's a symmetric bug in kernel/compat_futex.c too.
> > > > 
> > > > True. I'll update the patch and send it again with the Acked-bys.
> > > 
> > > thanks! Logistics-wise: given that v2.6.22 has this same bug too, it's 
> > > not a .23 regression per se and could in theory be merged after the 
> > > 2.6.23 release too, into 2.6.23.1.
> > 
> > Here we go. Tested with current git and latest glibc tst-robust8 on 
> > s390-64, native and compat.
> 
> excellent! This patch too looks good to me. I booted and tested it on 
> x86 too (32-bit-native, 64-bit-native and 32-bit-compat-on-64-bit.)

I would personally prefer it if this patch got scheduled into
2.6.23, it is a bug fix and it might even account for some of
the futex weirdness we're still seeing on sparc64.

I'll toss this patch to some folks seeing those issues for testing.

But even if it doesn't fix their bug, it still belongs in 2.6.23 and
there is no reason to delay this fix.
