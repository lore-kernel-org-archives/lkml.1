Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbYAXRHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbYAXRHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760402AbYAXRGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:06:45 -0500
Received: from nz-out-0506.google.com ([64.233.162.228]:43886 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760383AbYAXRGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:06:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BwU1Y5FnV8YDzFVazIwuf7nCL21fbVmVqvVvshfQm0OdeAxUfN8sM4TLdLR8KYCANDLFPqy5kaT0mDydgL1YS7hwzsQpRgf7JQJWgRmaLubq0Bj7tQMN8HcHZDUQmX5n8fd37ngcYG2XqCfRi9NZziVQqSJxZMD+lcVjuY09Y4c=
Message-ID: <84144f020801240906l7e018a95wfd4ad7736851dd63@mail.gmail.com>
Date: Thu, 24 Jan 2008 19:06:39 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Cc: "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080124164418.GA8226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
	 <20080124013720.GA21978@kroah.com>
	 <6c4c86470801240205u5361e090jc057270b03b5ebe7@mail.gmail.com>
	 <84144f020801240319o1f51613fx6e823120f74a9cf9@mail.gmail.com>
	 <20080124164418.GA8226@kroah.com>
X-Google-Sender-Auth: c6f04305bb25b907
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Jan 24, 2008 6:44 PM, Greg KH <greg@kroah.com> wrote:
> No, that's not the problem.  The code should just be using
> usb_register_driver() and then doing what it needs to do in the probe()
> callback, like any other USB driver.
>
> By calling usb_find_device() it allows more than one driver to talk to
> the device at the same time, setting it up for some very bad things to
> possibly happen to the device.
>
> So a simple code change should be all that is needed to properly fix
> this.
>
> If you want, I can make up a patch, just point me at the version you
> wish me to modify.

As I already mentioned in private, the code is here:

http://www.init0.nl/iriverfs-r0.1.0.1-linux-2.6.23.patch.bz2

It's basically abusing the USB driver stack with a ->probe() function
that returns -ENODEV and doing device discovery at mount time. That,
however, is also broken as it assumes there's only one device plugged
in (we're not passing any device identifier to sys_mount).

So it's not a simple code change at all. Are there any datasheets
available for these things or is the current driver reverse
engineered?

                        Pekka
