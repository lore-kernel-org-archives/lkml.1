Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbYEFENb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbYEFENb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYEFENT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:13:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbYEFENS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:13:18 -0400
Date: Mon, 5 May 2008 21:12:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
Message-Id: <20080505211251.6c5dec8d.akpm@linux-foundation.org>
In-Reply-To: <20080505101640.143220902@szeredi.hu>
References: <20080505101621.216789969@szeredi.hu>
	<20080505101640.143220902@szeredi.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2008 12:16:22 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> R/O bind mounts require operations which modify the filesystem to be
> wrapped in mnt_want_write()/mnt_drop_write().  Create helpers which do
> this, so callers won't need to bother, and more importantly, cannot
> forget!  Call these path_*, analogous to vfs_*.  Since there are no
> callers of vfs_* left, make them static.

ooh, yum.  This appears to address my main complaint about the r-o-bind-mount
stuff: fragility.

> Overall this patchset is just 23 lines in the red, but at the same
> time it fixes several places in nfsd and the whole of ecryptfs, where
> the mnt_want_write/drop_write() calls were missing.

Yeah, like that.
