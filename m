Return-Path: <linux-kernel-owner+w=401wt.eu-S1161250AbXCGDtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161250AbXCGDtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 22:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161253AbXCGDtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 22:49:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161250AbXCGDtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 22:49:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/utrace
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: Alan Stern's message of  Tuesday, 6 March 2007 10:23:53 -0500 <Pine.LNX.4.44L0.0703061015100.3401-100000@iolanthe.rowland.org>
X-Zippy-Says: I'm sitting on my SPEED QUEEN..  To me, it's ENJOYABLE..  I'm
   WARM..  I'm VIBRATORY..
Message-Id: <20070307034932.09F5A1801C4@magilla.sf.frob.com>
Date: Tue,  6 Mar 2007 19:49:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Yeah, I guess that's right.  It should still return NOTIFY_STOP when
> > args->err has no other bits set, so notifiers aren't called with zero.
> 
> In practice that might not work.  On my machine, at least, reads of DR6
> return ones in all the reserved bit positions.

Does that mean asm("mov %1,%%dr6; mov %%dr6,%0" : "=r" (mask) : "r" (0)); 
puts in mask the set of reserved bits?  We could collect that value at CPU
startup and mask it off args->err, then OR it back into vdr6.


Thanks,
Roland
