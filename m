Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZJSHGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZJSHGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 03:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbZJSHGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 03:06:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54061 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291AbZJSHGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 03:06:45 -0400
Date: Mon, 19 Oct 2009 09:06:49 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix comments for invalidate_inode_pages2()
In-Reply-To: <1255934893-7696-1-git-send-email-bergwolf@gmail.com>
Message-ID: <alpine.LSU.2.00.0910190906220.8582@wotan.suse.de>
References: <1255934893-7696-1-git-send-email-bergwolf@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009, Peng Tao wrote:

> invalidate_inode_pages2() returns -EBUSY *NOT* -EIO if any pages could not be
> invalidated.
> 
> Signed-off-by: Peng Tao <bergwolf@gmail.com>
> ---
>  mm/truncate.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 450cebd..2c147a7 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -490,7 +490,7 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);
>   * Any pages which are found to be mapped into pagetables are unmapped prior to
>   * invalidation.
>   *
> - * Returns -EIO if any pages could not be invalidated.
> + * Returns -EBUSY if any pages could not be invalidated.
>   */
>  int invalidate_inode_pages2(struct address_space *mapping)
>  {

Right, this way it's consistent with invalidate_inode_pages2_range().

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
