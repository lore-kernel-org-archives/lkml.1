Return-Path: <linux-kernel-owner+w=401wt.eu-S1755923AbZA2SpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbZA2SpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZA2SpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:45:04 -0500
Received: from casper.infradead.org ([85.118.1.10]:55560 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZA2SpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:45:02 -0500
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, jens.axboe@oracle.com
In-Reply-To: <alpine.LFD.2.00.0901291030510.3123@localhost.localdomain>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com>
	 <200901290955.38940.rusty@rustcorp.com.au>
	 <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>
	 <20090128173039.cbc29e81.akpm@linux-foundation.org>
	 <1233218954.7835.11.camel@twins>
	 <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain>
	 <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>
	 <1233253380.4495.123.camel@laptop>
	 <alpine.LFD.2.00.0901291030510.3123@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 19:44:40 +0100
Message-Id: <1233254680.4495.126.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 10:39 -0800, Linus Torvalds wrote:

> But you're right, I'm still not seeing anything that looks _likely_ to be 
> a problem. But I worry that it's something somebody may want to do.

Well, the kgdb case I looked at did exactly that, and that is a problem.

As for people wanting to do it, we have __smp_call_function_single() to
do just that, all you have to do is provide your own csd.



