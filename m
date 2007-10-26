Return-Path: <linux-kernel-owner+w=401wt.eu-S1756576AbXJZFMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbXJZFMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 01:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbXJZFL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 01:11:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbXJZFL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 01:11:58 -0400
Date: Thu, 25 Oct 2007 21:59:50 -0700
From: Greg KH <gregkh@suse.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC] full suspend/resume support for i915 DRM driver
Message-ID: <20071026045950.GA22920@suse.de>
References: <200710181401.50470.jbarnes@virtuousgeek.org> <200710240818.31128.jbarnes@virtuousgeek.org> <200710242322.36291.rjw@sisk.pl> <200710251653.19978.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710251653.19978.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 04:53:18PM -0700, Jesse Barnes wrote:
> Ok, here's yet another version that uses the device model for the
> suspend/resume, rather than pci hooks.
> 
> Greg, DRM desperately needs review of its device model usage, can you
> take a look at this patch and the current drm_sysfs.c code?  Right now,
> we're mixing class_devices and regular devices (the latter seem to be
> required for suspend/resume to work correctly), but this seems wrong.
> Any ideas?  Should we just rip out the class_device stuff and create
> full-on DRM device nodes?

The class_device stuff is already ripped out in the latest -mm trees and
I will be forwarding that change on for 2.6.25 after 2.6.24 is out.  So
yes, it should be taken away :)

But converting from class_device to struct device does not mean you use
a "device node".  But you could if you want to :)

Other than that, the driver model usage isn't the best, but I think the
majority of the major issues are fixed up now, especially with the
removal of class_device.  Is there anything specific you are curious
about?

thanks,

greg k-h
