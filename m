Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbZCaTPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbZCaTPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762360AbZCaTPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:15:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:54740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762050AbZCaTPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:15:21 -0400
Subject: Re: [PATCH] perf_counter: allow and require one-page mmap on
 counting counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <18889.64659.917207.685779@cargo.ozlabs.ibm.com>
References: <18889.59409.260586.87939@cargo.ozlabs.ibm.com>
	 <20090325082844.GA11217@elte.hu>
	 <18889.61903.636761.471281@cargo.ozlabs.ibm.com>
	 <20090325090336.GC2341@elte.hu>
	 <18889.64659.917207.685779@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 21:15:07 +0200
Message-Id: <1238526907.3898.93.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-25 at 20:42 +1100, Paul Mackerras wrote:
> 
> And here's something else that is semi-related: the PAPI guys want a
> kind of counter that counts until it overflows, and then sends a
> signal to the process and disables itself (and the whole group it's
> in).

I tried doing this this evening, and its remarkably hard. Disabling a
counter relies on reading the time, and taking ctx->lock and such.
Things that are impossible to do in NMI context.

Furthermore, some of the software counters (those that use hrtimers)
wait for the completion of the handler (hrtimer_cancel) which would
deadlock when tried from the handler.

Some of these things could be hacked around, others less so, but all in
all it looked remarkably hard for something that sounds so simple.



