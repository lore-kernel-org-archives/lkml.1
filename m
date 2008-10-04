Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYJDRf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYJDRf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 13:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYJDRfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 13:35:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:65183 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbYJDRfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 13:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=jWtED8k9yzBYwYzGZBtuRW+9+yIb5K6KnpGKeSKmYYXgrKiWz3s/e0sFn2SK08o6XD
         N7zlf1Jm98SP9adKSp0tbDzhNJQy9cAfPVeCZnBO885YWPyZSkvk6E1SyzPOPrcWmPSy
         rSco/axmN6qakb0fM2tpJSLH4TJCx38IS8Yk8=
Message-ID: <f4527be0810041035v14083735y81c95d13cf72a125@mail.gmail.com>
Date: Sat, 4 Oct 2008 18:35:11 +0100
From: "Andrew Lyon" <andrew.lyon@gmail.com>
To: "Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: kernel 2.6.27-rc8-git6 system lockup possibly caused by lm_sensors
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running kernel 2.6.27-rc8-git6 on a supermicro x7dwa-n system, I
have w83793, coretemp, and i5k_amb sensor modules loaded, occasionally
the system locks up hard requiring reset button to reboot it, this
usually happens after a few days of uptime and has never happened less
than 24 hours after bootup,  I have sensord running and noticed today
that the log output changes just before it locks up, which makes me
wonder if reading the sensors is the cause...

The board has 8 fan connections of which 5 are currently used, the
w83793 sensors show 10 fan outputs, I plan to add 2 more fans next
week as the hot swap drive bay has slots for 4 but only comes with 2,
I have not disabled any of the fan sensors in the config file so every
minute sensord logs alarms for the unused fans:

Oct  4 16:34:06 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan9: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:34:06 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan10: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:35:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan1: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:35:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan4: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:35:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan5: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:35:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan9: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:35:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan10: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:36:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan1: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:36:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan4: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:36:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan5: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:36:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan9: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:36:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan10: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:37:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan1: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:37:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan4: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:37:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan5: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:37:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan9: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:37:07 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan10: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:38:08 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan1: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:38:08 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan4: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:38:08 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan5: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:38:08 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan9: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:38:08 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan10: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:39:10 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan1: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:39:10 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan4: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:39:10 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan5: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:39:10 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan9: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:39:10 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan10: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:40:10 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan1: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:40:10 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan4: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:40:10 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan5: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:40:10 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan9: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:40:10 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan10: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:41:11 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan1: 0 RPM (min = 712 RPM) [ALARM]
Oct  4 16:41:11 supermicro sensord: Sensor alarm: Chip
w83793-i2c-0-2f: fan4: 0 RPM (min = 712 RPM) [ALARM]

right in the middle of a batch of alarm events the log output changes,
and these were the last events logged to the serial console before the
system locked up:

Oct  4 16:41:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan5: 0
Oct  4 16:41:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan9: 0
Oct  4 16:41:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan10: 0
Oct  4 16:42:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan1: 0
Oct  4 16:42:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan4: 0
Oct  4 16:42:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan5: 0
Oct  4 16:42:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan9: 0
Oct  4 16:42:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan10: 0
Oct  4 16:43:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan1: 0
Oct  4 16:43:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan4: 0
Oct  4 16:43:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan5: 0
Oct  4 16:43:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan9: 0
Oct  4 16:43:11 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan10: 0
Oct  4 16:44:13 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan1: 0
Oct  4 16:44:13 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan4: 0
Oct  4 16:44:13 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan5: 0
Oct  4 16:44:13 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan9: 0
Oct  4 16:44:13 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan10: 0
Oct  4 16:45:14 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan1: 0
Oct  4 16:45:14 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan4: 0
Oct  4 16:45:14 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan5: 0
Oct  4 16:45:14 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan9: 0
Oct  4 16:45:14 supermicro sensord: Sensor alarm: Chip w83793-i2c-0-2f: fan10: 0

as you can see part of the usual event is missing, the "RPM (min = 712
RPM) [ALARM]" that was visible on previous events has gone,  very
strange.

i will try running the system with these modules unloaded but I
wondered if this was a known issue that has already been fixed?

Andy
