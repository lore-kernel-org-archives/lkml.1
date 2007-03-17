Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbXCQRTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbXCQRTf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 13:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbXCQRTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 13:19:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:54005 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXCQRTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 13:19:34 -0400
To: =?iso-8859-2?q?Tomasz_Noi=F1ski?= <noix@sphere.pl>
Cc: linux-kernel@vger.kernel.org, timm@kip.uni-heidelberg.de,
       arne.wiebalck@kip.uni-heidelberg.de
Subject: Re: more precise CPU time accounting for x86
References: <20070317164722.1fed2b27.noix@sphere.pl>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Mar 2007 19:18:38 +0100
In-Reply-To: <20070317164722.1fed2b27.noix@sphere.pl>
Message-ID: <p73bqir7myp.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Noiñski <noix@sphere.pl> writes:

> Hi,
> 
> I've written a small patch for more precise process CPU time accounting
> for processors with TSC.
> 
> Currently, accounting is sample-based and it can be fooled by, for
> example, a process that always gives away the rest of it's timeslice.

RDTSC is unfortunately quite slow on some CPUs.

But we already use it in schedule for sched_clock(). I think
an interesting approach would be to use this information
and just sum it up in the task_struct. This would still not
account for interrupts and system time separately, but should
be relatively cheap and give more accurate time. Drawback would
be that user tools would need to be updated to read a "sys+user"
count.

BTW perfctrs on most x86 CPUs can count user/kernel separately,
unfortunately it is hard to find a performance counter that
matches real time well enough and they couldn't easily
separate interrupts vs systime belonging to the process.

-Andi
