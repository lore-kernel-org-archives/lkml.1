Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbZDQUOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbZDQUOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 16:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZDQUOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 16:14:07 -0400
Received: from THUNK.ORG ([69.25.196.29]:60769 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbZDQUOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 16:14:04 -0400
Date: Fri, 17 Apr 2009 16:13:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Amit Shah <amit.shah@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] Add ext3 data=guarded mode
Message-ID: <20090417201342.GF26479@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Amit Shah <amit.shah@redhat.com>,
	Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
References: <1239816159-6868-1-git-send-email-chris.mason@oracle.com> <a22f99ce2199ebebe63228edd8afa4809511ab1e.1239815649.git.chris.mason@oracle.com> <1239910921.21233.98.camel@think.oraclecorp.com> <20090417180906.GA8363@amit-x200.pnq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417180906.GA8363@amit-x200.pnq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 11:39:06PM +0530, Amit Shah wrote:
> # 4GiB file, kernel 9f76208c33984ab777eace5d07a4e36e88703e02 + ext3-guarded
> 
> filesystem	posix-fallocate	mmap	chunk-4096	chunk-8192
> ext3-guarded	85		97	459		90
> ext3-writeback 86		95	140		94
> ext3-ordered	86		96	277		95
> 
> Running the test in single user mode, I get the following results:
> 
> # 4GiB file, kernel 9f76208c33984ab777eace5d07a4e36e88703e02 + ext3-guarded
> 
> filesystem	posix-fallocate	mmap	chunk-4096	chunk-8192
> ext3-guarded	84		86	163		91
> ext3-writeback 84		88	217		91
> ext3-ordered	84		86	226		91


The difference between guarded and writeback in chunk-4096 looking at
your desktop timings and your single user times is.... surprising. 

In particular, the fact that the guarded time is 3 times longer than
ext3-writeback when the desktop is running, and 20% faster in single
user mode.  Are these results reproducible?  And do you have any
thoughts as to what might be causing them?

					- Ted
