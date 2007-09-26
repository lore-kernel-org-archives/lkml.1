Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbXIZEdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbXIZEdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 00:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbXIZEdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 00:33:01 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:41237 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbXIZEdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 00:33:01 -0400
Date: Tue, 25 Sep 2007 21:32:44 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 10/25] Unionfs: add un/likely conditionals on copyup ops
In-reply-to: <11907762093928-git-send-email-ezk@cs.sunysb.edu>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
Message-id: <46F9E0EC.3010105@intel.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu>
 <11907762093928-git-send-email-ezk@cs.sunysb.edu>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok wrote:
> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> ---
>  fs/unionfs/copyup.c |  102 +++++++++++++++++++++++++-------------------------
>  1 files changed, 51 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
> index 23ac4c8..e3c5f15 100644
> --- a/fs/unionfs/copyup.c
> +++ b/fs/unionfs/copyup.c
> @@ -36,14 +36,14 @@ static int copyup_xattrs(struct dentry *old_lower_dentry,
>  
>  	/* query the actual size of the xattr list */
>  	list_size = vfs_listxattr(old_lower_dentry, NULL, 0);
> -	if (list_size <= 0) {
> +	if (unlikely(list_size <= 0)) {


I've been told several times that adding these is almost always bogus - either it
messes up the CPU branch prediction or the compiler/CPU just does a lot better at
finding the right way without these hints.

Adding them as a blanket seems rather strange. Have you got any numbers that this
really improves performance?

Auke
