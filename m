Return-Path: <linux-kernel-owner+w=401wt.eu-S1762098AbXGFAtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762098AbXGFAtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 20:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759900AbXGFAtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 20:49:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52376 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759710AbXGFAtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 20:49:06 -0400
Message-ID: <468D917F.90204@garzik.org>
Date: Thu, 05 Jul 2007 20:49:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: slow down printk during boot.
References: <20070705211346.GB17030@redhat.com>
In-Reply-To: <20070705211346.GB17030@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> This patch from Randy has proven quite useful from time to time,
> and has been in Fedora kernels for a while for that reason.
> I fixed up some checkpatch warnings, and rediffed it a bunch
> of times, Randy did the heavy lifting.
> 
> ---
> 
> This one delays each printk() during boot by a variable time
> (from kernel command line), while system_state == SYSTEM_BOOTING.
> Caveat:  it's not terribly SMP safe or SMP nice.
> Any ideas for improvements (esp. in the SMP area) are appreciated.
> 
> ---
> 
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Optionally add a boot delay after each kernel printk() call,
> crudely measured in milliseconds, with a maximum delay of
> 10 seconds per printk.
> 
> Enable CONFIG_BOOT_DELAY=y and then add (e.g.):
> "lpj=loops_per_jiffy boot_delay=100"
> to the kernel command line.
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> ---
> 
>  init/calibrate.c  |    2 +-
>  init/main.c       |   25 +++++++++++++++++++++++++
>  kernel/printk.c   |   33 +++++++++++++++++++++++++++++++++
>  lib/Kconfig.debug |   18 ++++++++++++++++++
>  4 files changed, 77 insertions(+), 1 deletion(-)

hey, that's pretty neat.

I've occasionally hand-hacked something similar, to achieve those effects.

	Jeff



