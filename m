Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbYGMVcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbYGMVcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbYGMVc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:32:26 -0400
Received: from mail.fieldses.org ([66.93.2.214]:54342 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591AbYGMVcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:32:25 -0400
Date: Sun, 13 Jul 2008 17:32:22 -0400
To: richard@rsk.demon.co.uk
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: +
	file-lock-reorder-struct-file_lock-to-save-space-on-64-bit-builds.pa
	tch added to -mm tree
Message-ID: <20080713213222.GD2810@fieldses.org>
References: <200807120020.m6C0KnBx012130@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807120020.m6C0KnBx012130@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied to my queue of nfsd and locks stuff for 2.6.27 at:

	git://linux-nfs.org/~bfields/linux.git for-2.6.27

--b.

On Fri, Jul 11, 2008 at 05:20:49PM -0700, akpm@linux-foundation.org wrote:
> Subject: file lock: reorder struct file_lock to save space on 64 bit builds
> From: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> Reduce sizeof struct file_lock by 8 on 64 bit builds allowing +1 objects
> per slab in the file_lock_cache
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> Cc: "J. Bruce Fields" <bfields@fieldses.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/fs.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN include/linux/fs.h~file-lock-reorder-struct-file_lock-to-save-space-on-64-bit-builds include/linux/fs.h
> --- a/include/linux/fs.h~file-lock-reorder-struct-file_lock-to-save-space-on-64-bit-builds
> +++ a/include/linux/fs.h
> @@ -952,12 +952,12 @@ struct file_lock {
>  	struct list_head fl_link;	/* doubly linked list of all locks */
>  	struct list_head fl_block;	/* circular list of blocked processes */
>  	fl_owner_t fl_owner;
> +	unsigned char fl_flags;
> +	unsigned char fl_type;
>  	unsigned int fl_pid;
>  	struct pid *fl_nspid;
>  	wait_queue_head_t fl_wait;
>  	struct file *fl_file;
> -	unsigned char fl_flags;
> -	unsigned char fl_type;
>  	loff_t fl_start;
>  	loff_t fl_end;
>  
> _
> 
> Patches currently in -mm which might be from richard@rsk.demon.co.uk are
> 
> linux-next.patch
> shrink-struct-pid-by-removing-padding-on-64-bit-builds.patch
> file-lock-reorder-struct-file_lock-to-save-space-on-64-bit-builds.patch
> 
