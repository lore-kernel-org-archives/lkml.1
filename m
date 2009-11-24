Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbZKXLxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbZKXLxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 06:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932121AbZKXLxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 06:53:24 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60206 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbZKXLxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 06:53:23 -0500
To: Jeff Layton <jlayton@redhat.com>
CC: jamie@shareable.org, ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk
In-reply-to: <20091124062621.744beddb@tlielax.poochiereds.net> (message from
	Jeff Layton on Tue, 24 Nov 2009 06:26:21 -0500)
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks
 and file bind mounts (try #5)
References: <1258998084-26797-1-git-send-email-jlayton@redhat.com>
	<m1my2cdhi3.fsf@fess.ebiederm.org>
	<20091123173616.75c3f600@tlielax.poochiereds.net>
	<20091123224948.GB5598@shareable.org>
	<20091123181545.05ad004d@tlielax.poochiereds.net>
	<m1ljhwbyr3.fsf@fess.ebiederm.org>
	<20091123193426.55f1530a@tlielax.poochiereds.net>
	<20091124012027.GA14645@shareable.org> <20091124062621.744beddb@tlielax.poochiereds.net>
Message-Id: <E1NCtxF-0000rn-1z@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Nov 2009 12:53:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Jeff Layton wrote:
> Since it's clear that these symlinks do need to have special semantics,
> perhaps the approach you suggest would be the best thing. I'll have to
> think about it a bit more.

open() is not the only thing you need to think about.  Anything that
checks read or write permission on the inode (truncate, utimes,
*xattr) would have to be changed to respect the open mode.

See, this is not just about hacking the proc follow_symlink code to
check some lookup intent.  It's about changing the permission checking
mechanism for theses beasts.  And since the permission checking is
inode based, this is not at all trivial to do.

I still believe leaving the current semantics and documenting them is
the best option.

Thanks,
Miklos
