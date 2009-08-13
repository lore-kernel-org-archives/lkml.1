Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbZHMJIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbZHMJIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZHMJID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:08:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40309
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802AbZHMJIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:08:02 -0400
Date: Thu, 13 Aug 2009 02:08:12 -0700 (PDT)
Message-Id: <20090813.020812.251047996.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com
Subject: Re: inlined spinlocks on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090813082058.GX12579@kernel.dk>
References: <20090813082058.GX12579@kernel.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 13 Aug 2009 10:20:58 +0200

> I deleted the original thread, so I can't reply there. Just a heads up
> on the spinlock inlining on sparc64. I decided to give your patches a
> shot, since one of my IO benchmarks here basically degenerates into a
> spinlock microbenchmark with > 50% time spent there (unlock part,
> according to perf). Some of that is surely caching effects, but still.
> 
> For this particular workload, I get a net improvement of about 3.5% with
> the inlined functions. Not bad.

Doesn't surprise me, any function call can result in a register
window spill onto the stack, and that's 128 bytes of writes.

Later when you leave the code path you have to refill that spilled
window and you get 128 bytes of reads for each one of those.
