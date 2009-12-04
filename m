Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbZLDWSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbZLDWSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZLDWSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:18:47 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:35297 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZLDWSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:18:46 -0500
Date: Fri, 4 Dec 2009 14:17:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alex Chiang <achiang@hp.com>
Cc: akpm@linux-foundation.org, Haicheng Li <haicheng.li@intel.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andi Kleen <andi@firstfloor.org>, fengguang.wu@intel.com
Subject: Re: [PATCH] page-types: kernel pageflags mode
Message-Id: <20091204141733.b756039c.randy.dunlap@oracle.com>
In-Reply-To: <20091204212606.29258.98531.stgit@bob.kio>
References: <20091204212606.29258.98531.stgit@bob.kio>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B198AAD.0185:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Dec 2009 14:29:48 -0700 Alex Chiang wrote:

> An earlier commit taught page-types the -d|--describe argument, which
> allows the user to describe page flags passed on the command line:
> 
>   # ./Documentation/vm/page-types -d 0x4000
>   0x0000000000004000  ______________b___________________  swapbacked
> 
> In -d mode, page-types expects the page flag bits in the order generated
> by the kernel function get_uflags().
> 
> However, those bits are rearranged compared to what is actually stored
> in struct page->flags. A kernel developer dumping a page's flags
> using printk, e.g., may get misleading results in -d mode.
> 
> Teach page-types the -k mode, which parses and describes the bits in
> the internal kernel order:
> 
>   # ./Documentation/vm/page-types -k 0x4000
>   0x0000000000004000  ______________H_________  compound_head
> 
> Note that the recommended way to build page-types is from the top-level
> kernel source directory. This ensures that it will get the same CONFIG_*
> defines used to build the kernel source.
> 
>   # make Documentation/vm/
> 
> The implication is that attempting to use page-types -k on a kernel
> with different CONFIG_* settings may lead to surprising and misleading
> results. To retain sanity, always use the page-types built out of the
> kernel tree you are actually testing.
> 
> Cc: fengguang.wu@intel.com
> Cc: Haicheng Li <haicheng.li@intel.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
> Applies on top of mmotm.
> 
>  Documentation/vm/Makefile     |    2 +
>  Documentation/vm/page-types.c |  117 +++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 113 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/vm/Makefile b/Documentation/vm/Makefile
> index 5bd269b..1bebc43 100644
> --- a/Documentation/vm/Makefile
> +++ b/Documentation/vm/Makefile
> @@ -1,6 +1,8 @@
>  # kbuild trick to avoid linker error. Can be omitted if a module is built.
>  obj- := dummy.o
>  
> +HOSTCFLAGS_page-types.o += $(LINUXINCLUDE)
> +
>  # List of programs to build
>  hostprogs-y := slabinfo page-types

I can ack the Makefile part.  Thanks for the patch.

Not that I expect this patch to change for this, but I think that we
need to move tools (like this one) from Documentation/ to tools/ and
possibly move examples from Documentation/ to samples/ or tools/.



---
~Randy
