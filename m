Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbYJITTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbYJITTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 15:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYJITTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 15:19:32 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:24524 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbYJITTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 15:19:31 -0400
Message-ID: <ac3eb2510810091209rd76c8a4j83a6a48d5db5d4f9@mail.gmail.com>
Date: Thu, 9 Oct 2008 21:09:26 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Arkadiusz Miskiewicz" <a.miskiewicz@gmail.com>
Subject: Re: loading ipmi_watchdog causes tons of other watchdog modules to be loaded
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200810092102.16110.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810091348.19828.a.miskiewicz@gmail.com>
	 <200810091922.24108.a.miskiewicz@gmail.com>
	 <ac3eb2510810091158x3b677959j480c554b86c1ee26@mail.gmail.com>
	 <200810092102.16110.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2008 at 9:02 PM, Arkadiusz Miskiewicz
<a.miskiewicz@gmail.com> wrote:
> On Thursday 09 October 2008, Kay Sievers wrote:
>> On Thu, Oct 9, 2008 at 7:22 PM, Arkadiusz Miskiewicz
>>
>
>> > ... but that ipmi_watchdog is the correct driver that handles
>> > /dev/watchdog, so this shouldn't be happening, correct?
>>
>> While the driver you expect to work is loaded, what does:
>>   ls -l /dev/watchdog
>> print?
>>
>> If the devno of this node is 10:130, what does:
>>   find /sys/class /sys/devices/ -name dev | xargs grep 10:130
>> print?
>
> # ls -l /dev/watchdog
> crw------- 1 root root 10, 130 sie  8 17:00 /dev/watchdog
> # find /sys/class /sys/devices/ -name dev | xargs grep 10:130
> /sys/class/misc/watchdog/dev:10:130

Ok, so you actually have a driver bound to that device number, and it
should not trigger the usual module autoloading mechanism.

What does:
  ls -l /sys/class/misc/watchdog/
and
  ls -l /sys/class/misc/watchdog/device/
print?

Does the /sys/class/misc/watchdog/ directory exist, before you load
the module you expect to be the driver behind /dev/watchdog?

To clarify, the other modules get loaded, after you loaded but module,
the above /sys/class/misc/watchdog/ directory exists, and only if you
read from the device, all the other modules get loaded?

Kay
