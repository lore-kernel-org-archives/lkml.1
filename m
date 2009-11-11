Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbZKKI0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbZKKI0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZKKI0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:26:17 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:39660 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694AbZKKI0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:26:16 -0500
Subject: Re: [PATCH 0/2] vfs: ensure that dentries are revalidated on open
 (try #2)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
       ebiederm@xmission.com, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       jamie@shareable.org
In-Reply-To: <E1N884c-0006Br-Je@pomaz-ex.szeredi.hu>
References: <1257870456-31188-1-git-send-email-jlayton@redhat.com>
	 <E1N884c-0006Br-Je@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Wed, 11 Nov 2009 17:26:10 +0900
Message-Id: <1257927970.5138.24.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 9 msgs/h 1 sum rcpts/h 13 sum msgs/h 1 total rcpts 1851 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 2571C409393A41E1E1013460B5E4B011C4BE245C
X-UiO-SPAM-Test: remote_host: 133.93.205.205 spam_score: -49 maxlevel 80 minaction 2 bait 0 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 08:57 +0100, Miklos Szeredi wrote:
> On Tue, 10 Nov 2009, Jeff Layton wrote:
> > This is the second attempt to fix this problem. The first one attempted
> > to fix this in procfs, but Eric Biederman pointed out that file bind
> > mounts have a similar problem. This set attempts to fix the issue at a
> > higher level, in the generic VFS layer.
> 
> I suspect the correct fix would be to clean up the open API so that
> NFSv4 doesn't have to hack its stateful open routine into the
> ->lookup() and ->d_revalidate() methods.

I've been working on that. I hope to have patches soon...

> Having said that, doing revalidation for proc symlinks and bind mounts
> (and not just for opens) might make sense.  This is something similar
> to FS_REVAL_DOT, so perhaps make it conditional on this flag (or a
> new, appropriately named one).

Aren't both proc symlinks and bind mounts pretty much guaranteed to
point to a valid dentry? Once we fix the open case, I can't see that we
need to do much more. Networked filesystems may want to revalidate the
inode attributes, but not the dentry itself...

Cheers
  Trond

