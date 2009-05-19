Return-Path: <linux-kernel-owner+w=401wt.eu-S1754266AbZESK3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbZESK3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZESK3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:29:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52495 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZESK3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:29:39 -0400
Date: Tue, 19 May 2009 12:29:39 +0200
From: Jan Blunck <jblunck@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Message-ID: <20090519102939.GK16526@bolzano.suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <E1M6LvU-0000mN-HN@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M6LvU-0000mN-HN@pomaz-ex.szeredi.hu>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, Miklos Szeredi wrote:

> > Major changes since last post:
> > - Updated the whiteout patches:
> >   - DCACHE_WHITEOUT flag set on a negative dentry
> >   - uses filetype instead of reserved inode number on EXT2
> > - Copy-up directories during lookup
> > - Implemented fallthru support for in-kernel readdir() as proposed by
> >   Valerie Aurora (Henson)
> 
> Does this copy up directories persistently?  If so, does this
> implementation no longer supports union of all read-only branches?

The directory in the topmost filesystem is created during lookup. The contents
of the directory isn't copied up presistently at that point in time. Therefore
you have an empty directory in the topmost filesystem after the lookup. This
was necessary to get rid of the union_relookup_topmost() calls during create,
mknod, mkdir etc.

When readdir is called, the topmost directory is filed up with fallthru
entries which are persistently stored. This is only necessary to get readdir
right wrt POSIX. During lookup the fallthru dentry, which is in fact a special
negative dentry, is ignored and therefore the lookup continues on the lower
filesystem.

Hope that clarifies your questions,
Jan
