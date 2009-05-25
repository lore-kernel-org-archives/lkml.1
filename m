Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZEYHUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZEYHUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZEYHTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:19:53 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:43509 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZEYHTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:19:52 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 1/7] perf_counter: fix dynamic irq_period logging
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
In-Reply-To: <18969.57730.876306.394502@cargo.ozlabs.ibm.com>
References: <20090523162854.599719825@chello.nl>
	 <20090523163012.476197912@chello.nl>
	 <18969.57730.876306.394502@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Mon, 25 May 2009 09:19:52 +0200
Message-Id: <1243235992.26820.645.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-25 at 10:08 +1000, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > We call perf_adjust_freq() from perf_counter_task_tick() which is is called
> > under the rq->lock causing lock recursion.
> 
> What was the lock recursion?  I see perf_adjust_freq taking ctx->lock,
> but we were careful not to take any rq->lock within a ctx->lock, at
> least in the past.

perf_output_end() can end up calling a wake_up().

perf_output_end()
  perf_output_unlock()
    perf_output_wakeup()
      perf_counter_wakeup()
        wake_up_all();



