Return-Path: <linux-kernel-owner+w=401wt.eu-S965585AbXCQOcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965585AbXCQOcm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 10:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965618AbXCQOcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 10:32:41 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:3674 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965585AbXCQOck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 10:32:40 -0400
Date: Sat, 17 Mar 2007 15:30:43 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Paul Mackerras <paulus@samba.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
       cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070317143043.GA8577@osiris.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <17915.48105.70494.958220@cargo.ozlabs.ibm.com> <20070317110706.GB29931@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070317110706.GB29931@parisc-linux.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 05:07:06AM -0600, Matthew Wilcox wrote:
> On Sat, Mar 17, 2007 at 08:59:05PM +1100, Paul Mackerras wrote:
> > ... but wouldn't work on 32-bit powerpc. :(  We would end up with a
> > pad argument between fd and offset, giving 7 arguments in all
> > (counting the loff_t's as 2), but we only support 6.
> 
> Ditto mips and parisc.

Can't be. Or: mips supports 7 arguments and parisc doesn't pad.
Otherwise they couldn't have wired up

sys_sync_file_range(int fd, loff_t offset, loff_t nbytes, unsigned int flags)

But from what I read, it's currently not possible for 32-bit powerpc to
wire up the already present sync_file_range system call.
