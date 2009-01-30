Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZA3LZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZA3LZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 06:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZA3LZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 06:25:01 -0500
Received: from brick.kernel.dk ([93.163.65.50]:10156 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZA3LZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 06:25:00 -0500
Date: Fri, 30 Jan 2009 12:23:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH -v2] use per cpu data for single cpu ipi calls
Message-ID: <20090130112310.GI30821@kernel.dk>
References: <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com> <20090128173039.cbc29e81.akpm@linux-foundation.org> <1233218954.7835.11.camel@twins> <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain> <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com> <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain> <1233253380.4495.123.camel@laptop> <alpine.LFD.2.00.0901291030510.3123@localhost.localdomain> <1233254680.4495.126.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233254680.4495.126.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A little late into this discussion, was nasty ill the past days.

Anyway, v2 with the suggested patches looks fine to me. That is, use
local cpu storage (and thus lose the lock) and retain the the kmalloc()
for the !wait case. That should still scale fine, as far as I can tell.
The block layer usage, for which this was originally concocted, doesn't
really care that much, since it always provides its own csd storage and
thus use the __ variant of the helper.

Peter, can you post a final complete patch for review and acks?

-- 
Jens Axboe

