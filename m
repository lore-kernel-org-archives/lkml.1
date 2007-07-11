Return-Path: <linux-kernel-owner+w=401wt.eu-S1765500AbXGKQ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765500AbXGKQ5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbXGKQ5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:57:31 -0400
Received: from mail.fieldses.org ([66.93.2.214]:54128 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbXGKQ53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:57:29 -0400
Date: Wed, 11 Jul 2007 12:57:24 -0400
To: Mingming Cao <cmm@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Message-ID: <20070711165724.GD4138@fieldses.org>
References: <1183275424.4010.126.camel@localhost.localdomain> <20070710163038.ceb2ae94.akpm@linux-foundation.org> <1184105380.3759.65.camel@localhost.localdomain> <20070710182237.e2f88bf3.akpm@linux-foundation.org> <1184113156.20193.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184113156.20193.13.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 08:19:16PM -0400, Mingming Cao wrote:
> On Tue, 2007-07-10 at 18:22 -0700, Andrew Morton wrote:
> > And how does the NFS server know that the filesystem implements i_version? 
> > Will a zero-value of i_version have special significance, telling the
> > server to not send this attribute, perhaps?
> 
> Bruce raised up this question a few days back when he reviewed this
> patch, I think the solution is add a superblock flag for fs support
> inode versioning, probably at VFS layer?

Sounds fine.  As long as it's something that's standard across
filesystems, then I can just do something like

	if (sb->s_flags & MS_CHANGEATTR)
		/* return i_version to client as change attribute */
	else
		/* return ctime to client as change attribute */

--b.
