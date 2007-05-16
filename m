Return-Path: <linux-kernel-owner+w=401wt.eu-S1761090AbXEPAZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761090AbXEPAZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbXEPAYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:24:52 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:42326 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759349AbXEPAYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:24:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=0adCZgVW0nFSlQvmC5baf9NHzgqNOpxGOUVKSzJ4A2T4tYkF2ulEYGx1T5/7OeX+7XlwET9gn15l5x4EhfRvliLU5uwwvnstMRS6NzjjvdhxqudcTgqWed8BOmO6jBOkBf1pYz1jt6ckyf4UiBYC8htK2Ez/qrH+eUa4/IJnT7o=  ;
X-YMail-OSG: 07XbhUoVM1lmJP.yf2XYjOpHWamZrJBBAfZbIm08i5L9me2HpifnNpbXEGQsQka81IeAhZMr7Q--
Message-ID: <464A4F46.9060007@yahoo.com.au>
Date: Wed, 16 May 2007 10:24:38 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] AFS: Fix afs_prepare_write()
References: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> afs_prepare_write() should not mark a page up to date if it only partially
> fills it in, in expectation of the caller filling in the rest prior to calling
> commit_write().  commit_write(), however, should mark the page up to date.

Acked-by: Nick Piggin <npiggin@suse.de>

> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/afs/write.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/afs/write.c b/fs/afs/write.c
> index 28f3751..a03b92a 100644
> --- a/fs/afs/write.c
> +++ b/fs/afs/write.c
> @@ -206,7 +206,6 @@ int afs_prepare_write(struct file *file, struct page *page,
>  			_leave(" = %d [prep]", ret);
>  			return ret;
>  		}
> -		SetPageUptodate(page);
>  	}
>  
>  try_again:
> @@ -311,8 +310,8 @@ int afs_commit_write(struct file *file, struct page *page,
>  		spin_unlock(&vnode->writeback_lock);
>  	}
>  
> +	SetPageUptodate(page);
>  	set_page_dirty(page);
> -
>  	if (PageDirty(page))
>  		_debug("dirtied");
>  
> 
> 


-- 
SUSE Labs, Novell Inc.
