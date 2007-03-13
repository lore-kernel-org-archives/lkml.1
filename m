Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbXCMBz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbXCMBz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 21:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbXCMBz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 21:55:26 -0400
Received: from rtr.ca ([64.26.128.89]:3149 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbXCMBzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 21:55:17 -0400
Message-ID: <45F60482.6010501@rtr.ca>
Date: Mon, 12 Mar 2007 21:55:14 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Jim Radford <radford@blackbean.org>
Cc: Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net,
       Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb-serial regression fix
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <45F57F63.7010308@rtr.ca> <45F584D9.4090802@rtr.ca> <200703121948.21453.oneukum@suse.de> <45F5B67E.7000105@rtr.ca> <20070312203331.GA6769@kroah.com> <20070312224235.GB3709@blackbean.org> <20070312225922.GA4064@blackbean.org> <20070313001819.GA6147@kroah.com> <20070313004142.GA4835@blackbean.org>
In-Reply-To: <20070313004142.GA4835@blackbean.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Radford wrote:
> On Mon, Mar 12, 2007 at 05:18:19PM -0700, Greg KH wrote:
>> On Mon, Mar 12, 2007 at 03:59:22PM -0700, Jim Radford wrote:
>>> On Mon, Mar 12, 2007 at 03:42:35PM -0700, Jim Radford wrote:
>>>> On Mon, Mar 12, 2007 at 01:33:31PM -0700, Greg KH wrote:
>>>>> On Mon, Mar 12, 2007 at 04:22:22PM -0400, Mark Lord wrote:
>>>>>> Oliver Neukum wrote:
>>>>>>>> Mark Lord wrote:
>>>>>>>>> Okay, from that part (above), the problem is obvious:
>>>>>>>>> in that the "MCT U232 converter now disconnected"
>>>>>>>>> appears, and then we continue to try and call the
>>>>>>>>> driver's method.. Oops!
> 
>>>>>>> IMHO shutdown() is using serial->port[] and bombs.
>>>>>>> Could you reverse the order here?
> 
>>> Do not NULL serial->port[i] since it is used in ->shutdown().
>>> This wasn't an issue until the order or ->shutdown() and
>>> device_unregister was corrected.
> 
>>>         for (i = 0; i < serial->num_ports; ++i)
>>>                 if (serial->port[i]->dev.parent != NULL) {
>>>                         device_unregister(&serial->port[i]->dev);
>>> -                       serial->port[i] = NULL;
>>>                 }
> 
>> But shouldn't you null it out somewhere?  It will be an "empty"
>> pointer at some point in time...
> 
> Not as far as I can see. The serial structure that ->port[i] is in
> gets kfree()ed soon after, in the same function, and nothing in
> between, other than ->shutdown(), uses ->port[].  I assume it was
> someone being overly cautious.

So where does the memory get freed -- the structure pointed at
by the serial->port[i] thingie ?  It's not a leak, is it?

???
