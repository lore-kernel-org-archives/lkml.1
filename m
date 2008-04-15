Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbYDOIa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbYDOIa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYDOIam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:30:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41373 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbYDOIal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:30:41 -0400
Message-ID: <480467AA.2050808@firstfloor.org>
Date: Tue, 15 Apr 2008 10:30:34 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Vitaliy Gusev <vgusev@openvz.org>
CC: David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH][NET] Fix never pruned tcp out-of-order queue
References: <87mynvtuoj.fsf@basil.nowhere.org> <87iqyjttz3.fsf@basil.nowhere.org> <20080415.011810.178212948.davem@davemloft.net> <200804151226.47729.vgusev@openvz.org>
In-Reply-To: <200804151226.47729.vgusev@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vitaliy Gusev wrote:
> On 15 April 2008 12:18:10 David Miller wrote:
>> From: Andi Kleen <andi@firstfloor.org>
>> Date: Tue, 15 Apr 2008 10:14:56 +0200
>>
>>> The main difference seems to be that
>>> sk_rmem_schedule/__sk_mem_schedule is called more often, but it is 
>>> unclear how this affects the ooo pruning which only checks
>>> the queue length anyways.
>> tcp_data_queue() would not do the tcp_prune_ofo_queue() in some
>> cases, it's the whole point of the patch.

I still think the guards are pretty much the same as before, sorry:)

> Yes, if second sk_rmem_schedule() failed then tcp_prune_ofo_queue() is force called
> and try sk_rmem_schedule() again.

Yes but that doesn't affect the ooo prune guards at all, they only check
rmem_alloc and neither sk_rmem_schedule() nor __sk_mem_schedule
change that. Also the two callers are the same too in their checks.

But why not repeat the whole prune for all cases in this case then?

e.g. you should probably at least repeat the third step (setting
pred_flags to 0) too.

-Andi

