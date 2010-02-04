Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab0BDXUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:20:43 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:41983 "HELO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758627Ab0BDXUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:20:39 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PWM PATCH 0/5] Implements a common PWM API
Date: Thu, 4 Feb 2010 18:20:41 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190902152C2F@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909020E99C5@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PWM PATCH 0/5] Implements a common PWM API
Thread-Index: Acqj16TEqjVC+2BMRtqcHXm7QpgQlwAV0lAgAHBMIoA=
References: <cover.1265094517.git.bgat@billgatliff.com> <BD79186B4FD85F4B8E60E381CAEE1909020E99C5@mi8nycmail19.Mi8.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "H Hartley Sweeten" <hartleys@visionengravers.com>,
       "Bill Gatliff" <bgat@billgatliff.com>, <linux-embedded@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Feb 2010 23:20:37.0847 (UTC) FILETIME=[A8EF4E70:01CAA5F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 02, 2010 10:44 AM, H Hartley Sweeten wrote:
> On Tuesday, February 02, 2010 12:15 AM, Bill Gatliff wrote:
>> This patch series implements a common PWM API.  This series incorporates
>> the feedback from the linux-embedded mailing list and elsewhere; the author
>> greatly appreciates the efforts of everyone who reviewed the previous version
>> of this code.
>> 
>> Bill Gatliff (5):
>>   API to consolidate PWM devices behind a common user and kernel
>>     interface
>>   Emulates PWM hardware using a high-resolution timer and a GPIO pin
>>   Expunge old Atmel PWMC driver, replacing it with one that conforms to
>>     the PWM API
>>   PWM-based LED control
>>   LED "dimmer" trigger
>> 
>>  Documentation/pwm.txt       |  260 ++++++++++++++++++
>>  drivers/leds/leds-pwm.c     |  224 +++++++++-------
>>  drivers/leds/ledtrig-dim.c  |   95 +++++++
>>  drivers/misc/Makefile       |    6 +-
>>  drivers/misc/atmel_pwm.c    |  409 ----------------------------
>>  drivers/pwm/atmel-pwm.c     |  589 ++++++++++++++++++++++++++++++++++++++++
>>  drivers/pwm/gpio.c          |  307 +++++++++++++++++++++
>>  drivers/pwm/pwm.c           |  633 +++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/pwm.h         |   31 --
>>  include/linux/pwm/pwm-led.h |   34 +++
>>  include/linux/pwm/pwm.h     |  170 ++++++++++++
>>  11 files changed, 2217 insertions(+), 541 deletions(-)
>>  create mode 100644 Documentation/pwm.txt
>>  create mode 100644 drivers/leds/ledtrig-dim.c
>>  delete mode 100644 drivers/misc/atmel_pwm.c
>>  create mode 100644 drivers/pwm/atmel-pwm.c
>>  create mode 100644 drivers/pwm/gpio.c
>>  create mode 100644 drivers/pwm/pwm.c
>>  delete mode 100644 include/linux/pwm.h
>>  create mode 100644 include/linux/pwm/pwm-led.h
>>  create mode 100644 include/linux/pwm/pwm.h
>
> I think the following files/patches are missing from this series:
>
> drivers/Kconfig
> drivers/Makefile
> drivers/leds/Kconfig
> drivers/leds/Makefile
> drivers/pwm/Kconfig
> drivers/pwm/Makefile

Bill,

When you do repost this series please make sure that pwm support can only be
selected if CONFIG_SYSFS is enabled.  Your original patches did not have this.

I look forward to seeing the update.

BTW, setting pwm.dev = &pdev->dev in my driver did fix the Ooops.

Regards,
Hartley
