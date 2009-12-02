Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbZLBNLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbZLBNLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZLBNLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:11:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39964 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZLBNLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:11:44 -0500
Date: Wed, 2 Dec 2009 14:11:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/24] HWPOISON: abort on failed unmap
Message-ID: <20091202131150.GE18989@one.firstfloor.org>
References: <20091202031231.735876003@intel.com> <20091202043044.293905787@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202043044.293905787@intel.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	 * Now take care of user space mappings.
> +	 * Abort on fail: __remove_from_page_cache() assumes unmapped page.
>  	 */
> -	hwpoison_user_mappings(p, pfn, trapno);
> +	if (hwpoison_user_mappings(p, pfn, trapno) != SWAP_SUCCESS) {
> +		res = -EBUSY;
> +		goto out;

It would be good to print something in this case.

Did you actually see it during testing?

Or maybe loop forever in the unmapper.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
