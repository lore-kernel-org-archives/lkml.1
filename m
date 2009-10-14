Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZJNLWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZJNLWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 07:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756342AbZJNLWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 07:22:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55584 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756305AbZJNLWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 07:22:44 -0400
Date: Wed, 14 Oct 2009 13:22:00 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@Opfer-Online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com,
       Eric Miao <eric.y.miao@gmail.com>
Subject: Spitz battery questions
Message-ID: <20091014112200.GA16156@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I did some measurements of spitz battery subsystem; maybe they are
useful for someone.

Unfortunately, concistent numbers are quite hard: longer/thinner
cables mean lower voltage and also lower currents :-(. I get quite
consistents 5V at power supply, but it goes down to 4.5..4.2V when it
reaches zaurus behind ampermeter. (Is zaurus even able to charge
battery properly from such low voltage?)

One big surprise was wlan CF card, eating +200mA when initialized.

I'm working on drivers/power/spitz_battery driver, and I'll need to
know conversion between ADC readings and milivolts; does someone have
those?

Does someone have better/more reliable/other power consumption numbers?

								Pavel

Idle, charging, no backlight, linux 2.6.26: 200mA @ 4.8V
		bl 1:			310mA
		bl 10:			315mA
		bl 20			340mA
		bl 30:			390mA
		bl 40:			440mA
		bl 47:			445mA
disk is spinning:			+50mA
find /:				       +200mA
cat /dev/zero:			       +100mA
make:				       +240mA

charging, powerdown:		        380mA..440mA
charging, ROM menu:			550mA
D+M monitor, not charging:		170mA
D+M monitor, half charging:		280mA
D+M monitor, full charging:		480mA..550mA

Charging in ROM, 23:17:			260mA
	         23:21:			245mA
		 23:25:			230mA
		 23:34:			205mA
		 0:08:			100mA
		 0:29:			80mA, charger LED is off

Charging in ROM, from empty @ 8:35:	610mA
		              8:38:	555mA
			      8:45:	545mA
			      8:50:	540mA
			      9:01:	540mA
			      9:18:	530mA
			      9:36:	520mA
			      9:45:	505mA
			      9:51:	480mA
			     10:15:	365mA
			     10:48:	250mA
			     11:01:	225mA
			     11:31:	180mA
			     11:38:	170mA
			     12:48:	 80mA, charger LED is off.

Measured @ li-ion battery.
ROM					<7mA
Linux 2.6.26 suspend:			7.5mA, 10mA?!
Linux 2.6.26, fully running, charger connected: 50uA :-(
						100mA charge

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
