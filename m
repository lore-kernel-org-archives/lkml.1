Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZLCLTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZLCLTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZLCLTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:19:53 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45205 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZLCLTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 06:19:52 -0500
To: ebiederm@xmission.com (Eric W. Biederman)
CC: miklos@szeredi.hu, jlayton@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, jamie@shareable.org, pavel@ucw.cz,
       viro@ZenIV.linux.org.uk, duaneg@dghda.com
In-reply-to: <m1tyw8nwgk.fsf@fess.ebiederm.org>
Subject: Re: [PATCH 2/2] vfs: force reval on dentry of bind mounted files on FS_REVAL_DOT filesystems
References: <1259783983-26884-1-git-send-email-jlayton@redhat.com>
	<1259783983-26884-3-git-send-email-jlayton@redhat.com>
	<E1NG9OV-0002g5-3D@pomaz-ex.szeredi.hu> <m1tyw8nwgk.fsf@fess.ebiederm.org>
Message-Id: <E1NG9iu-0002jR-1r@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Dec 2009 12:19:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009, Eric W. Biederman wrote:
> > The only worry I have is that this adds an extra branch in a very hot
> > codepath (do_lookup).  An error can't be returned, as you note, and
> > for bind mounted directories d_invalidate() will not succeed: the
> > directory is busy, it's referenced by the mount. 
> 
> Not true.  d_mountpoint is false, so d_invalidate can succeed.

Have a look at the code.  d_invalidate() doesn't check for a
mountpoint, it checks the refcount.  It needs to keep the directory
dentry hashed if it's in any way reachable other than from the cache
(file descriptor, cwd, mount, etc).

Thanks,
Miklos
