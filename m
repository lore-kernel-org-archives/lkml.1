Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbXFWD4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbXFWD4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 23:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbXFWD4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 23:56:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbXFWD4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 23:56:04 -0400
Date: Fri, 22 Jun 2007 20:55:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: lenb@kernel.org, andreas.herrmann3@amd.com, swhiteho@redhat.com,
       ak@suse.de, shai@scalex86.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/12] acpi: fix another compile warning
Message-Id: <20070622205530.964ebef9.akpm@linux-foundation.org>
In-Reply-To: <20070620182548.GA561@localdomain>
References: <20070619225035.GI5193@alberich.amd.com>
	<200706192338.02807.lenb@kernel.org>
	<20070620084911.GO5193@alberich.amd.com>
	<200706200936.31236.lenb@kernel.org>
	<20070620182548.GA561@localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 20 Jun 2007 11:25:48 -0700 Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
> Paper over 'select' inadequacies.  
> 
> Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> 
> Index: linux-2.6.22-rc5/arch/x86_64/Kconfig
> ===================================================================
> --- linux-2.6.22-rc5.orig/arch/x86_64/Kconfig	2007-06-18 16:02:19.571323415 -0700
> +++ linux-2.6.22-rc5/arch/x86_64/Kconfig	2007-06-20 11:34:29.845354250 -0700
> @@ -366,6 +366,7 @@ config X86_64_ACPI_NUMA
>         depends on NUMA
>         select ACPI 
>  	select PCI
> +  	select PM
>         select ACPI_NUMA
>         default y
>         help

argh.  (and not just argh-at-your-email-client).

I went through some hair-tearing a few months ago working out why it is so
damn hard to make CONFIG_PM go away and then I fixed it.  And now you're
proposing a change which would reinstate the obnoxious old behaviour.

Is the "bug" which you're "fixing" here caused by the randconfig
inadequacies?  Because randconfig is just busted and simply should auto-run
oldconfig.
