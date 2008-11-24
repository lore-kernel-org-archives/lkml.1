Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbYKXUr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbYKXUr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 15:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYKXUrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 15:47:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33547 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYKXUrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 15:47:51 -0500
Message-ID: <492B12E4.1000602@sandeen.net>
Date: Mon, 24 Nov 2008 14:47:32 -0600
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, davem@davemloft.net, tony.luck@intel.com,
       ralf@linux-mips.org, kyle@mcmartin.ca, schwidefsky@de.ibm.com
Subject: Re: [PATCH] generic compat_sys_ustat
References: <20081121084105.GA7155@lst.de>
In-Reply-To: <20081121084105.GA7155@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:

...

> Index: linux-2.6/fs/compat.c
> ===================================================================
> --- linux-2.6.orig/fs/compat.c	2008-11-20 20:09:52.000000000 +0100
> +++ linux-2.6/fs/compat.c	2008-11-20 20:16:05.000000000 +0100
> @@ -378,6 +378,24 @@ out:
>  	return error;
>  }
>  
> +asmlinkage long compat_sys_ustat(unsigned dev, struct compat_ustat __user *u32)
> +{
> +	struct ustat *u = compat_alloc_user_space(sizeof(*u));

Also, Pete Zaitcev pointed out to me:

>> Isn't this supposed to be:
>> 	struct ustat __user *u = compat_alloc_user_space(sizeof(*u));

-Eric
