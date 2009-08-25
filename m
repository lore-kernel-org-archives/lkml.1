Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbZHYN5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbZHYN5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZHYN5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:57:48 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41941 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752906AbZHYN5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:57:47 -0400
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory (f6f6e1a4), by kmemleak's scan_block()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090825104311.GA10642@elte.hu>
References: <1251189914.7261.11.camel@penberg-laptop>
	 <20090825084808.GA14003@elte.hu> <1251190466.7261.12.camel@penberg-laptop>
	 <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
	 <1251191507.26351.0.camel@penberg-laptop>
	 <1251192069.15678.21.camel@pc1117.cambridge.arm.com>
	 <1251192415.26351.5.camel@penberg-laptop>
	 <1251192534.15678.29.camel@pc1117.cambridge.arm.com>
	 <84144f020908250231k30ff4e9do20856bd1291f418c@mail.gmail.com>
	 <20090825093423.GA12935@elte.hu>  <20090825104311.GA10642@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 25 Aug 2009 14:57:38 +0100
Message-Id: <1251208658.15678.45.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Aug 2009 13:57:39.0052 (UTC) FILETIME=[01DEFAC0:01CA258C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 12:43 +0200, Ingo Molnar wrote:
> btw., i re-tested the original tree, and got the lockup/crash below.
> 
> 	Ingo
> 
> --------------->
> EXT3 FS on sdb1, internal journal
> EXT3-fs: mounted filesystem with writeback data mode.
> BUG: soft lockup - CPU#0 stuck for 61s! [kmemleak:3080]

Do you have the "Allow rescheduling during object scanning" patch? Apart
from that, you may need another for not holding the tasklist_lock when
scanning the task stacks - it is at the top of my kmemleak branch,
together with a patch or informing kmemleak about thread stack
allocations
(http://www.linux-arm.org/git?p=linux-2.6.git;a=shortlog;h=refs/heads/kmemleak).

With these patches, I don't get any soft lockups on my system.

-- 
Catalin

