Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZKLXp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZKLXp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755429AbZKLXp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:45:58 -0500
Received: from kroah.org ([198.145.64.141]:47472 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275AbZKLXp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:45:57 -0500
Date: Thu, 12 Nov 2009 15:42:55 -0800
From: Greg KH <greg@kroah.com>
To: Nathaniel McCallum <nathaniel@natemccallum.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Devices that ignore USB spec generate invalid
 modaliases
Message-ID: <20091112234255.GA23889@kroah.com>
References: <4AFA73C7.4070002@natemccallum.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AFA73C7.4070002@natemccallum.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 03:20:23AM -0500, Nathaniel McCallum wrote:
> Please CC me as I'm not subscribed to LKML.
> 
> The current code to generate usb modaliases from usb_device_id assumes 
> that the device's bcdDevice descriptor will actually be in BCD format. 
> While this should be a sane assumption, some devices don't follow spec 
> and just use plain old hex.  This causes drivers for these devices to 
> generate invalid modalias lines which will never actually match for the 
> hardware.
> 
> The following patch adds hex support for bcdDevice in file2alias.c. 
> Drivers for devices which have bcdDevice conforming to BCD will have no 
> change in modalias output.  Drivers for devices which don't conform 
> (primarily usb-storage and ibmcam in my initial survey) should now 
> generate valid modaliases.
> 
> EXAMPLE OUTPUT (ibmcam; space added to highlight change)
> Old: usb:v0545p800D d030[10-9] dc*dsc*dp*ic*isc*ip*
> New: usb:v0545p800D d030a      dc*dsc*dp*ic*isc*ip*

Huh?  The old one had '[]' in it?

What does the bcdDevice for this really look like in the device itself?
If it is messed up in the descriptor, then how can we know to fix it up
here?

And you might want to cc: linux-usb@vger.kernel.org with this as well,
as that's where the USB developers are.

thanks,

greg k-h
