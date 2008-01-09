Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbYAIIs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbYAIIs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 03:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYAIIsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 03:48:45 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58021 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbYAIIso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 03:48:44 -0500
To: nigel@nigel.suspend2.net
CC: pavel@ucw.cz, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, ebiederm@xmission.com,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org
In-reply-to: <47840DAC.5000108@nigel.suspend2.net> (message from Nigel
	Cunningham on Wed, 09 Jan 2008 10:56:28 +1100)
Subject: Re: [patch 7/9] unprivileged mounts: allow unprivileged fuse mounts
References: <20080108113502.184459371@szeredi.hu> <20080108113630.861045063@szeredi.hu> <20080108214625.GE5050@ucw.cz> <E1JCN9I-0004DB-DF@pomaz-ex.szeredi.hu> <47840DAC.5000108@nigel.suspend2.net>
Message-Id: <E1JCWax-0005Ck-Kg@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jan 2008 09:47:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> On Tue 2008-01-08 12:35:09, Miklos Szeredi wrote:
> >>> From: Miklos Szeredi <mszeredi@suse.cz>
> >>>
> >>> Use FS_SAFE for "fuse" fs type, but not for "fuseblk".
> >>>
> >>> FUSE was designed from the beginning to be safe for unprivileged users.  This
> >>> has also been verified in practice over many years.  In addition unprivileged
> >> Eh? So 'kill -9 no longer works' and 'suspend no longer works' is not
> >> considered important enough to even mention?
> > 
> > No.  Because in practice they don't seem to matter.  Also because
> > there's no way in which fuse could be done differently to address
> > these issues.
> 
> Could you clarify, please? I hope I'm getting the wrong end of the stick
> - it sounds to me like you and Pavel are saying that this patch breaks
> suspending to ram (and hibernating?) but you want to push it anyway
> because you haven't been able to produce an instance, don't think
> suspending or hibernating matter and couldn't fix fuse anyway?

This patch has nothing to do with suspend or hibernate.  What this
patchset does, is help get rid of fusermount, a suid-root mount
helper.  It also opens up new possibilities, which are not fuse
related.

Fuse has bad interactions with the freezer, theoretically.  In
practice, I remember just one bug report (that sparked off this whole
"do we need freezer, or don't we" flamefest), that actually got fixed
fairly quickly, ...maybe.  Rafael probably remembers better.

> > The 'kill -9' thing is basically due to VFS level locking not being
> > interruptible.  It could be changed, but I'm not sure it's worth it.
> > 
> > For the suspend issue, there are also no easy solutions.
> 
> What are the non-easy solutions?

The ability to freeze tasks in uninterruptible sleep, or more
generally at any preempt point (except when drivers are poking
hardware).

I know this doesn't play well with userspace hibernate, and I don't
think it can be resolved without going the kexec way.

Miklos
