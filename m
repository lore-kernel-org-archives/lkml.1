Return-Path: <linux-kernel-owner+w=401wt.eu-S1752180Ab0AZIWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab0AZIWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027Ab0AZIWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:22:39 -0500
Received: from mtagate5.de.ibm.com ([195.212.17.165]:59403 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab0AZIWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:22:39 -0500
Date: Tue, 26 Jan 2010 09:22:34 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, Thomas Gleixner <tglx@linutronix.de>,
       John Stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH 3/4] kgdb,clocksource: Prevent kernel hang in kernel
 debugger
Message-ID: <20100126092234.77b363d4@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com>
	<1264480000-6997-4-git-send-email-jason.wessel@windriver.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 22:26:39 -0600
Jason Wessel <jason.wessel@windriver.com> wrote:

> This is a regression fix against: 0f8e8ef7c204988246da5a42d576b7fa5277a8e4
> 
> Spin locks were added to the clocksource_resume_watchdog() which cause
> the kernel debugger to deadlock on an SMP system frequently.
> 
> The kernel debugger can try for the lock, but if it fails it should
> continue to touch the clocksource watchdog anyway, else it will trip
> if the general kernel execution has been paused for too long.
> 
> This introduces an possible race condition where the kernel debugger
> might not process the list correctly if a clocksource is being added
> or removed at the time of this call.  This race is sufficiently rare vs
> having the kernel debugger hang the kernel
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> CC: John Stultz <johnstul@us.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Magnus Damm <damm@igel.co.jp>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

The first question I would ask is why does the kernel deadlock? Can we
have a backchain of a deadlock please?

Hmm, there are all kinds of races if the watchdog code gets interrupted
by the kernel debugger. Wouldn't it be better to just disable the
watchdog while the kernel debugger is active? 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

