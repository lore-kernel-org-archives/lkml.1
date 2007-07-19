Return-Path: <linux-kernel-owner+w=401wt.eu-S940221AbXGSRQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940221AbXGSRQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbXGSRP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:15:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:36258 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937903AbXGSRPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:15:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L8xOMvu9fKXjxWDGbNiqjou4Y6NlbW8OKsBVEGk42XTtIpzQSAMYQPe9OQJKxO/3xTgvzHSIUdzPkTvNFPM1wvlwzy+szXj6GGFVHhJV0Xy78YnqQd7W4LOyiTlIfpsgwIkCttyHBj5VdLHA28+H2qxUQDL7IXQDQkCpajkLnB4=
Message-ID: <86802c440707191015u4c6b0e72u17c7674593fb1085@mail.gmail.com>
Date: Thu, 19 Jul 2007 10:15:55 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] [7/58] x86_64: various cleanups in NUMA scan node
Cc: rientjes@google.com, patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070719095451.3578E14E04@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707191154.642492000@suse.de>
	 <20070719095451.3578E14E04@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/07, Andi Kleen <ak@suse.de> wrote:
>
> From: David Rientjes <rientjes@google.com>
> In acpi_scan_nodes(), we immediately return -1 if acpi_numa <= 0, meaning
> we haven't detected any underlying ACPI topology or we have explicitly
> disabled its use from the command-line with numa=noacpi.
>
> acpi_table_print_srat_entry() and acpi_table_parse_srat() are only
> referenced within drivers/acpi/numa.c, so we can mark them as static and
> remove their prototypes from the header file.
>
> Likewise, pxm_to_node_map[] and node_to_pxm_map[] are only used within
> drivers/acpi/numa.c, so we mark them as static and remove their externs
> from the header file.
>
> The automatic 'result' variable is unused in acpi_numa_init(), so it's
> removed.
>
> Signed-off-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Andi Kleen <ak@suse.de>
>
> ---
>  arch/x86_64/mm/srat.c |    6 +++---
>  drivers/acpi/numa.c   |   20 ++++++++++----------
>  include/linux/acpi.h  |    2 --
>  3 files changed, 13 insertions(+), 15 deletions(-)
>
> Index: linux/arch/x86_64/mm/srat.c
> ===================================================================
> --- linux.orig/arch/x86_64/mm/srat.c
> +++ linux/arch/x86_64/mm/srat.c
>  /* maps to convert between proximity domain and logical node ID */
> -static int pxm_to_node_map[MAX_PXM_DOMAINS]
> +static int __cpuinitdata pxm_to_node_map[MAX_PXM_DOMAINS]
>                                 = { [0 ... MAX_PXM_DOMAINS - 1] = NID_INVAL };
> -static int node_to_pxm_map[MAX_NUMNODES]
> +static int __cpuinitdata node_to_pxm_map[MAX_NUMNODES]
>                                 = { [0 ... MAX_NUMNODES - 1] = PXM_INVAL };
>
do we need to put __initdata just before =?

YH
