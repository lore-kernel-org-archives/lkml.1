Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYJPOMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYJPOMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYJPOMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:12:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60874 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753527AbYJPOMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:12:42 -0400
Date: Thu, 16 Oct 2008 10:12:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 3/9] Modifying generic debug exception to use virtual
 debug registers
In-Reply-To: <20081016002555.808EF1544CB@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0810161007560.2487-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Roland McGrath wrote:

> You need to redo this (and the whole set) for the post-2.6.27 tree.
> e.g. traps.c has been unified.
> 
> +	/* Store the virtualized DR6 value */
> +	tsk->thread.vdr6 = dr6;
> +
> +	if (notify_die(DIE_DEBUG, "debug", regs, dr6, error_code,
> +			SIGTRAP) == NOTIFY_STOP)
>  		return;
> 
> I'm not sure you should change vdr6 when notify_die returns NOTIFY_STOP.
> Maybe Alan and I hashed out the logic of this before, I don't recall.
> If the notifier is eating the event, then it should not affect the
> thread-virtualized view of %db6.  That would be consistent with the
> existing code, where ->thread.debugreg6 is only set later when all the
> intercepted or spurious exceptions have been filtered out.

I think we have to leave the code as it is.  As each notifier routine 
processes the event, it will turn off the corresponding bits in vdr6.  
We don't want those bits to get turned back on again by overwriting 
vdr6 after the notifier chain has finished.

Alan Stern

