Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbYE2OC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbYE2OC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 10:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757145AbYE2OCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 10:02:45 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57942 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936AbYE2OCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 10:02:44 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
       bfields@citi.umich.edu, neilb@suse.de
In-reply-to: <20080529124701.GA13147@infradead.org> (message from Christoph
	Hellwig on Thu, 29 May 2008 08:47:01 -0400)
Subject: Re: [patch 4/8] nfsd: rename MAY_ flags
References: <20080529113245.450308367@szeredi.hu> <20080529113312.288347247@szeredi.hu> <20080529124701.GA13147@infradead.org>
Message-Id: <E1K1iiF-00086t-Ve@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 May 2008 16:02:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Rename nfsd specific MAY_* flags to NFSD_MAY_* to make it clear, that
> > these are not used outside nfsd, and to avoid namespace conflicts with
> > the VFS.
> 
> But they _are_ in the same namespace as the VFS ones.  This needs to be
> sorted out by real by understanding what's going on here and either
> separating this flags out and passing them in a separate argument, or
> moving them to include/linux/fs.h so it's obvious for anyone adding new
> flags that they must not collide.

Neither I think.  What's going on is that nfsd has a private set of
permission flags, and a private permission checking function, which
incidentally calls the vfs' permission checking function.

Does it hurt to share the three base MAY_ flags for this purpose?  I
don't think it does, but I'm interested in the nfsd maintainers'
opinions.

Thanks,
Miklos
