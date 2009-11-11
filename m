Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbZKKIeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbZKKIeC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:34:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756911AbZKKIeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:34:01 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46658 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbZKKIeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:34:00 -0500
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: miklos@szeredi.hu, jlayton@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
       ebiederm@xmission.com, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       jamie@shareable.org
In-reply-to: <1257927970.5138.24.camel@heimdal.trondhjem.org> (message from
	Trond Myklebust on Wed, 11 Nov 2009 17:26:10 +0900)
Subject: Re: [PATCH 0/2] vfs: ensure that dentries are revalidated on open
 (try #2)
References: <1257870456-31188-1-git-send-email-jlayton@redhat.com>
	 <E1N884c-0006Br-Je@pomaz-ex.szeredi.hu> <1257927970.5138.24.camel@heimdal.trondhjem.org>
Message-Id: <E1N88eK-0006Im-1F@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Nov 2009 09:33:56 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009, Trond Myklebust wrote:
> > Having said that, doing revalidation for proc symlinks and bind mounts
> > (and not just for opens) might make sense.  This is something similar
> > to FS_REVAL_DOT, so perhaps make it conditional on this flag (or a
> > new, appropriately named one).
> 
> Aren't both proc symlinks and bind mounts pretty much guaranteed to
> point to a valid dentry?

It could for example happen that client bind mounts a regular file,
then the file is unlinked on the server.  Then the bind mounted dentry
is no longer valid.

Thanks,
Miklos
