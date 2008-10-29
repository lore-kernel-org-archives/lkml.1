Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYJ2MUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYJ2MUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 08:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbYJ2MUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 08:20:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42591 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYJ2MUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 08:20:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] hibernation should work ok with memory hotplug
Date: Wed, 29 Oct 2008 13:25:00 +0100
User-Agent: KMail/1.9.9
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       Andrew Morton <akpm@osdl.org>
References: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20081029105956.GA16347@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810291325.01481.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 29 of October 2008, Pavel Machek wrote:
> 
> hibernation + memory hotplug was disabled in kconfig because we could
> not handle hibernation + sparse mem at some point. It seems to work
> now, so I guess we can enable it.

OK, if "it seems to work now" means that it has been tested and confirmed to
work, no objection from me.

Thanks,
Rafael


> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> 
> diff -ur linux/mm/Kconfig linux.tmp/mm/Kconfig
> --- linux/mm/Kconfig	2008-10-27 10:10:59.000000000 +0100
> +++ linux.tmp/mm/Kconfig	2008-10-29 10:02:41.000000000 +0100
> @@ -128,12 +128,9 @@
>  config MEMORY_HOTPLUG
>  	bool "Allow for memory hot-add"
>  	depends on SPARSEMEM || X86_64_ACPI_NUMA
> -	depends on HOTPLUG && !HIBERNATION && ARCH_ENABLE_MEMORY_HOTPLUG
> +	depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
>  	depends on (IA64 || X86 || PPC64 || SUPERH || S390)
>  
> -comment "Memory hotplug is currently incompatible with Software Suspend"
> -	depends on SPARSEMEM && HOTPLUG && HIBERNATION
> -
>  config MEMORY_HOTPLUG_SPARSE
>  	def_bool y
>  	depends on SPARSEMEM && MEMORY_HOTPLUG
> 


