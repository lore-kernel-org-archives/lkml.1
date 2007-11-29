Return-Path: <linux-kernel-owner+w=401wt.eu-S1760975AbXK2Plk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760975AbXK2Plk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 10:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbXK2Plc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 10:41:32 -0500
Received: from rtr.ca ([76.10.145.34]:3593 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632AbXK2Plb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 10:41:31 -0500
Message-ID: <474EDDA9.1040205@rtr.ca>
Date: Thu, 29 Nov 2007 10:41:29 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] base/class.c: prevent ooops due to insert/remove race
References: <474E3964.7040200@rtr.ca> <20071129043307.GA4766@suse.de>
In-Reply-To: <20071129043307.GA4766@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Nov 28, 2007 at 11:00:36PM -0500, Mark Lord wrote:
>> While doing insert/remove (quickly) tests on USB, I managed to trigger
>> an Oops on 2.6.23.1 on the call to strlen() in make_class_name().
>>
>> This patch prevents this oops.
>>
>> There is still the larger problem of the overall race
>> that caused this in the first place, but much of the rest
>> of the code in class.c appears to also do NULL checks to
>> avoid Oops'ing, so this continues the tradition.
>>
>> Signed-off-by:  Mark Lord <mlord@pobox.com>
> 
> As this is a bandage over the real problem, I'd prefer to not apply this
> one right now until we find the root cause.
...

Ahh.. but the problem there, is that you've already said you will
not be looking for any cause.  This patch prevents the Oops,
in the same manner as existing code in that same file.

Would you perhaps prefer a second patch to remove all of the other
existing bandages from that file?  I don't think so.

This patch fixes a *real* ooops that can occur on servers, desktops,
and portables whenever a USB device is connected.

Sounds like something worth fixing.

Cheers
