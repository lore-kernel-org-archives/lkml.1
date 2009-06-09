Return-Path: <linux-kernel-owner+w=401wt.eu-S1761774AbZFIOAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774AbZFIOAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 10:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932307AbZFIOAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 10:00:06 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:43498 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbZFIOAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 10:00:04 -0400
Date: Tue, 9 Jun 2009 15:59:47 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20090609135947.GB18591@gundam.enneenne.com>
Mail-Followup-To: Liam Girdwood <lrg@slimlogic.co.uk>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: regulator_register() API
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to add the regulator support to my driver for max8821
(white led charge pump with mono class D audio amp and dual LDO).

Current regulator_register() implementation forces the caller to
allocate a proper device for each regulators and also the line:

   struct regulator_init_data *init_data = dev->platform_data;

forces the user to define the pointer platform_data as a "struct
regulator_init_data" only.

Since max8821 has both leds and LDOs I compared the functions
regulator_register() and led_classdev_register() and IMHO the latter
is more versatile/easy-to-use than the former. :)

In a multifunctional device connected with an I2C bus (as the max8821
is) it's quite complex defining a regulator device since I must
provide a new device for each regulators and redefing platform_data
for each registration.

However if the regulator_register() worked in a similar way to
led_classdev_register(), I simply can do something like this:

        for (i = 0; i < regulators_num; i++) {
	       /* init regulators structs */
	       ...

               ret = regulator_register(&client->dev, &reg[i].dev);
               if (ret < 0)
		       dev_warn(&client->dev, "unable to register\n");
        }

and writing the support for my multifunctional device will be
easier. :)

What about if I add a new function regulator_classdev_register() which
in turn calls regulator_register() doing in a similar way than
led_classdev_register() does?

This will keep backward compatibility with old drivers and may offer a
more versatile way to define a regulator expecially for
multifunctional devices.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
