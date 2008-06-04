Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbYFDEa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbYFDEa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbYFDEaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:30:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59263 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYFDEaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:30:14 -0400
To: mtk.manpages@googlemail.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@lst.de,
       miklos@szeredi.hu, viro@zeniv.linux.org.uk, jamie@shareable.org,
       drepper@redhat.com, linux-fsdevel@vger.kernel.org,
       subrata@linux.vnet.ibm.com
In-reply-to: <4845C4BD.70805@gmail.com> (message from Michael Kerrisk on Wed,
	04 Jun 2008 00:25:01 +0200)
Subject: Re: [parch 2/4] vfs: utimensat(): be consistent with utime() for immutable
 and append-only files
References: <4845C4BD.70805@gmail.com>
Message-Id: <E1K3kdH-0007fI-7R@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Jun 2008 06:29:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch fixes utimensat() to make its behavior consistent
> with that of utime()/utimes() when dealing with files marked
> immutable and append-only.
> 
> The current utimensat() implementation also returns EPERM if
> 'times' is non-NULL and the tv_nsec fields are both UTIME_NOW.
> For consistency, the
> 
> (times != NULL && times[0].tv_nsec == UTIME_NOW &&
>                   times[1].tv_nsec == UTIME_NOW)
> 
> case should be treated like the traditional utimes() case where
> 'times' is NULL.  That is, the call should succeed for a file
> marked append-only and should give the error EACCES if the file
> is marked as immutable.
> 
> The simple way to do this is to set 'times' to NULL
> if (times[0].tv_nsec == UTIME_NOW && times[1].tv_nsec == UTIME_NOW).
> 
> This is also the natural approach, since POSIX.1 semantics consider the
> times == {{x, UTIME_NOW}, {y, UTIME_NOW}}
> to be exactly equivalent to the case for
> times == NULL.
> 
> (Thanks to Miklos for pointing this out.)
> 
> Patch 3 in this series relies on the simplification provided
> by this patch.
> 
> CC: Miklos Szeredi <miklos@szeredi.hu>
> CC: Al Viro <viro@zeniv.linux.org.uk>
> CC: Ulrich Drepper <drepper@redhat.com>
> Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>

Acked-by: Miklos Szeredi <mszeredi@suse.cz>
