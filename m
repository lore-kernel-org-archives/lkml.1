Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYCIMtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYCIMtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 08:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752961AbYCIMta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 08:49:30 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:33684 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbYCIMt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 08:49:29 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
	<20080309111456.GA21690@elte.hu>
	<alpine.LFD.1.00.0803091244420.3099@apollo.tec.linutronix.de>
	<20080309120124.GB1249@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Mar 2008 13:49:26 +0100
In-Reply-To: <20080309120124.GB1249@elte.hu>
Message-ID: <87ejak12qx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2008 12:42:55.0127 (UTC) FILETIME=[18A7D270:01C881E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Right, also the quicklist_trim() in idle() is freeing at max 16 pages 
> > in one go. According to the quicklist_trim() code we keep up to 
> > (node_free_pages / 16) in the quicklist unconditionally, which seems 
> > rather odd as well.
> 
> i suspect the right approach would be to get rid of them altogether and 
> to convert the code to RCU and plain old alloc/free instead.

Are you sure RCU is even needed? AFAIK all delayed freeing 
on page table level is already handled by the standard free-after-flush
mmu code. 

iirc quicklists were just to avoid rezeroing pages which are known to
be zero at free time (in theory __GFP_ZERO should handle that at 
page_alloc.c level, but it doesn't) and to get a little private fast path 
for the page allocator (might actually predate the current page_alloc
fast paths)

-Andi
