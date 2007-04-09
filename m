Return-Path: <linux-kernel-owner+w=401wt.eu-S966035AbXDIP60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966035AbXDIP60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966031AbXDIP60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:58:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61488 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966035AbXDIP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:58:25 -0400
Date: Mon, 9 Apr 2007 08:59:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       mingo@redhat.com
Subject: Re: [PATCH]: Resubmit Fix overloaded use of acpi= on bootline
Message-Id: <20070409085920.2a467912.randy.dunlap@oracle.com>
In-Reply-To: <20070409132547.3222.96879.sendpatchset@prarit.boston.redhat.com>
References: <20070409132547.3222.96879.sendpatchset@prarit.boston.redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007 09:25:47 -0400 Prarit Bhargava wrote:

> The use of "apic=" on the boot line is overloaded.  It is used once to
> override the type of genapic, and then later on it is used to determine a debug
> level.  Because of this a bogus error message is sent to the console when using
> the debug option:
> 
> 	Unknown genapic `apic=debug' specified.
> 
> This patch changes the genapic situation to use "genapic=".
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>

Thanks, looks good except that the Subject line could confuse
someone (s/acpi/apic/).


> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index ef2ffde..8cbd90c 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -589,6 +589,9 @@ and is between 256 and 4096 characters. It is defined in the file
>  
>  	gamma=		[HW,DRM]
>  
> +	genapic=	[APIC,i386] Select a specific genapic type to be used.
> +			Format: <name>
> +
>  	gdth=		[HW,SCSI]
>  			See header of drivers/scsi/gdth.c.
>  
> diff --git a/arch/i386/mach-generic/probe.c b/arch/i386/mach-generic/probe.c
> index a7b3999..cabe31b 100644
> --- a/arch/i386/mach-generic/probe.c
> +++ b/arch/i386/mach-generic/probe.c
> @@ -49,7 +49,7 @@ static int __init parse_apic(char *arg)
>  	/* Parsed again by __setup for debug/verbose */
>  	return 0;
>  }
> -early_param("apic", parse_apic);
> +early_param("genapic", parse_apic);
>  
>  void __init generic_bigsmp_probe(void)
>  {
> -


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
