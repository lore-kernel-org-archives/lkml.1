Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbZAJN2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbZAJN2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZAJN2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:28:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:5377 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZAJN2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:28:34 -0500
Date: Sat, 10 Jan 2009 14:28:30 +0100
From: Erik Ekman <erik@kryo.se>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [STAGING] comedi breaks build
Message-Id: <20090110142830.26ad46b8.erik@kryo.se>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comedi does not build:

drivers/staging/comedi/kcomedilib/built-in.o: In function `comedi_unmap':
(.text+0x499): multiple definition of `comedi_unmap'
drivers/staging/comedi/comedi.o:(.text+0x18): first defined here
make[3]: *** [drivers/staging/comedi/built-in.o] Error 1
make[2]: *** [drivers/staging/comedi] Error 2
make[1]: *** [drivers/staging] Error 2

comedi_unmap() exists both in
drivers/staging/comedi/kcomedilib/kcomedilib_main.c and
drivers/staging/comedi/comedi_fops.c

.config extract:

CONFIG_STAGING=y
# CONFIG_STAGING_EXCLUDE_BUILD is not set
# CONFIG_ET131X is not set
# CONFIG_SLICOSS is not set
# CONFIG_ME4000 is not set
# CONFIG_MEILHAUS is not set
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_USB_IP_COMMON is not set
# CONFIG_W35UND is not set
# CONFIG_PRISM2_USB is not set
# CONFIG_ECHO is not set
# CONFIG_USB_ATMEL is not set
# CONFIG_AGNX is not set
# CONFIG_OTUS is not set
# CONFIG_RT2860 is not set
# CONFIG_RT2870 is not set
# CONFIG_BENET is not set
CONFIG_COMEDI=y
# CONFIG_COMEDI_PCI_DRIVERS is not set
# CONFIG_COMEDI_USB_DRIVERS is not set
# CONFIG_ASUS_OLED is not set
# CONFIG_PANEL is not set
# CONFIG_ALTERA_PCIE_CHDMA is not set
# CONFIG_RTL8187SE is not set
# CONFIG_INPUT_MIMIO is not set
# CONFIG_TRANZPORT is not set

Found when doing a make randconfig.

/Erik
