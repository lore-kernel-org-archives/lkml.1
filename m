Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbYKEJvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbYKEJvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYKEJvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:51:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:55444 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302AbYKEJvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:51:42 -0500
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use
 schedule_on_each_cpu()
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       npiggin@suse.de, linux-kernel@vger.kernel.org, hugh@veritas.com,
       torvalds@linux-foundation.org, riel@redhat.com, lee.schermerhorn@hp.com,
       linux-mm@kvack.org
In-Reply-To: <2f11576a0810290020i362441edkb494b10c10b17401@mail.gmail.com>
References: <2f11576a0810210851g6e0d86benef5d801871886dd7@mail.gmail.com>
	 <2f11576a0810211018g5166c1byc182f1194cfdd45d@mail.gmail.com>
	 <20081023235425.9C40.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20081027145509.ebffcf0e.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0810280914010.15939@quilx.com>
	 <20081028134536.9a7a5351.akpm@linux-foundation.org>
	 <2f11576a0810290020i362441edkb494b10c10b17401@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Nov 2008 10:51:44 +0100
Message-Id: <1225878704.7803.2771.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-29 at 16:20 +0900, KOSAKI Motohiro wrote:
> > I guess we should document our newly discovered schedule_on_each_cpu()
> > problems before we forget about it and later rediscover it.
> 
> Now, schedule_on_each_cpu() is only used by lru_add_drain_all().
> and smp_call_function() is better way for cross call.
> 
> So I propose
>    1. lru_add_drain_all() use smp_call_function()
>    2. remove schedule_on_each_cpu()
> 
> 
> Thought?

At the very least that will not solve the problem on -rt where a lot of
the smp_call_function() users are converted to schedule_on_each_cpu().


