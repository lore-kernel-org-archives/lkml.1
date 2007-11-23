Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbXKWOdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbXKWOdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 09:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbXKWOdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 09:33:42 -0500
Received: from mail164.messagelabs.com ([216.82.253.131]:16794 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755125AbXKWOdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 09:33:41 -0500
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-14.tower-164.messagelabs.com!1195828419!12033675!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
Date: Fri, 23 Nov 2007 15:33:38 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: NOHZ: local_softirq_pending 20
Message-ID: <20071123143338.GA13071@digi.com>
References: <20071123112442.GA12047@bre-cln-ukleine.digi.com> <alpine.LFD.0.9999.0711231323490.26417@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.9999.0711231323490.26417@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 23 Nov 2007 14:33:39.0113 (UTC) FILETIME=[D6946190:01C82DDD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thomas Gleixner wrote:
> On Fri, 23 Nov 2007, Uwe Kleine-König wrote:
> > my kernel reported:
> > 
> > 	NOHZ: local_softirq_pending 20
> 
> Thats TASKLET_SOFTIRQ
I suppose you're right, and it's only me that fails to see that.  Just
from looking on the code, I'd say TASKLET_SOFTIRQ is 5.  Ah, OK, I see,
0x20 == 1 << TASKLET_SOFTIRQ.

> > I cannot interpret it, but probably this is bad, because before
> > bc5393a6c9c0e70b4b43fb2fb63e3315e9a15c8f this used to BUG().
> 
> We removed the BUG, because it's a situation where the kernel can
> easily recover. It should never happen that the kernel goes to sleep
> with a pending softirq, but it's not a fatal error.
> 
> > This happend while having a high load.  Up to now it only happend once
> > and I cannot reproduce it.
> 
> That's hard to tell then. Without a reproducible test case I can not
> do much to help debugging this.
Is there something I can do to be able to report more if it reoccurs?

Can you isolate the problem?  Has it to do with the arch-specific timing
code?  With the hardware?

Best regards and thanks
Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
