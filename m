Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbYHYNsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbYHYNsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 09:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYHYNsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 09:48:15 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:48742 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754057AbYHYNsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 09:48:15 -0400
Date: Mon, 25 Aug 2008 09:48:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: edwin <edwintorok@gmail.com>, Ingo Molnar <mingo@elte.hu>, rml@tech9.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Quad core CPUs loaded at only 50% when running a CPU and mmap
	intensive multi-threaded task
Message-ID: <20080825134801.GN1408@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Peter Zijlstra <peterz@infradead.org>, edwin <edwintorok@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, rml@tech9.net,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <48B1CC15.2040006@gmail.com> <1219643476.20732.1.camel@twins> <48B25988.8040302@gmail.com> <1219656190.8515.7.camel@twins> <48B28015.3040602@gmail.com> <1219658527.8515.16.camel@twins> <48B287D8.1000000@gmail.com> <1219660582.8515.24.camel@twins> <48B290E7.4070805@gmail.com> <1219664477.8515.54.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219664477.8515.54.camel@twins>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 01:41:17PM +0200, Peter Zijlstra wrote:
> 
> I would certainly consider this for small (< 1M?) files. With mmap the
> faults and pte overhead aren't free either, and the extra memcpy from
> pread() isn't that much.
> 

Even for very big files, if you're only doing a single sequential pass
over a very large file (for example when converting a Canon raw image
file to TIFF format --- I know because I was trying to optimize dcraw
a while aback), you take the page fault for each 4k page, and so
simply using read/pread is faster.  And that's on a single-threded
program.  With a multithreaded program, the locking issues come on top
of that.

Maybe if I had used hugepages it would have been a win, I suppose, but
I never tried the experiment.  And this was several years ago, on much
older hardware, so maybe the relative times of doing the memory copy
versus the page fault, but I wouldn't be surprised if it's even more
expensive to do the mmap, relatively speaking.

							- Ted
