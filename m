Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYIDTGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYIDTGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbYIDTF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:05:27 -0400
Received: from mail.vyatta.com ([216.93.170.194]:39141 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbYIDTFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:05:25 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.63
Date: Thu, 4 Sep 2008 12:05:22 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] Return value from schedule()
Message-ID: <20080904120522.6d5fdf8d@extreme>
In-Reply-To: <20080904174845.GN2772@parisc-linux.org>
References: <20080827204626.4b65862f@extreme>
	<20080828111323.GI7908@solarflare.com>
	<20080903155713.7fab2e19@extreme>
	<20080904160739.GK2772@parisc-linux.org>
	<20080904161424.GA23042@elte.hu>
	<20080904162111.GM2772@parisc-linux.org>
	<20080904103049.01f748d9@infradead.org>
	<20080904174845.GN2772@parisc-linux.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 11:48:45 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Thu, Sep 04, 2008 at 10:30:49AM -0700, Arjan van de Ven wrote:
> > use schedule_hrtimerout() for this (hopefully will be in 2.6.28);
> > see this weeks LWN for an article describing it
> 
> OK, so something like:
> 
> 	struct timespec ts = { 0, 10 * 1000 };
> 
> 	set_task_state(TASK_INTERRUPTIBLE);
> 	schedule_hrtimeout(&ts, HRTIMER_MODE_REL);
> 	if (fatal_signal_pending())
> 		return -EINTR;
> 
> should do the trick.
> 

Never mind, I changed it to just yield() in revision.
