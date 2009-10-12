Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZJLHty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZJLHty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZJLHty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:49:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:5459 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782AbZJLHtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:49:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,544,1249282800"; 
   d="scan'208";a="558697430"
Subject: Re: [PATCH 3/5] PCI: maintain backwards compatibility with
 aer-inject user-land tool
From: Huang Ying <ying.huang@intel.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: "prarit@redhat.com" <prarit@redhat.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "pci-linux@vger.kernel.org" <pci-linux@vger.kernel.org>
In-Reply-To: <20091012070304.27029.14815.stgit@bob.kio>
References: <20091012070248.27029.78378.stgit@bob.kio>
	 <20091012070304.27029.14815.stgit@bob.kio>
Content-Type: text/plain
Date: Mon, 12 Oct 2009 15:49:15 +0800
Message-Id: <1255333755.6047.143.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-12 at 15:03 +0800, Andrew Patterson wrote: 
> PCI: maintain backwards compatibility with aer-inject user-land tool
> 
> Maintain backwards compatibility with the 0.1 version  of the aer-inject
> user-land tool.
> 
> Signed-off-by: Andrew Patterson<andrew.patterson@hp.com>
> ---
> 
> diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
> index 5fc5b3e..ac0b5e7 100644
> --- a/drivers/pci/pcie/aer/aer_inject.c
> +++ b/drivers/pci/pcie/aer/aer_inject.c
> @@ -23,10 +23,10 @@
>  #include <linux/pci.h>
>  #include <linux/fs.h>
>  #include <linux/uaccess.h>
> +#include <linux/stddef.h>
>  #include "aerdrv.h"
>  
>  struct aer_error_inj {
> -	u16 domain;
>  	u8 bus;
>  	u8 dev;
>  	u8 fn;
> @@ -36,6 +36,7 @@ struct aer_error_inj {
>  	u32 header_log1;
>  	u32 header_log2;
>  	u32 header_log3;
> +	u16 domain;
>  };
>  
>  struct aer_error {
> @@ -431,10 +432,11 @@ static ssize_t aer_inject_write(struct file *filp, const char __user *ubuf,
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> -
> -	if (usize != sizeof(struct aer_error_inj))
> +	if (usize < offsetof(struct aer_error_inj, domain) ||
> +	    usize > sizeof(einj))
>  		return -EINVAL;
>  
> +	memset(&einj, 0, sizeof(einj));
>  	if (copy_from_user(&einj, ubuf, usize))
>  		return -EFAULT;
>  

Why not merge this patch with [2/5]?

Best Regards,
Huang Ying


