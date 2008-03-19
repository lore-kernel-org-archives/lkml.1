Return-Path: <linux-kernel-owner+w=401wt.eu-S1760284AbYCSX2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760284AbYCSX2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934498AbYCSWBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:01:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34480 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761515AbYCSWB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:01:26 -0400
Date: Tue, 18 Mar 2008 17:53:40 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks
Message-ID: <20080319005340.GC8298@kroah.com>
References: <200803170020.55473.rjw@sisk.pl> <200803170022.30345.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803170022.30345.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 12:22:29AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Introduce 'struct pm_ops' representing a set of suspend and
> hibernation operations for bus types, device classes and device
> types.

Ok, I must have missed the thread describing why we need to do this, so,
why do we need to do this?  What is this going to buy us in the end
after everything is changed?

> +struct pm_ops {
> +#ifdef CONFIG_PM_SLEEP
> +	int (*prepare)(struct device *dev);
> +	void (*complete)(struct device *dev);
> +#endif
> +#ifdef CONFIG_SUSPEND
> +	int (*suspend)(struct device *dev);
> +	int (*resume)(struct device *dev);
> +#endif
> +#ifdef CONFIG_HIBERNATION
> +	int (*freeze)(struct device *dev);
> +	int (*thaw)(struct device *dev);
> +	int (*poweroff)(struct device *dev);
> +	int (*quiesce)(struct device *dev);
> +	int (*restore)(struct device *dev);
> +	int (*recover)(struct device *dev);
> +#endif


Don't ifdef stuff like this, it only causes ifdefs to be needed to the
.c code as well for all places these structures are defined in
drivers/busses, right?

thanks,

greg k-h
