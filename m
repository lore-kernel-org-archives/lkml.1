Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYIMHYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYIMHYf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 03:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbYIMHYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 03:24:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55586 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264AbYIMHYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 03:24:23 -0400
Date: 13 Sep 2008 09:21:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jwilson@redhat.com
Cc: j@jannau.net
Cc: linux-kernel@vger.kernel.org
Cc: lkml@ml.breakpoint.cc
Cc: superm1@ubuntu.com
Message-ID: <AlnE4cF3jFB@christoph>
In-Reply-To: <200809111509.51901.jwilson@redhat.com>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX194uGBYycjRa3dL/UZHHZjsc57YaDJ9ag6R1D9
 mi7pKpwJ8sAgWHyyXOYg9i/HDvqv/O/XFuLv8GStQzucUjOygv
 tf5zejGQveF4Xb6o5ZBbPnjPsXZhwqms8olrVz8h3g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jarod,

on 11 Sep 08 at 15:09, Jarod Wilson wrote:
> On Thursday 11 September 2008 14:30:00 Christoph Bartelmus wrote:
>> on 09 Sep 08 at 13:03, Jarod Wilson wrote:
>>> On Tuesday 09 September 2008 03:40:18 Sebastian Siewior wrote:
>>>>>+EXTRA_CFLAGS =-DIRCTL_DEV_MAJOR=61 -DLIRC_SERIAL_TRANSMITTER -I$(src)
>>>>
>>>> Do you rely on this specific major? Since your daemon opens /dev/lirc0
>>>> you don't need a fixed major do you?
>>>
>>> Good question. Quite honestly, I'm not sure. Christoph?
>>
>> LIRC does not rely on a specific major. But to be honest, the last time I
>> looked into this issue, was when devfs was bleeding-edge...
>>
>> So, we need some advice here how to proceed. Should we try to register an
>> official major number for LIRC? Should we try to have a minor number
>> mapping, e.g.
>> /dev/lirc/serial/0 LIRC device on 1st UART serial port
>> ...
>> /dev/lirc/serial/n LIRC device on n-th UART serial port
>> /dev/lirc/parallel/0 LIRC device on 1st parallel port
>> ...
>> /dev/lirc/parallel/n LIRC device on n-th parallel port
>> /dev/lirc/usb/0 1st LIRC USB device
>> ...

> Janne took a crack at dynamic device allocation earlier today, committed
> into my git tree:

The problem is this:
http://www.lirc.org/html/configure.html#multiple

Quoting the very last paragraph:
"The only situation where the described procedure will not work is when  
you have two devices that both use a kernel driver that can only handle  
one device at once like e.g. lirc_serial, lirc_sir or lirc_parallel. You  
can still make it work with a trick by compiling the affected driver  
multiple times using different names and different major numbers. You will  
find detailed instructions how to achieve this by searching the mailing  
list. Lifting this limitation is one of the todo items for future  
releases."

The limitation that lirc_serial can only handle one device at a time still  
exists and I think we should have a concept how to solve it before the  
drivers are merged into the kernel.

Christoph
