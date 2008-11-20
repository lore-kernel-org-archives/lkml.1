Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYKTSKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYKTSKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 13:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYKTSKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 13:10:45 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:49846 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195AbYKTSKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 13:10:44 -0500
Subject: Re: [PATCH 2.6.28-rc5 00/11] Kernel memory leak detector (updated)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081120122241.GH20724@elte.hu>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com>
	 <20081120122241.GH20724@elte.hu>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 20 Nov 2008 18:10:31 +0000
Message-Id: <1227204631.14146.63.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Nov 2008 18:10:32.0743 (UTC) FILETIME=[4741FB70:01C94B3B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 13:22 +0100, Ingo Molnar wrote:
> * Catalin Marinas <catalin.marinas@arm.com> wrote:
> I'd like to try it in the -tip automated testing setup, provided the 
> few details i just commented on are solved, and provided that these 
> things are addressed as well:
> 
> > Things still to be done:
> > 
> > - kernel thread to scan and report leaked objects periodically
> >   (currently done only when reading the /sys/kernel/debug/memleak
> >   file)
> > - run-time and boot-time configuration like task stacks scanning,
> >   disabling kmemleak, enabling/disabling the automatic scanning
> 
> the .config driven automatic "report currently known/suspected leaks 
> 60 seconds after bootup" feature would be nice to have. Should be 
> fairly easy to add, right? Otherwise i'd have no good way of getting a 
> leak report out of it, in an automated way.

This can be easily done and it will be part of the automatic scanning
mentioned above (after the first scan, I think a scan every 10 min would
be enough). The only issue is that currently a leak is reported after it
was found at least a number of times (the 2nd time by default) to avoid
transient reports where a pointer was held in registers for example. A
better approach might be to check the allocation jiffies and ignore the
very recent ones.

As for reporting, I think it should print a diff with the previous scan
otherwise you may end up with duplicated information in the log.

I'll look at implementing this over the following days and re-post.
Thanks for the other comments as well.

-- 
Catalin

