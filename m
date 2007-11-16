Return-Path: <linux-kernel-owner+w=401wt.eu-S1765679AbXKPDjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765679AbXKPDjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbXKPDjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:39:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36196 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbXKPDjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:39:16 -0500
Date: Thu, 15 Nov 2007 19:38:02 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: davem@davemloft.net
Subject: Re: [NET]: rt_check_expire() can take a long time, add a
 cond_resched()
Message-ID: <20071115193802.4ec64eef@laptopd505.fenrus.org>
In-Reply-To: <200711150401.lAF41mSs021898@hera.kernel.org>
References: <200711150401.lAF41mSs021898@hera.kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 04:01:48 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:
> http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d90bf5a976793edfa88d3bb2393f0231eb8ce1e5
> Commit:     d90bf5a976793edfa88d3bb2393f0231eb8ce1e5 Parent:
> 66ba886254edbbd9442d30f1eef6f6fb0145027d Author:     Eric Dumazet
> <dada1@cosmosbay.com> AuthorDate: Wed Nov 14 16:14:05 2007 -0800
> Committer:  David S. Miller <davem@davemloft.net>
> CommitDate: Wed Nov 14 16:14:05 2007 -0800
> 
>     [NET]: rt_check_expire() can take a long time, add a
> cond_resched() 
>     On commit 39c90ece7565f5c47110c2fa77409d7a9478bd5b:

>     When the IP route cache is big, rt_check_expire() can take a long
> time to run.  (default settings : 20% of the hash table is scanned at
> each invocation)
>     
>     Adding cond_resched() helps giving cpu to higher priority tasks if
>     necessary.
>     
>     Using a "if (need_resched())" test before calling
> "cond_resched();" is necessary to avoid spending too much time doing
> the resched check. 

int __sched cond_resched(void)
{
        if (need_resched() &&  .....

somehow I wonder why the second if() is useful at all; it's another
spot for a branch predictor to miss... and a void function call is
really really cheap... 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
