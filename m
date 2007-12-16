Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbXLPTRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbXLPTRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXLPTR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:17:26 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:40292 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750830AbXLPTR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:17:26 -0500
Date: Sun, 16 Dec 2007 20:17:30 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RANDOM] Move two variables to read_mostly section to save
	memory
Message-ID: <20071216191730.GA15890@stusta.de>
References: <47650FBD.2060209@cosmosbay.com> <20071216130028.GB14233@stusta.de> <476539D5.7050305@cosmosbay.com> <20071216165348.GC14233@stusta.de> <476563A1.4090508@cosmosbay.com> <20071216181455.GD14233@stusta.de> <47657096.50302@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47657096.50302@cosmosbay.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 07:38:14PM +0100, Eric Dumazet wrote:
>
> I am using gcc-4.2.1
>
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y makes no difference for me.
>
> $ make defconfig
> $ egrep "OPTIMIZE_FOR_SIZE|CONFIG_SMP" .config
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SMP=y
> $ make vmlinux
> $ nm -v vmlinux|grep -4 random_read_wakeup_thresh
> c057a02c d excluded_id_list
> c057a100 d zero_bdi
> c057a180 D random_table
> c057a300 d input_pool
> c057a400 d random_read_wakeup_thresh
> c057a404 d random_write_wakeup_thresh
>    <SAME HOLE HERE>
> c057a480 d blocking_pool
> c057a580 d nonblocking_pool
> c057a680 d rekey_work
>
> After my patch, I still gain 120 bytes.
>
> Please realize that most people now build their kernels with CONFIG_SMP=y, 
> or use a distro one (with CONFIG_SMP=y as well)
> 
> Your CONFIG_SYSCTL point is valid and should be addressed by a separate patch set.

How many patches do you want to send only for saving 120 bytes in some 
configurations (and even not the ones people who really care about the 
kernel size usually use)?

And most C files in the kernel would allow you to save more than
120 bytes if you don't mind how tihe source code looks like and e.g. 
don't mind turning it into an #ifdef mess.

If you care about the kernel size, you could e.g. help in fighting 
removals of unused EXPORT_SYMBOL's through Andrew instead - these are 
space saving patches that neither make the C code look worse nor can 
have negative impact on the generated code.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

