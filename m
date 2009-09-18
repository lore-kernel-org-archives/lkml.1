Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbZIRMbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbZIRMbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 08:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZIRMbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 08:31:25 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:58786 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbZIRMbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 08:31:24 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 0/2]: Get perf counters working on D-cache aliasing
 cpus.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, jens.axboe@oracle.com
In-Reply-To: <20090908.051045.26522683.davem@davemloft.net>
References: <20090908.051045.26522683.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 14:31:36 +0200
Message-Id: <1253277096.8439.127.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 05:10 -0700, David Miller wrote:
> With Jen's Axboe's basic sparc counter patch in my tree I started
> playing with it on sparc64.  Turns out it won't work on anything
> pre-Niagara.
> 
> The issue is D-cache aliasing between the kernel side mapping
> and the user side mapping of the perf event ring buffer.
> 
> The following two patches attempt to address this issue and
> are working properly on my test machine.

Dave,

Ingo just reminded me that we might want to do splice support for perf
stuff. My plan was to have the splice thing allocate a new page, flip
with a filled one from the buffer and send the filled one down to the
splice consumer.

Now having vmap'ed all that complicates stuff enourmously.

Would it also work if we use order-1 pages on your platform instead of
order-0, so that they are properly aligned for the d-cache?



