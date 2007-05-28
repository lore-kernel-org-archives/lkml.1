Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbXE1BRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbXE1BRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 21:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758445AbXE1BRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 21:17:34 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:21449 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728AbXE1BRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 21:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=j70wWX6dIfsiGT6Upv66g7FREPt3/ZUF38kM+KbHVzkDXeMBBDvU2l6odvK5llQOEbPwcC98ffluTFQ6eFpPE+M57NzPsBzUOoReRywuX4nxWkj9/Mt4wQWlS1Xl1lbXF9NlS5UDTZkLOUchzC/p5lDiIyAmpbIb4PI+6w+olnQ=
Message-ID: <465A2DA4.7070409@gmail.com>
Date: Mon, 28 May 2007 09:17:24 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v14
References: <20070523120616.GA23407@elte.hu>
In-Reply-To: <20070523120616.GA23407@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i'm pleased to announce release -v14 of the CFS scheduler patchset.
>
> The CFS patch against v2.6.22-rc2, v2.6.21.1 or v2.6.20.10 can be 
> downloaded from the usual place:
>    
>       http://people.redhat.com/mingo/cfs-scheduler/
>   

In comment before distribute_fair_add(), we have such text:

/*
  * A task gets added back to the runnable tasks and gets
  * a small credit for the CPU time it missed out on while
  * it slept, so fix up all other runnable task's wait_runtime
  * so that the sum stays constant (around 0).
  *
[snip]
  */

But as I observe by cat /proc/sched_debug (2.6.21.1, UP, RHEL4), I found 
the all waiting fields often are more than zero, or less than zero.

IMHO, the sum of task_struct->wait_runtime just is the denominator of 
all runnable time in some ways, is it right? if so, increasing the sum 
of wait_runtime just make scheduling decision more precise. so what's 
meaning for keeping the wait_runtime is zero-sum?

Good luck

- Li Yu
