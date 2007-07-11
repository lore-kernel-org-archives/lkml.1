Return-Path: <linux-kernel-owner+w=401wt.eu-S934502AbXGKWua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934502AbXGKWua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbXGKWuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:50:22 -0400
Received: from www.osadl.org ([213.239.205.134]:36583 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762113AbXGKWuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:50:21 -0400
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu>
	 <alpine.LFD.0.999.0707111438530.20061@woody.linux-foundation.org>
	 <1184191488.12353.160.camel@chaos>
	 <alpine.LFD.0.999.0707111518020.20061@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 12 Jul 2007 00:50:19 +0200
Message-Id: <1184194219.12353.170.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Wed, 2007-07-11 at 15:20 -0700, Linus Torvalds wrote:
> For example, we can make sure that the code in question that actually 
> touches the hardware stays exactly the same, and then just move the 
> interfaces around - and basically guarantee that _zero_ hardware-specific 
> issues pop up when you switch over, for example.
> 
> That way there is a gradual change-over.

Ok, I can try to split this down further.

> The other approach (which would be nice _too_) is to actually try to 
> convert one clock source at a time. Why is that not an option? 

We need to give control to the clock events core code once we convert
one clock event device. Having two competing subsystems controlling
different devices (e.g. PIT and APIC) is not really desirable.

The HPET change, which is the larger part of the conversion set simply
because we now share the code with i386, might be split out by disabling
HPET in the first step, doing the PIT / APIC conversion and then the
HPET one in a separate step.

Thanks,

	tglx


