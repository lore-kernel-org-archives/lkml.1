Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbZLaPsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbZLaPsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZLaPso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:48:44 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41339 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbZLaPsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:48:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dKEP47mXQ6Xss9hBlNC/1QpEA8DCbP4E7H8IgRWpQBsDM26FBC+NnXsHH4wpk2h0FY
         le9vEqEisOZQkw/e8m0HkCpySb7l1BuSdTuhPMm6wbLnduk6D8+2WMQtaXAKM5p5C+KX
         p34HfxNb3t8Gmq4idVLVxzzk/pHX1w9mmTsCg=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/13][v2] USB: serial: fix DMA buffers on stack and endianess bugs
Date: Thu, 31 Dec 2009 16:47:56 +0100
Message-Id: <1262274489-12447-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

Here's an updated series rebased against rc2 with all patches from Greg's tree
applied. The mct_u232 patch has been dropped as it had already been fixed. I
also updated the ch341 and cypress_m8 patches to use the unaligned macros. 

Johan


Johan Hovold (13):
  USB: ch341: replace printk warnings with dev_err
  USB: ch341: fix DMA buffer on stack
  USB: ch341: use get_unaligned_le16 in break_ctl
  USB: cypress_m8: fix DMA buffer on stack
  USB: cypress_m8: fix endianess bug and alignment
  USB: io_ti: fix DMA buffers on stack
  USB: keyspan_pda: fix DMA buffers on stack
  USB: kl5kusb105: fix DMA buffers on stack
  USB: mos7720: fix DMA buffers on stack and clean up send_mos_cmd
  USB: mos7840: fix DMA buffers on stack and endianess bugs
  USB: oti6858: fix DMA buffer on stack
  USB: visor: fix DMA buffers on stack
  USB: kobil_sct: clean up kobil_set_termios

 drivers/usb/serial/ch341.c       |   25 ++++++++++----
 drivers/usb/serial/cypress_m8.c  |   36 +++++++++++---------
 drivers/usb/serial/io_ti.c       |   66 +++++++++++++++++++++++++++----------
 drivers/usb/serial/keyspan_pda.c |   45 +++++++++++++++++++-------
 drivers/usb/serial/kl5kusb105.c  |   63 ++++++++++++++++++++++++++----------
 drivers/usb/serial/kobil_sct.c   |   22 ++----------
 drivers/usb/serial/mos7720.c     |   34 ++++++++++----------
 drivers/usb/serial/mos7840.c     |   22 ++++++++++--
 drivers/usb/serial/oti6858.c     |   13 ++++++--
 drivers/usb/serial/visor.c       |   26 ++++++++++----
 10 files changed, 230 insertions(+), 122 deletions(-)
