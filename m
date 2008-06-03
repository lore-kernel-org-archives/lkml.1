Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbYFCLWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbYFCLWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYFCLWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:22:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40414 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYFCLWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:22:35 -0400
Date: Tue, 3 Jun 2008 12:22:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: mtk.manpages@googlemail.com, drepper@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Message-ID: <20080603112221.GW28946@ZenIV.linux.org.uk>
References: <482D4665.4050401@gmail.com> <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com> <cfd18e0f0806030405u1c32b114pa0fdd979f36f87fb@mail.gmail.com> <E1K3URo-0005sj-JW@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K3URo-0005sj-JW@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 01:13:00PM +0200, Miklos Szeredi wrote:
> > > I'm not sure of the correct way to get the required nameidata (to do a
> > > vfs_permission() call) from the file descriptor.  Can you give me a
> > > tip there?
> > 
> > Could you point me at the right way of doing this?
> 
> You don't need nameidata for this at all.  Just call permission() with
> a NULL nameidata.
> 
> Ugly API?  Yes, will be cleaned up if we manage to find some common
> ground with the VFS maintainers.

As soon as I'm done with sysctls...

FWIW, I very much doubt that you are right wrt required permissions, though.
AFAICS, intent here is "if you can write to file, you can touch the timestamps
anyway" and having descriptor opened for write gives that, current permissions
be damned.
