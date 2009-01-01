Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbZAACco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbZAACco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 21:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZAACcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 21:32:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38073 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZAACcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 21:32:35 -0500
Date: Thu, 1 Jan 2009 02:32:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Duane Griffin <duaneg@dghda.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ufs: don't truncate longer ufs2 fast symlinks
Message-ID: <20090101023232.GC28946@ZenIV.linux.org.uk>
References: <1230742208-23972-1-git-send-email-duaneg@dghda.com> <1230742208-23972-2-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230742208-23972-2-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 04:50:06PM +0000, Duane Griffin wrote:
>  	} else {
> -		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
> +		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4 * 2; i++)
>  			ufsi->i_u1.i_symlink[i] = ufs2_inode->ui_u2.ui_symlink[i];

a) that probably ought to be a memcpy()
b) max len is superblock parameter and you've even validated it.  Why don't
you use it?

> -		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4; i++)
> +		for (i = 0; i < (UFS_NDADDR + UFS_NINDIR) * 4 * 2; i++)
>  			ufs_inode->ui_u2.ui_symlink[i] = ufsi->i_u1.i_symlink[i];

Ditto.
