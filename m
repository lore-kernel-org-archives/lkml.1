Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbZCKQ3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbZCKQ3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 12:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZCKQ3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 12:29:12 -0400
Received: from ns2.suse.de ([195.135.220.15]:35118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbZCKQ3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 12:29:11 -0400
Date: Wed, 11 Mar 2009 09:26:23 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [RFC] drivers/base: Add bus_register_notifier_alldev() variant
Message-ID: <20090311162623.GE21831@suse.de>
References: <20090306160818.404.92700.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306160818.404.92700.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 09:10:19AM -0700, Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> bus_register_notifier_alldev() is a variation on bus_register_notifier()
> which also triggers the notifier callback for devices already on the bus
> and already bound to drivers.
> 
> This function is useful for the case where a driver needs to get a
> reference to a struct device other than the one it is bound to and
> it is not known if the device will be bound before or after this
> function is called.  For example, an Ethernet device connected to
> a PHY that is probed separately.

Can't you just walk the list of all devices already on the bus to get
"notified" of them, and then register your notifier handler as well (or
register it first, and then walk the list, which is pretty much what
your patch does)?

I see this api addition as just confusing people as to which one they
should register for :)

thanks,

greg k-h
