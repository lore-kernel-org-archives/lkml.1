Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZILNmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZILNmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 09:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZILNmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 09:42:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41726 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbZILNmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 09:42:09 -0400
Date: Sat, 12 Sep 2009 14:42:11 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [RFC][PATCH 1/2] pin kern mounts as writable
Message-ID: <20090912134211.GC5858@ZenIV.linux.org.uk>
References: <20090803215940.DF984602@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803215940.DF984602@kernel>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 02:59:40PM -0700, Dave Hansen wrote:

> If we are going to continue to use mnt_clone_write() inside
> of init_file(), then we're going to need some kind of extra
> handling.
> 
> What I want to do in the next patch is add a debugging check
> in mnt_clone_write() to double-check that there *is* a real
> writer on the mount before mnt_clone_write() succeeds.  To
> do that, we either need to check for MS_KERNMOUNT around
> that debug check, or we need to make sure that these kern
> mounts *have* a write already.
> 
> I'm choosing to make sure they always have a write.

> +	err = mnt_want_write(mnt);
> +	WARN_ON(err);

And what would happen to that when we do it to a filesystem that is
made read-only by its ->get_sb()?
