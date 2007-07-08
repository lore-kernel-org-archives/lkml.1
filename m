Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbXGHRe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbXGHRe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 13:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbXGHReU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 13:34:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57909 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbXGHReU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 13:34:20 -0400
Date: Sun, 8 Jul 2007 18:34:16 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer	dereference - git-bisect result
Message-ID: <20070708173416.GG21668@ftp.linux.org.uk>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de> <20070708012016.455ce8d5.akpm@linux-foundation.org> <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de> <469119A3.6030409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469119A3.6030409@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 10:06:43AM -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Markus Trippelsdorf wrote:
> > I tested this further and it turned out that the Linus tree is also
> > affected. So I ran git-bisect, after I found out that version
> > 2.6.21.6 was not affected by this bug.
> 
> Try this patch.  The vfs_permission test can be skipped since the VFS
> isn't involved.  We got the inode etc from a file descriptor.
 
Like hell.  At the very least you want it to be opened for write.
And even that is dubious, since "process has write access to file"
is not quite the same thing as "somebody had given the process a
descriptor opened for write".
