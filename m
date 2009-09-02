Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZIBIrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZIBIrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 04:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZIBIrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 04:47:48 -0400
Received: from cosmos.geomatys.fr ([88.191.17.20]:36881 "EHLO
	cosmos.geomatys.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbZIBIrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 04:47:47 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Sep 2009 04:47:47 EDT
Message-ID: <4A9E308E.60505@geomatys.fr>
Date: Wed, 02 Sep 2009 10:45:02 +0200
From: "corentin.labbe" <corentin.labbe@geomatys.fr>
User-Agent: Thunderbird 2.0.0.22 (X11/20090817)
MIME-Version: 1.0
To: tomaz.mertelj@guest.arnes.si
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Driver for Texas Instruments amc6821
 chip
References: <20090831_202450_066558.tomaz.mertelj@guest.arnes.si>
In-Reply-To: <20090831_202450_066558.tomaz.mertelj@guest.arnes.si>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tomaz.mertelj@guest.arnes.si a écrit :
> I have crafted a hwmon driver for Texas Instruments amc6821 SMB-bus 2-
> channel temperature sensor, pwm controller. This is my first linux project 
> so some corrections will be necessary.
> 
> T. Mertelj

Hello

I have some warnings

  CC      drivers/hwmon/amc6821.o
drivers/hwmon/amc6821.c: In function `set_temp1_auto_point_temp':
drivers/hwmon/amc6821.c:390: warning: comparison is always true due to limited range of data type
drivers/hwmon/amc6821.c: In function `set_temp2_auto_point_temp':
drivers/hwmon/amc6821.c:391: warning: comparison is always true due to limited range of data type
drivers/hwmon/amc6821.c: In function `set_pwm1_auto_point_pwm':
drivers/hwmon/amc6821.c:408: warning: comparison is always true due to limited range of data type
drivers/hwmon/amc6821.c:419: warning: comparison is always true due to limited range of data type

you use tmp as a unsigned 8 bit so it is always >= 0 (it can't be below 0)
Prefer use:
s8 tmp;


Cordially
