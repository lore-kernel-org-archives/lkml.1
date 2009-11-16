Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbZKPK5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbZKPK5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 05:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZKPK5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 05:57:03 -0500
Received: from csldevices.com ([77.75.105.137]:44125 "EHLO
	mhall.vps.goscomb.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752566AbZKPK5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 05:57:00 -0500
Message-ID: <4B012FFC.1080600@csldevices.co.uk>
Date: Mon, 16 Nov 2009 10:57:00 +0000
From: Philip Downer <phil@csldevices.co.uk>
User-Agent: Icedove 1.5.0.14eol (X11/20090105)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: firmware loading interface
References: <4AFD971C.3090204@csldevices.co.uk> <4AFD9BAF.1010200@csldevices.co.uk> <200911132029.01432.arnd@arndb.de>
In-Reply-To: <200911132029.01432.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Friday 13 November 2009, Philip Downer wrote:
>   
>> However our device will have flash to store the firmware in and, whilst
>> it looks as though it would be possible for us to use request_firmware
>> to provide occasional firmware upgrades from userspace, I can't find any
>> reference as to whether this is an accepted method for doing so. Could
>> someone please confirm for me whether or not it's a good idea to use
>> request_firmware for this, or perhaps point me at another standard
>> method for doing firmware updates from userspace?
>>     
>
> The idea of request_firmware is that it helps you load the firmware
> into the device at initialization time so you can use it directly,
> without making the firmware blob a part of the kernel driver.
>
> If I understand you correctly, you never need a firmware in user space
> in order to use the device, but only for flashing a new version into
> the nonvolatile memory.
>   

Thats correct.

> The easiest way to do that would be an ioctl operation, if you are
> implementing a character or block device interface anyway. Just load
> the firmware into the RAM of a user application and call an ioctl
> with the pointer to the firmware as an argument, but don't use
> a data structure with a pointer in it, which would mess up 32 bit
> compatibility operation.

Thank you for this suggestion and for the warning about 32bit, we are in 
fact implementing a character device and could use this method.

Thanks,

Philip Downer
