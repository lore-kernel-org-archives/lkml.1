Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0CDR7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:59:22 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51129 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0CDR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:59:21 -0500
Subject: Re: [PATCH 0/9] oprofile, perf, x86: introduce new functions to
 reserve perfctrs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
In-Reply-To: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 18:59:19 +0100
Message-ID: <1267725559.25158.208.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 16:22 +0100, Robert Richter wrote:
> This patch set improves the perfctr reservation code. New functions
> are available to reserve a counter by its index only. It is no longer
> necessary to allocate both msrs of a counter which also improves the
> code and makes it easier.
> 
> For oprofile a handler is implemented that returns an error now if a
> counter is already reserved by a different subsystem such as perf or
> watchdog. Before, oprofile silently ignored that counter. Finally the
> new reservation functions can be used to allocate special parts of the
> pmu such as IBS, which is necessary to use IBS with perf too.
> 
> The patches are available in the oprofile tree:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> If there are no objections, I suggest to merge it into the
> tip/perf/core too, maybe after pending patches went in. If there are
> already conflicts, I will do the merge for this.

Right, so cleaning up that reservation code is nice, but wouldn't it be
much nicer to simply do away with all that and make everything use the
(low level) perf code?

You expressed interest in both making the oprofile kernel space user the
perf apis as well as making oprofile user space use the perf abi, in
which case the kernel entirely side goes away.



