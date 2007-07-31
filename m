Return-Path: <linux-kernel-owner+w=401wt.eu-S1763754AbXGaNQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763754AbXGaNQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763539AbXGaNO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:14:57 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55418 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763654AbXGaNOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:14:55 -0400
Subject: Re: [Patch 16/16] Remove unnecessary kmalloc casts in the jfs
	filesystem.
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jack@hawkeye.stone.uk.eu.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <20070731125448.190135000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
	 <20070731125448.190135000@hawkeye.stone.uk.eu.org>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 08:14:52 -0500
Message-Id: <1185887692.14534.12.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.  I'll push it through the jfs git tree.

Thanks,
Shaggy

On Tue, 2007-07-31 at 13:53 +0100, jack@hawkeye.stone.uk.eu.org wrote:

> Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
> 
> CC: David Kleikamp <shaggy@austin.ibm.com>
> ---
>  fs/jfs/jfs_dtree.c |    8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> Index: b/fs/jfs/jfs_dtree.c
> ===================================================================
> --- a/fs/jfs/jfs_dtree.c
> +++ b/fs/jfs/jfs_dtree.c
> @@ -592,9 +592,7 @@ int dtSearch(struct inode *ip, struct co
>  	struct component_name ciKey;
>  	struct super_block *sb = ip->i_sb;
>  
> -	ciKey.name =
> -	    (wchar_t *) kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t),
> -				GFP_NOFS);
> +	ciKey.name = kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t), GFP_NOFS);
>  	if (ciKey.name == 0) {
>  		rc = -ENOMEM;
>  		goto dtSearch_Exit2;
> @@ -957,9 +955,7 @@ static int dtSplitUp(tid_t tid,
>  	smp = split->mp;
>  	sp = DT_PAGE(ip, smp);
>  
> -	key.name =
> -	    (wchar_t *) kmalloc((JFS_NAME_MAX + 2) * sizeof(wchar_t),
> -				GFP_NOFS);
> +	key.name = kmalloc((JFS_NAME_MAX + 2) * sizeof(wchar_t), GFP_NOFS);
>  	if (key.name == 0) {
>  		DT_PUTPAGE(smp);
>  		rc = -ENOMEM;
> 
-- 
David Kleikamp
IBM Linux Technology Center

