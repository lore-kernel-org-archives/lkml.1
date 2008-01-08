Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbYAHWoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbYAHWoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYAHWo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:44:27 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56658 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYAHWoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:44:25 -0500
To: pavel@ucw.cz
CC: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
In-reply-to: <20080108214625.GE5050@ucw.cz> (message from Pavel Machek on Tue,
	8 Jan 2008 21:46:26 +0000)
Subject: Re: [patch 7/9] unprivileged mounts: allow unprivileged fuse mounts
References: <20080108113502.184459371@szeredi.hu> <20080108113630.861045063@szeredi.hu> <20080108214625.GE5050@ucw.cz>
Message-Id: <E1JCN9I-0004DB-DF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 08 Jan 2008 23:42:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue 2008-01-08 12:35:09, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Use FS_SAFE for "fuse" fs type, but not for "fuseblk".
> > 
> > FUSE was designed from the beginning to be safe for unprivileged users.  This
> > has also been verified in practice over many years.  In addition unprivileged
> 
> Eh? So 'kill -9 no longer works' and 'suspend no longer works' is not
> considered important enough to even mention?

No.  Because in practice they don't seem to matter.  Also because
there's no way in which fuse could be done differently to address
these issues.

The 'kill -9' thing is basically due to VFS level locking not being
interruptible.  It could be changed, but I'm not sure it's worth it.

For the suspend issue, there are also no easy solutions.

> 'updatedb no longer works' is not a problem?

I haven't seen any problems with updatedb, and haven't had any bug
reports about it either.

> Are you ready to offer shell account for bugtraq people to see how
> long it survives?

Bugtraq people are free to install fuse on their machines and take it
apart.

AFAIR there were two security vulnerabilities in fuse's history, one
of them an information leak in the kernel module, and the other one an
mtab corruption issue in the fusermount utility.  I don't think this
is such a bad track record.

Miklos
