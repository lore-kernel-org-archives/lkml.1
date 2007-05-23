Return-Path: <linux-kernel-owner+w=401wt.eu-S1763156AbXEWKYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763156AbXEWKYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 06:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758168AbXEWKYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 06:24:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59718 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394AbXEWKYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 06:24:39 -0400
Date: Wed, 23 May 2007 11:24:38 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070523102437.GS4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070523095127.GQ4095@ftp.linux.org.uk> <E1HqnmR-0001dI-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HqnmR-0001dI-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 12:09:19PM +0200, Miklos Szeredi wrote:
> Right.  After locking vfsmount_lock, mount_dironfile() should recheck
> if there was a race and bail out.

Owww...  Not pretty, that...
 
> I don't think the filesystem ought to try _creating_ a vfsmount.  I
> imagine, that the fs has already a kernel-internal mounted for this
> kind of stuff, and it just supplies a dentry from that.  The vfsmount
> isn't actually important, but it should be readily available, and it's
> easier to clone from a vfsmount/dentry pair.

I don't get it.  What's the point of that exercise, then?  When do you
create that kernel-internal mount?

> As I said, the superblock should be persistent, so we'll get a stable
> st_dev for multiple mounts.

OK, but then I guess I don't understand the intended use.
