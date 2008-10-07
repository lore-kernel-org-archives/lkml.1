Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbYJGPY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbYJGPY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYJGPYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:24:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbYJGPYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:24:14 -0400
Message-ID: <48EB7EEA.4040809@linux-foundation.org>
Date: Tue, 07 Oct 2008 10:23:22 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, minyard@acm.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
References: <20081006185026.GA10383@minyard.local>	 <48EA8197.6080502@cosmosbay.com> <1223367480.26330.7.camel@lappy.programming.kicks-ass.net> <48EB2AE3.3080200@cosmosbay.com> <48EB6EE4.8030703@linux-foundation.org> <48EB7747.9060505@cosmosbay.com>
In-Reply-To: <48EB7747.9060505@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:

> 
> 1) Hum, do you know why "struct file" objects dont use
> SLAB_DESTROY_BY_RCU then,
> since we noticed a performance regression for several workloads at
> RCUification
> of file structures ?

Because my patches were not accepted that fix the issue.
http://lkml.org/lkml/2006/6/16/144


> 2) What prevents an object to be *freed* (and deleted from a hash
> chain), then
> re-allocated and inserted to another chain (different keys) ? (final
> refcount=1)

Nothing.

> If the lookup detects a key mismatch, how will it continue to the next
> item,
> since 'next' pointer will have been reused for the new chain insertion...
> 
> Me confused...

If there is a mismatch then you have to do another hash lookup. Do an rcu
unlock and start over.



