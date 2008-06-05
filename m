Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYFEI3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYFEI3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 04:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbYFEI3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 04:29:04 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:7189 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbYFEI25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 04:28:57 -0400
X-Spam-Flag: NO
X-Spam-Score: -8.389
Message-ID: <4847A3C5.60600@tremplin-utc.net>
Date: Thu, 05 Jun 2008 10:28:53 +0200
From: Eric Piel <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.14) Gecko/20080504 Mandriva/2.0.0.14-1mdv2009.0 (2009.0) Thunderbird/2.0.0.14 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Riku Voipio <riku.voipio@movial.fi>
Cc: Yan Burman <burman.yan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       HWMON <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net, jic23@cam.ac.uk,
       pau@eslack.org
Subject: Re: [lm-sensors] [PATCH 2.6.25.4] hwmon: HP Mobile Data Protection
 System 3D ACPI	driver
References: <1212235533.3815.5.camel@localhost> <48479922.6050003@movial.fi>
In-Reply-To: <48479922.6050003@movial.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Riku Voipio wrote:
> Yan Burman wrote:
>> +==================
>> +
>> +Supported chips:
>> +
>> +  * STMicroelectronics LIS3LV02DL and LIS3LV02DQ
>> +
> These chips are connected to either I2C or SPI - This is the 4th driver for
> (apparently) these same chips:
> 
> http://docwiki.gumstix.org/Lis3lv02dq_spi.c
> http://svn.openmoko.org/branches/src/target/kernel/2.6.24.x/patches/lis302dl.patch 
> 
> http://article.gmane.org/gmane.linux.kernel.spi.devel/1010
Hi!
Thanks a lot for these links (which I was not aware of). They indeed 
seem to handle the same hardware (all via spi). To be even more 
complete, here is a link we received off-list for accessing the same 
hardware via I²C:
http://pof.eslack.org/HTC/shift/i2c-gsensor.tar.gz

There are for sure some nice things we could borrow ;-)
> 
>> +    depends on ACPI && INPUT && X86
>>   
> 
> 
>> +/* The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ
>> + * that seems to be connected via SPI */
>>   
> Perhaps it would make more sense implement support for SPI
> bus on the laptop and use the SPI interface directly instead or
> routing via the ACPI hiding layer?
Getting rid of ACPI could be nice, as it tends to be rather slow. 
However, so far we've stick to it because it ensures that for the ~15 
different models of HP laptop, we can access the hardware exactly the 
same way. I have the gut feeling that if HP spent some time to add an 
interface in ACPI, there was some kind of reason.

However, I know nothing about SPI. Maybe you'll tell that if this chip 
is on the SPI bus, it will always be accessed the same way, located at 
the same address... or whatever that can ensure us that from the moment 
we know this device is in the laptop (and that's easy via HPQ0004) we 
cannot mess up. In that case, going to SPI would be definitely worthy.

Eric
