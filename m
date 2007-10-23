Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbXJWPsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbXJWPsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbXJWPsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:48:04 -0400
Received: from mail0.scram.de ([78.47.204.202]:35260 "EHLO mail0.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbXJWPsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:48:01 -0400
X-Spam-Score: -4.046
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
 * -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
 *      [score: 0.0000]
 *  0.4 AWL AWL: From: address is in the auto white-list
Message-ID: <471E179F.6050605@scram.de>
Date: Tue, 23 Oct 2007 17:47:43 +0200
From: Jochen Friedrich <jochen@scram.de>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Scott Wood <scottwood@freescale.com>, Carsten Juttner <carjay@gmx.net>,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org,
       linuxppc-embedded@ozlabs.org
Subject: Re: [i2c] [PATCH take2] [POWERPC] i2c: adds support for i2c bus on
  8xx
References: <47134A94.60606@scram.de>	<20071015183107.GA4361@loki.buserror.net>	<47166085.1010608@scram.de> <20071017230027.334a5f48@hyperion.delvare>
In-Reply-To: <20071017230027.334a5f48@hyperion.delvare>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> On Wed, 17 Oct 2007 21:20:37 +0200, Jochen Friedrich wrote:
>>>> +	/* Select an arbitrary address.  Just make sure it is unique.
>>>> +	 */
>>>> +	out_8(&i2c->i2c_i2add, 0xfe);
>>>>     
>>> It's a 7-bit address...  and are you sure that 0x7e is unique?  Does this
>>> driver even support slave operation?
>>>   
>> It's in fact 0x7F << 1. The same value is used in the 2.4 driver and
>> in u-boot, as well. Slave operation is not supported.
> 
> I'm not sure what exactly you are doing here, but 0x7f isn't a valid
> 7-bit I2C address.

That's most probably the reason why it is used everywhere in the CPM world
(old driver, u-boot) ;-)

According to the documentation, the CPM enters a loopback mode as soon
as a write access to the I2C address written to i2c_i2add takes place.
This even happens if the CPM is set to master mode. So the only way to make
sure there are no limitations to the I2C addresses which can be used is to
use this invalid address. 0x00 can't be used either or no I2C broadcasts
would be possible.

>From the MPC-823 documentation:

16.13.3.1.3 I2C Loopback Configuration. Loopback on the I2C controller is a
special part of master mode operation with a device that does not contain
internal addresses. Refer to Figure 16-127 for more information. To begin a
loopback transmission, you must prepare a TX buffer descriptor with a data
buffer N+1 bytes long, where N is the number of data bytes to be written back
to the I2C controller. You must also prepare one or more RX buffer descriptors
to receive the N bytes of data. The first byte of the TX buffer descriptor
must contain the address of the MPC823 I2C device’s own address, which is in
the I2CADD register, followed by the write bit asserted (R/W = 0). The
remaining N bytes of the TX buffer descriptor contain the data to be sent and
received by the I2C controller. Next, set the R bit in the TX buffer descriptor
and the E bit in the RX buffer descriptor. Then set the W and L bits in the TX
buffer descriptor. Setting the L bit causes a stop condition to be issued after
this buffer is transmitted to conclude the operation. Set the I bit in the TX
and RX buffer descriptors to enable the transmission and reception status to be
updated in the I2CE register and to enable I2C transmit and receive interrupts
to the core. You must then set the STR bit in the I2COM register to initiate
the loopback operation.

Thanks,
Jochen
