Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbZJFMYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbZJFMYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 08:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932294AbZJFMYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 08:24:33 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:13977 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932289AbZJFMYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 08:24:32 -0400
X-IronPort-AV: E=Sophos;i="4.44,513,1249272000"; 
   d="scan'208";a="7233447"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
Date: Tue, 6 Oct 2009 13:23:52 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E3F4348@limkexm3.ad.analog.com>
In-Reply-To: <20091006115543.GH27168@sirena.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v3] mfd: ADP5520 Multifunction LCD Backlight and KeypadInput Device Driver
thread-index: AcpGfA7fH13P/i9NRVOIHcduEaoStAAAnCIw
References: <1253682664-27040-1-git-send-email-vapier@gentoo.org> <1254815071-15822-1-git-send-email-vapier@gentoo.org> <20091006115543.GH27168@sirena.org.uk>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>,
       "Mike Frysinger" <vapier@gentoo.org>
CC: "Samuel Ortiz" <sameo@linux.intel.com>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       <linux-kernel@vger.kernel.org>, "Bryan Wu" <cooloney@kernel.org>
X-OriginalArrivalTime: 06 Oct 2009 12:23:54.0205 (UTC) FILETIME=[DE8CF0D0:01CA467F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
>On Tue, Oct 06, 2009 at 03:44:31AM -0400, Mike Frysinger wrote:
>
>> +int adp5520_register_notifier(struct device *dev, struct
notifier_block *nb,
>> +				unsigned int events)
>> +{
>
>This notifier stuff looks an awful lot like an interrupt controller
>driver.  Now that it's possible to implement support for an I2C/SPI
>driven interrupt controller it'd be good to use that rather than having
>a custom API if that's possible.

Honestly this notifier chain is a clean approach and serves its purpose
here pretty well.
IMHO it's much more preferable than pretending there is a virtual GPIO
that doesn't exist and a MFD subdev could request.

>
>> +#define GPIO_R3		(1 << 3)	/* LED3 or GPIO3 aka R3
*/
>> +#define GPIO_R2		(1 << 2)
>> +#define GPIO_R1		(1 << 1)
>> +#define GPIO_R0		(1 << 0)
>
>> +struct adp5520_gpio_platfrom_data {
>> +	unsigned gpio_start;
>> +	u8 gpio_en_mask;
>> +	u8 gpio_pullup_mask;
>> +};
>
>Since there's platform data in here it'd probably be better to
namespace
>the #defines or put them in a separate header in case there are
>collisions with some other chip used on a board.

Will do.


>
>> +struct adp5520_leds_platfrom_data {
>
>There's some 'platfrom' rather than 'platform' typos.

Good catch - this happens to me all the time


>
>> +	int num_leds;
>> +	struct led_info	*leds;
>> +	u8 fade_in;		/* Backlight Fade-In Timer */
>> +	u8 fade_out;		/* Backlight Fade-Out Timer */
>> +	u8 led_on_time;
>
>I don't know exactly what the on_time option does but if it controls
>hardware-implemented blinking there's actually a callback function the
>LED driver can implement to allow triggers to use the hardware assisted
>blinking at runtime.  If it returns an error or isn't implemented
>there's a software fallback.

Yes its hardware controlled blinking. I noticed the leds timer trigger
driver.
People can still use it - the downside with the hardware assisted
blinking is that all LEDs share the same on_time. So I decided against
using the callback.

-Michael 
