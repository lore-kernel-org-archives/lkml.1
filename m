Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134Ab0ATJKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0ATJKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 04:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961Ab0ATJKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 04:10:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47927 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0ATJKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:10:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: anfei <anfei.zhou@gmail.com>
Subject: Re: cache alias in mmap + write
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux@arm.linux.org.uk, jamie@shareable.org
In-Reply-To: <20100120082610.GA5155@desktop>
References: <20100120082610.GA5155@desktop>
Message-Id: <20100120174630.4071.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 Jan 2010 18:10:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 96ac6b0..07056fb 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2196,6 +2196,9 @@ again:
>  		if (unlikely(status))
>  			break;
>  
> +		if (mapping_writably_mapped(mapping))
> +			flush_dcache_page(page);
> +
>  		pagefault_disable();
>  		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
>  		pagefault_enable();

I'm not sure ARM cache coherency model. but I guess correct patch is here.

+		if (mapping_writably_mapped(mapping))
+			flush_dcache_page(page);
+
 		pagefault_disable();
 		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
 		pagefault_enable();
-		flush_dcache_page(page);


Why do we need to call flush_dcache_page() twice?




