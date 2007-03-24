Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbXCXWpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbXCXWpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 18:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbXCXWpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 18:45:10 -0400
Received: from waste.org ([66.93.16.53]:45061 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932869AbXCXWpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 18:45:08 -0400
Date: Sat, 24 Mar 2007 17:32:28 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070324223228.GP10459@waste.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <1174433034.62033.16.camel@localhost> <20070320223643.d8cbc3f6.akpm@linux-foundation.org> <4601761F.4000302@lwfinger.net> <20070321185900.GC3801@tuxdriver.com> <20070321202225.GN10459@waste.org> <20070321233917.0393dfd1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321233917.0393dfd1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 11:39:17PM -0800, Andrew Morton wrote:
> On Wed, 21 Mar 2007 15:22:25 -0500 Matt Mackall <mpm@selenic.com> wrote:
> 
> > With the latest -mm, I'm now getting this:
> > 
> > Mar 21 15:06:52 cinder kernel: ipw2200: Detected Intel PRO/Wireless
> > 2200BG Network Connection
> > Mar 21 15:06:52 cinder kernel: firmware_loading_store: unexpected
> > value (0)
> > Mar 21 15:06:52 cinder kernel: ipw2200: ipw2200-bss.fw
> > request_firmware failed:
> > Reason -2
> > Mar 21 15:06:52 cinder kernel: ipw2200: Unable to load firmware: -2
> > Mar 21 15:06:52 cinder kernel: ipw2200: failed to register network
> > device
> 
> The firmware loading bug is caused by
> driver-core-handles-kobject_uevent-failure-while-device_add.patch
> 
> I've uploaded a revert patch to
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/hot-fixes/

For the record, with the following patches:

# hotfixes
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix-2.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings-fix.patch
revert-driver-core-handles-kobject_uevent-failure-while-device_add.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch

...I just had a boot where firmware loading failed again. rmmod+insmod
fixed it.

-- 
Mathematics is the supreme nostalgia of our time.
