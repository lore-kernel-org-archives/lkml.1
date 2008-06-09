Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbYFIVdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbYFIVdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 17:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbYFIVdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 17:33:45 -0400
Received: from 203-96-159-182.paradise.net.nz ([203.96.159.182]:56167 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753137AbYFIVdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 17:33:44 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2008 17:33:43 EDT
Message-ID: <484DA046.4010804@bluewatersys.com>
Date: Tue, 10 Jun 2008 09:27:34 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Uli Luckas <u.luckas@road.de>, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH, RFC] Earlier I2C initialization
References: <200806091541.43899.u.luckas@road.de> <20080609135739.GE30971@flint.arm.linux.org.uk> <484D947D.1090900@bluewatersys.com> <200806091359.12791.david-b@pacbell.net>
In-Reply-To: <200806091359.12791.david-b@pacbell.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Monday 09 June 2008, Ryan Mallon wrote:
>   
>>> Talk to i2c and framebuffer people about changing the link order.
>>>
>>> i2c should really be initialised before framebuffer devices because
>>> framebuffer devices tend to want to read DDC from monitors, which is
>>> basically a I2C EEPROM in the monitor.
>>>
>>> ... but there's probably some reason why it's done the way it is today,
>>> and changing it could well cause stuff to break.
>>>       
>> We have made i2c the first driver subsystem to come up in our 2.6.20
>> kernel since we use i2c io expanders for power domain control. All we
>> did was change drivers/Makefile so that obj-$(CONFIG_I2C) += i2c/ is at
>> the very top of the file. We didn't have any problems with doing this.
>> YMMV of course.
>>     
>
> OMAP does much the same thing, for the same reason, and the I2C
> adapter gets initialized earlier too (so power management chips
> will be fully usable before driver_initcall code runs).
>
> Unless there's a downside on x86, I'd just suggest someone submit
> a patch moving I2C init "early" so it merges in 2.6.27 ... cc to
> LKML to scare out more potential problems, but I have a hard time
> imagining there'd really be any.
>
> - Dave
>   
Okay, heres the patch. Is untested though (other than our experience 
under 2.6.20), so it probably needs some people to test. I'm not 
subscribed to LKML, so can people CC me if necessary.

Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>

diff --git a/drivers/Makefile b/drivers/Makefile
index f65deda..9eaf236 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -5,6 +5,7 @@
 # Rewritten to use lists instead of if-statements.
 #
 
+obj-y				+= i2c/
 obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpio/
 obj-$(CONFIG_PCI)		+= pci/
 obj-$(CONFIG_PARISC)		+= parisc/
@@ -61,7 +62,6 @@ obj-$(CONFIG_GAMEPORT)		+= input/gameport/
 obj-$(CONFIG_INPUT)		+= input/
 obj-$(CONFIG_I2O)		+= message/
 obj-$(CONFIG_RTC_LIB)		+= rtc/
-obj-y				+= i2c/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_POWER_SUPPLY)	+= power/
 obj-$(CONFIG_HWMON)		+= hwmon/

