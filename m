Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbZATI4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbZATI4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 03:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZATI4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 03:56:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:43830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbZATI4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 03:56:01 -0500
Date: Tue, 20 Jan 2009 09:55:59 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: lockdep and debug objects together are broken?
Message-ID: <20090120085559.GB19505@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've had a problem frustrating my testing because lockdep was silently turning
itself off... I patched out the code to disable lockdep after the first error,
and it started showing up weird errors. kernel/fork.c:990 seemed to be the
first to trigger (hard irqs disabled) from a call_usermodehelper call. Later,
migration thread was reported to try to unlock rq->lock although it was
holding no locks. Then init was reported to return to userspace without
releasing an objectdebug hash lock.

All that went away and everything seemed to work properly with debug objects
configured out.

I didn't get too far in trying to debug the problem. But it should be easy
enough to reproduce (if not, I can post traces or test patches).

Thanks,
Nick
