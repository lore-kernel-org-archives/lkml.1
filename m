Return-Path: <linux-kernel-owner+w=401wt.eu-S1762282AbXISRcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762282AbXISRcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759677AbXISRcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:32:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58940 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762059AbXISRcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:32:17 -0400
Date: Wed, 19 Sep 2007 18:32:16 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 08/24] make access() use mnt check
Message-ID: <20070919173216.GH20917@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Dave Hansen <haveblue@us.ibm.com>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <20070917182718.70494C9B@kernel> <20070917182728.116CADE8@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917182728.116CADE8@kernel>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:27:28AM -0700, Dave Hansen wrote:
>  	if(res || !(mode & S_IWOTH) ||
>  	   special_file(nd.dentry->d_inode->i_mode))
>  		goto out_path_release;
> -
> -	if(IS_RDONLY(nd.dentry->d_inode))
> +	/*
> +	 * This is a rare case where using __mnt_is_readonly()
> +	 * is OK without a mnt_want/drop_write() pair.  Since
> +	 * no actual write to the fs is performed here, we do
> +	 * not need to telegraph to that to anyone.
> +	 *
> +	 * By doing this, we accept that this access is
> +	 * inherently racy and know that the fs may change
> +	 * state before we even see this result.
> +	 */
> +	if (__mnt_is_readonly(nd.mnt))
>  		res = -EROFS;

Ok.
