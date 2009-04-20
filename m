Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZDTPIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZDTPIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 11:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZDTPIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 11:08:31 -0400
Received: from cathcart.site5.com ([74.54.107.137]:54542 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbZDTPIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 11:08:31 -0400
X-Greylist: delayed 2159 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 11:08:31 EDT
Message-ID: <49EC8775.8060609@compulab.co.il>
Date: Mon, 20 Apr 2009 17:32:21 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [RFD] voltage/current regulator consumer interface
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently there was a brief discussion on linux-arm-kernel list [1] about
controlling voltage regulator state in cases when there is no consumer device
for a particular regulator.

I have some thoughts but I'd like to know people opinion before I start
implementation.

Problem
-------
The regulator framework API provides ability to control the state of
voltage/current regulators from within the kernel. Usually the regulator
supplies power to a device and device driver or some hooks to the platform code
from the device driver manipulate the regulator state. However, the regulator
framework does not have userspace ABI that allows regulator state modifications.
Lack of this ABI prevents fine-grained control for power consumption of devices
such as GPS trancievers and GSM modems. Moreover, in SoC based systems it is
possible to switch on/off power to entire subsystem when it is not used.

Possible solutions
------------------
- Add a platform_driver similar to drivers/regulator/virtual.c that will expose
writable attributes to sysfs thus allowing userspace to control regulator state.
It is the most simple and straight forward solution. However, I have several
questions and I cannot answer them myself:
  Should the driver handle single or several supplies at once?
  If the driver handles single supply isn't it a waste of memory to have a
platform_device per supply?
  If the driver handles several supplies how to define attributes per-supply?
  What attributes will be exposed? Would it be simple 'state' that can be
enabled or disabled? Or the entire set of micorvolts/microamps etc?

- Extend regulator framework so that regulator_consumer_supply entities will
gain their own representation in sysfs. Depending on machine constraints the
supply attributes can be either read-only or writable. I haven't dedicated much
thought to it, so a cannot state any pros and cons.

Any feedback is appreciated.

--
[1] http://lists.arm.linux.org.uk/lurker/message/20090413.125359.613f85ad.en.html

-- 
Sincerely yours,
Mike.




