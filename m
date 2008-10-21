Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYJUTSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYJUTSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYJUTSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:18:37 -0400
Received: from pih-relay08.plus.net ([212.159.14.20]:59007 "EHLO
	pih-relay08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbYJUTSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:18:36 -0400
Message-ID: <48FE2ADC.8020203@mimc.co.uk>
Date: Tue, 21 Oct 2008 20:17:48 +0100
From: Mark Jackson <mpfj@mimc.co.uk>
Organization: Mercury IMC Ltd
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: ben-linux@fluff.org, akpm@linux-foundation.org, i2c@lm-sensors.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [i2c] [PATCH v2] Add support for Dallas DS28CM00 Unique ID chip
References: <48FDED5E.5080605@mimc.co.uk>	<20081021173505.2f7673e2@hyperion.delvare>	<48FE22A2.7030604@mimc.co.uk> <20081021211219.18fb7d84@hyperion.delvare>
In-Reply-To: <20081021211219.18fb7d84@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: b621c1117f837cac625ccb2b07223998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Mark,
> 
> On Tue, 21 Oct 2008 19:42:42 +0100, Mark Jackson wrote:
>> Jean Delvare wrote:
>>> On Tue, 21 Oct 2008 15:55:26 +0100, Mark Jackson wrote:
>>>> This patch adds support for the (I2C based) DS28CM00 ID chip.
>>>> (v2 after running through checkpatch)
>>>>
>>>> Signed-off-by: M.Jackson <mpfj@mimc.co.uk> 
>>>> ---
>>>>  drivers/i2c/chips/Kconfig    |    7 ++
>>>>  drivers/i2c/chips/Makefile   |    1 +
>>>>  drivers/i2c/chips/ds28cm00.c |  166 ++++++++++++++++++++++++++++++++++++++++++
>>>>  3 files changed, 174 insertions(+), 0 deletions(-)
>>> Nack. No new drivers under drivers/i2c/chips please, it's going away
>>> soon.
>> Okay ... where should any new drivers be located ?
> 
> Depends of what the device does.
> * Hardware monitoring chip drivers go to drivers/hwmon
> * RTC chip drivers go to drivers/rtc
> * I/O expander drivers go to drivers/gpio
> If you can't find a suitable directory under drivers, either create a
> new one if that makes sense, or put your driver under drivers/misc.

Ah, now I understand !!  I think drivers/misc is probably a good a place as any,

>>>> +static int ds28cm00_attach_adapter(struct i2c_adapter *adapter);
>>>> +static int ds28cm00_detect(struct i2c_adapter *adapter, int address, int kind);
>>>> +static int ds28cm00_detach_client(struct i2c_client *client);
>>>> +
>>>> +/* This is the driver that will be inserted */
>>>> +static struct i2c_driver ds28cm00_driver = {
>>>> +	.driver = {
>>>> +		.name	= "ds28cm00",
>>>> +	},
>>>> +	.attach_adapter	= ds28cm00_attach_adapter,
>>>> +	.detach_client	= ds28cm00_detach_client,
>>>> +};
>>> attach_adapter and detach_client are deprecated. Please use probe and
>>> remove instead.
>> Are there any existing chip drivers that use this new method ?
> 
> As of 2.6.27-git10: all drivers under drivers/i2c/chips, all i2c
> drivers under drivers/gpio, all i2c drivers under drivers/hwmon, all
> i2c drivers under drivers/rtc, and more.
> 
> You may want to take a look at Documentation/i2c/upgrading-clients too.

Okay ... thanks for the pointer.

Mark
