Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbXHBNDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbXHBNDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbXHBNDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:03:37 -0400
Received: from mail.fieldses.org ([66.93.2.214]:53233 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbXHBNDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:03:36 -0400
Date: Thu, 2 Aug 2007 09:03:19 -0400
To: Lee Revell <rlrevell@joe-job.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
Message-ID: <20070802130319.GB15761@fieldses.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <1185839164.27166.7.camel@localhost> <1185863461.3092.4.camel@twins> <20070731085713.GA15136@elte.hu> <75b66ecd0708011935x600fc547j8edbe1ed3092d560@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b66ecd0708011935x600fc547j8edbe1ed3092d560@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 10:35:41PM -0400, Lee Revell wrote:
> On 7/31/07, Ingo Molnar <mingo@elte.hu> wrote:
> > Almost all of the Reiser3
> > code runs under the BKL, and the only other major kernel infrastructure
> > that has BKL dependencies is the TTY code.
> 
> Also NFS:
> 
> $ grep -rIi lock_kernel kernel-source/linux-2.6.17/fs/nfs/ | wc -l
> 94

All the file locking code (the nfs-related stuff in fs/lockd/, and also
the vfs code in fs/locks.c) is under the kernel lock.  I doubt it's held
very long unless you have ridiculous numbers of processes requesting
locks on the same file, but I don't know.

--b.
