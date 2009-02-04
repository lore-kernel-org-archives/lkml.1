Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbZBDKwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbZBDKwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZBDKwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:52:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:56451 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbZBDKwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:52:10 -0500
Subject: Re: Performance counter API review was [patch] Performance
 Counters for Linux, v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       Maynard Johnson <mpjohn@us.ibm.com>, carll@us.ibm.com
In-Reply-To: <18825.29238.559809.341658@cargo.ozlabs.ibm.com>
References: <20081211155230.GA4230@elte.hu>
	 <87r64ag68n.fsf@basil.nowhere.org> <49875199.3010609@linux.vnet.ibm.com>
	 <1233606782.10184.4.camel@laptop>
	 <18824.64228.358045.890823@cargo.ozlabs.ibm.com>
	 <1233737124.10184.57.camel@laptop>
	 <18825.29238.559809.341658@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 11:51:44 +0100
Message-Id: <1233744704.5076.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 21:47 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > How is smp_call_function() going to help here? You still need to pull
> > all that data through that one FD. That's a cacheline bounce fest.
> 
> Well, let's put this into perspective.  We would be collecting 8 bytes
> of data from each CPU.  Hardly a "cacheline bounce fest". :)

Ah, I was thinking more of the event triggered profiling, like NMI time,
cachemiss or pagefault profiling.

In those cases you'd get a continuous stream of data for each cpu, at
possibly quite high speeds.

