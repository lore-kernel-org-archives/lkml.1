Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbXLRU5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbXLRU5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 15:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbXLRU4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 15:56:52 -0500
Received: from smtp3.global.net.uk ([80.189.92.91]:59727 "EHLO
	smtp3.global.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbXLRU4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 15:56:52 -0500
Message-ID: <4768340C.60208@linuxrealtime.co.uk>
Date: Tue, 18 Dec 2007 20:56:44 +0000
From: Steve Hardy <steve@linuxrealtime.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] : hwmon - new chip driver for TI ADS7828 A-D
References: <4754441F.1030405@linuxrealtime.co.uk> <20071212022550.d8d3b295.akpm@linux-foundation.org>
In-Reply-To: <20071212022550.d8d3b295.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Authenticated-Sender: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Thanks your your comments, I'm currently preparing/testing a revised patch based on your suggestions, which I will post later this week.

A couple of comments inline.

Steve

> I wouldn't bother with EXPERIMENTAL personally.  It seems a farily
> pointless thing.
> 

OK, I copied one of the other hwmon drivers, many of which are marked experimental.

>> +static int ads7828_attach_adapter(struct i2c_adapter *adapter);
>> +static int ads7828_detect(struct i2c_adapter *adapter, int address, int 
>> kind);
>> +static void ads7828_init_client(struct i2c_client *client);
>> +static int ads7828_detach_client(struct i2c_client *client);
>> +static struct ads7828_data *ads7828_update_device(struct device *dev);
>> +static u16 ads7828_read_value(struct i2c_client *client, u8 reg);
> 
> I do dislike all these forward declarations, but they're all needed here
> give the order of the functions.  Maybe from my Pascal-on-pdp11 days..
> 

OK, this is due to re-using the driver structure/style of other hwmon drivers, will try to improve.

>> +static int ads7828_attach_adapter(struct i2c_adapter *adapter)
>> +{
>> +    if (!(adapter->class & I2C_CLASS_HWMON))
>> +        return 0;
> 
> Can this happen?

Hmmm, this code exists in pretty much all of the other hwmon drivers, so I will leave it in.

I think it relates to I2C vs ISA connected devices, to avoid detecting something with the correct ID on the wrong bus?

