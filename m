Return-Path: <linux-kernel-owner+w=401wt.eu-S932756AbXK2Q2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756AbXK2Q2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932594AbXK2Q2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:28:23 -0500
Received: from mx1.suse.de ([195.135.220.2]:49155 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbXK2Q2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:28:22 -0500
Date: Thu, 29 Nov 2007 08:27:27 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] base/class.c: prevent ooops due to insert/remove race
Message-ID: <20071129162727.GA8352@suse.de>
References: <474E3964.7040200@rtr.ca> <20071129043307.GA4766@suse.de> <474EDDA9.1040205@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474EDDA9.1040205@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 10:41:29AM -0500, Mark Lord wrote:
> Greg KH wrote:
>> On Wed, Nov 28, 2007 at 11:00:36PM -0500, Mark Lord wrote:
>>> While doing insert/remove (quickly) tests on USB, I managed to trigger
>>> an Oops on 2.6.23.1 on the call to strlen() in make_class_name().
>>>
>>> This patch prevents this oops.
>>>
>>> There is still the larger problem of the overall race
>>> that caused this in the first place, but much of the rest
>>> of the code in class.c appears to also do NULL checks to
>>> avoid Oops'ing, so this continues the tradition.
>>>
>>> Signed-off-by:  Mark Lord <mlord@pobox.com>
>> As this is a bandage over the real problem, I'd prefer to not apply this
>> one right now until we find the root cause.
> ...
>
> Ahh.. but the problem there, is that you've already said you will
> not be looking for any cause.

I will not be looking for any cause _while_ you can only reproduce this
with a closed source kernel module loaded.

> This patch prevents the Oops,
> in the same manner as existing code in that same file.
>
> Would you perhaps prefer a second patch to remove all of the other
> existing bandages from that file?  I don't think so.
>
> This patch fixes a *real* ooops that can occur on servers, desktops,
> and portables whenever a USB device is connected.

You have seen this oops on all of these types of machines?  So far you
are the only one reporting it, and only on one machine, right?

Again, please reproduce this on a non-tainted machine and send the oops
to the linux-usb mailing list so that the developers there can help you
out.

thanks,

greg k-h
