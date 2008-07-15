Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbYGOXHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbYGOXHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbYGOXHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:07:34 -0400
Received: from isilmar.linta.de ([213.133.102.198]:57907 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752536AbYGOXHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:07:34 -0400
Date: Wed, 16 Jul 2008 01:07:31 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
       greg@kroah.com, nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 6/7] dynamic debug v2 - convert cpufreq
Message-ID: <20080715230731.GA15208@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
	nick@nick-andrew.net, randy.dunlap@oracle.com
References: <20080715213613.GG23331@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715213613.GG23331@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 15, 2008 at 05:36:13PM -0400, Jason Baron wrote:
> +#include <linux/dynamic_debug_cpufreq.h>

what's contained in this file (couldn't find it in this or one of the other
diffs, but may have missed it).

> -#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "cpufreq-nforce2", msg)
> +#define dprintk(msg...) do { \
> +	if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
> +		cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "cpufreq-nforce2", msg); \
> +	} while (0)

Hm.... What about leaving this as it is, renaming the
drivers/cpufreq/cpufreq.c function to __cpufreq_debug_printk(), and then
adding to include/linux/cpufreq.h

#define cpufreq_debug_printk(type, prefix, msg...) do { \
	if (dynamic_dbg_enabled(TYPE_FLAG, type, cpufreq_debug))
		cpufreq_debug_printk(type, prefix, msg); \
	} while (0)

> +#if defined(CONFIG_CPU_FREQ_DEBUG) || defined (CONFIG_DYNAMIC_PRINTK_DEBUG)
...
> +#if defined(CONFIG_CPU_FREQ_DEBUG) || defined (CONFIG_DYNAMIC_PRINTK_DEBUG)

can't we just depend on thing on another?

> -module_param(debug, uint, 0644);
> -MODULE_PARM_DESC(debug, "CPUfreq debugging: add 1 to debug core,"
> +module_param(cpufreq_debug, uint, 0644);
> +MODULE_PARM_DESC(cpufreq_debug, "CPUfreq debugging: add 1 to debug core,"
>  			" 2 to debug drivers, and 4 to debug governors.");

cpufreq.cpufreq_debug is ugly and not backwards compatible... what about 

module_param_named(debug, cpufreq_debug, uint, 0644) [or the other way
around, I always forget...])

Best,
	Dominik
