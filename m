Return-Path: <linux-kernel-owner+w=401wt.eu-S1761245AbXGKFRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245AbXGKFRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 01:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbXGKFRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 01:17:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35239 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757577AbXGKFRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 01:17:39 -0400
Date: Tue, 10 Jul 2007 22:17:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       nfsv4@linux-nfs.org
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
Message-Id: <20070710221721.23c46edf.akpm@linux-foundation.org>
In-Reply-To: <1184119748.20193.37.camel@localhost.localdomain>
References: <1183275424.4010.126.camel@localhost.localdomain>
	<20070710163038.ceb2ae94.akpm@linux-foundation.org>
	<1184105380.3759.65.camel@localhost.localdomain>
	<20070710182237.e2f88bf3.akpm@linux-foundation.org>
	<18068.19667.942363.686858@notabene.brown>
	<1184119748.20193.37.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 22:09:08 -0400 Mingming Cao <cmm@us.ibm.com> wrote:

> David Chinneer pointed that we need to journal the version number
> updates together with the operations that causes the change of the inode
> version number, in order to survive server crashes so clients won't see
> the counter go backwards.
> 
> So increment i_version in fs code is probably the place to ensure the
> inode version changes are stored to disk. It's seems update the ext4
> inode version in every ext4_mark_inode_dirty() is the easiest way.

That still makes us dependent upon _something_ changing the inode.  For
overwrites the only something is mtime.

If we don't want to have a peculiar dependency upon s_time_gran=1e9 (and
I don't think we do) then I guess we'll need new code in or around
file_update_time() to do this.
