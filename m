Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbYEGTZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbYEGTZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933392AbYEGTYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:24:48 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56844 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765976AbYEGTYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:24:43 -0400
Date: Wed, 7 May 2008 13:24:25 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507192425.GC19219@parisc-linux.org>
References: <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org> <20080507172246.GA13262@elte.hu> <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org> <20080507174900.GB13591@elte.hu> <alpine.LFD.1.10.0805071057280.3024@woody.linux-foundation.org> <20080507181714.GA14980@elte.hu> <alpine.LFD.1.10.0805071125090.3024@woody.linux-foundation.org> <20080507184304.GA15554@elte.hu> <alpine.LFD.1.10.0805071150140.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805071150140.3024@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 12:01:28PM -0700, Linus Torvalds wrote:
> The thing is, we definitely are interested to see whether it's the BKL or 
> some other semaphore that is the problem. But the best way to test that is 
> to just try my patch that *guarantees* that the BKL doesn't have any 
> semaphore behaviour AT ALL.
> 
> Could it be something else entirely? Yes. We know it's semaphore- related. 
> We don't know for a fact that it's the BKL itself. There could be other 
> semaphores that are that hot. It sounds unlikely, but quite frankly, 
> regardless, I don't really see the point of your patches.
> 
> If Yanmin tries my patch, it is *guaranteed* to show something. It either 
> shows that it's about the BKL (and that we absolutely have to do the BKL 
> as something _else_ than a generic semaphore), or it shows that it's not 
> about the BKL (and that _all_ the patches in this discussion are likely 
> pointless).

One patch I'd still like Yanmin to test is my one from yesterday which
removes the BKL from fs/locks.c.

http://marc.info/?l=linux-fsdevel&m=121009123427437&w=2

Obviously, it won't help if the problem isn't the BKL.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
