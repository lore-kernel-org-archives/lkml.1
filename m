Return-Path: <linux-kernel-owner+w=401wt.eu-S1750888AbXECIUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888AbXECIUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXECIUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:20:42 -0400
Received: from linux.dunaweb.hu ([62.77.196.1]:47527 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXECIUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:20:40 -0400
Message-ID: <46399B51.9040608@dunaweb.hu>
Date: Thu, 03 May 2007 10:20:33 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> *** Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
> > The problem is with comparing a s64 values with (s64)ULONG_MAX, which 
> > evaluates to -1. Then we check if exec_delta64 and fair_delta64 are 
> > greater than (s64)ULONG_MAX (-1), if so we assign (s64)ULONG_MAX to 
> > the respective values.
>
> ah, indeed ...
>
> > The fix is to compare these values against (s64)LONG_MAX and assign 
> > (s64)LONG_MAX to exec_delta64 and fair_delta64 if they are greater 
> > than (s64)LONG_MAX.
> > 
> > Tested on PowerPC, the regression is gone, tasks are load balanced as 
> > they were in v7.
>
> thanks, applied!
>
> 	Ingo

I started up 12 glxgears to see the effect of CFS v8
on my Athlon64 X2 4200.

Without this patch all the GL load was handled by the second core,
the system only stressed the first core if other processes were also
started, i.e. a kernel compilation. With this patch  the load is evenly
balanced across the two cores all the time. And while doing make -j4
on the kernel, the 12 gears are still spinning about 185+ FPS and
there are only slightly visible hiccups. Switching between workspaces,
i.e. refreshing the large windows of Thunderbird and Firefox are
done very quickly, the whole system is exceptionally responsive.

Thanks for this great work!

Best regards,
Zoltán Böszörményi

