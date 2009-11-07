Return-Path: <linux-kernel-owner+w=401wt.eu-S1751512AbZKGLNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbZKGLNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 06:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZKGLNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 06:13:32 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41360 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbZKGLNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 06:13:31 -0500
To: ebiederm@xmission.com (Eric W. Biederman)
CC: tj@kernel.org, serue@us.ibm.com, gregkh@suse.de, kay.sievers@vrfy.org,
       greg@kroah.com, linux-kernel@vger.kernel.org, cornelia.huck@de.ibm.com,
       linux-fsdevel@vger.kernel.org, eric.dumazet@gmail.com, bcrl@lhnet.ca,
       ebiederm@aristanetworks.com
In-reply-to: <m1y6mjw03m.fsf@fess.ebiederm.org>
Subject: Re: [PATCH 12/13] sysfs: Propagate renames to the vfs on demand
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<1257249429-12384-12-git-send-email-ebiederm@xmission.com>
	<20091104214938.GA21033@us.ibm.com> <m13a4ux86v.fsf@fess.ebiederm.org>
	<4AF4D76C.6090008@kernel.org> <m1y6mjw03m.fsf@fess.ebiederm.org>
Message-Id: <E1N6jDk-0006eq-23@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 07 Nov 2009 12:12:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Nov 2009, ebiederm@xmission.com (Eric W. Biederman wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
> > Hello,
> >
> > Eric W. Biederman wrote:
> >> It isn't what I want but it is what the VFS requires.  If let the vfs
> >> continue on it's delusional state we will leak the vfs mount and
> >> everything mounted on top of it, with no way to remove the mounts.

"umount -l" on the whole thing will clear any submounts up too.

> >
> > This is caused by not having any way to prevent deletion on
> > directories with submounts, right?  How does other distributed
> > filesystems deal with directories with submounts going away underneath
> > it?
> 
> NFS does exactly the same thing I am doing.

Yes, this is a problem for NFS too.  You cannot tell the NFS server
"this directory is mounted on some client, don't let anything happen
to it!".  Basically the remaining choices are:

 a) let the old path leading up to the mount still be accessible, even
 though it doesn't exist anymore on the server (or has been replaced
 with something different)

 b) automatically dissolve any submounts if the path disappeard on the
 server

I think Al was arguing in favor of b), while Linus said that mounts
must never just disappear, so a) is better.  I don't think an
agreement was reached.

Thanks,
Miklos
