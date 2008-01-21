Return-Path: <linux-kernel-owner+w=401wt.eu-S1762509AbYAUX1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762509AbYAUX1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbYAUX1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:27:04 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:35731 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbYAUX1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:27:01 -0500
Date: Mon, 21 Jan 2008 17:15:57 -0600
From: David Fries <david@fries.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org
Subject: W1: w1_slave units, standardize 1C or .001C?  Break API
Message-ID: <20080121231557.GA4025@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 21 Jan 2008 17:15:58 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ds18b20 one wire temperature sensor conversion routine is
returning the units in degrees C while the ds1820 (ds18s20) is
returning it in .001 degrees C.  20C vs 20312C.  Once you know the
units I'm liking the latter as it gives a higher precision.  Time to
break user applications so the driver can give the temperature in the
same units for both sensors.

I only have the ds18b20 sensor model.  Here is the current output from
the sys file for this sensor.
/sys/devices/w1_bus_master1/28-0000000e84a2/w1_slave
45 01 4b 46 7f ff 0b 10 84 : crc=84 YES
45 01 4b 46 7f ff 0b 10 84 t=20

I ran the example data from the specification for the ds1820 through
it's conversion routine and found that t= was 1000 times the value.  
What should the displayed units be?  

This is the same ds18b20 conversion *1000.  Is everyone ok or is any
objecting to .001 degrees C for the units?  Patch will follow.  The
.001 C does truncate one bit of precision from the ds18b20 by the way.

45 01 4b 46 7f ff 0b 10 84 : crc=84 YES
45 01 4b 46 7f ff 0b 10 84 t=20312

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
