Return-Path: <linux-kernel-owner+w=401wt.eu-S1763494AbXEWJ6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763494AbXEWJ6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbXEWJ60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:58:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39667 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444AbXEWJ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:58:25 -0400
Date: Wed, 23 May 2007 10:58:24 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070523095824.GR4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070522221045.GH4095@ftp.linux.org.uk> <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu> <20070523070306.GM4095@ftp.linux.org.uk> <E1Hql7t-0001EQ-00@dorka.pomaz.szeredi.hu> <20070523073658.GO4095@ftp.linux.org.uk> <E1HqlqT-0001KD-00@dorka.pomaz.szeredi.hu> <20070523082918.GP4095@ftp.linux.org.uk> <E1HqmkO-0001R4-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HqmkO-0001R4-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 11:03:08AM +0200, Miklos Szeredi wrote:
> I still don't get it where the superblock comes in.  The locking is
> "interesting" in there, yes.  And I haven't completely convinced
> myself it's right, let alone something that won't easily be screwed up
> in the future.  So there's definitely room for thought there.
> 
> But how does it matter if two different paths have the same sb or a
> different sb mounted over them?
 
Because then you get a slew of fun issues with dropping the final reference
to vfsmount vs. lookup on another place.  What hold do you have on that
superblock and when do you switch from "oh, called ->enter() on the same
inode again, return vfsmount over the same superblock" to "need to
initialize that damn superblock, all mounts are gone"?

> The same dentry is mounted over each one.  The contents of the
> directory should only depend on the contents of the underlying inode.
> The path leading up to it is completely irrelevant.

So what kind of exclusion do you have for ->enter()?  None?
