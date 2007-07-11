Return-Path: <linux-kernel-owner+w=401wt.eu-S934161AbXGKWwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161AbXGKWwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbXGKWwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:52:35 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34910 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757369AbXGKWwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:52:35 -0400
Date: Wed, 11 Jul 2007 15:51:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070711225139.GB4306@sequoia.sous-sol.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org> <1184191488.12353.160.camel@chaos> <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> For example, we can make sure that the code in question that actually 
> touches the hardware stays exactly the same, and then just move the 
> interfaces around - and basically guarantee that _zero_ hardware-specific 
> issues pop up when you switch over, for example.

That's not quite right.  Leaving the code unchanged caused breakage
already.  The PIT is damn stupid and can be sensitive to how quickly it's
programmed.  So code that enable/disable didn't change, but frequency
with which it is called did and broke some random boxes.

> The other approach (which would be nice _too_) is to actually try to 
> convert one clock source at a time. Why is that not an option? 

It was that way for x86_64, that's the first thing I fixed (since it was
done by fully disabling all other timers but the one coverted ;-)
