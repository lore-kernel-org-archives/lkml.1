Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbYARWs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbYARWs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762736AbYARWsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:48:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43416 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759738AbYARWst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:48:49 -0500
Date: Fri, 18 Jan 2008 14:47:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Oeser <ioe-lkml@rameria.de>
cc: Miklos Szeredi <miklos@szeredi.hu>, peterz@infradead.org,
       salikhmetov@gmail.com, linux-mm@kvack.org, jakob@unthought.net,
       linux-kernel@vger.kernel.org, valdis.kletnieks@vt.edu, riel@redhat.com,
       ksm@42.dk, staubach@redhat.com, jesper.juhl@gmail.com,
       akpm@linux-foundation.org, protasnb@gmail.com, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
Subject: Re: [PATCH -v6 2/2] Updating ctime and mtime for memory-mapped
 files
In-Reply-To: <200801182332.02945.ioe-lkml@rameria.de>
Message-ID: <alpine.LFD.1.00.0801181439330.2957@woody.linux-foundation.org>
References: <12006091182260-git-send-email-salikhmetov@gmail.com> <E1JFwnQ-0001FB-2c@pomaz-ex.szeredi.hu> <alpine.LFD.1.00.0801181127000.2957@woody.linux-foundation.org> <200801182332.02945.ioe-lkml@rameria.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Jan 2008, Ingo Oeser wrote:
> 
> Can we get "if the write to the page hits the disk, the mtime has hit the disk
> already no less than SOME_GRANULARITY before"? 
> 
> That is very important for computer forensics. Esp. in saving your ass!
> 
> Ok, now back again to making that fast :-)

I certainly don't mind it if we have some tighter guarantees, but what I'd 
want is:

 - keep it simple. Let's face it, Linux has never ever given those 
   guarantees before, and it's not is if anybody has really cared. Even 
   now, the issue seems to be more about paper standards conformance than 
   anything else.

 - I get worried about people playing around with the dirty bit in 
   particular. We have had some really rather nasty bugs here. Most of 
   which are totally impossible to trigger under normal loads (for 
   example the old random-access utorrent writable mmap issue from about 
   a year ago).

So these two issues - the big red danger signs flashing in my brain, 
coupled with the fact that no application has apparently ever really 
noticed in the last 15 years - just makes it a case where I'd like each 
step of the way to be obvious and simple and no larger than really 
absolutely necessary.

			Linus
