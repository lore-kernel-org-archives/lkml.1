Return-Path: <linux-kernel-owner+w=401wt.eu-S1422828AbXBHF4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422828AbXBHF4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 00:56:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422836AbXBHF4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 00:56:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422828AbXBHF4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 00:56:00 -0500
Date: Wed, 7 Feb 2007 21:54:52 -0800
From: Greg KH <greg@kroah.com>
To: Simon White <sidplay2@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Multiple virtual bus instances
Message-ID: <20070208055452.GB13270@kroah.com>
References: <883291.79449.qm@web52902.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <883291.79449.qm@web52902.mail.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 02:15:08PM -0800, Simon White wrote:
> Hi,
> 
> I've been working through trying to create a virtual
> bus.

How does this differ from a "real" bus?

> I've successfuly made it work for a single instance but wanted to
> confirm how to create multiple instances of the virtual bus.

Why would you need that?

> I believe to do this you have only one instance of your new
> bus_type registered but register multiple instances of struct device
> for it.  I just wanted to confirm that was correct.

That would create multiple devices on the same bus.  Is that what you
need to do?

> Lastly how do you walk over all devices on a bus
> instance?

You usually do this in your bus-specific code somehow.

> I note bus_for_each_dev but that appears to take a bus_type rather
> than struct device instance, hence I assume it will return all devices
> from all instances.

No, it will walk the bus that you created.  If you need multiple busses,
create multiple 'struct bus_type' structures.

> I know I could compare each device to see if it is on a certain bus
> instance but wondered if there was a better way?

I think you will find that it works the way it is described.

Might I ask what you are trying to do with these multiple busses?

Note that you can have multiple trees of devices, all with the same
bus_type, yet not joined together in any other way.  Odds are, you
probably want to do that, right?

thanks,

greg k-h
