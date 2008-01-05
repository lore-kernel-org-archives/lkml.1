Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYAEXXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYAEXXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 18:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYAEXXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 18:23:30 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:57749 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbYAEXX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 18:23:29 -0500
Message-ID: <47801126.7020807@oracle.com>
Date: Sat, 05 Jan 2008 15:22:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Adrian Bunk <bunk@kernel.org>, Al Boldi <a1426z@gawab.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] USB Kconfig: Select SCSI for USB Mass Storage support
References: <200801051546.SAA08947@raad.intranet> <20080105113024.209485f5.randy.dunlap@oracle.com> <20080105210330.GC22232@does.not.exist> <20080105210940.GA10302@uranus.ravnborg.org>
In-Reply-To: <20080105210940.GA10302@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Sat, Jan 05, 2008 at 11:03:30PM +0200, Adrian Bunk wrote:
>> On Sat, Jan 05, 2008 at 11:30:24AM -0800, Randy Dunlap wrote:
>>> On Sat, 5 Jan 2008 18:41:39 +0300 Al Boldi wrote:
>>>
>>>> Select SCSI for USB Mass Storage support.
>>>>
>>>>
>>>> Cc: David Brownell <david-b@pacbell.net>
>>>> Cc: Greg KH <greg@kroah.com>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Signed-off-by: Al Boldi <a1426z@gawab.com>
>>>>
>>>> ---
>>>>
>>>> --- 23.a/drivers/usb/storage/Kconfig
>>>> +++ 23.b/drivers/usb/storage/Kconfig
>>>> @@ -2,14 +2,10 @@
>>>>  # USB Storage driver configuration
>>>>  #
>>>>  
>>>> -comment "NOTE: USB_STORAGE needs SCSI, and 'SCSI disk support' may"
>>>> -	depends on USB
>>>> -comment "also be needed; see USB_STORAGE Help for more information"
>>>> -	depends on USB
>>>> -
>>>>  menuconfig USB_STORAGE
>>>>  	tristate "USB Mass Storage support"
>>>> -	depends on USB && SCSI
>>>> +	depends on USB
>>>> +	select SCSI
>>> We try not to use 'select' on subsystems and try to limit its use
>>> to library-like code that is relatively small.  Selecting SCSI
>>> breaks both of those efforts.
>>> ...
>> _You_ are trying to do this.

I'd say that sometimes Andrew helps also.

>> For kconfig users, "select" is _much_ better than sending them through 
>> different menus.
> Only if used within the current limitations of Kconfig.
> And that requires you to use select only to select symbols with
> no dependencies.

Right.  One of the main (or maybe even the only) problem(s) is
that select does not follow dependency chains.
and that no one works on that problem.

> In this case we do not know if BLOCK is enabled or not.

For Aunt Tillie cases, "select" makes sense.  For other cases,
I'd argue that it makes sense for config users to know when they
do something that causes an entire subsystem to be added to their
kernel (like SCSI or NET).

-- 
~Randy
desserts:  http://www.xenotime.net/linux/recipes/
