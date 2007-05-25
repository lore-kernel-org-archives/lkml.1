Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbXEYHbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbXEYHbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXEYHbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:31:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:12514 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbXEYHbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:31:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=iOwnYlx6ZcWZ6c2qr3WI7H+vBvOwGjnpkfRa0p0ID/kIxG+qmB60RITg5mNnX3xO6m8zR/j7zpjemwQb6JFlUuqDs/5q+VkdkvzCe68yHB1CCt8O+uF87fPV/bxfD/PSwtRY0TvhtFbk8fbWtVywkVBrZR4Iw9lOErYZ+s7AE30=
Message-ID: <465690B5.2050602@gmail.com>
Date: Fri, 25 May 2007 09:31:01 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement file locking
References: <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070524165554.22292.38887.stgit@warthog.cambridge.redhat.com>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells napsal(a):
> Implement file locking for AFS.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/afs/Makefile    |    1 
>  fs/afs/afs.h       |    8 +
>  fs/afs/afs_fs.h    |    3 
>  fs/afs/callback.c  |    3 
>  fs/afs/dir.c       |    1 
>  fs/afs/file.c      |    2 
>  fs/afs/flock.c     |  558 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/afs/fsclient.c  |  155 ++++++++++++++
>  fs/afs/internal.h  |   30 +++
>  fs/afs/main.c      |    1 
>  fs/afs/misc.c      |    1 
>  fs/afs/super.c     |    3 
>  fs/afs/vnode.c     |  130 +++++++++++-
>  include/linux/fs.h |    4 
>  14 files changed, 885 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/afs/Makefile b/fs/afs/Makefile
> index 73ce561..a666710 100644
> --- a/fs/afs/Makefile
> +++ b/fs/afs/Makefile
> @@ -8,6 +8,7 @@ kafs-objs := \
>  	cmservice.o \
>  	dir.o \
>  	file.o \
> +	flock.o \
>  	fsclient.o \
>  	inode.o \
>  	main.o \
> diff --git a/fs/afs/afs.h b/fs/afs/afs.h
> index 2452579..c548aa3 100644
> --- a/fs/afs/afs.h
> +++ b/fs/afs/afs.h
> @@ -37,6 +37,13 @@ typedef enum {
>  	AFS_FTYPE_SYMLINK	= 3,
>  } afs_file_type_t;
>  
> +typedef enum {
> +	AFS_LOCK_READ		= 0,	/* read lock request */
> +	AFS_LOCK_WRITE		= 1,	/* write lock request */
> +} afs_lock_type_t;

Why typedef?

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
