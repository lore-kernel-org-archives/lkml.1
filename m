Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbYHMSrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbYHMSrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYHMSrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:47:15 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:31577 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYHMSrO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:47:14 -0400
X-BigFish: VPS-22(zz1432R98dR1805Mzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K5JYU9-01-ML0-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH](retry 2) Re: invalidate caches before going into suspend
Date: Wed, 13 Aug 2008 13:47:05 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC6B@sausexmb4.amd.com>
In-Reply-To: <20080813114229.118be446@infradead.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH](retry 2) Re: invalidate caches before going into suspend
Thread-Index: Acj9dFr7bRLYaJ1PSJqkT0ak32lf4gAAEINw
References: <200808131141.18003.mark.langsdorf@amd.com><200808131230.07581.mark.langsdorf@amd.com><20080813175232.GA1127@elte.hu><200808131333.17850.mark.langsdorf@amd.com> <20080813114229.118be446@infradead.org>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Arjan van de Ven" <arjan@infradead.org>
CC: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 13 Aug 2008 18:47:06.0030 (UTC) FILETIME=[FBA9C4E0:01C8FD74]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Mark Langsdorf <mark.langsdorf@amd.com> wrote:
> > +	/* mask all interrupts, flush any and all caches, and halt */
> > +	if (cpu_has_clflush)
> > +		wbinvd_halt();
> > +	else
> > +		while (1)
> > +			halt();
> >  }
> 
> I like the asm version .. but this code makes me blink.
> when you HAVE clflush you do wbinvd.
> yeah I know it's correct but... it reads wonky ;)

It's the most convenient symbol to test against.  I
suppose I should add a comment explaining it.

> also.. can we move that check into the wbinvd_halt() itself, so that
> the callers don't need to care what is used to select it ?

irqflags.h doesn't guarantee the presence of boot_cpu_data, 
so I wasn't able to make that check cleanly.  I could move
the macro definition to process_??.c if that would better.

-Mark Langsdorf
Operating System Research Center
AMD

