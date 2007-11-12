Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbXKLArU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbXKLArU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 19:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756165AbXKLArM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 19:47:12 -0500
Received: from mga10.intel.com ([192.55.52.92]:52939 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756134AbXKLArL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 19:47:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,402,1188802800"; 
   d="scan'208";a="378727816"
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: a.p.zijlstra@chello.nl, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <337294.80877.qm@web32607.mail.mud.yahoo.com>
References: <337294.80877.qm@web32607.mail.mud.yahoo.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 12 Nov 2007 08:45:57 +0800
Message-Id: <1194828357.20251.63.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-09 at 04:36 -0800, Martin Knoblauch wrote:
> ----- Original Message ----
> > From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
> > To: a.p.zijlstra@chello.nl
> > Cc: LKML <linux-kernel@vger.kernel.org>
> > Sent: Friday, November 9, 2007 10:47:52 AM
> > Subject: iozone write 50% regression in kernel 2.6.24-rc1
> > 
> > Comparing with 2.6.23, iozone sequential write/rewrite (512M) has
> > 50%
> > 
>  regression
> > in kernel 2.6.24-rc1. 2.6.24-rc2 has the same regression.
> > 
> > My machine has 8 processor cores and 8GB memory.
> > 
> > By bisect, I located patch
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=
> > 04fbfdc14e5f48463820d6b9807daa5e9c92c51f.
> > 
> > 
> > Another behavior: with kernel 2.6.23, if I run iozone for many
> > times
> > 
>  after rebooting machine,
> > the result looks stable. But with 2.6.24-rc1, the first run of
> > iozone
> > 
>  got a very small result and
> > following run has 4Xorig_result.
> > 
> > What I reported is the regression of 2nd/3rd run, because first run
> > has
> > 
>  bigger regression.
> > 
> > I also tried to change
> > /proc/sys/vm/dirty_ratio,dirty_backgroud_ratio
> > 
>  and didn't get improvement.
>  could you tell us the exact iozone command you are using?
iozone -i 0 -r 4k -s 512m


>  I would like to repeat it on my setup, because I definitely see the opposite behaviour in 2.6.24-rc1/rc2. The speed there is much better than in 2.6.22 and before (I skipped 2.6.23, because I was waiting for the per-bdi changes). I definitely do not see the difference between 1st and subsequent runs. But then, I do my tests with 5GB file sizes like:
> 
> iozone3_283/src/current/iozone -t 5 -F /scratch/X1 /scratch/X2 /scratch/X3 /scratch/X4 /scratch/X5 -s 5000M -r 1024 -c -e -i 0 -i 1
My machine uses SATA (AHCI) disk.

-yanmin
