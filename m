Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbZKDN2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbZKDN2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:28:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZKDN2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:28:07 -0500
Received: from cantor.suse.de ([195.135.220.2]:43263 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181AbZKDN2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:28:06 -0500
Date: Wed, 4 Nov 2009 14:28:10 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Myron Stowe <myron.stowe@hp.com>,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/7] acpi: processor: fix section mismatch
In-Reply-To: <1255906474-25091-5-git-send-email-felipe.contreras@gmail.com>
Message-ID: <alpine.LSU.2.00.0911041427400.9988@wotan.suse.de>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com> <1255906474-25091-5-git-send-email-felipe.contreras@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009, Felipe Contreras wrote:

> WARNING: drivers/acpi/processor.o(.text+0x99a): Section mismatch in
> reference from the function acpi_processor_add() to the function
> .cpuinit.text:acpi_processor_power_init()
> 
> acpi_processor_add replaced acpi_processor_start which had __cpuinit.
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  drivers/acpi/processor_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index c567b46..ec742a4 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -770,7 +770,7 @@ static struct notifier_block acpi_cpu_notifier =
>  	    .notifier_call = acpi_cpu_soft_notify,
>  };
>  
> -static int acpi_processor_add(struct acpi_device *device)
> +static int __cpuinit acpi_processor_add(struct acpi_device *device)
>  {
>  	struct acpi_processor *pr = NULL;
>  	int result = 0;

I don't see this patch in today's linux-next ... ACPI guys, are you going 
to merge it?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
