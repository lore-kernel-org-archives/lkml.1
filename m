Return-Path: <linux-kernel-owner+w=401wt.eu-S1759792AbXJZT7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792AbXJZT7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXJZT7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:59:03 -0400
Received: from galaxy.systems.pipex.net ([62.241.162.31]:53278 "EHLO
	galaxy.systems.pipex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbXJZT7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:59:00 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] [PATCH] rt2500usb - Don't claim 050d:705{0/a}
Date: Fri, 26 Oct 2007 20:58:56 +0100
User-Agent: KMail/1.9.5
Cc: Roland Dreier <rdreier@cisco.com>, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org, kernel-stuff@comcast.net
References: <alpine.DEB.0.99.0710241909250.18618@parag-desktop> <200710262039.17027.IvDoorn@gmail.com> <adamyu5zo88.fsf@cisco.com>
In-Reply-To: <adamyu5zo88.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710262058.56188.linux@baker-net.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 20:10, Roland Dreier wrote:
>  > Well it could be something quite simple, in the module loader it is
> looping > through all modules to look for a device with the correct USB/PCI
> ID. > Currently, after the first occurence it loads the module and doesn't
> continue, > it should perhaps be relatively easy that it checks if the
> driver returned -ENODEV > and continues looping to search for another
> driver.
>
> But a driver (especially a driver for something as hot-pluggable as a
> USB device) shouldn't return -ENODEV just because no devices are
> present at the moment.  It should just load successfully and wait for
> a device to appear.

The function that is returning ENODEV is the driver probe function. According 
to Documentation/DocBook/writing_usb_driver/ch03.html when that function is 
called 

"The driver now needs to verify that this device is actually one that it can 
accept. If so, it returns 0. If not, or if any error occurs during 
initialization, an errorcode (such as -ENOMEM or -ENODEV) is returned from 
the probe function."

It isn't a device the driver can accept so it returns -ENODEV

Adam
