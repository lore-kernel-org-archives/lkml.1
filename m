Return-Path: <linux-kernel-owner+w=401wt.eu-S1765102AbYCEKRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765102AbYCEKRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 05:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761564AbYCEKRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 05:17:04 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:30344 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759182AbYCEKRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 05:17:03 -0500
Date: Wed, 5 Mar 2008 13:16:17 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, "Zhang, Rui" <rui.zhang@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, kay.sievers@vrfy.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc regression: kernel panic on boot
Message-ID: <20080305101617.GD19059@localhost.sw.ru>
References: <1204500349.10256.171.camel@acpi-hp-zz.sh.intel.com> <20080303224259.GA27008@suse.de> <20080304135447.GD32383@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304135447.GD32383@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 02:54:47PM +0100, Ingo Molnar wrote:
> CONFIG_SYSFS_DEPRECATED=y changed its meaning recently and causes
> regressions in working setups that had SYSFS_DEPRECATED disabled.
> 
> so rename it to SYSFS_DEPRECATED_V2 so that testers pick up the new
> default via 'make oldconfig', even if their old .config's disabled
> CONFIG_SYSFS_DEPRECATED ...

It has all the same help text, so people who disabled it in the past
will disable again!

> --- linux.orig/init/Kconfig
> +++ linux/init/Kconfig
> @@ -367,9 +367,13 @@ config RESOURCE_COUNTERS
>  	depends on CGROUPS
>  
>  config SYSFS_DEPRECATED
> +	bool
> +
> +config SYSFS_DEPRECATED_V2
>  	bool "Create deprecated sysfs files"
>  	depends on SYSFS
>  	default y
> +	select SYSFS_DEPRECATED
>  	help
>  	  This option creates deprecated symlinks such as the
>  	  "device"-link, the <subsystem>:<name>-link, and the

Is anyone aware of a case when turning SYSFS_DEPRECATED back on also
breaks something? I mean, option can be simply removed and sysfs people
can finally stop breaking boxes.

