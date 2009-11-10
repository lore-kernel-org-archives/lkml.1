Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbZKJJs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbZKJJs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZKJJs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:48:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58091 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZKJJs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:48:58 -0500
Subject: Re: [BUG] cpu controller can't provide fair CPU time for each group
From: Peter Zijlstra <peterz@infradead.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4AEF94E8.3030403@cn.fujitsu.com>
References: <4AEF94E8.3030403@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 10 Nov 2009 10:48:38 +0100
Message-ID: <1257846518.4648.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 11:26 +0900, Miao Xie wrote:
> Hi, Peter.
> 
> I found two problems about cpu controller:
> 1) cpu controller didn't provide fair CPU time to groups when the tasks
>     attached into those groups were bound to the same logic CPU.
> 2) cpu controller didn't provide fair CPU time to groups when shares of
>     each group <= 2 * nr_cpus.
  3) if you nest them too deep you're too going to see similar funnies.

Too sodding bad gcc messed up unsigned long long for LP64 mode, so we're
stuck with 64bit fixed point math where otherwise we could have used
128bit things.

Also, I don't really care much about fairness vs affinity, if you're
going to constrain the load-balancer and make his life impossible by
using affinities you get to keep the pieces.

But you've got a point, since you can probably see the same issue (1)
with cpusets, and that is because the whole cpu-controller vs cpusets
thing was done wrong.

Someone needs to fix that if they really care.
