Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbZAOH32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbZAOH32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755534AbZAOH3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:29:17 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38849 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbZAOH3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:29:16 -0500
Subject: Re: 2.6.28 has unconfigurable group sched?
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Glines <mark@glines.org>
Cc: Ingo Molnar <mingo@elte.hu>, L-K <linux-kernel@vger.kernel.org>
In-Reply-To: <496DFACE.10403@glines.org>
References: <496CDDE9.3050008@glines.org> <1231926992.7141.23.camel@twins>
	 <496DFACE.10403@glines.org>
Content-Type: text/plain
Date: Thu, 15 Jan 2009 08:29:04 +0100
Message-Id: <1232004544.14825.75.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 06:46 -0800, Mark Glines wrote:
> Peter Zijlstra wrote:
> >> So it seems rt_schedulable() is never succeeding.  Any ideas?
> > 
> > Yeah, I should test this user grouping stuff more often :/
> > 
> > The below fixes it for me.
> > ---
> > Subject: sched: fix bandwidth validation for UID grouping 
> > 
> > For UID grouping we initialize the root group with infinite bandwidth
> > which by default is actually more than the global limit, therefore the
> > bandwidth check always fails.
> > 
> > Because the root group is a phantom group (for UID grouping) we cannot
> > runtime adjust it, therefore we let it reflect the global bandwidth
> > settings.
> 
> 
> Thanks.  Sadly, this doesn't seem to change anything for me.  I applied
> it to 2.6.28, rebuilt and reinstalled, and got the same result.  I did a
> clean rebuild to be sure; and got the same behavior again.
> 
> Please let me know if there are any additional diagnostics I can provide.

Most strange, I did the patch on .28 just to be sure (my initial testing
was done on -linus since I couldn't remember it having changed in a
while), and it still works for me.

CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set

Linux opteron 2.6.28 #634 SMP PREEMPT Wed Jan 14 18:13:31 CET 2009
x86_64 x86_64 x86_64 GNU/Linux

# echo 450000 > /sys/kernel/uids/0/cpu_rt_runtime 
# cat /sys/kernel/uids/0/cpu_rt_runtime
450000


