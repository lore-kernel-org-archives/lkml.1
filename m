Return-Path: <linux-kernel-owner+w=401wt.eu-S1762669AbYFWTGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762669AbYFWTGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYFWTGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:06:46 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34573 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYFWTGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:06:45 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org
In-reply-to: <20080623185043.GZ28946@ZenIV.linux.org.uk> (message from Al Viro
	on Mon, 23 Jun 2008 19:50:43 +0100)
Subject: Re: [patch v3] vfs: fix sys_getcwd for detached mounts
References: <E1KAqjG-00080e-KH@pomaz-ex.szeredi.hu> <20080623185043.GZ28946@ZenIV.linux.org.uk>
Message-Id: <E1KArND-00086v-PS@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 23 Jun 2008 21:06:43 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jun 23, 2008 at 08:25:26PM +0200, Miklos Szeredi wrote:
> > I tested this one in various situations, and it appears to do what
> > it's supposed to.
> > 
> > A somewhat analogous issue is if we have cwd (or fd) outside
> > current->root.  Should we add a prefix for that case as well?  Perhaps
> > a double slash?
> 
> OK, I've applied everything except the last one (all in for-linus in
> vfs-2.6.git).

Thanks.  Could you please open a branch for this last patch and get
that into linux-next ?  I've also got some other cleanup stuff
pending, and Andrew would prefer all VFS stuff to go through you.

>  As for the stuff outside current->root (or other
> namespace, for that matter)...  I don't like the idea of using // -
> as it is, we have a nice sane check (path[0] != '/') and if
> anything, I'd consider going for deleted:<path> instead of <path>
> (deleted) as we have now.  _That_ would eliminate the major
> annoyance with handling of unlinked/rmdired - we'd get rid of
> guessing whether that's a file really called "a (deleted)" or an
> unlinked one that used to be called "a"...

Yes, it would be nice and consistent.  OTOH, there is a real chance of
breaking some stuff, that already tries to parse "(deleted)".  I don't
think it's worth touching that thing.

Miklos
