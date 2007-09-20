Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbXITXWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbXITXWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 19:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbXITXWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 19:22:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47637 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbXITXWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 19:22:37 -0400
Date: Thu, 20 Sep 2007 16:22:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andreas Dilger <adilger@clusterfs.com>, cmm@us.ibm.com
Subject: Re: [PATCH] Ext4: Uninitialized Block Groups
Message-Id: <20070920162208.17f96f78.akpm@linux-foundation.org>
In-Reply-To: <46F06C7B.20308@linux.vnet.ibm.com>
References: <46F06C7B.20308@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 17:25:31 -0700
Avantika Mathur <mathur@linux.vnet.ibm.com> wrote:

> In pass1 of e2fsck, every inode table in the fileystem is scanned and checked, 
> regardless of whether it is in use.  This is this the most time consuming part 
> of the filesystem check.  The unintialized block group feature can greatly 
> reduce e2fsck time by eliminating checking of uninitialized inodes.  
> 
> With this feature, there is a a high water mark of used inodes for each block 
> group.  Block and inode bitmaps can be uninitialized on disk via a flag in the
> group descriptor to avoid reading or scanning them at e2fsck time.  A checksum
> of each group descriptor is used to ensure that corruption in the group
> descriptor's bit flags does not cause incorrect operation.

This needed a few fixups due to conflicts with
ext2-ext3-ext4-add-block-bitmap-validation.patch but they were pretty
straightforward.  Please check that the result is OK.


