Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZESKjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZESKjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZESKjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:39:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:39664 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbZESKjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:39:24 -0400
Date: Tue, 19 May 2009 12:39:24 +0200
From: Jan Blunck <jblunck@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Message-ID: <20090519103924.GL16526@bolzano.suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <E1M6LvU-0000mN-HN@pomaz-ex.szeredi.hu> <20090519102939.GK16526@bolzano.suse.de> <E1M6Mez-0000tG-3q@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M6Mez-0000tG-3q@pomaz-ex.szeredi.hu>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, Miklos Szeredi wrote:

> On Tue, 19 May 2009, Jan Blunck wrote:
> > The directory in the topmost filesystem is created during
> > lookup. The contents of the directory isn't copied up presistently
> > at that point in time. Therefore you have an empty directory in the
> > topmost filesystem after the lookup. This was necessary to get rid
> > of the union_relookup_topmost() calls during create, mknod, mkdir
> > etc.
> > 
> > When readdir is called, the topmost directory is filed up with
> > fallthru entries which are persistently stored. This is only
> > necessary to get readdir right wrt POSIX. During lookup the fallthru
> > dentry, which is in fact a special negative dentry, is ignored and
> > therefore the lookup continues on the lower filesystem.
> 
> So this means that the topmost branch always needs to be writable,
> right?  It isn't possible to make a union of two iso9660 filesystems,
> for example?

Exactly. Although, you can do that with the help of tmpfs on top of the two
iso9660 filesystems. Or by adding fake write support to iso9660 ...

I know that this seems to be suboptimal but it is the cost that the POSIX
correct readdir comes with.
