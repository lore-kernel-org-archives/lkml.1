Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbXIZVkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbXIZVkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXIZVko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:40:44 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:42607 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbXIZVkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:40:43 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 17:40:43 EDT
Message-ID: <46FAD1D2.8030306@tiscali.nl>
Date: Wed, 26 Sep 2007 23:40:34 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Erez Zadok <ezk@cs.sunysb.edu>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
Subject: Re: [PATCH 13/25] Unionfs: add un/likely conditionals on dir ops
References: <11907762042481-git-send-email-ezk@cs.sunysb.edu> <11907762104036-git-send-email-ezk@cs.sunysb.edu>
In-Reply-To: <11907762104036-git-send-email-ezk@cs.sunysb.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Erez Zadok wrote:

> @@ -194,7 +194,7 @@ int check_empty(struct dentry *dentry, struct unionfs_dir_state **namelist)
>  
>  	BUG_ON(!S_ISDIR(dentry->d_inode->i_mode));
>  
> -	if ((err = unionfs_partial_lookup(dentry)))
> +	if (unlikely((err = unionfs_partial_lookup(dentry))))
>  		goto out;
>  
>  	bstart = dbstart(dentry);

Is it bad to leave this assignment within the unlikely()?
