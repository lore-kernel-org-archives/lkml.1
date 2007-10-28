Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbXJ1K0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbXJ1K0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 06:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbXJ1K0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 06:26:04 -0400
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:57297 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbXJ1K0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 06:26:02 -0400
Message-ID: <472470DC.3080809@freemail.hu>
Date: Sun, 28 Oct 2007 12:22:04 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, Rodrigo Pereira <rodripe@gmail.com>
Subject: Re: [PATCH 3/3] leds-clevo-mail: driver for Clevo mail LED
References: <4718FD04.3080602@freemail.hu>	 <20071019133607.3419b00a.randy.dunlap@oracle.com>	 <471B4BA5.30100@freemail.hu>  <471B4C46.9030502@freemail.hu> <1193176104.5709.137.camel@localhost.localdomain>
In-Reply-To: <1193176104.5709.137.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:
> On Sun, 2007-10-21 at 14:55 +0200, Németh Márton wrote:
>> diff -uprN linux-2.6.23.orig/drivers/leds/Kconfig linux-2.6.23/drivers/leds/Kconfig
>> --- linux-2.6.23.orig/drivers/leds/Kconfig	2007-10-09 22:31:38.000000000 +0200
>> +++ linux-2.6.23/drivers/leds/Kconfig	2007-10-21 12:04:50.000000000 +0200
>> @@ -101,6 +101,39 @@ config LEDS_GPIO
>>  	  outputs. To be useful the particular board must have LEDs
>>  	  and they must be connected to the GPIO lines.
>>
>> +config LEDS_CLEVO_MAIL
>> +	tristate "Mail LED on Clevo notebook (EXPERIMENTAL)"
>> +	depends on LEDS_CLASS && X86 && SERIO_I8042 && DMI && EXPERIMENTAL
>> +	help
>> +	  This driver makes the mail LED accessible from userspace
>> +	  programs through the leds subsystem. This LED have three
>> +	  known mode: off, blink at 0.5Hz and blink at 1Hz.
>> +
>> +	  The driver supports two kinds of interface: using ledtrig-timer
>> +	  or through /sys/class/leds/clevo::mail/brightness. As this LED
>> +	  cannot change it's brightness it blinks instead. The brightness
>> +	  value 0 means off, 1..127 means blink at 0.5Hz and 128..255 means
>> +	  blink at 1Hz.
> 
> Hmm, there really is no way to just turn the LED on? :(

I looked up the printed manual (which can be also found at
ftp://ftp.clevo.com.tw/USRMANUAL/D4x0J/D4x0J_CUG.zip ), page 9 contains
the following information:

LED Power & Communication Indicators:

Icon | Color            | Description
-----+------------------+-----------------------------------------------
Mail | Blinking Green & | New mail has arrived
LED  | Orange           |
     +------------------+-----------------------------------------------
     | Fast Blinking    | New mail has arrived from users defined
     | Green & Orange   | in the Special Group in the Auto Mail Checker
     +------------------+-----------------------------------------------
     | Green            | The (optional) Wireless LAN module is On
     +------------------+-----------------------------------------------
     | Orange           | The (optional) Bluetooth module is On
     +------------------+-----------------------------------------------
     | Half Orange/     | Both the (optional) Wireless LAN and Bluetooth
     | Half Green       | modules are On (see sidebar)
-----+------------------+-----------------------------------------------

Unfortunately I do not have these optional modules so I never saw the LED
just on without blinking. I don't know if there is any hardware limitation
turning on the LED without the optional modules.

I will send a new patch collection which addresses the other mentioned topics.

	Márton Németh
