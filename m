Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbYJNQEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbYJNQEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 12:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYJNQEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 12:04:23 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:41502 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYJNQEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 12:04:23 -0400
Date: Tue, 14 Oct 2008 18:03:33 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.28, round 1
Message-ID: <20081014180333.55d9004a@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the first round of i2c subsystem updates for Linux 2.6.28
from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

There is one new i2c bus driver (i2c-highlander), support for new VIA
chips (VX800/VX820), documentation updates and many random fixes.

 Documentation/i2c/busses/i2c-viapro    |    8 +-
 Documentation/i2c/dev-interface        |  110 ++++++--
 Documentation/i2c/smbus-protocol       |    4 +-
 Documentation/i2c/writing-clients      |    4 +-
 arch/arm/mach-omap1/board-h3.c         |    4 +
 arch/arm/mach-omap2/board-h4.c         |   11 +
 drivers/hwmon/dme1737.c                |  320 ++++++++++-----------
 drivers/i2c/busses/Kconfig             |   20 +-
 drivers/i2c/busses/Makefile            |    1 +
 drivers/i2c/busses/i2c-highlander.c    |  498 ++++++++++++++++++++++++++++++++
 drivers/i2c/busses/i2c-parport-light.c |   39 +--
 drivers/i2c/busses/i2c-pca-isa.c       |   20 +-
 drivers/i2c/busses/i2c-viapro.c        |   17 +-
 drivers/i2c/chips/isp1301_omap.c       |  141 ++++------
 drivers/i2c/chips/tps65010.c           |   12 +-
 drivers/i2c/i2c-core.c                 |   35 +++-
 16 files changed, 918 insertions(+), 326 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-highlander.c

---------------

David Brownell (2):
      i2c: Guard against oopses from bad init sequences
      i2c: Do earlier driver model init

Felipe Balbi (1):
      i2c/isp1301_omap: Convert to a new-style i2c driver, part 1

Jean Delvare (7):
      i2c/isp1301_omap: Convert to a new-style i2c driver, part 2
      hwmon: (dme1737) Be less i2c-centric
      hwmon: (dme1737) Convert to a new-style i2c driver
      i2c-parport-light: Don't register a platform device resource
      i2c: Improve dev-interface documentation
      i2c: Document the implementation details of the /dev interface
      i2c: Only build Tyan SMBus mux drivers on x86

Marek Vasut (1):
      i2c/tps65010: Vibrator hookup to gpiolib

Paul Mundt (1):
      i2c: Renesas Highlander FPGA SMBus support

Prakash Mortha (2):
      i2c: Restore i2c_smbus_process_call function
      i2c-viapro: Add support for SMBus Process Call transactions

Rene Herman (1):
      i2c-pca-isa: Don't grab arbitrary resources

Rudolf Marek (1):
      i2c-viapro: Add VX800/VX820 support

Thanks,
-- 
Jean Delvare
