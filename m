Return-Path: <linux-kernel-owner+w=401wt.eu-S1762779AbYCXS6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762779AbYCXS6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758040AbYCXS6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:58:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753694AbYCXS6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:58:09 -0400
Date: Mon, 24 Mar 2008 11:57:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] printk vs rq->lock and xtime lock
Message-Id: <20080324115738.85c72bb5.akpm@linux-foundation.org>
In-Reply-To: <1206382547.6437.131.camel@lappy>
References: <20080324122424.671168000@chello.nl>
	<alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
	<1206382547.6437.131.camel@lappy>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008 19:15:47 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> How about I use the lockdep infrastructure to check if printk() is
> invoked whole holding either xtime or rq lock, and then avoid calling
> wake_up_klogd(). That way, we at least get sane debug output when the
> lock debugging infrastructure is enabled?

The core problem seems to be that printk shouldn't be calling wake_up(). 
Can we fix that?

I expect it would be acceptable to do it from the timer interrupt instead. 
For NOHZ kernels a poll when we enter the idle loop would also be needed. 

But does that cover everything?  Is it possible for a CPU to run 100% busy
while not receiving timer interrupts?  I guess so.  To receive no
interrupts at all?  Also possible.

