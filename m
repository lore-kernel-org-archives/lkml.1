Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbZFJNiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbZFJNiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbZFJNiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:38:01 -0400
Received: from customer-relay.songnetworks.se ([195.42.210.9]:40978 "EHLO
	customer-relay.songnetworks.se" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518AbZFJNiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:38:01 -0400
Message-ID: <4A2FB734.4020202@mocean-labs.com>
Date: Wed, 10 Jun 2009 15:37:56 +0200
From: =?ISO-8859-15?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH 2/9] SPI: xilinx_spi: Added platform driver and support
 for DS570
References: <4A292043.70704@mocean-labs.com>	<20090609160954.ae0bda8e.akpm@linux-foundation.org>	<4A2F737A.2000407@mocean-labs.com> <20090610015710.3afb1a92.akpm@linux-foundation.org>
In-Reply-To: <20090610015710.3afb1a92.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-06-10 10.57, Andrew Morton wrote:
> On Wed, 10 Jun 2009 10:48:58 +0200 Richard R__jfors <richard.rojfors.ext@mocean-labs.com> wrote:
> 
>> On 09-06-10 01.09, Andrew Morton wrote:
>>> On Fri, 05 Jun 2009 15:40:19 +0200
>>> Richard R__jfors <richard.rojfors.ext@mocean-labs.com> wrote:
>>>
>>>> This patch splits xilinx_spi into three parts, an OF and a platform
>>>> driver and generic part.
>>>>
>>>> The generic part now also works on X86 and also supports the Xilinx
>>>> SPI IP DS570
>>> Unfortunately we already have two fairly significant
>>> drivers/spi/xilinx_spi.c patches queued in -mm:
>>> spi-move-more-spi_setup-functionality-into-core.patch and
>>> spi-move-common-spi_setup-functionality-into-core.patch.  Applying this
>>> patch on top of those makes rather a mess.
>>>
>>> Hopefully things will still be OK if I skip this patch.  You didn't
>>> identify the dependencies between those nine patchs.  Can you please
>>> explain that?
>> Actually all patches except for the 7th(of 9), would work without the
>> xilinx_spi-patch.
>> The 7th (Timberdale MFD) would not build. Some of the othe drivers are not
>> possible to select because they depend on the MFD in their Kconfigs,
>> but not the code.
> 
> Confused.

Sorry, will try to explain below.

> See, my problem is that normally I will hold off on sending a patch to
> its subsystem maintainer until its prerequisite patch(es) are in mainline.

That was what I started doing, the MFD-driver requires plaform-data structs
from some of the drivers.

On the other hand some of the drivers depends on the MFD conf-option, which
you found in the GPIO-driver :-)

> But for each of these patches, I don't know what the exact prerequisites
> are.  Help?

Patch dependencies
1/9 -> (mc33880) no dependencies on my patches
2/9 -> (xilinx_spi) no dependencies on my patches
3/9 -> (i2c-ocores) no dependencies on my patches
4/9 -> (timb-dma) Kconfig depends on config set by timberdale (patch 7/9)
5/9 -> (logiwin) code depends on timb-dma (patch 4/9)
6/9 -> (v4l2 Kconfig) Kconfig depends on config set by timb-dma (patch(4/9)
7/9 -> (timberdale) code depends on mc3380 (patch 1/9), xilinx_spi (patch 2/9)
	i2c-ocores (patch 3/9), logiwin (patch 5/9)
8/9 -> (timbserial) Kconfig depends on config set by timberdale (patch 7/9)
	Btw Alan Cox said i has queued it for the ttydev stack, and it is
	further patched.
9/9 -> (timbgpio) Kconfig depends on config set by timberdale (patch 7/9)

So my suggestion is;
Apply all but patch 2 and 7. They will apply, some have Kconfig dependencies
to patch 7.

>> I would be very happy if you applied all but the 7th (MFD) and 2nd (SPI) anyway.
>>
>> I will update my SPI-patch to work against the two patches you point out above.
>> And them I will resend the Timberdale MFD and the Xilinx SPI patch.
>>
>> Would that be OK?
> 
> That would be great, thanks.

I will come up with a patch as soon as possible.

Thanks
--Richard
