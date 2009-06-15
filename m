Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbZFOGwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbZFOGwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 02:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbZFOGv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 02:51:57 -0400
Received: from smtp-out.google.com ([216.239.45.13]:8250 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbZFOGv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 02:51:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=awTtgmmXc4RD5OcCdPUuaJSQtopOC7J0xpIs1i1P9VIYWug/Qe665uU1IepC3+HyM
	3qOYYRetpDgKxOuChjblw==
MIME-Version: 1.0
In-Reply-To: <20090615064234.GA1221@excalibur.local>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
	 <1245033557-10968-2-git-send-email-swetland@google.com>
	 <1245033557-10968-3-git-send-email-swetland@google.com>
	 <1245033557-10968-4-git-send-email-swetland@google.com>
	 <20090615064234.GA1221@excalibur.local>
Date: Sun, 14 Jun 2009 23:51:53 -0700
Message-ID: <a55d774e0906142351o67b2388dnf26be72815fc3edf@mail.gmail.com>
Subject: Re: [PATCH 3/3] [ARM] msm: add minimal board file for HTC Dream 
	device
From: Brian Swetland <swetland@google.com>
To: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       pavel@ucw.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 11:42 PM, Stefan
Schmidt<stefan@datenfreihafen.org> wrote:
>> +
>> +#include <linux/mtd/nand.h>
>> +#include <linux/mtd/partitions.h>
>
> I see nothing in this file that needs mtd header files. Leftover from the "big"
> machine file? Please aslo check if the other header files are needed.
>
>> +#include "devices.h"
>> +#include "board-dream.h"
>> +
>> +static struct resource smc91x_resources[] = {
>> +     [0] = {
>> +             .start  = 0x9C004300,
>> +             .end    = 0x9C004400,
>> +             .flags  = IORESOURCE_MEM,
>> +     },
>> +     [1] = {
>> +             .start  = MSM_GPIO_TO_INT(49),
>> +             .end    = MSM_GPIO_TO_INT(49),
>> +             .flags  = IORESOURCE_IRQ,
>> +     },
>> +};
>> +
>> +static struct platform_device smc91x_device = {
>> +     .name           = "smc91x",
>> +     .id             = 0,
>> +     .num_resources  = ARRAY_SIZE(smc91x_resources),
>> +     .resource       = smc91x_resources,
>> +};
>
> I'm a bit confused here. The dream is the T-Mobile G1 and the Android dev phone,
> right? Is there really a network chip connected inside the device? Or is this a
> leftover from the developer board?

Oops.  Yeah that's definitely not present on G1.  I did a quick trim
from the halibut (qualcomm dev board) board file to get to a sane
starting point, but obviously didn't trim enough.

Reconstructing the board files a little at a time as peripherals are
added in various patch sets is going to be tedious, but probably a
good opportunity to clean them up a bit.

Thanks,

Brian
