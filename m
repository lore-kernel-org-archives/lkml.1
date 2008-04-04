Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbYDDUTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbYDDUTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbYDDUSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:18:53 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:62051 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbYDDUSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:18:52 -0400
Date: Fri, 4 Apr 2008 13:18:14 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Jean Delvare <khali@linux-fr.org>
cc: David Brownell <david-b@pacbell.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
In-Reply-To: <20080404213632.300eb3de@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0804041302200.20532@t2.domain.actdsltmp>
References: <200710291809.29936.david-b@pacbell.net> <200711301040.54777.david-b@pacbell.net>
 <20071130211332.49a21a6b@hyperion.delvare> <200711301259.22666.david-b@pacbell.net>
 <Pine.LNX.4.64.0804031844500.11928@t2.domain.actdsltmp>
 <20080404100933.077bee33@hyperion.delvare> <Pine.LNX.4.64.0804041102230.20532@t2.domain.actdsltmp>
 <20080404213632.300eb3de@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Jean Delvare wrote:
> On Fri, 4 Apr 2008 12:07:12 -0700 (PDT), Trent Piepho wrote:
>> On Fri, 4 Apr 2008, Jean Delvare wrote:
>>> On Thu, 3 Apr 2008 19:06:27 -0700 (PDT), Trent Piepho wrote:
>>>> +	strcpy(buf, test_bit(FLAG_IS_OUT, &gdesc->flags) ? "out\n" : "in\n\0");
>>>> +
>>>> +	return 5;
>>>
>>> Confusing construct... I suggest using sprintf instead, which will
>>> automatically return the correct number of bytes for you.
>>
>> But it's less efficient!  Will nobody think of the wasted cycles?
>
> Can you prove that it is actually less efficient, and if so, by how
> much? The time spent in this single function if probably insignificant

I think sprintf will parse the format string, and then end up calling the same
strcpy() call to handle a %s.  Since sprintf() contains the strcpy(), it has
to be slower than strcpy alone.

But I should have put a :) in there, as I changed this code.

> thread, you aren't support to include trailing \0s in the buffer you
> pass back to sysfs. Not all programming languages use \0 for string
> termination.

I fixed all those.  I wasn't clear on that when I wrote this code and forgot I
had done it incorrectly.

>>>> +	/* FIXME:  Code to remove all the sysfs devices and files created
>>>> +	 * should go here */
>>>
>>> Oh yes it really should ;)
>>
>> I know, but I'm not using modules for the system this is in, so it will never
>> get called.  What's the point of writing code I'll never use if this isn't
>> useful for the kernel?
>
> Because most certainly your code won't be accepted upstream until this
> is fixed, and presumably you posted this patch in the hope that it
> would go upstream ;) Just because it isn't useful to you doesn't mean
> it won't be useful to others. Otherwise this particular piece of code
> couldn't be built as a module at all.

I guess I was waiting for a "this could go upstream if you fix this" or "this
won't go upstream even if you fix it" so I don't waste time writing code no
one is interested in.
