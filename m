Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbZEKUww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbZEKUww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 16:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759103AbZEKUwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 16:52:41 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35515 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939AbZEKUwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 16:52:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18952.36878.942836.803265@cargo.ozlabs.ibm.com>
Date: Tue, 12 May 2009 06:52:30 +1000
From: Paul Mackerras <paulus@samba.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
In-Reply-To: <4A086A89.6030905@linux.vnet.ibm.com>
References: <20090508165219.469818319@chello.nl>
	<20090508170028.837558214@chello.nl>
	<18951.32643.749495.538351@drongo.ozlabs.ibm.com>
	<4A086A89.6030905@linux.vnet.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Ashford writes:

> One problem that I was seeing was that disabling only the group leader didn't 
> keep the group member hardware counters from continuing to run and generate 
> overflows, and causing sample records to be put in the mmap buffer.

That's very strange.  Disabling the group leader should have taken the
whole group off the PMU and so none of the members should have been
able to generate any more overflows or sample records.  What machines
did you see this on?

> Was this the intention?

Not at all.

> For PAPI, we really need to be able to disable, at least, the sample records 
> from going into the mmap buffers.  Even better would be to stop the hardware 
> counters from counting while disabled.

Disabling the leader should be doing all that.

Paul.
