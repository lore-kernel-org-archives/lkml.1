Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYEZRDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYEZRDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYEZRCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:02:40 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54092 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754010AbYEZRCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:02:38 -0400
Date: Mon, 26 May 2008 13:01:48 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kara <jack@suse.cz>, Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080526170147.GB9893@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Jan Kara <jack@suse.cz>, Arjan van de Ven <arjan@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
References: <4836EE8C.1010200@linux.intel.com> <20080524222304.GD20563@atrey.karlin.mff.cuni.cz> <20080524153020.1df96cf2@linux.intel.com> <20080524224554.GA5970@mit.edu> <20080526093913.GG13529@elte.hu> <20080526101646.GD24507@mit.edu> <20080526104832.GG23261@elte.hu> <20080526162048.GH32407@duck.suse.cz> <20080526164858.GA24098@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526164858.GA24098@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 06:48:58PM +0200, Ingo Molnar wrote:
> 
> What if the USB stick was pulled mistakenly, the user notices her 
> mistake later on and plugs the USB stick back in and expects all the 
> data to not be corrupted?

If the USB stack folks would like to work on how to recognize that
it's the same USB stick that had been previously pulled, so that it
gets the same block device, and we can decide for how long we should
keep dirty buffers around associated with a pulled USB stick, we can
certainly have that conversation.  :-)

> And any such problems do come up in the enterprise space as well, in 
> terms of multipath IO issues - and Linux still does quite poorly in that 
> area.

We definitely have problems here, I agree.  But at least with a
multipath I/O device we have something that sticks around even when
the last I/O path is pulled.  We could talk about setting up
dm-multipath with USB, I suppose --- that would have the benefit of
getting the dm-multipath code much more widely exercised without
needing exotic (and expensive) hardware kit being required.

	       	    	       		    	  - Ted
