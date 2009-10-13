Return-Path: <linux-kernel-owner+w=401wt.eu-S1758742AbZJMBw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbZJMBw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 21:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758718AbZJMBwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 21:52:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755735AbZJMBwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 21:52:55 -0400
Date: Tue, 13 Oct 2009 03:52:17 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       samba-technical@lists.samba.org
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091013015217.GB9641@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <20091007095657.GB8703@kernel.dk> <20091012035843.GC25882@wotan.suse.de> <20091013012627.GA19089@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013012627.GA19089@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 09:26:27PM -0400, Christoph Hellwig wrote:
> On Mon, Oct 12, 2009 at 05:58:43AM +0200, Nick Piggin wrote:
> > Tridge, Samba people: measuring vfs performance with dbench
> > in my effort to improve Linux vfs scalability has shown up
> > the statvfs syscall you make to be the final problematic
> > issue for this workload. In particular reading /proc/mounts
> > that glibc does to impement it. We could add complexity to
> > the kernel to try improving it, or we could extend the
> > statfs syscall so glibc can avoid the issue (requiring
> > glibc upgrade). But I would like to know whether samba
> > really uses statvfs() significantly?
> 
> Not sure if it's the reason why Samba uses it, but many portable
> applications use statvfs because that is the standardizes one in
> XPG / recent Posix while statfs is just a BSD extension Linux picked
> up.  So making sure statvfs goes fast is a pretty essential thing.

OK, I'll keep that in mind. I think the best idea then will be
to extend statfs so that it returns the mount flags for glibc
to implement statvfs nicely and get rid of the insane stuff it
is doing now.

I don't know how we can version that nicely but I guess I'll
talk to the glibc guys about it.

