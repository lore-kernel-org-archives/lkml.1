Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbYDOIQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbYDOIQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYDOIQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:16:27 -0400
Received: from [88.44.60.11] ([88.44.60.11]:4434 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754675AbYDOIQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:16:25 -0400
To: David Miller <davem@davemloft.net>
Cc: vgusev@openvz.org, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH][NET] Fix never pruned tcp out-of-order queue
From: Andi Kleen <andi@firstfloor.org>
References: <200804142121.53860.vgusev@openvz.org>
	<87mynvtuoj.fsf@basil.nowhere.org>
	<20080415.010131.156668601.davem@davemloft.net>
Date: Tue, 15 Apr 2008 10:14:56 +0200
In-Reply-To: <20080415.010131.156668601.davem@davemloft.net> (David Miller's message of "Tue, 15 Apr 2008 01:01:31 -0700 (PDT)")
Message-ID: <87iqyjttz3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Apr 2008 08:08:10.0349 (UTC) FILETIME=[D83F11D0:01C89ECF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Andi Kleen <andi@firstfloor.org>
> Date: Tue, 15 Apr 2008 09:59:40 +0200
>
>> Vitaliy Gusev <vgusev@openvz.org> writes:
>> 
>> > Hello!
>> >
>> > tcp_prune_queue() doesn't prune an out-of-order queue at all.
>> 
>> Why are you saying this? It has code to prune the ooo queue. You're even
>> moving it in your patch.
>> 
>> You're saying that the code doesn't work? If yes why? 
>
> There are inappropriate guards there, and it didn't get invoked
> from another important code path.
>
> That's what his change is fixing.

Perhaps I'm dense, but I don't see the inappropiate guards. The 
guards are pretty much the same as before.

The main difference seems to be that
sk_rmem_schedule/__sk_mem_schedule is called more often, but it is 
unclear how this affects the ooo pruning which only checks
the queue length anyways.

-Andi

