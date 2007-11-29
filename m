Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbXK2UKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbXK2UKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932126AbXK2UJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:09:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121AbXK2UJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:09:58 -0500
Date: Thu, 29 Nov 2007 12:12:24 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
	insert/remove race (v3)
Message-ID: <20071129201224.GA25356@suse.de>
References: <Pine.LNX.4.44L0.0711291417530.5666-100000@iolanthe.rowland.org> <474F1AAC.7040908@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474F1AAC.7040908@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 03:01:48PM -0500, Mark Lord wrote:
> Alan Stern wrote:
>> On Thu, 29 Nov 2007, Mark Lord wrote:
>>> Mark Lord wrote:
>>>> ..
>>>>
>>>> While doing insert/remove (quickly) tests on USB,
>>>> I managed to trigger an Oops on 2.6.23.8 on a call
>>>> to strlen() in make_class_name().
>> Does this oops occur under 2.6.24?  The SCSI async scanning code was
>> changed between 2.6.23 and 2.6.24, in a way intended to prevent exactly 
>> this sort of thing.
>>> And below is a "prevented Oops", courtesy of the patch.
>>> The next bug to fix is whereever the code resides that
>>> repeatedly continues to flog the unplugged device
>>> after the test, despite SCSI returning host_byte=DID_NO_CONNECT.
>> It has probably already been fixed.
>> Besides, it's not the flogging an unplugged device that causes the oops.  
>> It's trying to unregister a device that was never registered in the first 
>> place.
> ..
>
> Well, duh, I kinda knew that already, thanks.  ;)
>
> But the flogging continues multiple times per second
> until the system is shutdown, so it is "the next bug to fix".
>
> Unless the 2.6.24 code already has that one taken care of.
> This machine doesn't run 2.6.24 (yet) due to other incompatibilities.

Incompatibilities in the 2.4.24-rc tree?  Have they been reported so
that they can be fixed?

I'll hold off on adding this patch for now.

thanks,

greg k-h
