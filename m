Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbXK2UCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbXK2UCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932619AbXK2UBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:01:51 -0500
Received: from rtr.ca ([76.10.145.34]:2895 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522AbXK2UBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:01:50 -0500
Message-ID: <474F1AAC.7040908@rtr.ca>
Date: Thu, 29 Nov 2007 15:01:48 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
 insert/remove race (v3)
References: <Pine.LNX.4.44L0.0711291417530.5666-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711291417530.5666-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 29 Nov 2007, Mark Lord wrote:
> 
>> Mark Lord wrote:
>>> ..
>>>
>>> While doing insert/remove (quickly) tests on USB,
>>> I managed to trigger an Oops on 2.6.23.8 on a call
>>> to strlen() in make_class_name().
> 
> Does this oops occur under 2.6.24?  The SCSI async scanning code was
> changed between 2.6.23 and 2.6.24, in a way intended to prevent exactly 
> this sort of thing.
> 
>> And below is a "prevented Oops", courtesy of the patch.
>> The next bug to fix is whereever the code resides that
>> repeatedly continues to flog the unplugged device
>> after the test, despite SCSI returning host_byte=DID_NO_CONNECT.
> 
> It has probably already been fixed.
> 
> Besides, it's not the flogging an unplugged device that causes the 
> oops.  It's trying to unregister a device that was never registered in 
> the first place.
..

Well, duh, I kinda knew that already, thanks.  ;)

But the flogging continues multiple times per second
until the system is shutdown, so it is "the next bug to fix".

Unless the 2.6.24 code already has that one taken care of.
This machine doesn't run 2.6.24 (yet) due to other incompatibilities.

Cheers
