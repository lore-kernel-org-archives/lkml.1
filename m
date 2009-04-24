Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbZDXWtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbZDXWtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 18:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZDXWtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 18:49:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36160 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbZDXWtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 18:49:41 -0400
Date: Sat, 25 Apr 2009 00:49:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Message-ID: <20090424224905.GC6403@elte.hu>
References: <20090423191934.GW1926@parisc-linux.org> <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it> <20090424071312.GE8633@ZenIV.linux.org.uk> <20090424071853.GG8633@ZenIV.linux.org.uk> <20090424080634.GG24912@elte.hu> <20090424085017.GB28592@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424085017.GB28592@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> > You've also not explained why you have done it this way. It 
> > would cost you almost nothing to apply these bits into a 
> > separate branch and merge that branch into your main tree. Lots 
> > of other maintainer are doing that.
> 
> Having a separate kill the BKL tree is a stupid idea. Locking 
> changes need deep subsystem knowledge and should always go through 
> the subsystem trees.

Here you are missing the small inconvenient fact that having the 
kill-the-BKL tree is what got this work underway. It is what got 
developers interested, it is what is concentrating the effort, and 
it is that is producing the patches.

_Nobody_ ever suggested that VFS patches should not go upstream via 
the VFS tree. We are _happy_ that BKL removal patches are finally 
flowing through the VFS tree.

The _only_ very minimal courtesy i was asking for was to also be 
'allowed' to carry those fixes that we WROTE, with the same commit 
ID - so that if the kill-the-BKL tree goes upstream sometime in the 
(apparently far) future (well after the VFS bits go upstream), it 
will look nice and wont have duplicate commits. We are patient, and 
we'd like to maintain a tidy tree.

But i didnt even get a _reply_ to that initial request - Al just 
committed it straight into the VFS tree and ignored my question 
somewhat rudely.

The thing is, for years you never cared about the BKL being deep 
embedded in the guts of the VFS. But the minute someone _else_ does 
what arguably you should have done long ago, you stand in the way 
and hinder that effort by first proclaiming that this tree should 
not be doing such changes and then forcing it into an ugly (future) 
rebase?

Exactly how does such kind of behavior help Linux, in your opinion?

	Ingo
