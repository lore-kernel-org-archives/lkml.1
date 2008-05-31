Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbYEaIVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbYEaIVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 04:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYEaIUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 04:20:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYEaIUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 04:20:52 -0400
Date: Sat, 31 May 2008 04:20:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>
Subject: Re: [patch 2/8] vfs: fix sys_getcwd for detached mounts
Message-ID: <20080531082052.GC24135@infradead.org>
References: <20080529113245.450308367@szeredi.hu> <20080529113309.365088543@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529113309.365088543@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 01:32:47PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Currently getcwd(2) on a detached mount will give a garbled result:
> 
>    > mkdir /mnt/foo
>    > mount --bind /etc /mnt/foo
>    > cd /mnt/foo/skel
>    > /bin/pwd
>    /mnt/foo/skel
>    > umount -l /mnt/foo
>    > /bin/pwd
>    etcskel
> 
> After the patch it will give a much saner "/skel" result.
> 
> Thanks to John Johansen for pointing out this bug.

I'm not sure just cuttinig of the prefix is perfect, but the previous
behvaiour is obviously completely wrong, and the change is simple
enough.  So okay from me.
