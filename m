Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbXHDEFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbXHDEFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 00:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbXHDEFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 00:05:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:43991 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbXHDEFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 00:05:46 -0400
Date: Fri, 3 Aug 2007 21:08:06 -0700
From: Greg KH <gregkh@suse.de>
To: "Denis V. Lunev" <den@openvz.org>
Cc: dev@openvz.org, akpm@linux-foundation.org, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pci_get_device call from interrupt in reboot fixups
Message-ID: <20070804040806.GF23330@suse.de>
References: <20070803103924.GA23786@iris.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070803103924.GA23786@iris.sw.ru>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 02:39:24PM +0400, Denis V. Lunev wrote:
> The following calltrace is possible now:
>  handle_sysrq
>    machine_emergency_restart
>      mach_reboot_fixups
>        pci_get_device
>          pci_get_subsys
> 	   down_read
> The patch obtains PCI device during initialization to avoid bothering PCI
> search engine in interrupt. Devices used in this code are not supposed to
> be pluggable, so it looks safe to keep them.

What devices are supposed to be affected here?  Are you sure that they
can't be removed later?  Grabbing references here might mess with them
in the future.

thanks,

greg k-h
