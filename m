Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbXKFEih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbXKFEih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 23:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbXKFEi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 23:38:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37952 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754802AbXKFEi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 23:38:29 -0500
Date: Mon, 5 Nov 2007 20:38:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org, Dong Pu <cocobear.cn@gmail.com>
Subject: Re: [git Patch] mm/util.c: Remove needless code
Message-Id: <20071105203816.3f8b2e7a.akpm@linux-foundation.org>
In-Reply-To: <20071106031207.GA2478@hacking>
References: <20071106031207.GA2478@hacking>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Nov 2007 11:12:07 +0800 WANG Cong <xiyou.wangcong@gmail.com> wrote:

> 
> If the code can be executed there, 'new_size' is always larger
> than 'ks'. Thus min() is needless.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Signed-off-by: Dong Pu <cocobear.cn@gmail.com>
> Cc: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  mm/util.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/util.c b/mm/util.c
> index 5f64026..295c7aa 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -96,7 +96,7 @@ void *krealloc(const void *p, size_t new_size, gfp_t flags)
>  
>  	ret = kmalloc_track_caller(new_size, flags);
>  	if (ret) {
> -		memcpy(ret, p, min(new_size, ks));
> +		memcpy(ret, p, ks);
>  		kfree(p);
>  	}
>  	return ret;

Thanks.  This was already fixed by

http://www.mail-archive.com/mm-commits@vger.kernel.org/msg28294.html

(which is somewhere in one of my ever-growing number of for-2.6.24 queues)
