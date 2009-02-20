Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbZBTO4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbZBTO4Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 09:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbZBTO4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 09:56:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:54594 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbZBTO4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 09:56:08 -0500
MIME-Version: 1.0
In-Reply-To: <20090220142705.GA429@silver.sucs.org>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
	 <20090220094356.GB26124@silver.sucs.org>
	 <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com>
	 <20090220131209.GA21446@silver.sucs.org>
	 <ac3eb2510902200523o619e64aas7bffac9aeca86814@mail.gmail.com>
	 <20090220142705.GA429@silver.sucs.org>
Date: Fri, 20 Feb 2009 15:56:06 +0100
Message-ID: <ac3eb2510902200656l11275aber128848182553726d@mail.gmail.com>
Subject: Re: General question (scheduler) with SSDs?
From: Kay Sievers <kay.sievers@vrfy.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 15:27, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Fri, Feb 20, 2009 at 02:23:38PM +0100, Kay Sievers wrote:
>> On Fri, Feb 20, 2009 at 14:12, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
>> >
>> > I tried
>> > SUBSYSTEM=="block", ATTRS{model}=="ASUS-PHISON *", ATTR{queue/rotational}="0"
>> > but udevtest /sys/block/sda/ doesn't list it as firing (udev 117-8)...
>>
>> I does here:
>>   udev_rules_apply_to_event: ATTR '/sys/devices/ ...
>> /sdb/queue/rotational' writing '0'
>>
>>   $grep . /sys/class/block/*/queue/rotational
>>   /sys/class/block/sda/queue/rotational:1
>>   /sys/class/block/sdb/queue/rotational:0
>>
>> Maybe "udevtest" is not showing it for you, or udev 117 is too old and
>> does not work that way.
>
> After you mentioned this I tried again and seemingly I was mistaken - it
> does work as you described.

Great.

> I had to make a slight rule tweak to stop
> it matching on partitions though:
>
> SUBSYSTEM=="block", KERNEL=="[sh]d[a-z]", ATTRS{model}=="ASUS-PHISON *", ATTR{queue/rotational}="0"

Newer kernels have DEVTYPE in the envent environment, and:
  ENV{DEVTYPE}=="disk"
can be used, which is easier and more reliable.

Also the whitespace after "...PHISON *" does not need to be matched.
If the match value does not end in whitespace itself, udev will match
against the value with all trailing whitespace ignored.

Kay
