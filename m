Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZCBSwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZCBSwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 13:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZCBSwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 13:52:24 -0500
Received: from mail.impinj.com ([206.169.229.170]:47182 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751577AbZCBSwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 13:52:23 -0500
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Mar 2009 13:52:23 EST
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] irq: remove IRQF_DISABLED
Date: Mon, 2 Mar 2009 10:45:20 -0800
User-Agent: KMail/1.11.0 (Linux/2.6.27.15-170.2.24.fc10.x86_64; KDE/4.2.0; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-arch" <linux-arch@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1235996477.5330.174.camel@laptop> <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903020852220.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021045.20723.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 02 Mar 2009 18:45:25.0977 (UTC) FILETIME=[0D0EA490:01C99B67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009 09:11:54 Linus Torvalds wrote:
> The thing is, with PIO, a 512-byte disk read ends up doing 256 16-bit word
> reads from the controller, each potentially up to 600ns long (PIO0
> timings). That's 150ms - for a single sector!

Out of curiosity, the peanut gallery wishes to ask:
Is the above supposed to be 600us (*1000), or 150us (/1000)? Probably the 
latter.

> For example, Mode2 timings are probably still something we should consider
> realistic, and that's 240ns per word - a single sector now takes ~60ms to
> read off the disk.

Same factor of 1000 question here.

> And we don't do single sectors. Most transfers will be 8 sectors (4k
> contiguos read). So now that 60ms is 480ms per such IDE interrupt. And
> even with the _good_ timings, we're certainly looking at a reduction of
> that to about half.
>
> Imagine what happens when we have interrupts disabled for half a second at
> a time.

-- Vadim Lobanov

