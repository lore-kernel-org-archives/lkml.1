Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbXK2Uqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbXK2Uqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762093AbXK2Uqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:46:45 -0500
Received: from rtr.ca ([76.10.145.34]:4841 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760136AbXK2Uqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:46:45 -0500
Message-ID: <474F2532.5090708@rtr.ca>
Date: Thu, 29 Nov 2007 15:46:42 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
 insert/remove race (v3)
References: <Pine.LNX.4.44L0.0711291417530.5666-100000@iolanthe.rowland.org> <474F1AAC.7040908@rtr.ca> <20071129201224.GA25356@suse.de> <474F1DB3.4030900@rtr.ca> <474F2020.7020004@rtr.ca> <20071129203225.GA5383@suse.de>
In-Reply-To: <20071129203225.GA5383@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Nov 29, 2007 at 03:25:04PM -0500, Mark Lord wrote:
>> (resending .. somebody trimmed the CC: list earlier)
>>
>> Greg KH wrote:
>>>>>> Mark Lord wrote:
>>>>>>> ..
>>>>>>>
>>>>>>> While doing insert/remove (quickly) tests on USB,
>>>>>>> I managed to trigger an Oops on 2.6.23.8 on a call
>>>>>>> to strlen() in make_class_name().
>> ...
>>
>>> I'll hold off on adding this patch for now.
>> ..
>>
>> Why?
>>
>> Bugs that result in Oops in core code (class.c) can bite
>> just about any subsystem that does hotplug, and should get
>> prompt attention.  Or so one might think.
> 
> And they have, the 2.6.24 kernel should have the correct fix for this
> problem, right?  The fact that you oopsed out in this function enabled
> people to find and fix the problem already.  Adding a BUG_ON() does the
> same exact thing :)
..

Well, actually BUG_ON() allows the system to continue running
while still not masking the issue.  But close enough.


> So again, the problem is in the higher up scsi layer, and that is where
> the problem should already be fixed.
..

Ahhh.. so you figure the Oops should also have been fixed
as part of the 2.6.24 SCSI fixes ?  That's what I was missing here.

Thanks.
