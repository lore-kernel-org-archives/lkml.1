Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYAQDdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYAQDdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbYAQDdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:33:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41265 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbYAQDdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:33:14 -0500
Date: Thu, 17 Jan 2008 03:33:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
Subject: Re: [patch] VFS: extend /proc/mounts
Message-ID: <20080117033309.GX27894@ZenIV.linux.org.uk>
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 11:12:31PM +0100, Miklos Szeredi wrote:
> The alternative (and completely safe) solution is to add another file
> to proc.  Me no likey.

Since we need saner layout, I would strongly suggest exactly that.

> major:minor -- is the major minor number of the device hosting the filesystem

Bad description.  "Value of st_dev for files on that filesystem", please -
there might be no such thing as "the device hosting the filesystem" _and_
the value here may bloody well be unrelated to device actually holding
all data (for things like ext2meta, etc.).

> 1) The mount is a shared mount.
> 2) Its peer mount of mount with id 20
> 3) It is also a slave mount of the master-mount with the id  19
> 4) The filesystem on device with major/minor number 98:0 and subdirectory
> 	mnt/1/abc makes the root directory of this mount.
> 5) And finally the mount with id 16 is its parent.

I'd suggest doing a new file that would *not* try to imitate /etc/mtab.
Another thing is, how much of propagation information do we want to
be exposed and what do we intend to do with it?  Note that "entire
propagation tree" is out of question - it spans many namespaces and
contains potentially sensitive information.  So we won't see all nodes.

What do we want to *do* with the information about propagation?
