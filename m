Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbXFTMLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbXFTMLE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 08:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbXFTMK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 08:10:56 -0400
Received: from mail.atmel.fr ([81.80.104.162]:55621 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754792AbXFTMKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 08:10:55 -0400
Message-ID: <46791945.6090203@rfo.atmel.com>
Date: Wed, 20 Jun 2007 14:10:45 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Subject: Re: [PATCH] atmel_lcdfb: Fix STN LCD support
References: <467252C4.50203@rfo.atmel.com> <20070619094752.1b7ba108@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20070619094752.1b7ba108@dhcp-255-175.norway.atmel.com>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen :
> On Fri, 15 Jun 2007 10:50:12 +0200
> Nicolas Ferre <nicolas.ferre@rfo.atmel.com> wrote:
> 
>> From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
>>
>> Fixes STN LCD support for the atmel_lcdfb framebuffer driver.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
> 
> Looks correct to me. Although...
> 
>> Index: b/drivers/video/Kconfig
>> ===================================================================
>> --- a/drivers/video/Kconfig	2007-05-14 11:02:16.000000000 +0200
>> +++ b/drivers/video/Kconfig	2007-06-13 11:04:10.000000000 +0200
>> @@ -701,6 +701,16 @@
>>  	  Say Y if you want to map Frame Buffer in internal SRAM. Say N if you want
>>  	  to let frame buffer in external SDRAM.
>>  
>> +config FB_ATMEL_STN
>> +	bool "Use a STN display with AT91/AT32 LCD Controller"
>> +	depends on FB_ATMEL && ARCH_AT91SAM9261
>> +	default n
>> +	help
>> +	  Say Y if you want to connect a STN LCD display to the AT91/AT32 LCD
>> +	  Controller. Say N if you want to connect a TFT.
>> +
>> +	  If unsure, say N.
>> +
> 
> I don't think it's appropriate to include chip-specific options here.
> This option will not affect the driver at all, it will only affect the
> board-specific setup code, so IMO it should be under Platform-specific
> options or something like that.

True in a "code centric" point of view. I do not think it is very usable 
to move this switch in the board setup : The user will have to check if 
an option is appearing in the board menu while he select the Atmel LCD 
driver. He is supposed to have already selected the chip'n'board he is 
using.
Moreover, this option will not show its nose until the board that 
implements it is not included in depends.
(It is basically the same case with the option just above, with the very 
same arguments).

> Also, the text says AT91/AT32 but it depends on one particular AT91
> chip.

Ok, will move it to a board switch (MACH_AT91SAM9261EK for instance). 
This will grow as STN configuration will be implemented for boards.

Regards,
-- 
Nicolas Ferre


