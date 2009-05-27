Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbZE0G7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbZE0G7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 02:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759028AbZE0G7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 02:59:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:32881 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbZE0G7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 02:59:09 -0400
Subject: Re: [PATCH] sched: Support current clocksource handling in
 fallback sched_clock().
From: Peter Zijlstra <peterz@infradead.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1243378835.3275.30.camel@localhost>
References: <20090526061532.GD9188@linux-sh.org>
	 <63386a3d0905260731m655bfee3q82a6f52d71fa3cef@mail.gmail.com>
	 <1243348681.23657.14.camel@twins>  <1243369423.3275.5.camel@localhost>
	 <1243369815.6600.2.camel@laptop>  <1243370439.3275.13.camel@localhost>
	 <1243371309.6600.8.camel@laptop>  <1243378835.3275.30.camel@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 27 May 2009 08:58:46 +0200
Message-Id: <1243407526.23657.37.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 16:00 -0700, john stultz wrote:

> Sure, I guess what I'm trying to pull out here is that should we try to
> create some OK_FOR_SCHED_CLOCK flag for clocksources, and then we try to
> make this generic so other arches can add that flag and be done, what is
> the guidance we want to give to arch maintainers for setting that flag?
> 
> 1) Has to be very very fast. Can we put a number on this? 50ns to read?

I'd express it in cpu cycles, but not sure, the very fastest the arch
has :-) Just tell people this is in their scheduling hot-path and they
might understand.

> 2) How long does it have to be monotonic for? 

Forever? (per cpu)

> Is it ok if it wraps every few seconds?

No, if it wraps it needs to wrap on u64.

