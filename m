Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbYHTRhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbYHTRhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYHTRhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:37:45 -0400
Received: from mga12.intel.com ([143.182.124.36]:18607 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751990AbYHTRho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:37:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,240,1217833200"; 
   d="scan'208";a="35779401"
Message-ID: <48AC5668.2030203@linux.intel.com>
Date: Wed, 20 Aug 2008 19:37:44 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: linux-kernel@vger.kernel.org, len.brown@intel.com, arjan@linux.intel.com,
       bjorn.helgaas@hp.com, linux-acpi@vger.kernel.org,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: [PATCH 1/3] Introduce interface to report BIOS bugs
References: <1219251726-24746-1-git-send-email-trenn@suse.de> <1219251726-24746-2-git-send-email-trenn@suse.de>
In-Reply-To: <1219251726-24746-2-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:

I approve of the basic idea. Some nits in the implementation.

First shouted macros look ugly. Can you use something lower case
similar to dev_printk()?

> +
> +#define 	FW_EMERG	KERN_EMERG  /* System cannot boot */
> +#define 	FW_ALERT 	KERN_ALERT  /* Risk of HW or data damage, 
> +					       e.g. overheating, dmraid */
> +#define 	FW_CRIT 	KERN_CRIT   /* A major device is not functional
> +					       e.g. hpet, lapic, network... */
> +#define 	FW_ERR		KERN_ERR    /* A major device is not working
> +					       as expected, e.g. cpufreq stuck
> +					       to lowest freq, lowered
> +					       performance, increased power
> +					       consumption... */

These should probably have another string after the KERN_* severities appended
because KERN_* doesn't make it into the syslog log files or serial
console logs and you would lose the severity then.


> +config REPORT_FIRMWARE_BUGS
> +	bool "Report Firmware Bugs"
> +	default y
> +	help
> +	  This option will make the kernel print out all firmware bug messages
> +	  it finds. This especially is very useful on ACPI systems where
> +	  potentially a lot firmware bugs can happen and should be reported.
> +	  
> +	  Always say yes here unless memory really matters.

I don't think this should be a CONFIG.  If someone really wants to save
that much memory they can disable printk.

-Andi
