Return-Path: <linux-kernel-owner+w=401wt.eu-S933042AbYD1IeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042AbYD1IeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765924AbYD1Idx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:33:53 -0400
Received: from viefep25-int.chello.at ([62.179.121.45]:19094 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764962AbYD1Idw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:33:52 -0400
X-SourceIP: 80.56.237.116
Subject: Re: [PATCH] sched: fair-group: fix a Div0 error of the fair group
	scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: miaox@cn.fujitsu.com
Cc: Ingo Molnar <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <48158A78.5010904@cn.fujitsu.com>
References: <481558A0.9020803@cn.fujitsu.com>
	 <1209361544.6429.4.camel@lappy>  <48158A78.5010904@cn.fujitsu.com>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 10:33:45 +0200
Message-Id: <1209371625.13978.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 16:27 +0800, Miao Xie wrote:

> I'm sorry, I didn't explained clearly.Though echoing ULONG_MAX value into
> cpu.shares causes Div0 error, this error was not caused by the above code.
> It is caused by the following code.
> 
>     calc_delta_mine()
>         ->lw->inv_weight = (WMULT_CONST-lw->weight/2) / (lw->weight+1);
> 
> And besides, the Div0 error caused by echoing ULONG_MAX occured on the UP system
> or on SMP system with only one cpu.
> 
> So this patch fixes the bug caused by echoing a number which was less than the number
> of processores into the "cpu.shares" file, but doesn't fix the bug caused by echoing
> ULONG_MAX.

Ah, ok. But I guess we run into other problems with weights that heavy,
but we should not crash.

Ok, I'll ACK your initial patch

