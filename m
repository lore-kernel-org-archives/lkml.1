Return-Path: <linux-kernel-owner+w=401wt.eu-S1762588AbZC0Xyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762588AbZC0Xyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755778AbZC0Xyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:54:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbZC0Xyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:54:37 -0400
Subject: Re: [PATCH] Allow preemption during lazy mmu updates
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1238176963-21093-1-git-send-email-jeremy@goop.org>
References: <1238176963-21093-1-git-send-email-jeremy@goop.org>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 00:48:20 +0100
Message-Id: <1238197700.4039.300.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-27 at 11:02 -0700, Jeremy Fitzhardinge wrote:
> Hi all,
> 
> We discussed this series a while ago.  The specific problem
> was the need to disable preemption in apply_to_pte_range when using
> lazy mmu updates around the callback function.  When used on usermode
> addresses there was no problem because it needs to take the pte
> lock anyway, but there's no requirement for taking a pte lock when
> updating kernel ptes, so it ended up adding a new no-preempt region.
> 
> The gist of the series is that if we get preempted while doing an mmu
> update, we flush all the pending updates and switch to the next task.
> We record that the task was doing a lazy mmu update in its task flags,
> and resume lazy updates when we switch back.
> 
> All the context-switch time activity happens in the existing
> context-switch pvops calls, so there's no cost to non-pvops systems,
> or to pvops backends which don't use lazy mmu updates.
> 
> I don't think there were any objections to this series, but Ingo would
> like to see an Acked by from someone since it gets into the mm side
> of things.
> 
> (The first patch in the series adds the required preempt disable/enable
> and then the rest of the series removes them again.  I think the first
> patch is already in mm-.)

Looks good from my POV

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

