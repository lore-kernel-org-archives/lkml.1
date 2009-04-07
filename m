Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZDGBCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZDGBCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZDGBCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:02:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804AbZDGBCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:02:09 -0400
Date: Mon, 6 Apr 2009 17:59:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: intel-iommu: Add for_each_iommu() and for_each_active_iommu()
 macros
Message-Id: <20090406175918.c38654b2.akpm@linux-foundation.org>
In-Reply-To: <200904062159.n36Lx1OJ001967@hera.kernel.org>
References: <200904062159.n36Lx1OJ001967@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009 21:59:01 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/linus/8f912ba4d7cdaf7d31cf39fe5a9b7732308a256d
> Commit:     8f912ba4d7cdaf7d31cf39fe5a9b7732308a256d
> Parent:     20bec8ab1458c24bed0d5492ee15d87807fc415a
> Author:     David Woodhouse <David.Woodhouse@intel.com>
> AuthorDate: Fri Apr 3 15:19:32 2009 +0100
> Committer:  David Woodhouse <David.Woodhouse@intel.com>
> CommitDate: Fri Apr 3 21:45:46 2009 +0100

Three days old?  Never been in linux-next afaict.

Please don't do that.

>     intel-iommu: Add for_each_iommu() and for_each_active_iommu() macros
>     
>     Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>     Acked-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/dmar.h |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> index 2f34274..0b4aa80 100644
> --- a/include/linux/dmar.h
> +++ b/include/linux/dmar.h
> @@ -44,6 +44,14 @@ extern struct list_head dmar_drhd_units;
>  #define for_each_drhd_unit(drhd) \
>  	list_for_each_entry(drhd, &dmar_drhd_units, list)
>  
> +#define for_each_active_iommu(i, drhd)					\
> +	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
> +		if (i=drhd->iommu, drhd->ignored) {} else
> +
> +#define for_each_iommu(i, drhd)						\
> +	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
> +		if (i=drhd->iommu, 0) {} else 
> +
>  extern int dmar_table_init(void);
>  extern int dmar_dev_scope_init(void);

From: Andrew Morton <akpm@linux-foundation.org>

drivers/pci/intel-iommu.c:2637:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c: In function 'init_iommu_hw':
drivers/pci/intel-iommu.c:2637: error: expected '(' before '{' token
drivers/pci/intel-iommu.c:2638: error: '______r' undeclared (first use in this function)
drivers/pci/intel-iommu.c:2638: error: (Each undeclared identifier is reported only once
drivers/pci/intel-iommu.c:2638: error: for each function it appears in.)
drivers/pci/intel-iommu.c:2641:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c:2641: error: expected '(' before '{' token
drivers/pci/intel-iommu.c:2662:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c: In function 'iommu_flush_all':
drivers/pci/intel-iommu.c:2662: error: expected '(' before '{' token
drivers/pci/intel-iommu.c:2676:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c: In function 'iommu_suspend':
drivers/pci/intel-iommu.c:2676: error: expected '(' before '{' token
drivers/pci/intel-iommu.c:2678: error: too few arguments to function 'kzalloc'
drivers/pci/intel-iommu.c:2685:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c:2685: error: expected '(' before '{' token
drivers/pci/intel-iommu.c:2688: error: '__dummy' undeclared (first use in this function)
drivers/pci/intel-iommu.c:2704:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c:2704: error: expected '(' before '{' token
drivers/pci/intel-iommu.c:2721:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c:2737:35: error: macro "if" passed 2 arguments, but takes just 1
drivers/pci/intel-iommu.c: At top level:
drivers/pci/intel-iommu.c:2745: error: 'iommu_resume' undeclared here (not in a function)

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dmar.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/dmar.h~include-linux-dmarh-fix-build-with-config_profile_all_branches include/linux/dmar.h
--- a/include/linux/dmar.h~include-linux-dmarh-fix-build-with-config_profile_all_branches
+++ a/include/linux/dmar.h
@@ -47,11 +47,11 @@ extern struct list_head dmar_drhd_units;
 
 #define for_each_active_iommu(i, drhd)					\
 	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
-		if (i=drhd->iommu, drhd->ignored) {} else
+		if ((i=drhd->iommu, drhd->ignored)) {} else
 
 #define for_each_iommu(i, drhd)						\
 	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
-		if (i=drhd->iommu, 0) {} else 
+		if ((i=drhd->iommu, 0)) {} else
 
 extern int dmar_table_init(void);
 extern int dmar_dev_scope_init(void);
_

