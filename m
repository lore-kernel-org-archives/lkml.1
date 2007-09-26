Return-Path: <linux-kernel-owner+w=401wt.eu-S1762150AbXIZVeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150AbXIZVeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXIZVeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:34:36 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:52814 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbXIZVef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:34:35 -0400
Message-ID: <46FAD062.4060009@tiscali.nl>
Date: Wed, 26 Sep 2007 23:34:26 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Erez Zadok <ezk@cs.sunysb.edu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 11/25] Unionfs: add un/likely conditionals on debug ops
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu> <11907762093651-git-send-email-ezk@cs.sunysb.edu>
In-Reply-To: <11907762093651-git-send-email-ezk@cs.sunysb.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok wrote:
> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> ---
>  fs/unionfs/debug.c |  108 +++++++++++++++++++++++++++------------------------
>  1 files changed, 57 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
> index 9546a41..09b52ce 100644
> --- a/fs/unionfs/debug.c
> +++ b/fs/unionfs/debug.c
> @@ -56,19 +56,19 @@ void __unionfs_check_inode(const struct inode *inode,
>  	sb = inode->i_sb;
>  	istart = ibstart(inode);
>  	iend = ibend(inode);
> -	if (istart > iend) {
> +	if (unlikely(istart > iend)) {
>  		PRINT_CALLER(fname, fxn, line);
>  		printk(" Ci0: inode=%p istart/end=%d:%d\n",
>  		       inode, istart, iend);
>  	}
> -	if ((istart == -1 && iend != -1) ||
> -	    (istart != -1 && iend == -1)) {
> +	if (unlikely((istart == -1 && iend != -1) ||
> +		     (istart != -1 && iend == -1))) {

you could also do
	if (unlikely((istart == -1 || iend == -1) && istart != iend)) {
	
[...]

> @@ -138,8 +139,8 @@ void __unionfs_check_dentry(const struct dentry *dentry,
>  	dend = dbend(dentry);
>  	BUG_ON(dstart > dend);
>  
> -	if ((dstart == -1 && dend != -1) ||
> -	    (dstart != -1 && dend == -1)) {
> +	if (unlikely((dstart == -1 && dend != -1) ||
> +		     (dstart != -1 && dend == -1))) {

[...]

the same here

> @@ -223,30 +224,30 @@ void __unionfs_check_dentry(const struct dentry *dentry,
>  	istart = ibstart(inode);
>  	iend = ibend(inode);
>  	BUG_ON(istart > iend);
> -	if ((istart == -1 && iend != -1) ||
> -	    (istart != -1 && iend == -1)) {
> +	if (unlikely((istart == -1 && iend != -1) ||
> +		     (istart != -1 && iend == -1))) {

and here

[...]

> @@ -350,30 +354,30 @@ void __unionfs_check_file(const struct file *file,
>  	fend = fbend(file);
>  	BUG_ON(fstart > fend);
>  
> -	if ((fstart == -1 && fend != -1) ||
> -	    (fstart != -1 && fend == -1)) {
> +	if (unlikely((fstart == -1 && fend != -1) ||
> +		     (fstart != -1 && fend == -1))) {

and here

[...]
