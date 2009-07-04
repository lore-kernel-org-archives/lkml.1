Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbZGDMX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbZGDMX6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 08:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZGDMXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 08:23:49 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:37940 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbZGDMXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 08:23:48 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A4F498E.3010109@cam.ac.uk>
Date: Sat, 04 Jul 2009 12:22:38 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-kernel@vger.kernel.org, chrisv@cyberswitching.com, daniel@caiaq.de,
       iws@ovro.caltech.edu, dmitry.torokhov@gmail.com, hmh@hmh.eng.br,
       david-b@pacbell.net
Subject: Re: [PATCH] IIO: Add missing I2C dependencies for max1363 and tsl2561
References: <1246542464-6974-1-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-2-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-3-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-4-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-5-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-6-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-7-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-8-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-9-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-10-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-11-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-12-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-13-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-14-git-send-email-jic23@cam.ac.uk>	<1246542464-6974-15-git-send-email-jic23@cam.ac.uk>	<4A4E3BED.5050504@cam.ac.uk> <20090703211348.4033c109@hyperion.delvare>
In-Reply-To: <20090703211348.4033c109@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> On Fri, 03 Jul 2009 17:12:13 +0000, Jonathan Cameron wrote:
>> Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
>>
>> I will roll these into the original patches at some point, but
>> for now they are here.
>>
>> Thanks to David Brownell for spotting this.
>> ---
>>  drivers/iio/adc/Kconfig   |    2 +-
>>  drivers/iio/light/Kconfig |    2 +-
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
>> index cb773d2..ab2066c 100644
>> --- a/drivers/iio/adc/Kconfig
>> +++ b/drivers/iio/adc/Kconfig
>> @@ -6,7 +6,7 @@ comment "Analog to digital convertors"
>>  
>>  config MAX1363
>>  	tristate "MAXIM max1363 ADC driver"
>> -	depends on IIO
>> +	depends on IIO && I2C
>>  	help
>>  	  Say yes here to build support for many MAXIM i2c analog to digital
>>  	  convertors (ADC). (max1361, max1362, max1363, max1364, max1136,
>> diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
>> index 620e249..62d502c 100644
>> --- a/drivers/iio/light/Kconfig
>> +++ b/drivers/iio/light/Kconfig
>> @@ -6,7 +6,7 @@ comment "Light sensors"
>>  
>>  config TSL2561
>>         tristate "TAOS TSL2561 light-to-digital convertor"
>> -       depends on IIO
>> +       depends on IIO && I2C
>>         help
>>  	Say yes bere to build support for the TAOS light to digital
>>  	convertor.  This chip has two light sensors. One is broadband
> 
> Unrelated suggestion: you could surround all the driver configuration
> entries with a big
> 
> if IIO
> 
> (...)
> 
> endif # IIO
> 
> This would save you the hassle of adding "depends on IIO" to every
> driver. Many subsystems have resorted to this technique by now.
> 
Thanks Jean, I hadn't realized you could do that.

Jonathan
