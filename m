Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbYBXPQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbYBXPQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 10:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbYBXPQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 10:16:36 -0500
Received: from mail0.scram.de ([78.47.204.202]:40539 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYBXPQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 10:16:35 -0500
X-Spam-Score: -4.066
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.3 AWL AWL: From: address is in the auto white-list
Message-ID: <47C18A4E.5080804@scram.de>
Date: Sun, 24 Feb 2008 16:16:30 +0100
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, i2c@lm-sensors.org,
       Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCHv4 2.6.25] i2c: adds support for i2c bus on Freescale	CPM1/CPM2
 controllers
References: <47A1C4E9.4000003@scram.de> <20080221130520.12b01553@hyperion.delvare> <47BEAF00.50106@scram.de> <20080223212823.GA22131@lixom.net>
In-Reply-To: <20080223212823.GA22131@lixom.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

>> 2. record the I2c name in the dts tree, either as seperate tag (like linux,i2c-name="<i2c-name>")
>>    or as additional compatible entry (like compatible="...", "linux,<i2c-name>").
> 
> I have to say no on this one. The device tree is not supposed to know
> about how linux uses devices, there are firmwares out there that don't
> use DTS for thier device trees, etc.

I still believe this this could be done for embedded devices which are usually booted
via wrapper or U-Boot as those devices will most probably use the most exotic I2c devices
out there (e.g. home-grown devices used by stbs). However, I'm not an device tree expert.
 
>> 3. use a glue layer with a translation map.
> 
> In my opinion this is an OK solution since the same information has to
> be added somewhere already anyway -- eiither to the drivers or to this
> translation table. It should of course be an abstacted shared table,
> preferrably contained under the i2c source directories since several
> platforms and architectures might share them.

I could think of a mixture between 2. and 3.:

Using the compatible attribute with the manufacturer stripped off as I2c name by default
and using an exception table. For now, the struct i2c_driver_device would currently only
need one entry ("dallas,ds1374", "rtc-ds1374").

Thanks,
Jochen
