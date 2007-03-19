Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbXCSLZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbXCSLZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 07:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbXCSLZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 07:25:13 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:24718 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbXCSLZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 07:25:10 -0400
Date: Mon, 19 Mar 2007 12:23:12 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
       cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com,
       Matthew Wilcox <matthew@wil.cx>, Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070319112312.GA8331@osiris.boeblingen.de.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316152103.GD8525@osiris.boeblingen.de.ibm.com> <20070319092404.GA12092@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319092404.GA12092@amitarora.in.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 02:54:04PM +0530, Amit K. Arora wrote:
> On Fri, Mar 16, 2007 at 04:21:03PM +0100, Heiko Carstens wrote:
> > On Fri, Mar 16, 2007 at 08:01:01PM +0530, Amit K. Arora wrote:
> > >  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> > > 
> > > Currently we have two modes FA_ALLOCATE and FA_DEALLOCATE, for
> > > preallocation and deallocation of preallocated blocks respectively. More
> > > modes can be added, when required. And these modes can be renamed, since
> > > I am sure these are no way the best ones ! :)
> > > 
> Yes, the problem was adding compat wrapper for this. I will appreciate
> your help in writing it. Only thing is that we might have to wait till
> the order of the arguments is decided upon. Thanks!

There is probably not much choice. If you want to stay with the loff_t
arguments it won't work on 31-bit s390 or 32-bit powerpc dependent on the
order of the arguments.
So you should go for what Matthew Wilcox suggested:

asmlinkage long sys_fallocate(int fd, int mode, u32 off_low, u32 off_high,
			      u32 len_low, u32 len_high);

That way it will work an all architectures and in addition no architecture
has to do some magic to combine the splitted 64 bit arguments in compat
mode.
