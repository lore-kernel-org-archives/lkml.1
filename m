Return-Path: <linux-kernel-owner+w=401wt.eu-S1761304AbXGCV44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761304AbXGCV44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbXGCV4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:56:47 -0400
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:42356 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbXGCV4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:56:45 -0400
Date: Tue, 3 Jul 2007 15:56:43 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Message-ID: <20070703215643.GK6578@schatzie.adilger.int>
Mail-Followup-To: Trond Myklebust <trond.myklebust@fys.uio.no>,
	cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
References: <1183275424.4010.126.camel@localhost.localdomain> <1183388313.3864.35.camel@localhost.localdomain> <1183472682.6494.38.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183472682.6494.38.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 03, 2007  10:24 -0400, Trond Myklebust wrote:
> It looks OK to me, but you might want to strip out the now redundant
> i_version updates in add_dirent_to_buf(), ext4_rmdir(), ext4_rename().

Agreed, and I thought we discussed that already on the ext4 list.

> I also have some questions about how this will affect the readdir code:
> unless I missed something, the filp->f_version is still unsigned long,
> so the comparisons and assignments in ext4_readdir()/ext4_dx_readdir()
> no longer make sense.

I don't see them as any worse than existing checks.  For 32-bit systems
we only ever had a 32-bit in-memory version anyway so using only the
low 32 bits of i_version in f_version is no more racy than in the past.
For 64-bit systems using the full on-disk i_version is possible.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

