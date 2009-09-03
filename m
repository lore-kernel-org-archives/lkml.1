Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZICAKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZICAKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 20:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZICAKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 20:10:48 -0400
Received: from kroah.org ([198.145.64.141]:42418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbZICAKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 20:10:47 -0400
Date: Wed, 2 Sep 2009 17:05:06 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
       Shane Huang <Shane.Huang@amd.com>
Subject: Re: [PATCH] pci: separate out pci_add_dynid()
Message-ID: <20090903000506.GA31897@kroah.com>
References: <4A9E38FA.3000506@kernel.org>
 <20090902161048.GA5405@lackof.org>
 <4A9EF402.7090800@kernel.org>
 <4A9EF510.9080902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9EF510.9080902@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 07:43:28AM +0900, Tejun Heo wrote:
> Ummm... another thought.
> 
> Tejun Heo wrote:
> > It's one of the gripes I've had with the driver core interface.
> > Returning the object which had its reference bumped up is nice to do
> > do_something(get_driver(driver)); but it should have been made clear
> > that the return value always equals the input parameter.  IIRC, in the
> > early days of the current driver model and kref, there were intentions
> > to make kref somehow more capable and handle the last reference
> > problem from within it so that if (get_driver(driver)) test is
> > actually meaningful but that turned out to be not too feasible, so we
> > ended up with unnecessary if () around driver model get functions.  I
> > try to remove them whenever an affected piece of code is being
> > modified but there still are plenty left.  I'll update comment on
> > driver core get functions.
> 
> Greg, I think I suggested this before.  What do you think about just
> making those get functions return void?

I have no objection to that at all.

> The current interface combined with widespread if() around them is
> quite misleading.

I agree.

> Most device/driver structures are inherited and extended when actually
> in use, so the driver or its subsystem code usually can't do much with
> the return value other than checking for bogus error condition anyway.

I totally agree.

thanks,

greg k-h
