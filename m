Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZGNSag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZGNSag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 14:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbZGNSaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 14:30:35 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:51755 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbZGNSae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 14:30:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Q+gs+otO5XoFpQO3evyLEQoNZLSnf2Oml0JDuquZUbJIQ95ycAGZcslFkR5IDIZAX3
         /cuxzxD9BxLCfOqAq3HZ+KitvhI66KKLluyQPbsEG0ynf2jAXl2PHX1t6lE4U9rBPLML
         Pd8aSbQGCFMtlfhUr0hnVLl7QLrSOYNH6a674=
MIME-Version: 1.0
In-Reply-To: <1246474254-10401-1-git-send-email-adkulkar@umail.iu.edu>
References: <1246474254-10401-1-git-send-email-adkulkar@umail.iu.edu>
Date: Tue, 14 Jul 2009 13:30:33 -0500
Message-ID: <a4e6962a0907141130h5dedd444i8f1eaf99b20ed34@mail.gmail.com>
Subject: Re: [V9fs-developer] [9P PATCH 1/2] 9p: Fix incorrect parameters to 
	v9fs_file_readn.
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Abhishek Kulkarni <adkulkar@umail.iu.edu>
Cc: linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied v9fs-devel

On Wed, Jul 1, 2009 at 1:50 PM, Abhishek Kulkarni<adkulkar@umail.iu.edu> wrote:
> Fix v9fs_vfs_readpage. The offset and size parameters to v9fs_file_readn
> were interchanged and hence passed incorrectly.
>
> Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
> ---
> :100644 100644 6fcb1e7... 9282828... M  fs/9p/vfs_addr.c
>  fs/9p/vfs_addr.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
> index 6fcb1e7..9282828 100644
> --- a/fs/9p/vfs_addr.c
> +++ b/fs/9p/vfs_addr.c
> @@ -57,7 +57,7 @@ static int v9fs_vfs_readpage(struct file *filp, struct page *page)
>        buffer = kmap(page);
>        offset = page_offset(page);
>
> -       retval = v9fs_file_readn(filp, buffer, NULL, offset, PAGE_CACHE_SIZE);
> +       retval = v9fs_file_readn(filp, buffer, NULL, PAGE_CACHE_SIZE, offset);
>        if (retval < 0)
>                goto done;
>
> --
> 1.6.3.3
>
>
> ------------------------------------------------------------------------------
> _______________________________________________
> V9fs-developer mailing list
> V9fs-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/v9fs-developer
>
