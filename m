Return-Path: <linux-kernel-owner+w=401wt.eu-S1765163AbZFLNwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765163AbZFLNwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934421AbZFLNvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:51:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38040 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934429AbZFLNvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:51:35 -0400
Date: Fri, 12 Jun 2009 15:46:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] posix-cpu-timers: avoid do_sys_times() races with
	__exit_signal()
Message-ID: <20090612134626.GA3784@redhat.com>
References: <20090612103403.2e1d576f@dhcp-lab-109.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612103403.2e1d576f@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12, Stanislaw Gruszka wrote:
>
> Protect thread_group_cputime() call by siglock, to avoid possible (but
> to be honest - very improbable) double times accounting of exiting task.
> This is revert of commit 2b5fe6de58276d0b5a7c884d5dbfc300ca47db78
> "thread_group_cputime: move a couple of callsites outside of ->siglock",
> but implementation of thread_group_cputime() was different then.

Yes, at that time thread_group_cputime() was reading per-cpu data, and
->siglock was unneeded.

I think the patch is correct.

Oleg.

