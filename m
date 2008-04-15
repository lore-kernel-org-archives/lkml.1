Return-Path: <linux-kernel-owner+w=401wt.eu-S1760759AbYDOJb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759AbYDOJb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 05:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbYDOJbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 05:31:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:11143 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbYDOJbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 05:31:18 -0400
From: Vitaliy Gusev <vgusev@openvz.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC][PATCH][NET] Fix never pruned tcp out-of-order queue
Date: Tue, 15 Apr 2008 13:33:47 +0400
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
       linux-kernel@vger.kernel.org
References: <87mynvtuoj.fsf@basil.nowhere.org> <200804151226.47729.vgusev@openvz.org> <480467AA.2050808@firstfloor.org>
In-Reply-To: <480467AA.2050808@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804151333.47395.vgusev@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2008 12:30:34 Andi Kleen wrote:
> Vitaliy Gusev wrote:
> > On 15 April 2008 12:18:10 David Miller wrote:
> >> From: Andi Kleen <andi@firstfloor.org>
> >> Date: Tue, 15 Apr 2008 10:14:56 +0200
> >>
> >>> The main difference seems to be that
> >>> sk_rmem_schedule/__sk_mem_schedule is called more often, but it is 
> >>> unclear how this affects the ooo pruning which only checks
> >>> the queue length anyways.
> >> tcp_data_queue() would not do the tcp_prune_ofo_queue() in some
> >> cases, it's the whole point of the patch.
> 
> I still think the guards are pretty much the same as before, sorry:)
> 
> > Yes, if second sk_rmem_schedule() failed then tcp_prune_ofo_queue() is force called
> > and try sk_rmem_schedule() again.
> 
> Yes but that doesn't affect the ooo prune guards at all, they only check
> rmem_alloc and neither sk_rmem_schedule() nor __sk_mem_schedule
> change that. Also the two callers are the same too in their checks.
>
> But why not repeat the whole prune for all cases in this case then?
> 
> e.g. you should probably at least repeat the third step (setting
> pred_flags to 0) too.

Did you mean merely add check on tcp_memory_allocated < prot->sysctl_mem[2]
to tcp_prune_queue() ?
It is not enough as __sk_mem_schedule() can fail also
because of memory_pressure is on and there are too many opened sockets.

i.e. I avoid duplicating checks from __sk_mem_schedule().


> 
> -Andi



-- 
Thank,
Vitaliy Gusev
