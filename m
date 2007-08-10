Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbXHJVc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbXHJVc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXHJVct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:32:49 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55517 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbXHJVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:32:48 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] kernel/sysctl_check.c must #include <linux/string.h>
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<20070810143802.GG18938@stusta.de>
Date: Fri, 10 Aug 2007 15:32:29 -0600
In-Reply-To: <20070810143802.GG18938@stusta.de> (Adrian Bunk's message of
	"Fri, 10 Aug 2007 16:38:02 +0200")
Message-ID: <m1r6mbulci.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

> On Thu, Aug 09, 2007 at 10:42:54PM -0700, Andrew Morton wrote:
>>...
>> Changes since 2.6.23-rc1-mm2:
>>...
>> +sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
>> +sysctl-factor-out-sysctl_data.patch
>> +sysctl-error-on-bad-sysctl-tables.patch
>> +sysctl-update-sysctl_check_table.patch
>> +sysct-mqueue-remove-the-binary-sysctl-numbers.patch
>> +sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
>> +sysctl-fix-neighbour-table-sysctls.patch
>> +sysctl-ipv6-route-flushing-kill-binary-path.patch
>> +sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
>> +sysctl-x86_64-remove-unnecessary-binary-paths.patch
>> +sysctl-remove-broken-cdrom-binary-sysctls.patch
>> +sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
>>
> +sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
>> 
>>  sysctl cleanups
>>...
>
> This patch fixes the following compile error:
>
> <--  snip  -->
>
> ...
>   CC      kernel/sysctl_check.o
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/kernel/sysctl_check.c: In
> function 'sysctl_binary_lookup':
> /home/bunk/linux/kernel-2.6/linux-2.6.23-rc2-mm2/kernel/sysctl_check.c:1303:
> error: implicit declaration of function 'strcmp'
> make[2]: *** [kernel/sysctl_check.o] Error 1
>
> <--  snip  -->
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
> --- a/kernel/sysctl_check.c
> +++ b/kernel/sysctl_check.c
> @@ -3,6 +3,7 @@
>  #include "../arch/s390/appldata/appldata.h"
>  #include "../fs/xfs/linux-2.6/xfs_sysctl.h"
>  #include <linux/sunrpc/debug.h>
> +#include <linux/string.h>
>  #include <net/ip_vs.h>
>  
>  struct trans_ctl_table {

Thanks.  This problem doesn't happen on x86_64 for some reason so I missed that.

Eric

