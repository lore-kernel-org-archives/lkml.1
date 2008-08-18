Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYHRVua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYHRVua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbYHRVuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:50:08 -0400
Received: from adsl-69-107-80-255.dsl.pltn13.pacbell.net ([69.107.80.255]:45350
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752964AbYHRVuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:50:07 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes to use
	function calls [POST 2]
Message-Id: <patchbomb.1219083817@localhost>
Date: Mon, 18 Aug 2008 11:23:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series:
 - adds a simple debugfs profiling entry for cross-cpu tlb flushes
 - converts them to using smp_call_function_mask
 - unifies 32 and 64-bit tlb flushes
 - converts smp_call_function to using multiple queues (using the now
   freed vectors)
 - allows config-time adjustment of the number of queues
 - adds a kernel parameter to disable multi-queue in case it causes
   problems

The main concern is whether using smp_call_function adds an
unacceptible performance hit to cross-cpu tlb flushes.  My limited
measurements show a ~35% regression in latency for a particular flush;
it would be interesting to try this on a wider range of hardware.  I
gather the effect tlb flush performance is very application specific
as well, but I'm not sure what benchmarks show what effects.

Trading off agains the latency of a given flush, the smp_function_call
mechanism allows multiple requests to be queued, and so may improve
throughput on a system-wide basis.

So, I'd like people to try this out and see what performance effects it
has.

Thanks,
	J


