Return-Path: <linux-kernel-owner+w=401wt.eu-S1759980AbXEXNhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980AbXEXNhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757752AbXEXNhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:37:07 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:61457 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389AbXEXNhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:37:03 -0400
Date: Thu, 24 May 2007 15:36:25 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       lhcs-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 4/7] SMP: Implement on_one_cpu()
Message-ID: <20070524133625.GA9863@osiris.ibm.com>
References: <1180008615579-git-send-email-avi@qumranet.com> <11800086152009-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11800086152009-git-send-email-avi@qumranet.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 03:10:12PM +0300, Avi Kivity wrote:
> This defines on_one_cpu() which is similar to smp_call_function_single()
> except that it works if cpu happens to be the current cpu.  Can also be
> seen as a complement to on_each_cpu() (which also doesn't treat the
> current cpu specially).
> 
> Signed-off-by: Avi Kivity <avi@qumranet.com>
> ---
>  include/linux/smp.h |   15 +++++++++++++++
>  kernel/softirq.c    |   24 ++++++++++++++++++++++++
>  2 files changed, 39 insertions(+), 0 deletions(-)
> 
> +/*
> + * Call a function on one processor
> + */
> +int on_one_cpu(int cpu, void (*func)(void *info), void *info,
> +	       int retry, int wait);
> 

Would you mind renaming that one to simply 'on_cpu'? It's even shorter and
clearly everybody will know what its purpose is. Also I doubt we will ever
have something like 'on_two_cpus'.
