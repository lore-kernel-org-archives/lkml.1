Return-Path: <linux-kernel-owner+w=401wt.eu-S1763171AbXK2Udh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763171AbXK2Udh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760953AbXK2Ud2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:33:28 -0500
Received: from mail.suse.de ([195.135.220.2]:55841 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760951AbXK2Ud2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:33:28 -0500
Date: Thu, 29 Nov 2007 12:32:25 -0800
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
	insert/remove race (v3)
Message-ID: <20071129203225.GA5383@suse.de>
References: <Pine.LNX.4.44L0.0711291417530.5666-100000@iolanthe.rowland.org> <474F1AAC.7040908@rtr.ca> <20071129201224.GA25356@suse.de> <474F1DB3.4030900@rtr.ca> <474F2020.7020004@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474F2020.7020004@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 03:25:04PM -0500, Mark Lord wrote:
> (resending .. somebody trimmed the CC: list earlier)
>
> Greg KH wrote:
>>>>> Mark Lord wrote:
>>>>>> ..
>>>>>>
>>>>>> While doing insert/remove (quickly) tests on USB,
>>>>>> I managed to trigger an Oops on 2.6.23.8 on a call
>>>>>> to strlen() in make_class_name().
> ...
>
>> I'll hold off on adding this patch for now.
> ..
>
> Why?
>
> Bugs that result in Oops in core code (class.c) can bite
> just about any subsystem that does hotplug, and should get
> prompt attention.  Or so one might think.

And they have, the 2.6.24 kernel should have the correct fix for this
problem, right?  The fact that you oopsed out in this function enabled
people to find and fix the problem already.  Adding a BUG_ON() does the
same exact thing :)

So again, the problem is in the higher up scsi layer, and that is where
the problem should already be fixed.  Don't add code to lower layers to
paper over bugs elsewhere.

thanks,

greg k-h
