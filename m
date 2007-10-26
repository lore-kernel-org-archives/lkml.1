Return-Path: <linux-kernel-owner+w=401wt.eu-S1762951AbXJZQ71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762951AbXJZQ71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbXJZQ7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:59:09 -0400
Received: from outbound-mail-21.bluehost.com ([69.89.21.16]:34696 "HELO
	outbound-mail-21.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755585AbXJZQ7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:59:07 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <gregkh@suse.de>
Subject: Re: [RFC] full suspend/resume support for i915 DRM driver
Date: Fri, 26 Oct 2007 09:57:14 -0700
User-Agent: KMail/1.9.7
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
References: <200710181401.50470.jbarnes@virtuousgeek.org> <200710251653.19978.jbarnes@virtuousgeek.org> <20071026045950.GA22920@suse.de>
In-Reply-To: <20071026045950.GA22920@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710260957.15137.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 25, 2007 9:59 pm Greg KH wrote:
> On Thu, Oct 25, 2007 at 04:53:18PM -0700, Jesse Barnes wrote:
> > Ok, here's yet another version that uses the device model for the
> > suspend/resume, rather than pci hooks.
> >
> > Greg, DRM desperately needs review of its device model usage, can
> > you take a look at this patch and the current drm_sysfs.c code? 
> > Right now, we're mixing class_devices and regular devices (the
> > latter seem to be required for suspend/resume to work correctly),
> > but this seems wrong. Any ideas?  Should we just rip out the
> > class_device stuff and create full-on DRM device nodes?
>
> The class_device stuff is already ripped out in the latest -mm trees
> and I will be forwarding that change on for 2.6.25 after 2.6.24 is
> out.  So yes, it should be taken away :)
>
> But converting from class_device to struct device does not mean you
> use a "device node".  But you could if you want to :)

Yeah, bad choice of words. :)

To retain compatibility, we need to have directories under the DRM class 
dir (/sys/class/drm) for each card (e.g. card0) that contains a file 
describing which graphics driver is bound to the device.  For class 
devices, we could just add an attributes structure to the device.  Can 
we do the same with regular, non-class devices?

Thanks,
Jesse
