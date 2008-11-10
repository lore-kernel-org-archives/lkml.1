Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYKJNHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYKJNHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 08:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbYKJNHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 08:07:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34370 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033AbYKJNHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 08:07:47 -0500
Date: Mon, 10 Nov 2008 14:07:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       lguest@ozlabs.org, jeremy@xensource.com,
       Steven Rostedt <srostedt@redhat.com>, Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081110130709.GA32613@elte.hu>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com> <20081104204400.GC10825@elte.hu> <1226243805.27361.1283784629@webmail.messagingengine.com> <20081110085846.GG22392@elte.hu> <1226321061.23701.1283927805@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226321061.23701.1283927805@webmail.messagingengine.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@fastmail.fm> wrote:

> On Mon, 10 Nov 2008 09:58:46 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> > * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> > > Hi all,
> > > 
> > > I have spent some time trying to find out how expensive the 
> > > segment-switching patch was. I have only one computer available at 
> > > the time: a "Sempron 2400+", 32-bit-only machine.
> > > 
> > > Measured were timings of "hackbench 10" in a loop. The average was 
> > > taken of more than 100 runs. Timings were done for two seperate 
> > > boots of the system.
> 
> Hi Ingo,
> 
> I guess you just stopped reading here?

yeah, sorry! You describe and did exactly the kind of histogram that i 
wanted to see done ;-)

I'm not sure i can read out the same thing from the result though. 
Firstly, it seems the 'after' histograms are better, because there the 
histogram shifted towards shorter delays. (i.e. lower effective irq 
entry overhead)

OTOH, unless i'm misreading them, it's a bit hard to compare them 
visually: the integral of the histograms does not seem to be constant, 
they dont seem to be normalized.
 
It should be made constant for them to be comparable. (i.e. the total 
number of irq hits profiled should be equal - or should be normalized 
with the sum after the fact)

	Ingo
