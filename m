Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYJ2HUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYJ2HUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 03:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYJ2HUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 03:20:07 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:23880 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752020AbYJ2HUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 03:20:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3sPlSNFlouoMgJaW/qmnegpaLC2R2xQ9+2XbfrjWNGDFWmsDJvzASLzRl/ngIvhf9HrJ24QUA1PuDk/vhl9HAop14MrhC1Vsi3Puv3832va9kmyHpSunn0UT35OMRkRPQPEKD3uKx8rQrO/b7F2E9Q8Ui7gBWNtnMeys3eyov5s=  ;
X-YMail-OSG: c2eqQJwVM1l12xVnchP8DCqLapsIohEGfmYgk5tFfNGRoI9glQyF.nrOKKswlPUW8LCaZV_kqaw6fr0t_LA2pniux9lznsNOj0VqOquva36mTWKkSHGvxeJhtbplG_NWMieYKmQxqAyMHkxe_UnXaYR7y5prdeQU5Wx2tj0-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2.6.28-rc2] at91_mci: workaround lockdep
Date: Wed, 29 Oct 2008 00:20:03 -0700
User-Agent: KMail/1.9.10
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Russell King <rmk@arm.linux.org.uk>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200810271426.27110.david-b@pacbell.net> <1225213442.15763.20.camel@lappy.programming.kicks-ass.net> <200810281022.42803.david-b@pacbell.net>
In-Reply-To: <200810281022.42803.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810290020.03953.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2008, David Brownell wrote:
> 
> > > Workaround: depend on LOCKDEP=n ...

Note that LOCKDEP causes the BUG() on line 1159 of drivers/mmc/host/omap.c
to fire too -- exactly the same root cause:  IRQ handler getting called
in a goofy context, because of lockdep.

That's the older OMAP1/OMAP2 driver ... the new highspeed MMC controller
in OMAP3 (handling 8-bit parallel I/O etc, nyet in mainline) doesn't seem
to have the same issue(s).

- Dave



