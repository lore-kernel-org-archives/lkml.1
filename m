Return-Path: <linux-kernel-owner+w=401wt.eu-S1763528AbYEFMog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763528AbYEFMog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762829AbYEFMoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:44:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49571 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762637AbYEFMoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:44:08 -0400
Subject: Re: [2.6 patch] proper prototype for
	acpi_processor_tstate_has_changed()
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Adrian Bunk <bunk@kernel.org>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080505182845.GR17139@cs181133002.pp.htv.fi>
References: <20080505182845.GR17139@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Tue, 06 May 2008 16:43:56 +0200
Message-Id: <1210085036.4802.40.camel@linux-2bdv.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-05 at 21:28 +0300, Adrian Bunk wrote:
> This patch adds a proper prototype for acpi_processor_tstate_has_changed()
> in include/acpi/processor.h

IMO the header files for ACPI could get a bit cleaned up anyway.
E.g. /include/acpi/* has Linux kernel and acpica specific headers
(e.g. acpi_bus.h and acpi_drivers.h).
I was thinking about starting:
- drivers/acpi/acpi.h (or more) header files for Linux specific
  declarations only used in the acpi subsystem
- include/linux/acpi.h (or more) for Linux specific global ACPI
  declarations
- /include/acpi/* should then just be a copy of the acpica
  lindent'ed header files

If someone thinks this produces more trouble any good..., otherwise I or
whoever could send some cleanup patches if feeling bored.

   Thomas

> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> This patch has been sent on:
> - 23 Apr 2008
> - 14 Apr 2008
> - 31 Mar 2008
> - 1 Mar 2008
> 
>  drivers/acpi/processor_core.c |    1 -
>  include/acpi/processor.h      |    1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> fcdb74ac24c943bc290e85e2d757f82dbb065955 foobar
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index a3cc8a9..d88f21e 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -86,7 +86,6 @@ static int acpi_processor_info_open_fs(struct inode *inode, struct file *file);
>  static void acpi_processor_notify(acpi_handle handle, u32 event, void *data);
>  static acpi_status acpi_processor_hotadd_init(acpi_handle handle, int *p_cpu);
>  static int acpi_processor_handle_eject(struct acpi_processor *pr);
> -extern int acpi_processor_tstate_has_changed(struct acpi_processor *pr);
>  
> 
>  static const struct acpi_device_id processor_device_ids[] = {
> diff --git a/include/acpi/processor.h b/include/acpi/processor.h
> index 06480bc..06ebb6e 100644
> --- a/include/acpi/processor.h
> +++ b/include/acpi/processor.h
> @@ -319,6 +319,7 @@ static inline int acpi_processor_ppc_has_changed(struct acpi_processor *pr)
>  #endif				/* CONFIG_CPU_FREQ */
>  
>  /* in processor_throttling.c */
> +int acpi_processor_tstate_has_changed(struct acpi_processor *pr);
>  int acpi_processor_get_throttling_info(struct acpi_processor *pr);
>  extern int acpi_processor_set_throttling(struct acpi_processor *pr, int state);
>  extern struct file_operations acpi_processor_throttling_fops;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

