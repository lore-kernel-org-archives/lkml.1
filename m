Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbYBJPbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbYBJPbV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 10:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbYBJPbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 10:31:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:36595 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbYBJPbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 10:31:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XcGmFyxxVAFbL7sxKQUHUwKO2icXKV6Dd+kpYeDrBCufzHEAI+xPgPErrehykbP2BwH5hW+lWt9SfTxlkhC0PAdg6QEwed6cvaAKvZ348b8e8D7h9gcGG53hmQsdu12o/c9F1YIiHnKB+Ioyms8DuGCij9SX8JcHNIAXQ+nrngs=
Message-ID: <6101e8c40802100731r4c90834fy2186e28dffc0a1c3@mail.gmail.com>
Date: Sun, 10 Feb 2008 16:31:10 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Bastian Blank" <bastian@waldi.eu.org>,
       "Pekka J Enberg" <penberg@cs.helsinki.fi>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jens.axboe@oracle.com, akpm@linux-foundation.org,
       ndenev@gmail.com, oliver.pntr@gmail.com
Subject: Re: [PATCH] splice: fix user pointer access in get_iovec_page_array()
In-Reply-To: <20080210151735.GA2810@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802101644510.12440@sbz-30.cs.Helsinki.FI>
	 <20080210151735.GA2810@wavehammer.waldi.eu.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

----8<----

Linux pancs 2.6.22.17-opt2-cve2 #1 SMP Sun Feb 10 16:22:37 CET 2008
i686 GNU/Linux
-----------------------------------
 Linux vmsplice Local Root Exploit
 By qaaz
-----------------------------------
[+] mmap: 0x0 .. 0x1000
[+] page: 0x0
[+] page: 0x20
[+] mmap: 0x4000 .. 0x5000
[+] page: 0x4000
[+] page: 0x4020
[+] mmap: 0x1000 .. 0x2000
[+] page: 0x1000
[+] mmap: 0xb7f2d000 .. 0xb7f5f000
[-] vmsplice: Bad address

-----

oliver@pancs:/tmp$ uname -a && ./2623_2624_root_exploit
Linux pancs 2.6.22.17-opt2-cve2 #1 SMP Sun Feb 10 16:22:37 CET 2008
i686 GNU/Linux
-----------------------------------
 Linux vmsplice Local Root Exploit
 By qaaz
-----------------------------------
[+] addr: 0xc01112e9
[-] wtf


---->8----
On 2/10/08, Bastian Blank <bastian@waldi.eu.org> wrote:
> On Sun, Feb 10, 2008 at 04:47:57PM +0200, Pekka J Enberg wrote:
> > From: Bastian Blank <bastian@waldi.eu.org>
> >
> > The commit 8811930dc74a503415b35c4a79d14fb0b408a361 ("splice: missing user
> > pointer access verification") added access_ok() to
> copy_from_user_mmap_sem()
> > which only ensures we can copy the struct iovecs from userspace to the
> kernel
> > but we also must check whether we can access the actual memory region
> pointed
> > to by the struct iovec to close the local root exploit.
> >
> > Cc: <stable@kernel.org>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Signed-off-by: Bastian Blank <waldi@debian.org>
>
> > Index: linux-2.6/fs/splice.c
> > ===================================================================
> > --- linux-2.6.orig/fs/splice.c
> > +++ linux-2.6/fs/splice.c
> > @@ -1237,6 +1237,9 @@ static int get_iovec_page_array(const st
> >  		if (unlikely(!base))
> >  			break;
> >
> > +		if (unlikely(!access_ok(VERIFY_READ, base, len)))
> > +			break;
> > +
> >  		/*
> >  		 * Get this base offset and number of pages, then map
> >  		 * in the user pages.
>
> --
> Those who hate and fight must stop themselves -- otherwise it is not
> stopped.
> 		-- Spock, "Day of the Dove", stardate unknown
>


-- 
Thanks,
Oliver
