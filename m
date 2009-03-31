Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbZCaJNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbZCaJNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbZCaJMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:12:54 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35832 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbZCaJMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:12:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18897.56973.324304.995540@cargo.ozlabs.ibm.com>
Date: Tue, 31 Mar 2009 20:12:45 +1100
From: Paul Mackerras <paulus@samba.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] perf_counter: provide generic callchain bits
In-Reply-To: <49D1C544.7020403@linux.vnet.ibm.com>
References: <20090330170701.856843742@chello.nl>
	<20090330171024.254266860@chello.nl>
	<18897.46177.528910.51044@cargo.ozlabs.ibm.com>
	<1238481552.28248.1384.camel@twins>
	<49D1C544.7020403@linux.vnet.ibm.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Ashford writes:

> If this is the case, what is the exact meaning of PERF_COUNTER_SIMPLE 
> now? and PERF_COUNTER_GROUP?  One simplification would be that reading 
> the fd of a group leader would always read up all of the counters in the 
> group (along with their enabled and running times if those bits are 
> set), and that reading a single counter's fd would yield only that 
> counter's values and times (if enabled).  In effect, these two values, 
> PERF_COUNTER_GROUP and PERF_COUNTER_SIMPLE would no longer be necessary 
> at all.  Other bits would be used to determine what's in the mmap'd samples.

Now that events are only read through mmap, it's quite simple -
hw_event.read_format controls what read() gives you, and
hw_event.record_type controls what gets put into the pages that you
get with mmap.

Currently read_format and record_type don't use the same set of bit
definitions.  Maybe they should?  I don't have a strong feeling about
it, but that might be a nice simplification.

Paul.
