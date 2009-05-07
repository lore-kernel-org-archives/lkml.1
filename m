Return-Path: <linux-kernel-owner+w=401wt.eu-S1760889AbZEGRqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbZEGRqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 13:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZEGRpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 13:45:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:40395 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZEGRpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 13:45:52 -0400
Subject: Re: [PATCH] x86: Reduce the default HZ value
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Alok Kataria <akataria@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.1.10.0905071318570.22107@qirst.com>
References: <1241462661.412.8.camel@alok-dev1>  <4A00ADDE.9000908@zytor.com>
	 <1241560625.8665.17.camel@alok-dev1>
	 <alpine.DEB.1.10.0905071010170.24528@qirst.com>
	 <1241716053.6311.1514.camel@laptop>
	 <alpine.DEB.1.10.0905071318570.22107@qirst.com>
Content-Type: text/plain
Date: Thu, 07 May 2009 19:45:02 +0200
Message-Id: <1241718302.6311.1573.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-07 at 13:19 -0400, Christoph Lameter wrote:
> On Thu, 7 May 2009, Peter Zijlstra wrote:
> 
> > The problem is that running the scheduler of off hrtimers is too
> > expensive. We have the code, we tried it, people complained.
> 
> If you aggregate events into a single hrtimer event then it may work.
> Wasnt that recently added?

No it won't, you want fairly decent involuntary preemption rate to keep
the full service latency at a usable figure.

The problem with scheduling a hrtimer along with tasks is that at high
context switch rates the timer will never fire but you do pay the
overhead of programming the hardware each time, something that can be
about as expensive as the whole context switch itself.

Although, I guess we could amortize that by not re-programming the timer
when the existing timer is within a reasonable period (say 1ms) of the
requested on.



