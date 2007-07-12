Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbXGLE4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbXGLE4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 00:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXGLE4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 00:56:37 -0400
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:48328 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbXGLE4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 00:56:35 -0400
Date: Wed, 11 Jul 2007 22:56:35 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Neil Brown <neilb@suse.de>,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org, cmm@us.ibm.com,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Message-ID: <20070712045635.GA5586@schatzie.adilger.int>
Mail-Followup-To: "J. Bruce Fields" <bfields@fieldses.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Neil Brown <neilb@suse.de>, nfsv4@linux-nfs.org,
	linux-kernel@vger.kernel.org, cmm@us.ibm.com,
	linux-fsdevel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
References: <1183275424.4010.126.camel@localhost.localdomain> <20070710163038.ceb2ae94.akpm@linux-foundation.org> <1184105380.3759.65.camel@localhost.localdomain> <20070710182237.e2f88bf3.akpm@linux-foundation.org> <18068.19667.942363.686858@notabene.brown> <18068.25879.745638.343290@notabene.brown> <1184164086.12154.15.camel@kleikamp.austin.ibm.com> <20070711200430.GF4138@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711200430.GF4138@fieldses.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 11, 2007  16:04 -0400, J. Bruce Fields wrote:
> A 32-bit i_version could in theory wrap pretty quickly, couldn't it?
> That's not a problem in itself--the problem would only arise if two
> subsequent client queries of the change attribute happened a multiple of
> 2^32 i_version increments apart.
> 
> This is more likely than the previous scenario, but still very unlikely.
> I would have guessed that even in situations with a very high rate of
> updates and a low rate of client revalidations, the chance of two
> revalidations happening exactly 2^32 updates apart would still be no
> more than 1 in 2^32.  (Could odd characteristics of the workloads (like
> updates that tend to happen in power-of-2 groups?) make it any more
> likely?)
> 
> I'd be happier if ext4 at least allowed the possibility of 64 bits in
> the future.  And there's always the chance someone would find a use for
> an i_version that was nondecreasing, even if nfs didn't care.

This would indeed be the case for ext3 filesystems updated to ext4.
They will only be able to store the low 32 bits of the version, which
is itself normally enough for NFSv4 because it only uses the inequality
check.  Having the full 64 bits available eliminates the risk of
collisions, and given that the spec mandates a 64-bit version I'm sure
someone will take full advantage of it in NFS at some point.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

