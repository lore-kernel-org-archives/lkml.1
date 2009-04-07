Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbZDGBGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbZDGBGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZDGBGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:06:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37185 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZDGBGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:06:02 -0400
Date: Mon, 6 Apr 2009 17:58:03 -0700
From: Greg KH <gregkh@suse.de>
To: Elina <epasheva@sierrawireless.com>
Cc: rfiler@sierrawireless.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/003] USB: serial: sierra driver performance
	improvements
Message-ID: <20090407005803.GA2839@suse.de>
References: <1239062754.10120.36.camel@Linuxdev3>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1239062754.10120.36.camel@Linuxdev3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 05:05:54PM -0700, Elina wrote:
> Subject: [PATCH 001/003] USB: serial: sierra driver performance
> improvements
> From: Elina Pasheva <epasheva@sierrawireless.com>
> 
> The series of 3 patches modify sierra usb serial driver with
> ﻿performance improvements, blacklisting of specific non-serial 
> interfaces and bug fixing. 
> ﻿The following is summary of changes we have made to sierra.c driver in
> [PATCH 001/003] dealing with performance improvements:

You do a lot of different things in this patch, care to split it up into
tinier pieces, one per change?

> ﻿- Updated Copyright notice with new authors names
> ﻿- Version number set to 1.6.0
> - Increased the number of input/output URBs for improved performance
> (numbers based on an measurement study triggered by a user request).
> ﻿- Removed “no_dynamic_id=1” setting. Removing this setting will allow
> customers to add support for new modems via a system call (i.e. adding
> unrecognized PIDs) instead of having to download and build/install the
> driver for the new modem

This is incorrect, that value is an override for the usb driver, not the
usb-serial layer.  It should work today, just fine, to add a device id
after the driver is loaded dynamically through sysfs.  If not, please
let me know and I'll be glad to work on fixing it, but this is not the
correct way do to it.

Also, USB patches should be cc:ed to the linux-usb mailing list, I
really doubt that linux-kernel cares about tiny driver specific things
like this :)

Care to redo this whole series?

thanks,

greg k-h
