Return-Path: <linux-kernel-owner+w=401wt.eu-S1757469AbZEYANp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469AbZEYANp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 20:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZEYANi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 20:13:38 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:59908 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbZEYANh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 20:13:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18969.57730.876306.394502@cargo.ozlabs.ibm.com>
Date: Mon, 25 May 2009 10:08:34 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 1/7] perf_counter: fix dynamic irq_period logging
In-Reply-To: <20090523163012.476197912@chello.nl>
References: <20090523162854.599719825@chello.nl>
	<20090523163012.476197912@chello.nl>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> We call perf_adjust_freq() from perf_counter_task_tick() which is is called
> under the rq->lock causing lock recursion.

What was the lock recursion?  I see perf_adjust_freq taking ctx->lock,
but we were careful not to take any rq->lock within a ctx->lock, at
least in the past.

Paul.
