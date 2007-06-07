Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbXFGOEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbXFGOEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXFGOEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:04:36 -0400
Received: from kirby.webscope.com ([204.141.84.54]:55894 "EHLO
	kirby.webscope.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbXFGOEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:04:36 -0400
Message-ID: <46681040.2010003@linuxtv.org>
Date: Thu, 07 Jun 2007 10:03:44 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, v4l-dvb-maintainer@linuxtv.org,
       linux-dvb@linuxtv.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] drivers/media/dvb/b2c2/flexcop-dma.c uses
 PCI DMA API
References: <Pine.LNX.4.64.0706062106150.30244@anakin> <1181220656.4187.64.camel@gaivota>
In-Reply-To: <1181220656.4187.64.camel@gaivota>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> Hi Geert,
>
> Em Qua, 2007-06-06 às 21:11 +0200, Geert Uytterhoeven escreveu:
>   
>> 	Hi,
>>
>> drivers/media/dvb/b2c2/flexcop-dma.c uses the PCI DMA API, but DVB_B2C2_FLEXCOP
>> doesn't depend on PCI, causing the following problem on PCI-less systems:
>>
>> | linux/drivers/media/dvb/b2c2/flexcop-dma.c:20: warning: implicit declaration of function 'pci_alloc_consistent'
>> | linux/drivers/media/dvb/b2c2/flexcop-dma.c:20: warning: implicit declaration of function 'pci_alloc_consistent'
>>
>> Apparently this is the flexcop DMA core, which is used by both
>> DVB_B2C2_FLEXCOP_PCI and DVB_B2C2_FLEXCOP_USB.
>>
>> DVB_B2C2_FLEXCOP_PCI depends on PCI.
>> DVB_B2C2_FLEXCOP_USB depends on USB.
>>     
>
> Thanks for pointing us about this issue. While the usage of the generic
> dma is the better way, a simple fix can be applied by simply moving
> flexcop-dma to b2c2-flexcop-pci (currently, only the last uses the DMA
> stuff). I've committed such patch. It is available at:
>
> http://linuxtv.org/hg/v4l-dvb/rev/c314ec17335a
>   

Mauro,

It appears that your change has caused the following build warning:

WARNING: "b2c2_flexcop_debug"
[/home/mk/v4l-dvb-master/v4l/b2c2-flexcop-pci.ko] undefined!

Regards,

Mike

