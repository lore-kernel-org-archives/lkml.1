Return-Path: <linux-kernel-owner+w=401wt.eu-S1761480AbZCaQFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761480AbZCaQFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbZCaQFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:05:08 -0400
Received: from relay02.pair.com ([209.68.5.16]:4783 "HELO relay02.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751162AbZCaQFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:05:07 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2009 12:05:06 EDT
X-pair-Authenticated: 66.134.71.115
User-Agent: Microsoft-Entourage/12.15.0.081119
Date: Tue, 31 Mar 2009 08:58:03 -0700
Subject: Re: [RFC] Add Alternative Log Buffer Support for printk Messages
From: Grant Erickson <gerickson@nuovations.com>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Timo Juhani Lindfors <timo.lindfors@iki.fi>, Wolfgang Denk <wd@denx.de>,
       <linux-kernel@vger.kernel.org>
Message-ID: <C5F78B9B.15826%gerickson@nuovations.com>
Thread-Topic: [RFC] Add Alternative Log Buffer Support for printk Messages
Thread-Index: AcmyGXj0MrrJ4ol2OUS/c9KAjDWlaA==
In-Reply-To: <49D17E5D.30306@gmx.net>
Organization: Nuovation System Designs, LLC
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/09 7:22 PM, Carl-Daniel Hailfinger wrote:
> On 21.01.2009 18:39, Grant Erickson wrote:
>> This merges support for the previously DENX-only kernel feature of
>> specifying an alternative, "external" buffer for kernel printk
>> messages and their associated metadata. In addition, this ports
>> architecture support for this feature from arch/ppc to arch/powerpc.
>> 
>> When this option is enabled, an architecture- or machine-specific log
>> buffer is used for all printk messages. This allows entities such as
>> boot loaders (e.g. U-Boot) to place printk-compatible messages into
>> this buffer and for the kernel to coalesce them with its normal
>> messages.
>>   
> 
> What is your current status for this patch? I'd like to make sure the
> implementation will not be incompatible with the coreboot log buffer.

Carl-Daniel:

Unfortunately, the project with which the patch was associated has since
wrapped up and I have not had the cycles in the intervening period to
follow-up "mainlining" the patch.

Philosophically, my perspective, based on the ensuing RFC dialog, is that my
preferred tack would be something akin to a log buffer driver model. For
99.99% of the cases, the standard would be the generic log buffer driver we
all know and use today.

However, under the driver model, also available would be the u-boot
read/write log buffer driver, the read-only
slurp-up-the-firmware-log-and-append driver proposed by Andrew, whatever
David proposes for Sparc, perhaps something slightly different for Coreboot,
etc. Some of these may/may not support ALL the options the generic driver
supports (e.g. resizing through a kernel parameter).

Compatibility on the back end among all these is a laudable goal; however,
given the varying requirements of the embedded space in which these variant
drivers are inevitably targeted, it seems unreasonable to expect they'll all
converge into a "one true log buffer driver".

So long as the front-end driver API is compatible with the current generic
driver, printk, klogd, etc., the kernel configurator is free to select the
driver that makes the most sense for his/her board/application/etc.

So, that's as far as I got with the philosophy. My next step would have been
creating drivers/log, moving the generic driver pieces there from
kernel/printk, establishing a u-boot driver as a representative variant,
roll in Andrew's feedback, etc.

Regards,

Grant


