Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbZL1WCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbZL1WCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZL1WCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:02:22 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61514 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZL1WCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:02:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Qc3c4YmOzmOwfeeFLt/9PkXGYKoU2Sy1bDuLcgr7HkTodHKA1g4KfzC8uOTqe4HJUg
         UPyKo3eZK/y7g++cmDHDG2tBC8xD+qll3U+SkvlGgaiXxL/CMFMSk4afCBFm0cXWp6BD
         FcRzQd875P4wqo+MynwXd+8JzOD0Hvt6d48cU=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] USB: serial: fix DMA buffers on stack and endianess bugs
Date: Mon, 28 Dec 2009 23:01:44 +0100
Message-Id: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

These patches should address all remaining instances of DMA buffers on stack
(being passed to usb_control_msg) for the usb serial drivers. They also fix a
few endianess bugs I found along the way and do some minor clean up.

Note that I have not been able to test them on actual hardware, so please have
a go if you happen to have access to one of these devices.

Also note that these patches do not include the DMA-buffer-on-stack fix for
ftdi_sio i submitted a few days ago.

Cheers,
Johan


Johan Hovold (14):
  USB: ch341: replace printk warnings with dev_err
  USB: ch341: fix DMA buffer on stack
  USB: ch341: use le16_to_cpup to be explicit about endianess
  USB: cypress_m8: fix DMA buffer on stack
  USB: cypress_m8: fix endianess bug
  USB: io_ti: fix DMA buffers on stack
  USB: keyspan_pda: fix DMA buffers on stack
  USB: kl5kusb105: fix DMA buffers on stack
  USB: mct_u232: fix DMA buffers on stack
  USB: mos7720: fix DMA buffers on stack and clean up send_mos_cmd
  USB: mos7840: fix DMA buffers on stack and endianess bugs
  USB: oti6858: fix DMA buffer on stack
  USB: visor: fix DMA buffers on stack
  USB: kobil_sct: clean up kobil_set_termios

 drivers/usb/serial/ch341.c       |   24 +++++++++----
 drivers/usb/serial/cypress_m8.c  |   35 +++++++++++---------
 drivers/usb/serial/io_ti.c       |   66 +++++++++++++++++++++++++++----------
 drivers/usb/serial/keyspan_pda.c |   45 ++++++++++++++++++-------
 drivers/usb/serial/kl5kusb105.c  |   63 +++++++++++++++++++++++++----------
 drivers/usb/serial/kobil_sct.c   |   22 ++----------
 drivers/usb/serial/mct_u232.c    |   67 ++++++++++++++++++++++++++++++-------
 drivers/usb/serial/mos7720.c     |   34 +++++++++---------
 drivers/usb/serial/mos7840.c     |   22 ++++++++++--
 drivers/usb/serial/oti6858.c     |   13 ++++++--
 drivers/usb/serial/visor.c       |   26 ++++++++++----
 11 files changed, 282 insertions(+), 135 deletions(-)

