Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbYLJEpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbYLJEpC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 23:45:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbYLJEot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 23:44:49 -0500
Received: from ozlabs.org ([203.10.76.45]:37622 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbYLJEot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 23:44:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18751.18627.42382.554060@drongo.ozlabs.ibm.com>
Date: Wed, 10 Dec 2008 15:42:43 +1100
From: Paul Mackerras <paulus@samba.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: David Miller <davem@davemloft.net>, andi@firstfloor.org, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org, eranian@googlemail.com, dada1@cosmosbay.com,
       robert.richter@amd.com, arjan@infradead.org, hpa@zytor.com,
       rostedt@goodmis.org
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
In-Reply-To: <20081210034824.GA27217@linux-sh.org>
References: <20081205.002701.172921476.davem@davemloft.net>
	<20081205084233.GE2030@elte.hu>
	<87ej0mx0c0.fsf@basil.nowhere.org>
	<20081205.120814.51226316.davem@davemloft.net>
	<20081210034824.GA27217@linux-sh.org>
X-Mailer: VM 8.0.11 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt writes:

> On Fri, Dec 05, 2008 at 12:08:14PM -0800, David Miller wrote:
> > From: Andi Kleen <andi@firstfloor.org>
> > Date: Fri, 05 Dec 2008 13:39:43 +0100
> > 
> > > Given these are more obscure features, but not being able to fit
> > > them easily into your model from the start isn't a very promising sign
> > > for the long term extensibility of the design.
> > 
> > Another thing I'm interested in is if this new stuff will work with
> > performance counters that lack an overflow interrupt.
> > 
> > We have several chips that are like this, and perfmon supported that
> > on the kernel side, and also provided overflow emulation for such
> > hardware in userspace (where such complexity belongs).
> 
> There doesn't seem to have been any reply to this point unfortunately,
> and it is something I am also wondering about.
> 
> The sh perf counters were not designed with overflowing in mind, they are
> split in to a pair of 48-bit or 64-bit counters that simply keep running.
> Any write simply clears the value and the counter starts over. They are
> simply counters only, and generate no events whatsoever.
> 
> Oprofile has been a pretty bad fit for them, and while I'm slightly more
> optimistic about perfmon, I'm rather less enthusiastic about yet another
> peformance counter implementation that I am unable to make any use of. 

This is the sampling vs. counting distinction again, and it sounds
like these counters were designed for counting but not sampling.  If
Ingo and Thomas extend their infrastructure to provide good support
for counting as well as sampling, then you should hopefully be able to
use them for counting, at least.

On POWER6 we have a somewhat similar situation with two out of the six
available counters.  These two counters are fixed function (they
always count cycles and instructions completed) and don't generate
interrupts.  Furthermore, they are only 32 bits wide.  So I definitely
agree we need support for counters that don't interrupt.

Paul.
