Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZGBNs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZGBNs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbZGBNsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:48:43 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:53243 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbZGBNsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:48:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: chrisv@cyberswitching.com, daniel@caiaq.de, iws@ovro.caltech.edu,
       dmitry.torokhov@gmail.com, hmh@hmh.eng.br, david-b@pacbell.net,
       khali@linux-fr.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 00/14] IIO V4. Industrial I/O Subsystem
Date: Thu,  2 Jul 2009 13:47:30 +0000
Message-Id: <1246542464-6974-1-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Major changes since last version:

* Allocation of most internal structures now handled in a much
  simpler fashion - very close to how input does it.
* Moved to cdev based dynamic allocation of all chrdevs.
* Cleaner and more modular code.
* Now works fine with udev
* Patch series reordered in order to aid review by adding devices
  as soon as there is sufficient support.
* Software ring buffer code thoroughly reworked.  Now much
  more reliable.now reasonably happy with the core design so all
  comments on the contents of the first patch especially welcome.
* Numerous minor fixes, clarifications etc

As is readily apparent from the patches, some are still very much
at the proof of concept stage.  The periodic rtc trigger is a tempoary
stop gap until a more suitable timer interface is available. The gpio
trigger is very minimal. Finally the documenation clearly still needs
considerable refinement.

Thanks to everyone who has helped with comments on the previous versions
and to the users for bug reports etc.

All comments on any aspect so design or indeed specific elements of the
patches would be most welcome! More formal reviews also welcome if
anyone has time.  Suggestions relating to moving towards merging this
also particuarly welcome.

For now I'll still be reworking this patch set in response to reviews,
so I wouldn't suggest using the tree as the basis of development just yet.

git tree available at: (based on Linus' tree as of about 2 days ago)

git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio_v4.git
http://www.kernel.org/pub/scm/linux/kernel/git/jic23/iio_v4.git

Updated white paper describing the subsystem to appear in the
next few days.

Note that I'm still not all that convinced by the name.
Other suggestions would be most welcome.

Jonathan Cameron (14):
  IIO: core support for device registration and management
  IIO: max1363 ADC driver
  IIO: tsl2561 digital light sensor core support
  IIO: lis3l02dq accelerometer core support
  IIO: kxsd9 accelerometer minimal support
  IIO: Add generic ring buffer support to the IIO core
  IIO: VTI sca3000 series accelerometer driver (spi)
  IIO: Trigger support added to core.
  IIO: Ring buffer: Initial pass at rarely locked ring buffer
  IIO: lis3l02dq ring buffer and data ready trigger support
  IIO: max1363 add software ring buffer support using ring_sw
  IIO: Periodic timer based trigger
  IIO: Proof of concept gpio trigger
  IIO: Initial documentation

 Documentation/iio/device.txt                |   49 +
 Documentation/iio/iio_utils.h               |  163 +++
 Documentation/iio/lis3l02dqbuffersimple.c   |  172 +++
 Documentation/iio/overview.txt              |   62 ++
 Documentation/iio/ring.txt                  |   62 ++
 Documentation/iio/trigger.txt               |   38 +
 Documentation/iio/userspace.txt             |   60 ++
 drivers/Kconfig                             |    2 +
 drivers/Makefile                            |    1 +
 drivers/iio/Kconfig                         |   42 +
 drivers/iio/Makefile                        |   16 +
 drivers/iio/accel/Kconfig                   |   28 +
 drivers/iio/accel/Makefile                  |   11 +
 drivers/iio/accel/kxsd9.c                   |  395 +++++++
 drivers/iio/accel/lis3l02dq.h               |  232 ++++
 drivers/iio/accel/lis3l02dq_core.c          |  925 ++++++++++++++++
 drivers/iio/accel/lis3l02dq_ring.c          |  599 +++++++++++
 drivers/iio/accel/sca3000.h                 |  273 +++++
 drivers/iio/accel/sca3000_core.c            | 1509 +++++++++++++++++++++++++++
 drivers/iio/accel/sca3000_ring.c            |  334 ++++++
 drivers/iio/adc/Kconfig                     |   14 +
 drivers/iio/adc/Makefile                    |    8 +
 drivers/iio/adc/max1363.h                   |  269 +++++
 drivers/iio/adc/max1363_core.c              |  622 +++++++++++
 drivers/iio/adc/max1363_ring.c              |  235 +++++
 drivers/iio/industrialio-core.c             |  847 +++++++++++++++
 drivers/iio/industrialio-ring.c             |  566 ++++++++++
 drivers/iio/industrialio-trigger.c          |  400 +++++++
 drivers/iio/light/Kconfig                   |   14 +
 drivers/iio/light/Makefile                  |    5 +
 drivers/iio/light/tsl2561.c                 |  275 +++++
 drivers/iio/ring_sw.c                       |  431 ++++++++
 drivers/iio/trigger/Kconfig                 |   18 +
 drivers/iio/trigger/Makefile                |    5 +
 drivers/iio/trigger/iio-trig-gpio.c         |  203 ++++
 drivers/iio/trigger/iio-trig-periodic-rtc.c |  230 ++++
 include/linux/iio/accel.h                   |  167 +++
 include/linux/iio/adc.h                     |   13 +
 include/linux/iio/chrdev.h                  |  118 +++
 include/linux/iio/gpio_trigger.h            |    6 +
 include/linux/iio/iio.h                     |  411 ++++++++
 include/linux/iio/light.h                   |   12 +
 include/linux/iio/prtc_trigger.h            |    7 +
 include/linux/iio/ring_generic.h            |  283 +++++
 include/linux/iio/ring_hw.h                 |   22 +
 include/linux/iio/ring_sw.h                 |  189 ++++
 include/linux/iio/sca3000.h                 |   37 +
 include/linux/iio/sysfs.h                   |  293 ++++++
 include/linux/iio/trigger.h                 |  148 +++
 include/linux/iio/trigger_consumer.h        |   45 +
 50 files changed, 10866 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/iio/device.txt
 create mode 100644 Documentation/iio/iio_utils.h
 create mode 100644 Documentation/iio/lis3l02dqbuffersimple.c
 create mode 100644 Documentation/iio/overview.txt
 create mode 100644 Documentation/iio/ring.txt
 create mode 100644 Documentation/iio/trigger.txt
 create mode 100644 Documentation/iio/userspace.txt
 create mode 100644 drivers/iio/Kconfig
 create mode 100644 drivers/iio/Makefile
 create mode 100644 drivers/iio/accel/Kconfig
 create mode 100644 drivers/iio/accel/Makefile
 create mode 100644 drivers/iio/accel/kxsd9.c
 create mode 100644 drivers/iio/accel/lis3l02dq.h
 create mode 100644 drivers/iio/accel/lis3l02dq_core.c
 create mode 100644 drivers/iio/accel/lis3l02dq_ring.c
 create mode 100644 drivers/iio/accel/sca3000.h
 create mode 100644 drivers/iio/accel/sca3000_core.c
 create mode 100644 drivers/iio/accel/sca3000_ring.c
 create mode 100644 drivers/iio/adc/Kconfig
 create mode 100644 drivers/iio/adc/Makefile
 create mode 100644 drivers/iio/adc/max1363.h
 create mode 100644 drivers/iio/adc/max1363_core.c
 create mode 100644 drivers/iio/adc/max1363_ring.c
 create mode 100644 drivers/iio/industrialio-core.c
 create mode 100644 drivers/iio/industrialio-ring.c
 create mode 100644 drivers/iio/industrialio-trigger.c
 create mode 100644 drivers/iio/light/Kconfig
 create mode 100644 drivers/iio/light/Makefile
 create mode 100644 drivers/iio/light/tsl2561.c
 create mode 100644 drivers/iio/ring_sw.c
 create mode 100644 drivers/iio/trigger/Kconfig
 create mode 100644 drivers/iio/trigger/Makefile
 create mode 100644 drivers/iio/trigger/iio-trig-gpio.c
 create mode 100644 drivers/iio/trigger/iio-trig-periodic-rtc.c
 create mode 100644 include/linux/iio/accel.h
 create mode 100644 include/linux/iio/adc.h
 create mode 100644 include/linux/iio/chrdev.h
 create mode 100644 include/linux/iio/gpio_trigger.h
 create mode 100644 include/linux/iio/iio.h
 create mode 100644 include/linux/iio/light.h
 create mode 100644 include/linux/iio/prtc_trigger.h
 create mode 100644 include/linux/iio/ring_generic.h
 create mode 100644 include/linux/iio/ring_hw.h
 create mode 100644 include/linux/iio/ring_sw.h
 create mode 100644 include/linux/iio/sca3000.h
 create mode 100644 include/linux/iio/sysfs.h
 create mode 100644 include/linux/iio/trigger.h
 create mode 100644 include/linux/iio/trigger_consumer.h

