Return-Path: <linux-kernel-owner+w=401wt.eu-S965942AbXCFQwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965942AbXCFQwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965920AbXCFQwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:52:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55161 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965938AbXCFQwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:52:49 -0500
Message-ID: <45ED9B00.3020502@redhat.com>
Date: Tue, 06 Mar 2007 10:46:56 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, Mingming Cao <cmm@us.ibm.com>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       nscott@aconex.com, "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, alex@clusterfs.com,
       suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070301142537.b5950cd7.akpm@linux-foundation.org> <1172788855.26078.294.camel@edge> <20070301145256.3e999932.akpm@linux-foundation.org> <45E86CBA.3070905@us.ibm.com> <20070305122742.GA11486@atrey.karlin.mff.cuni.cz> <45EC7773.7020603@us.ibm.com> <20070306072850.GA23081@infradead.org> <45ED7C59.4050508@redhat.com>
In-Reply-To: <45ED7C59.4050508@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> Christoph Hellwig wrote:
>> fallocate with the whence argument and flags is already quite complicated,
>> I'd rather have another call for placement decisions, that would
>> be called on an fd to do placement decissions for any further allocations
>> (prealloc, write, etc)
> 
> Yes, posix_fallocate shouldn't be made more complicated.  But I don't
> understand why requesting linear layout of the blocks should be an
> option.  It's always an advantage if the blocks requested this way are
> linear on disk.  So, the kernel should always do its best to make this
> happen, without needing an additional option.
> 

Agreed on both points.  The hints would be for things like start block,
or speculative EOF preallocation, not contiguity, which I think should
always be the goal.

-Eric
