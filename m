Return-Path: <linux-kernel-owner+w=401wt.eu-S1031658AbXEAKLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031658AbXEAKLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031659AbXEAKLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:11:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:16781 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031662AbXEAKLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=hrzE9jfVjkC5nzqLMwpBuMJsUDFbegXcAQZtPRW9wzsVETuNj5irqp8Lp4Dfpn1qjiQ++ey+E39+S2MA/+XQa9chUcyR0S6R1Tmrrui2DvqhIXPOC8IyrbpcEYMR/lEj1FbtWZnVUqEhpn4nhc63ktv9wL93pRc/N09E4k4Q5w0=
Date: Tue, 1 May 2007 13:11:08 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <609081207.20070501131108@gmail.com>
To: Ben Dooks <ben-linux-arm@fluff.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       <kernel-discuss@handhelds.org>
Subject: Re: [RFC, PATCH 0/4] SoC base drivers
In-Reply-To: <20070501083900.GL5875@trinity.fluff.org>
References: <1354376306.20070501080806@gmail.com> <20070501083900.GL5875@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ben,

Tuesday, May 1, 2007, 11:39:00 AM, you wrote:

> On Tue, May 01, 2007 at 08:08:06AM +0300, Paul Sokolovsky wrote:

[]

>> Initial implementation from few years ago registered per-SoC bus
>> for the purpose of attaching subdevices, but during LKML reviews it
>> was pointed out that there're no good reasons for that, as such bus
>> does not have any special functionality attached, so now platform_bus
>> is used instead, for good.
>> 
>> For the most part, subdevices are allocated dynamically, and SoC
>> base driver calculates/fixes up resources and parameters for them,
>> to be suitable for specific configuration (for example, different
>> base address of SoC).
>> 
>> What exact functionality and API a SoC base driver provides depends
>> largely on specific chip, there's no specific API a SoC driver should
>> implement. Here is a list of common tasks the driver usually would do:
>> 
>> 1. Access handling to the chip (serialization, locking, etc.)
>> 2. Managing common chip resources:
>> 2.1. Interrupts control, demultiplexing, etc. (using Generic IRQ subsystem)
>> 2.2. GPIO handling (adhoc, while eagerly waiting for an extensible GPIO API, 
>> we posted our implementation at http://lkml.org/lkml/2007/4/10/299 ).
>> 2.3. Clocks (Using Platform Clock API)
>> 2.4. Other kinds of "enable" and "power" switches (in adhoc manner or 
>> (ab)using the Clocks API, and waiting for generalization of it).
>> 3. Calculating properties and registerting subdevices.

> Wow, platform devices with a new name. I don't see how any of this is
> not handled by platfrom device.

> GPIO devices could be handled by a new resource type of GPIO
> 
> The only other item in the list which we do not yet have is a
> form of the clock API which can be extended past the base CPU
> clock implementation.
> 
> Anything registering new IRQs could create sub platform devices
> with the correct resources. 

        Where did you see a new name? I specially mentioned that era of
new names are gone. We talk about device drivers and platform devices,
plain and straight. It's just a driver which does convenience
operations for a group of platform_devices, and sure, all these
convenience operations are well familiar to anyone in topic.

        How such drivers (SoC base ones) are still useful is also
pretty obvious: first of all, they are there, like mentioned sa1111.c
and locomo.c. This RFC just calls for recognition of them as a special
class of drivers, instead of keeping them hoard arch dirs.

        As for registering subdevices by SoC driver, it should be also
clear why that's useful: as was mentioned, we have 12 devices using
ASIC3 now. Instead of polluting machine definitions with duplicate
subdevices declarations, we declare a SoC chip devices in them, and
let chip driver declare subdevices, handling other boring tasks, as
resource munging, at the same time (like that bus_shift thing - some
ASIC3 devices has 2 byte register spacing, some 4 (essentially
attached to off-by-one address lines)).


[]


-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

