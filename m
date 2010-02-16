Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0BPAG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 19:06:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932090Ab0BPAGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 19:06:25 -0500
Date: Mon, 15 Feb 2010 16:05:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jan Kara <jack@suse.cz>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, jengelh@medozas.de,
       stable@kernel.org, gregkh@suse.de
Subject: Re: [PATCH] writeback: Fix broken sync writeback
In-Reply-To: <20100215141750.GC3434@quack.suse.cz>
Message-ID: <alpine.LFD.2.00.1002151601360.18830@localhost.localdomain>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain> <20100215141750.GC3434@quack.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Feb 2010, Jan Kara wrote:
> 
> Personally, I don't see why VM shouldn't generate IO from a single inode
> larger than a few MB for data integrity syncs. There are two reasons I know
> about for MAX_WRITEBACK_PAGES:

Two issues:
 - it shouldn't matter for performance (if you have a broken disk that 
   wants multi-megabyte writes to get good performance, you need to fix 
   the driver, not the VM)
 - I generally think that _latency_ is much more important than 
   throughput, and huge writes are simply bad for latency.

But the real complaint I had about your patch was that it made no sense. 

Your statement that it speeds up sync is indicative of some _other_ 
independent problem (perhaps starting from the beginning of the file each 
time? Who knows?) and the patch _clearly_doesn't actually address the 
underlying problem, it just changes the logic in a way that makes no 
obvious sense to anybody, without actually explaining why it would matter.

So if you can explain _why_ that patch makes such a big difference for 
you, and actually write that up, I wouldn't mind it. But right now it was 
sent as a voodoo patch with no sensible explanation for why it would 
really make any difference, since the outer loop should already do what 
the patch does.

		Linus
