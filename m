Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbZAGCul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbZAGCul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbZAGCud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:50:33 -0500
Received: from relay1.sgi.com ([192.48.179.29]:54748 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755548AbZAGCuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:50:32 -0500
Message-ID: <49641872.3000404@sgi.com>
Date: Tue, 06 Jan 2009 18:50:26 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Cliff Wickman <cpw@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>, Jes Sorensen <jes@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] x86: cpumask: some more cpumask cleanups - flush_tlb_*
References: <20090104131759.865331000@polaris-admin.engr.sgi.com> <20090104144454.GA1132@elte.hu> <4962D4CF.7070200@sgi.com> <200901071242.42573.rusty@rustcorp.com.au>
In-Reply-To: <200901071242.42573.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tuesday 06 January 2009 14:19:35 Mike Travis wrote:
>> Ingo Molnar wrote:
>>> Quite good! Can we fix those TLB flush cpumask uses too?
>> Here is one proposal.
> 
> Here's what I had.  It's untested though...
> 
> x86: change flush_tlb_others to take a const struct cpumask *. FIXME: REVIEW
> 
> This is made a little more tricky by uv_flush_tlb_others which
> actually alters its argument, for an IPI to be sent to the remaining
> cpus in the mask.
> 
> I solve this by allocating a cpumask_var_t for this case and falling back
> to IPI should this fail.

I thought about this but I wondered if we wanted to add the overhead of a kmalloc
call for every tlb flush?  For a UV system, simultaneous flushes will be quite common,
so introducing two kmalloc's in the path could really hamper performance.

Thanks,
Mike
