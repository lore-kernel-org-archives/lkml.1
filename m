Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715Ab0AEPBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0AEPBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695Ab0AEPBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:01:13 -0500
Received: from kroah.org ([198.145.64.141]:43210 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab0AEPBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:01:03 -0500
Date: Tue, 5 Jan 2010 06:55:02 -0800
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [0/12] SYSFS: Sysfs attribute improvements
Message-ID: <20100105145502.GG11732@kroah.com>
References: <201001051247.104464547@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001051247.104464547@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 12:47:57PM +0100, Andi Kleen wrote:
> 
> sysdev_class attributes and class attributes do not pass
> their own attribute to the low level store/show functions. This means
> that itiss not possible to use shared functions for common data,
> but each data item had to have its own function. Typically this
> lead to ugly and big custom macro cascades in drivers, generating
> the store/show functions for each attribute. This leads to 
> large code and is ugly.
> 
> When the attributes are passed to the callbacks -- like they are for plain
> attributes and sysdev attributes -- it's possible to "derive"
> own attribute objects that carry some data, use that data and then call into 
> shared store/show code.
> 
> This patchkit fixes up these callback interfaces to allow to do this. This
> involves two tree sweeps for sysdev_class_attributes and class_attributes,
> changing them all to accept the new attribute argument.
> 
> I tried to convert all users, but was only able to compile test on x86.
> 
> All users were converted in a single patch to avoid unbisectable
> sections. I didn't put all the individual driver maintainers in cc,
> they probably wouldn't need to care.
> 
> Also I added some utility functions to easier deal with arrays
> of attributes. A lot of users define multiple attributes and had
> to open code array handling for this. Add new sysfs interfaces
> to handle the arrays directly. sysdev classes now can just
> directly carry their own attributes, similar to normal classes.
> 
> Then the CPU and the NODE driver in drivers/base serve as a poster
> child for the new facilities and shrink their code dramatically
> by using the new facilities.
> 
> In addition I added a new string attribute type derived 
> from class attributes. This allows various drivers who use
> class attributes to export static version strings to just
> use a single macro, no custom callbacks.
> 
> I didn't convert all drivers over to the new facilities, this
> can be done gradually.

I like these changes, thanks for doing the work.  I do have some
comments on some of the patches, they will follow.

thanks,

greg k-h
