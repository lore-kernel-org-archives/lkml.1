Return-Path: <linux-kernel-owner+w=401wt.eu-S1764144AbYEAQki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764144AbYEAQki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760676AbYEAQk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:40:26 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37278 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760371AbYEAQkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:40:24 -0400
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1JrTpy-0004mH-Gg@pomaz-ex.szeredi.hu>
References: <20080424113950.818688067@szeredi.hu>
	 <1209620457.4461.59.camel@nimitz.home.sr71.net>
	 <E1JrTpy-0004mH-Gg@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Thu, 01 May 2008 09:40:18 -0700
Message-Id: <1209660018.16729.3.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 10:08 +0200, Miklos Szeredi wrote:
> Sorry for the claptrap.  I'm going to resubmit this one more time
> with some slight modifications and additions, and it'd be really nice
> if you or other interested parties would provide comments and opinions
> (either way), because I don't think me and Al have anything new to say
> to each other.

I was trying to stay out of it a bit, since you both have very good
points. :)

But, from a purely aesthetic point of view, I like the patches.  They do
make r/o mount detection less error-prone in coding.  They also remove
more code than they add.

I also certainly understand Al's point about why it puts vfsmounts in a
place where they probably shouldn't be exposed.

Is there a way we could pass around a vfs-internal object to these
things?  Maybe something that is like an opaque token only known to the
vfs?

linux/mount.h:

	struct hidden_mount;

fs/namespace.c:

struct hidden_mount {
	struct vfsmount *mnt;
};

int mnt_want_write(struct hidden_mount *hidmnt)
{
	return __mnt_want_write(hidmnt->mnt);
}

We could have *that* passed down the way that you're currently passing
the vfsmount.

-- Dave

