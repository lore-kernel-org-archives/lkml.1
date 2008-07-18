Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYGRIxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYGRIxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753398AbYGRIxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:53:45 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:11485 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbYGRIxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jk+EApBQcHXbyy/ZLmq1YOJo4DpkeavLRyW5ly+1boEZCbvZXpRK3UD5n3z8Y8xlzZ
         f1fUvExF3sPT3Z4y2gkWBA3fZ9hNAOpzeel8JYzyHcGkKPCE4aXJCjLd61ScrVvyFSHf
         Ta7ndlYDelNUAP0bz9ufKM3g4czHUjrpKgAWE=
Message-ID: <aec7e5c30807180153s4aac361fwdbc5064e575acf02@mail.gmail.com>
Date: Fri, 18 Jul 2008 17:53:43 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Ben Dooks" <ben-linux@fluff.org>
Subject: Re: [i2c] [PATCH 03/05] resource: add new IORESOURCE_CLK type V2
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, gregkh@suse.de,
       lethal@linux-sh.org, i2c@lm-sensors.org, akpm@linux-foundation.org
In-Reply-To: <20080718075302.GP30539@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se>
	 <20080718074027.32713.15674.sendpatchset@rx1.opensource.se>
	 <20080718075302.GP30539@fluff.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 4:53 PM, Ben Dooks <ben-linux@fluff.org> wrote:
> On Fri, Jul 18, 2008 at 04:40:27PM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@igel.co.jp>
>>
>> So far struct resource has been used with the types IORESOURCE_MEM,
>> IORESOURCE_IO and IORESOUCE_IRQ to pass I/O and interrupt parameters
>> to platform drivers. This patch extends this with IORESOURCE_CLK which
>> should be used to pass a clock string to the platform driver. This
>> string points out which specific clock that should be used with clk_get()
>> for a certain driver instance.
>>
>> Using a hard coded strings in the device driver won't do since we may
>> have multiple instances of drivers that need to use different clocks.
>
> It works already. The S3C24XX has n-number of H and P clocks fed to
> each driver, differentiated by the device being supplied. This is
> why clk_get() has two arguments, a device pointer and a name.

Oh, I see. Both the platform device id and the string seems to be used
in the comparison.

> This might be useful to allow optional clocks to be passed, but I'm
> not sure if it is necessary.

No, you are right. It is possible to use platform device id to
differentiate between devices. I'm not sure if it maps well to our
SuperH Mobile clock stop bits though...

Thanks for your comments!

/ magnus
