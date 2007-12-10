Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbXLJEwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbXLJEwJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 23:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXLJEv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 23:51:56 -0500
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:28962 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751211AbXLJEvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 23:51:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=GbcN4+XyFTAbA1d6mmEGx014wJeUahyCr/ENvHH3meA4zIKW/i8XM57nx8f3b8+GATkXz8RhxUz1gr3xMVSFjYS/cqEfpzUg7Ik9Sxx9X9NCv1rJcfCd6I9dKBoM/5B/KkZPZRZf0ROJYk94l0wWEyd8VM1UIgL2GqP+E7uMPd4=  ;
X-YMail-OSG: WQhRw5UVM1m4qLNw91xHa6dbjIirSeC5AmiLjLAg.xxQzYD5Wt2c0AvJ0sNakD_iqRDZFmBUAn859TMVbpsjRNmOIn0o4zWP5goZzgA6dxEtU9r16IE-
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc4-mm 0/6] gpiolib updates
Date: Sun, 9 Dec 2007 20:34:59 -0800
User-Agent: KMail/1.9.6
Cc: eric miao <eric.y.miao@marvell.com>, Jean Delvare <khali@linux-fr.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712092034.59924.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following this are several patches updating the current gpio
implemenentation framework.  Because one of those changes
involves creating a new drivers/gpio directory, the patches
are a bit simpler if two existing patches are first removed
from the MM tree:

	mcp23s08-spi-gpio-expander.patch
	mcp23s08-spi-gpio-expander-checkpatch-fixes.patch

The patches in this series are:

 - Adding a gpio_desc[] layer, making it easier to mix in
   gpio_chips with different numbers of GPIOs without any
   large holes in the number sequence.  When those holes
   are also reflected in IRQ number sequences, they cost
   a lot of memory.  (Based on work from Eric Miao.)

 - More diagnostics with CONFIG_DEBUG_GPIO.  Handy when
   bringing up a new board, needless later.  (Various
   platforms had similar diagnostics.)

 - A bit of implementor-oriented documentation for this
   gpiolib infrastructure.

 - Create a new drivers/gpio directory for expanders and
   (eventually) other code.  (Strongly encouraged by
   Jean Delvare, to help shrink drivers/i2c/chips.)

 - New-style I2C driver for pcf8574/pcf8575/compatible
   GPIO expanders ... these are pretty widely used.
   (This was previously posted as patch/rfc.)

 - Relocated mcp23s08 driver.  This includes two minor
   functional changes, to handle the gpio_desc changes
   and modified driver init sequence, and it merges the
   minor checkpatch.pl update above.

There's an updated pca9539 driver in the works too; it
should land in the drivers/i2c directory.

I'm thinking there should be a non-functional change to
the gpiolib code:  move it from lib to drivers/gpio.

My question is whether that's better done by replacing
the current patches with one new patch, or by a patch
deleting the current lib/gpiolib.c and adding a new
drivers/gpio/gpiolib.c ... I think the former would
make more sense to anyone looking at GIT history.

- Dave
