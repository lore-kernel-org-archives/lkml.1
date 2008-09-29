Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbYI2QRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbYI2QRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 12:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYI2QRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 12:17:25 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:43540 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYI2QRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 12:17:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=cZwcMVYCseI7GpsBb/0jEXBdHkPscZAt/dUCay8kV55zR5hOju1bkm8IqDify/pJkk
         BRpgEjq0w32Y6IUifmfdWhABql0aVKYXKnWoFYSSVfxSjE1anY1bUzLorTDMmN9215dn
         Q0VX/nZK0cFjevsX0txq+w/5Nr3W4ShLyM7FI=
From: Jon Smirl <jonsmirl@gmail.com>
Subject: [RFC PATCH 0/4] Implementation of IR support using the input subsystem
To: linux-kernel@vger.kernel.org, lirc-list@lists.sourceforge.net,
       lirc@bartelmus.de
Date: Mon, 29 Sep 2008 12:17:20 -0400
Message-ID: <20080929155506.14559.35166.stgit@terra>
User-Agent: StGIT/0.14.3.224.g199b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second pass at implementing evdev support for IR. The goal of in-kernel IR is to integrate IR events into the evdev input event queue and maintain ordering of events from all input devices.

Note that user space IR device drivers can use the existing support in evdev to inject events into the input queue.

Send and receive are implemented. Received IR messages are decoded and sent to user space as input messages. Send is done via an IOCTL on the input device.

Two drivers are supplied. mceusb2 implements send and receive support for the Microsoft USB IR dongle. 

The GPT driver implements receive only support for a GPT pin - GPT is a GPIO with a timer attached.

Encoders and decoders have not been written for all protocols. Repeat is not handled for any protocol. 
I'm looking for help. There are 15 more existing LIRC drivers.

---

Jon Smirl (4):
      Microsoft mceusb2 driver for in-kernel IR subsystem
      GPT driver for in-kernel IR support.
      Example of PowerPC device tree support for GPT based IR
      Changes to core input subsystem to allow send and receive of IR messages. Encode and decode state machines are provided for common IR porotocols such as Sony, JVC, NEC, Philips, etc.


 arch/powerpc/boot/dts/dspeak01.dts |   19 -
 drivers/input/Kconfig              |    2 
 drivers/input/Makefile             |    3 
 drivers/input/evdev.c              |   55 +++
 drivers/input/input.c              |    4 
 drivers/input/ir-core.c            |  523 ++++++++++++++++++++++++++
 drivers/input/ir/Kconfig           |   26 +
 drivers/input/ir/Makefile          |    7 
 drivers/input/ir/ir-gpt.c          |  214 +++++++++++
 drivers/input/ir/ir-mceusb2.c      |  729 ++++++++++++++++++++++++++++++++++++
 include/linux/input.h              |   70 +++
 11 files changed, 1640 insertions(+), 12 deletions(-)
 create mode 100644 drivers/input/ir-core.c
 create mode 100644 drivers/input/ir/Kconfig
 create mode 100644 drivers/input/ir/Makefile
 create mode 100644 drivers/input/ir/ir-gpt.c
 create mode 100644 drivers/input/ir/ir-mceusb2.c

-- 
Jon Smirl
jonsmirl@gmail.com
