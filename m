Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbZEVJWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbZEVJWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZEVJWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:22:12 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:1292 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZEVJWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:22:11 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	 <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 22 May 2009 11:22:09 +0200
Message-Id: <1242984129.26820.627.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 14:27 +1000, Paul Mackerras wrote:
> 
>                 -----Unmodified-----            With this patch series
> Counters:       none    2 HW    4H+4S   none    2 HW    4H+4S
> 
> 2 processes:
> Average         3.44    6.45    11.24   3.12    3.39    3.60
> St dev          0.04    0.04    0.13    0.05    0.17    0.19
> 
> 8 processes:
> Average         6.45    8.79    14.00   5.57    6.23    7.57
> St dev          1.27    1.04    0.88    1.42    1.46    1.42
> 
> 32 processes:
> Average         5.56    8.43    13.78   5.28    5.55    7.15
> St dev          0.41    0.47    0.53    0.54    0.57    0.81

Any clues as to why the time is still dependent on the number of
counters in the context? The approach seems to be O(1) in that it
does a simple counter context swap on sched_out and nothing on sched_in.



