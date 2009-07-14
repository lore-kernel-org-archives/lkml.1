Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbZGNPaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbZGNPaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbZGNPaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:30:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:18871 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbZGNPav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rX6U8s9QE507tGVbBQgsWwWq3x5mCj4DeYbnde+m5I2pqmrMsCr0mOB1lQ3cDmRx+o
         dZX/ZGzQg/ppbOWRR8UH8H9spk5XEUo8fOKdOPAsZf9hYgbT34zbPFHVTiOIMhIkueFB
         gyC6d53UmtVX79aBsifcDl6DUcpCKDUj/8ZWI=
Date: Tue, 14 Jul 2009 23:33:08 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] shmem: call set_page_dirty() with locked page
Message-ID: <20090714153250.GA4149@hack>
References: <20090714092926.GA23969@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714092926.GA23969@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 05:29:26PM +0800, Wu Fengguang wrote:
>Here set_page_dirty() can be moved into the page lock.
>
>CC: Hugh Dickins <hugh@veritas.com>
>Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
> mm/shmem.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>--- linux.orig/mm/shmem.c
>+++ linux/mm/shmem.c
>@@ -1630,8 +1630,8 @@ shmem_write_end(struct file *file, struc
> 	if (pos + copied > inode->i_size)
> 		i_size_write(inode, pos + copied);
> 
>-	unlock_page(page);
> 	set_page_dirty(page);
>+	unlock_page(page);
> 	page_cache_release(page);
> 
> 	return copied;
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
