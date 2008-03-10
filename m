Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbYCJIWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbYCJIWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 04:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbYCJIW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 04:22:29 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:57675 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYCJIW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 04:22:29 -0400
Message-ID: <47D4EFC1.1050403@tiscali.nl>
Date: Mon, 10 Mar 2008 09:22:25 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Colin Leroy <colin@colino.net>, lkml <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: ADT746X: logical-bitwise & confusion in set_max_duty_at_crit()
References: <47D47B11.1000303@tiscali.nl>	 <20080310084633.5246ecfe@paperstreet.colino.net> <1205136413.8621.3.camel@pasglop>
In-Reply-To: <1205136413.8621.3.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Mon, 2008-03-10 at 08:46 +0100, Colin Leroy wrote:
>> On Mon, 10 Mar 2008 01:04:33 +0100, Roel Kluin wrote:
>>
>>> logical-bitwise & confusion
>> Looks good to me, but I'm not really maintaining that anymore :-)
>> I'm not sure who does, Cc:ing Benjamin as he'll probably know.
> 
> Nobody is U suspect...
> 
> Send it to the list linuxppc-dev@ozlabs.org, it should be picked up
> anyway.
(linuxppc-dev CC'd)
---
logical-bitwise & confusion

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/hwmon/adt7473.c b/drivers/hwmon/adt7473.c
index 9587869..8ea7da2 100644
--- a/drivers/hwmon/adt7473.c
+++ b/drivers/hwmon/adt7473.c
@@ -570,7 +570,7 @@ static ssize_t set_max_duty_at_crit(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adt7473_data *data = i2c_get_clientdata(client);
 	int temp = simple_strtol(buf, NULL, 10);
-	temp = temp && 0xFF;
+	temp &= 0xFF;
 
 	mutex_lock(&data->lock);
 	data->max_duty_at_overheat = temp;

