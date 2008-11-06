Return-Path: <linux-kernel-owner+w=401wt.eu-S1752879AbYKFUuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbYKFUuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYKFUuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:50:05 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:37402 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbYKFUuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:50:04 -0500
Message-ID: <49135873.7010309@nortel.com>
Date: Thu, 06 Nov 2008 14:49:55 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Ken Chen <kenchen@google.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [patch] restore sched_exec load balance heuristics
References: <b040c32a0811061140u27093e4er70a43041564617f1@mail.gmail.com> <20081106200746.GA3578@elte.hu> <b040c32a0811061232j49a40ce8md32ff5e614441e38@mail.gmail.com>
In-Reply-To: <b040c32a0811061232j49a40ce8md32ff5e614441e38@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Nov 2008 20:49:59.0654 (UTC) FILETIME=[3BCC4060:01C94051]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ken Chen wrote:

> There are two callers to sched_balance_self().  In the sched_fork
> path, sched_balance_self will balance the newly forked task.  I think
> it is OK to bounce a newly forked task to another CPU since current
> CPU will be busy when fork returns in the parent process.

What about vfork()?

> And if sched_balance_self() needs to different between fork / exec
> load balance, it has to check a flag from function argument, which I
> think it is better to just short circuit in sched_exec() directly.

 From a cleanliness perspective, it make more sense to me for the 
decision as to whether or not to balance to be done in the "balance" 
function, not the "exec" function.

Chris
