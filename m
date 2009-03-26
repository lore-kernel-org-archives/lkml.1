Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZCZCUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZCZCUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753739AbZCZCUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:20:37 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:48877 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbZCZCUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:20:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18890.58987.604249.823917@drongo.ozlabs.ibm.com>
Date: Thu, 26 Mar 2009 13:20:27 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3] perfcounters: record time running and time enabled
 for each counter
In-Reply-To: <1237983668.7972.847.camel@twins>
References: <18890.6578.728637.139402@cargo.ozlabs.ibm.com>
	<1237983668.7972.847.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Paul, should we perhaps also put a format header in the sys_read()
> output?

Hmmm..., possibly.  It could be useful to have a PERF_FORMAT_GROUP,
and then we'd want headers, I guess.

However, to simplify life for userland, we should make it possible to
predict the layout for the simple cases (the cases where they have
only asked for fixed-length items).  For example, if the user only
wants the counter value, they should be able to do the read() and know
that the counter value is at some fixed offset in the buffer they just
read, provided they got the number of bytes they expected.  It would
be unfortunate if we have to have code to step through a series of
tagged records to find the counter value, and additionally have code
to cope with not finding the tag we're expecting.

Paul.
