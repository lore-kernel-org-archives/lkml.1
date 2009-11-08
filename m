Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZKHNe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZKHNe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZKHNez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:34:55 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39138 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZKHNey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:34:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=VQw2teBJL+VyABdnivEqxxp7PgYgxClfkODdLc/avAEx6EeiCJ6bd6VtBXK71SX9XL
         v0xB+nnPBhRJb/ikdKg2poh6cHo/z85sYLRyYtwDrwsQlp265Ik02rAWYmTWu85aW+6I
         zS0oqR2xIAAxdKIDwZFpXhvYIwd1DkeuClsHo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [git patches] rt2800 drivers updates
Date: Sun, 8 Nov 2009 14:33:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200911081433.32005.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Another bunch of updates for rt2800 drivers, this time:

- unify rt2800 drivers some more removing another 300 LOC in the process
  (rt2800pci is down to 1.5 KLOC now)

- add missing RF values to rt2800pci driver

- add eFuse EEPROM support to rt2800usb
  (needed for RT3070 and maybe some other chips)

- fix RX descriptor naming in rt2800usb

I've also merged recent rt2x00 patches from Gertjan to my tree to not
waste time on eventually synchronizing rt2x00 / rt2800 trees later.

Oh, there is also an unrelated bonus change to rt2500usb driver present
(removal of dead link tuning code which kills 130 LOC).

I'll post new patches to linux-wireless for review in few minutes.


The following changes since commit 93f65fc385c7cca807826ce7f7a76c7429849331:
  Bartlomiej Zolnierkiewicz (1):
        rt2800: add rt2800lib (part four)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git rt2800

Bartlomiej Zolnierkiewicz (10):
      rt2800: prepare for unification of EEPROM support code
      rt2800: unify EEPROM support code
      rt2800pci: add missing RF values to rf_vals table
      rt2800usb: reorganize code in rt2800usb_probe_hw_mode()
      rt2800: prepare for rt2800*_probe_hw_mode() unification
      rt2800: unify rt2800*_probe_hw_mode()
      rt2800usb: fix RX descriptor naming
      rt2800: add eFuse EEPROM support code to rt2800lib
      rt2800usb: add eFuse EEPROM support
      rt2500usb: remove dead link tuning code

Gertjan van Wingerde (3):
      rt2x00: Mark rt2800pci as broken.
      rt2x00: Move interface type assignments to generic code.
      rt2x00: Add dynamic detection of eFuse EEPROM in rt2800pci.

 drivers/net/wireless/rt2x00/Kconfig     |    7 +-
 drivers/net/wireless/rt2x00/rt2500usb.c |  134 ---------
 drivers/net/wireless/rt2x00/rt2800.h    |   29 ++
 drivers/net/wireless/rt2x00/rt2800lib.c |  460 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |    6 +
 drivers/net/wireless/rt2x00/rt2800pci.c |  406 ++--------------------------
 drivers/net/wireless/rt2x00/rt2800pci.h |   28 --
 drivers/net/wireless/rt2x00/rt2800usb.c |  411 +--------------------------
 drivers/net/wireless/rt2x00/rt2800usb.h |   40 ++--
 drivers/net/wireless/rt2x00/rt2x00pci.c |    2 +
 drivers/net/wireless/rt2x00/rt2x00soc.c |    5 +
 drivers/net/wireless/rt2x00/rt2x00usb.c |    2 +
 12 files changed, 556 insertions(+), 974 deletions(-)
