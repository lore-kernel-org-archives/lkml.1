Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbYKEJ4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbYKEJ4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbYKEJz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:55:58 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53472 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbYKEJz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:55:57 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] lru_add_drain_all() don't use schedule_on_each_cpu()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       npiggin@suse.de, linux-kernel@vger.kernel.org, hugh@veritas.com,
       torvalds@linux-foundation.org, riel@redhat.com, lee.schermerhorn@hp.com,
       linux-mm@kvack.org
In-Reply-To: <1225878704.7803.2771.camel@twins>
References: <2f11576a0810290020i362441edkb494b10c10b17401@mail.gmail.com> <1225878704.7803.2771.camel@twins>
Message-Id: <20081105185458.968B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed,  5 Nov 2008 18:55:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 2008-10-29 at 16:20 +0900, KOSAKI Motohiro wrote:
> > > I guess we should document our newly discovered schedule_on_each_cpu()
> > > problems before we forget about it and later rediscover it.
> > 
> > Now, schedule_on_each_cpu() is only used by lru_add_drain_all().
> > and smp_call_function() is better way for cross call.
> > 
> > So I propose
> >    1. lru_add_drain_all() use smp_call_function()
> >    2. remove schedule_on_each_cpu()
> > 
> > 
> > Thought?
> 
> At the very least that will not solve the problem on -rt where a lot of
> the smp_call_function() users are converted to schedule_on_each_cpu().

yup.
Now, I testing "simple dropping lru_add_drain_all() in mlock path" patch.

Thanks.


