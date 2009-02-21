Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbZBUTtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbZBUTtj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 14:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZBUTtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 14:49:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47258 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZBUTta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 14:49:30 -0500
Date: Sat, 21 Feb 2009 19:48:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean Delvare <khali@linux-fr.org>, Wolfram Sang <w.sang@pengutronix.de>,
       Juergen Beisert <j.beisert@pengutronix.de>,
       Alessandro Zummo <a.zummo@towertech.it>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux-arm@fluff.org>, linux-kernel@vger.kernel.org
Subject: Fwd: PCF8583 not detected on RiscPC
Message-ID: <20090221194814.GA24385@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous mail sent just to Jean:

| Any ideas why the RTC isn't being detected on the ARM RiscPC platform?
| 
| Could it be because someone's decided to regress stuff because of having
| an i2c_boardinfo structure without actually first making sure everything
| is converted over?
| 
| If yes, what do I need to do to make it work?  (IOW, please supply a
| patch to fix the regression or explain in detail what's required to make
| it work.)

To summarise the situation, the bus driver is:

drivers/i2c/busses/i2c-acorn.c

which is not a platform driver.  It is not initialised by the platform
code.  It does not provide i2c_boarddata or whatever the funky name for
that feature is.

However, PCF8583 got converted to require i2c_boarddata without first
fixing up the platform which uses it, thereby making the driver utterly
useless.

Putting i2c_boarddata into i2c-acorn.c feels wrong.

So, please either revert 02bb584f3b1cfc8188522a4d2c8881b65073a4f1 so
that the regression can be fixed (no RTC on Acorn RiscPC machines) or
provide a patch which fixes this mess that the above change causes.
