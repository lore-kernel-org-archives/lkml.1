Return-Path: <linux-kernel-owner+w=401wt.eu-S1752333AbZIKNjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbZIKNjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 09:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZIKNjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 09:39:51 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:48554 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbZIKNjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 09:39:51 -0400
X-Greylist: delayed 845 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2009 09:39:50 EDT
Date: Fri, 11 Sep 2009 15:25:30 +0200
From: Arjan Opmeer <arjan@opmeer.net>
To: dtor@mail.ru, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20090911132530.GA2708@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ado@adopmeer.homeip.net
Subject: How to handle laptop with Elantech touchpad that chokes on current
 driver configuration values?
X-SA-Exim-Version: 4.2.1 (built Sat, 01 Aug 2009 12:09:26 +0000)
X-SA-Exim-Scanned: Yes (on ado.lan)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Recently I debugged a problem for a user where the Elantech touchpad of his
laptop chokes on the configuration values that the current kernel driver is
using. After sending a conflicting value the PS/2 controller freezes and
doesn't accept any subsequent bytes.

The current configuration values for hardware version 2 (EeePC style) come
from the touchpad driver in the original Xandros Linux distribution for the
EeePC. And until now I haven't heard of problems with them. They look like
this:

   etd->reg_10 = 0x54;
   etd->reg_11 = 0x88;
   etd->reg_21 = 0x60;

Some time ago I received the updated touchpad driver that is used in the
Dell mini Ubuntu distribution. Here the values are changed to be the same as
most of the Windows driver are using. Notice the difference in register 0x11
and how they dropped configuring register 0x21:

   etd->reg_10 = 0x54;
   etd->reg_11 = 0x8a;

However for the laptop of the user mentioned above the values of his Windows
driver are like this:

   etd->reg_10 = 0x64;
   etd->reg_11 = 0x8a;

Notice the different values for registers 0x10 and 0x11 in comparison with
the current kernel driver. Also the registers _must_ be configured like
this. Using the current kernel driver values for either one of the registers
makes the touchpad freeze up.

Remember that there isn't any publicly available documentation for the
hardware, so these configuration values are "black magic numbers" and the
only source of them is snooping what Windows drivers do or the source of
drivers in dedicated Linux distributions that happen to come my way.

In all cases this is about touchpads with a firmware version reply of 0x02,
0x00, 0x30. So even though the touchpad in this users laptops seems to be
the same as in the EeePC it really requires different values to be
configured.

My question now is what is a prudent way to go forward?

Is it OK that add a DMI check to the kernel driver that matches this users
laptop and dynamically adjust the configuration values?

And how about the common case? Do we keep the values in the driver as they
are, or do we update them to the revised numbers as learned from the Ubuntu
driver?

What are your thoughts on this?


Arjan
