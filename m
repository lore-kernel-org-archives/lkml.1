Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbYJLNmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbYJLNmy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYJLNmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:42:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56677 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbYJLNmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:42:44 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-ia64 <linux-ia64@vger.kernel.org>,
       "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [mmotm 10 Oct][PATCH 1/2] fix build error of git-tip
Cc: kosaki.motohiro@jp.fujitsu.com, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081012223808.1817.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081012223808.1817.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081012224113.181D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sun, 12 Oct 2008 22:42:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Oops, I forgot to CCed Tony.
sorry.

> 
> Patch name: git-tip-fix.patch
> Patch against: mmotm 10 Oct
> Applied after: git-tip.patch
> 
> -----------
> git-tip can't build on ia64 because __acpi_unmap_table() function tyep is wrong.
> Then it cause following build error.
> 
> 
>   CC      arch/ia64/kernel/acpi.o
> arch/ia64/kernel/acpi.c:180: error: conflicting types for '__acpi_unmap_table'
> include/linux/acpi.h:82: error: previous declaration of '__acpi_unmap_table' was here
> make[1]: *** [arch/ia64/kernel/acpi.o] Error 1
> make: *** [arch/ia64/kernel] Error 2
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Yinghai Lu <yhlu.kernel@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> 
> ---
>  arch/ia64/kernel/acpi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/arch/ia64/kernel/acpi.c
> ===================================================================
> --- a/arch/ia64/kernel/acpi.c
> +++ b/arch/ia64/kernel/acpi.c
> @@ -176,7 +176,7 @@ char *__init __acpi_map_table(unsigned l
>  	return __va(phys_addr);
>  }
>  
> -char *__init __acpi_unmap_table(unsigned long virt_addr, unsigned long size)
> +void __init __acpi_unmap_table(char *virt_addr, unsigned long size)
>  {
>  }
>  
> 
> 



