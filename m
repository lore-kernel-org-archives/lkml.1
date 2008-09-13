Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbYIMGgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbYIMGgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 02:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYIMGgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 02:36:05 -0400
Received: from il.qumranet.com ([212.179.150.194]:25036 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbYIMGgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 02:36:04 -0400
Message-ID: <48CB5F56.5050001@qumranet.com>
Date: Sat, 13 Sep 2008 09:36:06 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/cpu.c: Move the CPU_DYING notifiers
References: <200808311809.m7VI9whf014532@mail.q-ag.de>
In-Reply-To: <200808311809.m7VI9whf014532@mail.q-ag.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> When a cpu is taken offline, the CPU_DYING notifiers are called on the
> dying cpu. According to <linux/notifiers.h>, the cpu should be "not
> running any task, not handling interrupts, soon dead".
>
> For the current implementation, this is not true:
> - __cpu_disable can fail. If it fails, then the cpu will remain alive
>   and happy.
> - At least on x86, __cpu_disable() briefly enables the local interrupts
>   to handle any outstanding interrupts.
>
> What about moving CPU_DYING down a few lines, behind the __cpu_disable()
> line?
> There are only two CPU_DYING handlers in the kernel right now: one in
> kvm, one in the scheduler. Both should work with the patch applied
> [and: I'm not sure if either one handles a failing __cpu_disable()]
>
> The patch survives simple offlining a cpu. kvm untested due to lack
> of a test setup.
>
>   

kvm should work with this patch.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

