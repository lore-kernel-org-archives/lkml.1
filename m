Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbXEUP0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbXEUP0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbXEUPZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:25:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:57431 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbXEUPZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ApqfqG63ZnyH0R6Kv8NlkEzVYdQhNEx7WClXzgs0wpJ5s6ymE8MpNewJu3UV6sPIAin2SxX/q44ydChvIVkNkGjLPD+7ILvwxKBLpEPc3gqTXWrpF3jblaV/HsKdoH0573s/luyS4FzmhtTSOHafomxgu/KCW3QG+nStK9yc+jc=
Message-ID: <b647ffbd0705210825y25331066x8b2a4d50cdb7c266@mail.gmail.com>
Date: Mon, 21 May 2007 17:25:48 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Peter Williams" <pwil3058@bigpond.net.au>
Subject: Re: [patch] CFS scheduler, -v12
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <464DA61A.4040406@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070513153853.GA19846@elte.hu> <464A6698.3080400@bigpond.net.au>
	 <20070516063625.GA9058@elte.hu> <464CE8FD.4070205@bigpond.net.au>
	 <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/05/07, Peter Williams <pwil3058@bigpond.net.au> wrote:
[...]
> One thing that might work is to jitter the load balancing interval a
> bit.  The reason I say this is that one of the characteristics of top
> and gkrellm is that they run at a more or less constant interval (and,
> in this case, X would also be following this pattern as it's doing
> screen updates for top and gkrellm) and this means that it's possible
> for the load balancing interval to synchronize with their intervals
> which in turn causes the observed problem.

Hum.. I guess, a 0/4 scenario wouldn't fit well in this explanation..
all 4 spinners "tend" to be on CPU0 (and as I understand each gets
~25% approx.?), so there must be plenty of moments for
*idle_balance()* to be called on CPU1 - as gkrellm, top and X consume
together just a few % of CPU. Hence, we should not be that dependent
on the load balancing interval here..

(unlikely consiparacy theory) - idle_balance() and load_balance() (the
later is dependent on the load balancing interval which can be in
sync. with top/gkerllm activities as you suggest) move always either
top or gkerllm between themselves.. esp. if X is reniced (so it gets
additional "weight") and happens to be active (on CPU1) when
load_balance() (kicked from scheduler_tick()) runs..

p.s. it's mainly theoretical specualtions.. I recently started looking
at the load-balancing code (unfortunatelly, don't have an SMP machine
which I can upgrade to the recent kernel) and so far for me it's
mainly about getting sure I see things sanely.


-- 
Best regards,
Dmitry Adamushko
