Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZEYKuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZEYKuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZEYKuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:50:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbZEYKuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:50:04 -0400
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1243247887.26820.651.camel@twins>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	 <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	 <1243000016.6582.574.camel@laptop>
	 <18969.58137.356360.144339@cargo.ozlabs.ibm.com>
	 <1243247887.26820.651.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 25 May 2009 12:50:03 +0200
Message-Id: <1243248603.26820.652.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-25 at 12:38 +0200, Peter Zijlstra wrote:
> On Mon, 2009-05-25 at 10:15 +1000, Paul Mackerras wrote:
> > Peter Zijlstra writes:
> > 
> > > Ingo just pointed out that there is nothing there to close the race with
> > > attaching a counter.
> > > 
> > > That is, you could end up attaching your counter to the wrong task.
> > 
> > Good point.  Doing the unclone in find_get_context would be a start,
> > but the locking could get tricky (in fact we don't have any way to
> > remove an inherited counter from a context, so we only have to worry
> > about counters being attached).  I'll work out a solution after I have
> > digested your recent batch of patches.
> 
> I'm currently staring at something like the below, trying to find races
> etc.. ;-)
> 
> attach vs destroy vs flip

Hmm, it appears we only unclone ctx on remove, not attach.. how odd..
