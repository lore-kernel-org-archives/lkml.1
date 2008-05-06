Return-Path: <linux-kernel-owner+w=401wt.eu-S1765237AbYEFQhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765237AbYEFQhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYEFQhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:37:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247AbYEFQhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:37:00 -0400
Date: Tue, 6 May 2008 09:36:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Ingo Molnar <mingo@elte.hu>, "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080506162332.GI19219@parisc-linux.org>
Message-ID: <alpine.LFD.1.10.0805060931450.32269@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Matthew Wilcox wrote:
> 
> I've wanted to fix file locks for a while.  Here's a first attempt.
> It was done quickly, so I concede that it may well have bugs in it.
> I found (and fixed) one with LTP.

Hmm. Wouldn't it be nicer to make the lock be a per-inode thing? Or is 
there some user that doesn't have the inode info, or does anything that 
might cross inode boundaries?

This does seem to drop all locking around the "setlease()" calls down to 
the filesystem, which worries me. That said, we clearly do need to do 
this. Probably should have done it a long time ago.

Also, why do people do this:

> -find_conflict:
> + find_conflict:

Hmm?

		Linus
