Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbYDRE7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbYDRE7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 00:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYDRE7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 00:59:37 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:24215 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbYDRE7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 00:59:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=vQ6eY4RssysGk85+L/skAPSnZEUaDYd7wX7u8CUZlVKKzL3yC4lcKIZEVjN11znRmCT0L//Vbt+0wUyaK2i6z+90n+IS4VmD4ud1h6i8TU2QchwjHRZAMCTGmmrH6fwzbDrkhhswIERxvyK6PepsV4muJwm3SdfmPhMJzxdHQkE=
Message-ID: <e9c3a7c20804172159x16554078i6d5c9097eeadc91c@mail.gmail.com>
Date: Thu, 17 Apr 2008 21:59:34 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH mm] sysfs: add /sys/dev/usb to handle CONFIG_USB_DEVICE_CLASS=y
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Kay Sievers" <kay.sievers@vrfy.org>, linux-usb@vger.kernel.org
In-Reply-To: <20080418032146.GA8754@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1208484663.12570.5.camel@dwillia2-linux.ch.intel.com>
	 <20080418032146.GA8754@kroah.com>
X-Google-Sender-Auth: ba79444a33b1100f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 8:21 PM, Greg KH <greg@kroah.com> wrote:
> On Thu, Apr 17, 2008 at 07:11:03PM -0700, Dan Williams wrote:
>
> > The deprecated config option CONFIG_USB_DEVICE_CLASS causes class devices
>  > with duplicate major:minor numbers to be registered.  In effect they
>  > represent a usb specific address space for major:minor numbers so add 'usb'
>  > as a directory along side 'block' and 'char'.
>
>  Hm, no they do not, they are not a new address space, we are just
>  reusing them as the other user wasn't using them, and the code is
>  deprecated and will be removed eventually.  Neither of these char
>  devices are really hooked up to anything within the kernel, so it
>  doesn't matter yet.
>
>  I wonder how many other duplicates we have floating around...
>

Hm, so how about making this an opt-in capability of the class?  At
device_add() time the class is queried to see if a link should be
created in /sys/dev/block or /sys/dev/char?  Although, this leads to
inconsistent coverage.  But maybe that does not matter as many of
these character devices do not have interesting attributes to be
accessed?  Sigh, I am beginning to wonder if the character device side
of this capability is a solution looking for a problem...

Ideas?

>  thanks,
>
>  greg k-h
>

Thanks,
Dan
