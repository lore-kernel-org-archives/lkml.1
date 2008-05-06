Return-Path: <linux-kernel-owner+w=401wt.eu-S1764136AbYEFPUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764136AbYEFPUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 11:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbYEFPTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 11:19:53 -0400
Received: from mail0.scram.de ([78.47.204.202]:48194 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbYEFPTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 11:19:52 -0400
X-Spam-Score: -4.194
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.2 AWL AWL: From: address is in the auto white-list
Message-ID: <4820770B.1010002@scram.de>
Date: Tue, 06 May 2008 17:19:39 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Kumar Gala <galak@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       Scott Wood <scottwood@freescale.com>, Linux I2C <i2c@lm-sensors.org>
Subject: Re: [i2c] [PATCH6/7] i2c: adds support for i2c bus on Freescale	CPM1/CPM2
 controllers
References: <47FF71A9.4010907@scram.de> <20080506135113.GA4265@pengutronix.de>
In-Reply-To: <20080506135113.GA4265@pengutronix.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

>> +	/* Begin transmission */
>> +	setbits8(&i2c_reg->i2com, 0x80);
> Hardcoded value. (I also wonder if 0x81 might be more suitable, as it
> keeps the "be-a-master"-bit set. Still, both values work with my setup.)

>> +#ifdef I2C_CHIP_ERRATA
>> +	/*
>> +	 * Chip errata, clear enable. This is not needed on rev D4 CPUs.
>> +	 * Disabling I2C too early may cause too short stop condition
>> +	 */
>> +	udelay(4);
>> +	clrbits8(&i2c_reg->i2mod, 1);
> I was unable to find the corresponding errata document, still I wonder
> if it is a 0 which should have been written? The text says "clear" and
> according to the reference manual, this means the bit should be 0.

setbits8() and clrbits8() use a bitmask as second argument.

setbits8(&i2c_reg->i2com, 0x80) will set bit 7 on the i2com register but 
leave bit 0 untouched. Likewise, clrbits8(&i2c_reg->i2mod, 1) will clear bit 0.

Thanks,
Jochen
