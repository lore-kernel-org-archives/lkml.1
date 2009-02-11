Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbZBKNAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbZBKNAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204AbZBKNAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:00:40 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:60569 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbZBKNAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:00:39 -0500
X-SourceIP: 213.46.9.244
Subject: Re: Time slice for SCHED_BATCH ( CFS)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: J K Rai <jk.anurag@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <303179.28635.qm@web94707.mail.in2.yahoo.com>
References: <315626.71453.qm@web94713.mail.in2.yahoo.com>
	 <20090211102024.GI20518@elte.hu> <1234348436.23438.119.camel@twins>
	 <303179.28635.qm@web94707.mail.in2.yahoo.com>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 14:02:30 +0100
Message-Id: <1234357350.23438.149.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-11 at 17:58 +0530, J K Rai wrote:
> Can we say that given n cpus and m processes the time-slice will
> remain constant under SCHED_BATCH or so? 

Only if those processes remain running, if they get blocked for whatever
reason it'll change.

> Can we form some kind of relationship? 

Sure,

latency := 20ms * (1 + log2(nr_cpus))
min_granularity := 4ms * (1 + log2(nr_cpus))
nr_latency := floor(latency / min_granularity)


           latency ; nr_running <= nr_latency
period = {
           nr_running * min_granularity ; nr_running > nr_latency


slice = task_weight * period / runqueue_weight


as you can see, its a function of the number of cpus, as well as all
other running tasks on a particular cpu.

Load-balancing of course makes this an even more interesting thing.


