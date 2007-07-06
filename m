Return-Path: <linux-kernel-owner+w=401wt.eu-S1763612AbXGFUtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbXGFUtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 16:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760058AbXGFUtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 16:49:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36443 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760057AbXGFUtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 16:49:03 -0400
Date: Fri, 6 Jul 2007 16:48:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070628023100.E46AB4D05E6@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0707061637530.4777-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Roland McGrath wrote:

> In the first battle just to make it compile, the only issue was that you
> assume every machine has TIF_DEBUG, which is in fact an implementation
> detail chosen lately by i386 and x86_64.  AFAIK the only reason for it
> there is just to make a cheap test of multiple bits in the hot path
> deciding to call __switch_to_xtra.  Do you rely on it meaning something
> more precise than just being a shorthand for hw_breakpoint_info!=NULL?

Going over the code, I remembered that TIF_DEBUG really does mean moree
than just hw_breakpoint_info != NULL.  It means that the thread
actually has some breakpoints registered.

Why keep the hw_breakpoint_info structure if there are no registered 
breakpoints?  I did it so that the virtualized DR[0-3] values would 
remain intact.

For other processors that have only one debug register, this won't
matter so much.  But of course there are references to TIF_DEBUG in the 
arch-independent code.  Do you think there would be any problem about 
reserving a bit for TIF_DEBUG in the other architectures?

Alan Stern

P.S.: I'm just now getting around to doing the stuff we discussed last
week.  It has been a busy time...  At OLS somebody asked when 
hw-breakpoint would get into the mainline.  I guessed that it would be 
a few months before it is added to -mm.  Solving this 
pre/post-notification issue will be difficult.

