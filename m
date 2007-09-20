Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbXITMTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbXITMTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 08:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbXITMS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 08:18:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51276 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbXITMS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 08:18:56 -0400
Date: Thu, 20 Sep 2007 17:51:42 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 5/4] [-mm patch] Rename macros returning the size.
In-Reply-To: <46F2056E.6080601@mxs.nes.nec.co.jp>
Message-ID: <alpine.LFD.0.999.0709201746090.17093@enigma.security.iitk.ac.in>
References: <46E9F6A9.8060500@mxs.nes.nec.co.jp> <46E9F942.5070007@mxs.nes.nec.co.jp>
 <20070914190350.011cdadb.akpm@linux-foundation.org> <46F204FD.6040303@mxs.nes.nec.co.jp>
 <46F2056E.6080601@mxs.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Thu, 20 Sep 2007, Ken'ichi Ohmichi wrote:
> 
> [PATCH 5/4] [-mm patch] Rename macros returning the size.
>  The #define SIZE() should be renamed STRUCT_SIZE() since it's always 
>  returning the size of the struct with a given name.  This would allow 
>  TYPEDEF_SIZE() to simply become SIZE() since it need not be used 
>  exclusively for typedefs. This idea is David Rientjes's.
>  http://www.ussg.iu.edu/hypermail/linux/kernel/0709.1/1964.html
> 
> Thanks
> Ken'ichi Ohmichi
> 
> ---
> Signed-off-by: David Rientjes <rientjes@google.com>

Hmm, I think adding a s-o-b line for David here isn't quite correct.
When someone reviews a patch and gives a suggestion, you only need to
copy him on the next iteration (and he may ack it or whatever, if he
wants) -- but adding a s-o-b line like that ends up (incorrectly)
denoting that he came between the author-to-git-commit chain ...


> Signed-off-by: Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>

> --- a/include/linux/kexec.h	2007-09-18 15:22:19.000000000 +0900
> +++ b/include/linux/kexec.h	2007-09-18 15:23:22.000000000 +0900
> @@ -131,10 +131,10 @@ unsigned long paddr_vmcoreinfo_note(void
>  	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
>  #define VMCOREINFO_SIZE(name) \
>  	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
> -			      (unsigned long)sizeof(struct name))
> -#define VMCOREINFO_TYPEDEF_SIZE(name) \
> -	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
>  			      (unsigned long)sizeof(name))
> +#define VMCOREINFO_STRUCT_SIZE(name) \
> +	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
> +			      (unsigned long)sizeof(struct name))
>  #define VMCOREINFO_OFFSET(name, field) \
>  	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
>  			      (unsigned long)&(((struct name *)0)->field))

Please use %zu and lose all the ugly (unsigned long) casts here.

Otherwise it looks good,

Satyam
