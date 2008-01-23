Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbYAWWJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbYAWWJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 17:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbYAWWIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 17:08:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48581 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756103AbYAWWIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:08:14 -0500
Date: Wed, 23 Jan 2008 14:08:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, knikanth@novell.com, jens.axboe@oracle.com
Subject: Re: [PATCH 2/6] io context sharing: preliminary support
Message-Id: <20080123140803.ff320a96.akpm@linux-foundation.org>
In-Reply-To: <1200995361-24001-3-git-send-email-jens.axboe@oracle.com>
References: <1200995361-24001-1-git-send-email-jens.axboe@oracle.com>
	<1200995361-24001-3-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 Jan 2008 10:49:17 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> -void put_io_context(struct io_context *ioc)
> +int put_io_context(struct io_context *ioc)
>  {
>  	if (ioc == NULL)
> -		return;
> +		return 1;
>  
>  	BUG_ON(atomic_read(&ioc->refcount) == 0);
>  
> @@ -3856,7 +3856,9 @@ void put_io_context(struct io_context *ioc)
>  		rcu_read_unlock();
>  
>  		kmem_cache_free(iocontext_cachep, ioc);
> +		return 1;
>  	}
> +	return 0;
>  }

Document the return value?  (and the function)

I assume this return value gets used in some other patch.
