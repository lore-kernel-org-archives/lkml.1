Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbXGKGTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbXGKGTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 02:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbXGKGSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 02:18:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47884 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbXGKGSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 02:18:51 -0400
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       nfsv4@linux-nfs.org
In-Reply-To: <20070710221721.23c46edf.akpm@linux-foundation.org>
References: <1183275424.4010.126.camel@localhost.localdomain>
	 <20070710163038.ceb2ae94.akpm@linux-foundation.org>
	 <1184105380.3759.65.camel@localhost.localdomain>
	 <20070710182237.e2f88bf3.akpm@linux-foundation.org>
	 <18068.19667.942363.686858@notabene.brown>
	 <1184119748.20193.37.camel@localhost.localdomain>
	 <20070710221721.23c46edf.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 10 Jul 2007 23:18:50 -0400
Message-Id: <1184123930.20193.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 22:17 -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2007 22:09:08 -0400 Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > David Chinneer pointed that we need to journal the version number
> > updates together with the operations that causes the change of the inode
> > version number, in order to survive server crashes so clients won't see
> > the counter go backwards.
> > 
> > So increment i_version in fs code is probably the place to ensure the
> > inode version changes are stored to disk. It's seems update the ext4
> > inode version in every ext4_mark_inode_dirty() is the easiest way.
> 
> That still makes us dependent upon _something_ changing the inode.  For
> overwrites the only something is mtime.
> 
> If we don't want to have a peculiar dependency upon s_time_gran=1e9 (and
> I don't think we do) then I guess we'll need new code in or around
> file_update_time() to do this.

do you mean mark inode dirty all the times in file_update_time()? Not
sure about the overhead for ext3/4.

Mingming

