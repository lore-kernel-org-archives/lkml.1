Return-Path: <linux-kernel-owner+w=401wt.eu-S933325AbXCBKpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbXCBKpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 05:45:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933322AbXCBKpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 05:45:38 -0500
Received: from mail.clusterfs.com ([206.168.112.78]:46702 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320AbXCBKpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 05:45:36 -0500
Date: Fri, 2 Mar 2007 18:45:32 +0800
From: Andreas Dilger <adilger@clusterfs.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
       cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
Message-ID: <20070302104532.GT6573@schatzie.adilger.int>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
	cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <45E72647.9000001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E72647.9000001@redhat.com>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 01, 2007  13:15 -0600, Eric Sandeen wrote:
> One thing I'd like to see is a cmd argument as well, to allow for 
> example allocation vs. reservation (i.e. allocating blocks vs. simply 
> reserving a number), as well as the inverse of those functions 
> (un-reservation, de-allocation)?
> 
> If the allocation interface allows allocation/reservation within 
> arbitrary ranges, if the only way to un-allocate is via a truncate, 
> that's pretty asymmetric.

I'd rather we just get the oft-discussed punch() syscall instead.
This is really what "unallocate" would do for persistent allocations
and it would be useful for files that were not preallocated.

For filesystems that don't implement punch glibc() would do zero-filling
of the punched area I guess (to make it equivalent to reading from a
hole in the file).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

