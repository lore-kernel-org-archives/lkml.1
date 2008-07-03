Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYGCWnC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYGCWnC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 18:43:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755364AbYGCWmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 18:42:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288AbYGCWmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:42:50 -0400
Date: Thu, 3 Jul 2008 15:42:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: John Blackwood <john.blackwood@ccur.com>
Cc: linux-kernel@vger.kernel.org, andi-suse@firstfloor.org,
       todd.allen@ccur.com, stable@kernel.org
Subject: Re: [PATCH] node meminfo Active & Inactive pages to Kbytes
Message-Id: <20080703154230.17263a19.akpm@linux-foundation.org>
In-Reply-To: <486CE3CD.7090907@ccur.com>
References: <486CE3CD.7090907@ccur.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008 10:35:57 -0400
John Blackwood <john.blackwood@ccur.com> wrote:

> Hi Andrew and Andi,
> 
> We found a minor bug in the output of
> /sys/devices/system/node/node[n]/meminfo
> where the Active and Inactive values are in pages instead of Kbytes.
> 
> Looks like this occurred back in 2.6.20 when the code was changed
> over to use node_page_state().
> 
> Thanks.
> 
> --- linux.2.6.26-rc8/drivers/base/node.c	2008-07-03 09:26:01.000000000 -0400
> +++ new/drivers/base/node.c	2008-07-03 09:25:45.000000000 -0400
> @@ -84,8 +84,8 @@ static ssize_t node_read_meminfo(struct
>   		       nid, K(i.totalram),
>   		       nid, K(i.freeram),
>   		       nid, K(i.totalram - i.freeram),
> -		       nid, node_page_state(nid, NR_ACTIVE),
> -		       nid, node_page_state(nid, NR_INACTIVE),
> +		       nid, K(node_page_state(nid, NR_ACTIVE)),
> +		       nid, K(node_page_state(nid, NR_INACTIVE)),
>   #ifdef CONFIG_HIGHMEM
>   		       nid, K(i.totalhigh),
>   		       nid, K(i.freehigh),

ug.  After all that time there might be applications out there which
use the existing numbers and work around the kernel bug.  Which we'll
break if we fix it.

otoh, who the heck cares about the per-node active and inactive page
counts?

I guess we just fix this, backport the fix as far as we can and
apologise for any fallout.  Not that there's likely to be any.


Please do remember to add a Signed-off-by: for kernel patches.

