Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbZBGQJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbZBGQJf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 11:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZBGQJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 11:09:27 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:50622 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbZBGQJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 11:09:27 -0500
Subject: Re: [PATCH] eCryptfs: Regression in unencrypted filename symlinks
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090207000649.GA10560@boomer>
References: <20090207000649.GA10560@boomer>
Content-Type: text/plain
Date: Sat, 07 Feb 2009 10:09:23 -0600
Message-Id: <1234022963.21124.0.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 18:06 -0600, Tyler Hicks wrote:
> The addition of filename encryption caused a regression in unencrypted
> filename symlink support.  ecryptfs_copy_filename() is used when dealing
> with unencrypted filenames and it reported that the new, copied filename
> was a character longer than it should have been.
> 
> This caused the return value of readlink() to count the NULL byte of the
> symlink target.  Most applications don't care about the extra NULL byte,
> but a version control system (bzr) helped in discovering the bug.
> 
> Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

> ---
>  fs/ecryptfs/crypto.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index c01e043..f6caeb1 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -1716,7 +1716,7 @@ static int ecryptfs_copy_filename(char **copied_name, size_t *copied_name_size,
>  {
>  	int rc = 0;
> 
> -	(*copied_name) = kmalloc((name_size + 2), GFP_KERNEL);
> +	(*copied_name) = kmalloc((name_size + 1), GFP_KERNEL);
>  	if (!(*copied_name)) {
>  		rc = -ENOMEM;
>  		goto out;
> @@ -1726,7 +1726,7 @@ static int ecryptfs_copy_filename(char **copied_name, size_t *copied_name_size,
>  						 * in printing out the
>  						 * string in debug
>  						 * messages */
> -	(*copied_name_size) = (name_size + 1);
> +	(*copied_name_size) = name_size;
>  out:
>  	return rc;
>  }
-- 
David Kleikamp
IBM Linux Technology Center

