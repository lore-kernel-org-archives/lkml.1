Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbZKIQVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbZKIQVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZKIQVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:21:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbZKIQVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:21:49 -0500
Message-ID: <4AF8433C.4090905@redhat.com>
Date: Mon, 09 Nov 2009 18:28:44 +0200
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ksm: cond_resched in unstable tree
References: <Pine.LNX.4.64.0911091554500.25509@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0911091554500.25509@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 05:58 PM, Hugh Dickins wrote:
> KSM needs a cond_resched() for CONFIG_PREEMPT_NONE, in its unbounded
> search of the unstable tree.  The stable tree cases already have one,
> and originally there was one down inside get_user_pages();
> but I missed it when I converted to follow_page() instead.
>
> Signed-off-by: Hugh Dickins<hugh.dickins@tiscali.co.uk>
> ---
>
>   mm/ksm.c |    1 +
>   1 file changed, 1 insertion(+)
>
> --- 2.6.32-rc6/mm/ksm.c	2009-10-12 00:26:43.000000000 +0100
> +++ linux/mm/ksm.c	2009-11-07 14:44:58.000000000 +0000
> @@ -1012,6 +1012,7 @@ static struct rmap_item *unstable_tree_s
>   		struct rmap_item *tree_rmap_item;
>   		int ret;
>
> +		cond_resched();
>   		tree_rmap_item = rb_entry(*new, struct rmap_item, node);
>   		page2[0] = get_mergeable_page(tree_rmap_item);
>   		if (!page2[0])
>    
ACK.
Low risk patch - we are for sure at sleepable context there.
