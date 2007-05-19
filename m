Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbXESN2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbXESN2G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 09:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbXESN15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 09:27:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:64187 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbXESN14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 09:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rmZdZUHuFIFUW2eu+3qWWwFP7rWQ5M94RDkR4vhgQcJWw9ZU8j5+voUDIe1s8JPiMexdtSFC4pcvmjIJedlsuw4QBoGa6+kgkCmo1eLmo8RKputdnG4Xr4YHt0gz3XV2EbCMnHdhkwAEYgq0OyFUBj3ihLy2W+k6NxbgLXG9XDM=
Message-ID: <b647ffbd0705190627x4ff15f3cw19bc292e47257287@mail.gmail.com>
Date: Sat, 19 May 2007 15:27:54 +0200
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
> [...]
> One thing that might work is to jitter the load balancing interval a
> bit.  The reason I say this is that one of the characteristics of top
> and gkrellm is that they run at a more or less constant interval (and,
> in this case, X would also be following this pattern as it's doing
> screen updates for top and gkrellm) and this means that it's possible
> for the load balancing interval to synchronize with their intervals
> which in turn causes the observed problem.  A jittered load balancing
> interval should break the synchronization.  This would certainly be
> simpler than trying to change the move_task() logic for selecting which
> tasks to move.

Just an(quick) another idea. Say, the load balancer would consider not
only p->load_weight but also something like Tw(task) =
(time_spent_on_runqueue / total_task's_runtime) * some_scale_constant
as an additional "load" component (OTOH, when a task starts, it takes
some time for this parameter to become meaningful). I guess, it could
address the scenarios your have described (but maybe break some others
as well :) ...
Any hints on why it's stupid?


>
> Peter
> --
> Peter Williams                                   pwil3058@bigpond.net.au

-- 
Best regards,
Dmitry Adamushko
