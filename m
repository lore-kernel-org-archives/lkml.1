Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbYBARQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbYBARQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYBARQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:16:04 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:48195 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbYBARQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:16:01 -0500
Subject: Re: [PATCH] drivers/base: export (un)register_memory_notifier
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Jan-Bernd Themann <ossthema@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Thomas Klein <osstklei@de.ibm.com>,
       Christoph Raisch <RAISCH@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
In-Reply-To: <200802011716.32511.ossthema@de.ibm.com>
References: <200802011716.32511.ossthema@de.ibm.com>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 09:18:37 -0800
Message-Id: <1201886317.11808.32.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-01 at 17:16 +0100, Jan-Bernd Themann wrote:
> Drivers like eHEA need memory notifiers in order to 
> update their internal DMA memory map when memory is added
> to or removed from the system.
> 
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
> 
> ---
>  Comment: eHEA patches that exploit these functions will follow
> 
> 
>  drivers/base/memory.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 7ae413f..1e1bd4c 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -52,11 +52,13 @@ int register_memory_notifier(struct notifier_block *nb)
>  {
>          return blocking_notifier_chain_register(&memory_chain, nb);
>  }
> +EXPORT_SYMBOL(register_memory_notifier);
> 
>  void unregister_memory_notifier(struct notifier_block *nb)
>  {
>          blocking_notifier_chain_unregister(&memory_chain, nb);
>  }
> +EXPORT_SYMBOL(unregister_memory_notifier);
> 
>  /*
>   * register_memory - Setup a sysfs device for a memory block

Is there a reason for not making them EXPORT_SYMBOL_GPL() ?
Otherwise, looks good to me.

I have been planning to send this as part of my next update
with ppc64 arch-specific remove support and generic __remove_pages()
support. If this is blocking your work, lets get this in.

Acked-by: Badari Pulavarty <pbadari@us.ibm.com>

Thanks,
Badari

