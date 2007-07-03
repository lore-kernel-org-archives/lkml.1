Return-Path: <linux-kernel-owner+w=401wt.eu-S1761080AbXGCXcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761080AbXGCXcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 19:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbXGCXcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 19:32:11 -0400
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:36333 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbXGCXcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 19:32:09 -0400
Date: Tue, 3 Jul 2007 17:32:00 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       nfsv4@linux-nfs.org
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Message-ID: <20070703233200.GL6578@schatzie.adilger.int>
Mail-Followup-To: "J. Bruce Fields" <bfields@fieldses.org>,
	Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	nfsv4@linux-nfs.org
References: <1183275424.4010.126.camel@localhost.localdomain> <1183388313.3864.35.camel@localhost.localdomain> <20070703221522.GE14074@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070703221522.GE14074@fieldses.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 03, 2007  18:15 -0400, J. Bruce Fields wrote:
> How will nfsd tell whether it can really on a given filesystem's
> i_version, or whether it should fall back on ctime?

Good question.

> > As to performance concerns that raise before the inode version counter
> > (at least for ext4) is done inside ext4_mark_inode_dirty), so there is
> > no extra IO work to store this counter to disk.
> 
> So what's the motivation for the "noversion" mount option?

Lustre needs to be able to control the version number directly (version
number needs to be ordered between all inodes, is set by Lustre to be a
transaction number).  Instead of trying to incorporate this unused code
into ext4 we just turn off the ext4 version code and let Lustre control
this directly.  It may even be that NFSv4 will need to control the version
numbers itself...

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

