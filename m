Return-Path: <linux-kernel-owner+w=401wt.eu-S1422750AbXBUSM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422750AbXBUSM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422751AbXBUSM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:12:56 -0500
Received: from pat.uio.no ([129.240.10.15]:41478 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422750AbXBUSMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:12:54 -0500
Subject: Re: [PATCH] update ctime and mtime for mmaped write
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, staubach@redhat.com, hugh@veritas.com,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu>
References: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 13:12:42 -0500
Message-Id: <1172081562.9108.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: F37B93CA4CF87844BFD77ECD3558E5894253D049
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 243 total 2345 max/h 1293 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 18:51 +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This patch makes writing to shared memory mappings update st_ctime and
> st_mtime as defined by SUSv3:
> 
>    The st_ctime and st_mtime fields of a file that is mapped with
>    MAP_SHARED and PROT_WRITE shall be marked for update at some point
>    in the interval between a write reference to the mapped region and
>    the next call to msync() with MS_ASYNC or MS_SYNC for that portion
>    of the file by any process. If there is no such call and if the
>    underlying file is modified as a result of a write reference, then
>    these fields shall be marked for update at some time after the
>    write reference.
> 
> A new address_space flag is introduced: AS_CMTIME.  This is set each
> time a page is dirtied through a userspace memory mapping.  This
> includes write accesses via get_user_pages().
> 
> Note, the flag is set unconditionally, even if the page is already
> dirty.  This is important, because the page might have been dirtied
> earlier by a non-mmap write.
> 
> This flag is checked in msync() and __fput(), and if set, the file
> times are updated and the flag is cleared

Why not also check inside vfs_getattr?

Cheers
  Trond

