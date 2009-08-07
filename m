Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZHGQjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZHGQjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 12:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbZHGQjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 12:39:54 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:62218 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZHGQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 12:39:53 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [patch] x86, perf_counter, bts: add bts to perf_counter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, oleg@redhat.com
In-Reply-To: <20090807092256.A6083@sedona.ch.intel.com>
References: <20090807092256.A6083@sedona.ch.intel.com>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 18:39:36 +0200
Message-Id: <1249663176.32113.750.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 09:22 +0200, Markus Metzger wrote:
> Implement a performance counter with:
>     attr.type           = PERF_TYPE_HARDWARE
>     attr.config         = PERF_COUNT_HW_BRANCH_INSTRUCTIONS
>     attr.sample_period  = 1
> 
> using branch trace store (BTS) on x86 hardware, if available.
> 
> The from and to address for each branch can be sampled using:
>     PERF_SAMPLE_IP      for the from address
>     PERF_SAMPLE_ADDR    for the to address


The patch seems to forget one fundamental aspect, it doesn't provide a
counter.

The 'fake' fixed purpose counter we create only provides event samples,
but it does not provide a counter abstraction, so people who'd expect
read() to return the current count of things will get 0.

We could fix this by keeping a software counter along with it that
counts the number of BTS entries processed so far.



