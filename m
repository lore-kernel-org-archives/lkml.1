Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbZCKRD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbZCKRD2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 13:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZCKRDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 13:03:18 -0400
Received: from mail.suse.de ([195.135.220.2]:33306 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbZCKRDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 13:03:17 -0400
Date: Wed, 11 Mar 2009 10:00:57 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [RFC] drivers/base: Add bus_register_notifier_alldev() variant
Message-ID: <20090311170057.GA24113@suse.de>
References: <20090306160818.404.92700.stgit@localhost.localdomain> <20090311162623.GE21831@suse.de> <fa686aa40903110935g155fbf7m83f4aead71d72488@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa686aa40903110935g155fbf7m83f4aead71d72488@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 10:35:29AM -0600, Grant Likely wrote:
> On Wed, Mar 11, 2009 at 10:26 AM, Greg KH <gregkh@suse.de> wrote:
> > On Fri, Mar 06, 2009 at 09:10:19AM -0700, Grant Likely wrote:
> >> From: Grant Likely <grant.likely@secretlab.ca>
> >>
> >> bus_register_notifier_alldev() is a variation on bus_register_notifier()
> >> which also triggers the notifier callback for devices already on the bus
> >> and already bound to drivers.
> >>
> >> This function is useful for the case where a driver needs to get a
> >> reference to a struct device other than the one it is bound to and
> >> it is not known if the device will be bound before or after this
> >> function is called.  For example, an Ethernet device connected to
> >> a PHY that is probed separately.
> >
> > Can't you just walk the list of all devices already on the bus to get
> > "notified" of them, and then register your notifier handler as well (or
> > register it first, and then walk the list, which is pretty much what
> > your patch does)?
> 
> Yes, and I originally did, but it looks to me like a useful common
> pattern that is less error prone than open coding it.

How about we wait, and if someone else does the same thing, we then add
it to the core like this?

Actually, wouldn't it make more sense to just change the default
"bus_register_notifier" to do this?  Is there some reason that the
caller would not want this kind of thing to happen?

thanks,

greg k-h
