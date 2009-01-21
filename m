Return-Path: <linux-kernel-owner+w=401wt.eu-S1763492AbZAUIbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763492AbZAUIbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbZAUIbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:31:01 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:44243 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750879AbZAUIbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:31:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=HckTfVGKmWLPZsHI4LOwRlt6GcsrrhOOtgORVcLYjJyFxF9h0ZZqbiXwFPM2zXbuel+9uyYPrA2lfjz40qTWx4RlsrCZ7llrhpeHELV4QJnR9Ckpcx4gxaX9SJlMwhxgb7uswR9Q9kKIJlI4h536orQF4vl9eN5subrjuzMoNyA=  ;
X-YMail-OSG: R9IuX0MVM1khpjAbs9AfySvPCEGb.W0gaodnrI0fmsVtMHUUZYa64TvZ10kR3ubxrULERvzz_.NIHvYG5WVOKPuTFogSq4QNWK6yE.naDLmYA10WOVK0fJudMFWwZ2bG2ohjQrd3yLliFtBd.8cfkqdq1q6MK_E29eUyTYKK7jTx3IslWvIr396szIrjPQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: miaox@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the unallowed node when memory spread is set
Date: Wed, 21 Jan 2009 19:30:26 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>
References: <4976D77C.3020107@cn.fujitsu.com>
In-Reply-To: <4976D77C.3020107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901211930.27178.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009 19:06:20 Miao Xie wrote:
> The task still allocated the page caches on old node after modifying its
> cpuset's mems when 'memory_spread_page' was set, it is caused by the old
> mem_allowed_list of the task, the current kernel doesn't updates it unless
> some function invokes cpuset_update_task_memory_state(), it is too late
> sometimes. We must update the mem_allowed_list of the tasks in time.
>
> Slab has the same problem.
>
> We fixes the bug by updating tasks' mem_allowed_list and spread flag after
> its cpuset's mems or spread flag is changed.

Thank you, this is a much better way to handle the problem, and keeps
those costly function calls out of fastpaths.

I don't know the cpuset code well enough to review it right now, but
the mm/ pieces thank you kindly for it :) Nice patch.

