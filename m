Return-Path: <linux-kernel-owner+w=401wt.eu-S1763512AbXHVOlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763512AbXHVOlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbXHVOlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:41:40 -0400
Received: from dax.msoe.edu ([155.92.194.41]:54233 "EHLO mx.msoe.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbXHVOlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:41:39 -0400
Message-ID: <45719.198.169.188.225.1187793693.squirrel@myweb.msoe.edu>
In-Reply-To: <20070822054615.GA23336@kroah.com>
References: <1187716018.731090.165620@j4g2000prf.googlegroups.com>
    <20070821171018.C964B5F778@attila.bofh.it>
    <39877.198.169.188.225.1187733834.squirrel@myweb.msoe.edu>
    <20070822054615.GA23336@kroah.com>
Date: Wed, 22 Aug 2007 09:41:33 -0500 (CDT)
Subject: Re: Restricting CDC-ACM devices
From: "Nate" <stoddarn@msoe.edu>
To: "Greg KH" <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-MSOE-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MSOE-MailScanner-From: stoddarn@msoe.edu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Why do you not want to modify the driver?

Modifying the cdc-acm driver is an alternative; however, I would like to
avoid that when I'm adding my vendor specific restrictions.  My hope is
that when patches are made to that file, I don't need to worry about
someone merging them over the my previous ones.  Is this a bad goal?


> You can disconnect the device from the driver from userspace for any
> device you just don't want to have connected by using the sysfs
> bind/unbind files.  That doesn't require any kernel changes at all.

I don't fully follow you here.  Are you saying that I can disconnect the
CDC-ACM driver from my USB device and allow my driver to get a call probe?


> Why do you want to do this, what are you expecting to achieve with such
> a change?

The main application accesses data from USB devices over the /dev/ttyACMx
files, so using the CDC-ACM driver makes it easy for me to get the USB
device data.  There will be multiple USB devices that will be
communicating using CDC-ACM protocol, and I would like to restrict access
to only devices with the correct product IDs.  I was thinking if my driver
checked the VID/PID before allowing the CDC-ACM driver to process the
probe call, then I can restrict the devices.  The approved devices would
then be connected to ttyACMx by the standard cdc-acm driver code.

I'm still pretty green with regards to USB driver development, so there
might be a better way to achieve this.  If there is please tell me. :)

Thanks,
-Nate

