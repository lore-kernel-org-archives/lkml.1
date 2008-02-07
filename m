Return-Path: <linux-kernel-owner+w=401wt.eu-S934587AbYBGVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934587AbYBGVBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762236AbYBGUv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:51:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:38492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932929AbYBGUvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:51:53 -0500
Date: Thu, 7 Feb 2008 12:47:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, linux-usb@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stefan Bader <stefan.bader@canonical.com>, Alan Cox <alan@redhat.com>
Subject: [patch 22/45] USB: Fix usb_serial_driver structure for Kobil
	cardreader driver.
Message-ID: <20080207204729.GW16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-usb_serial_driver-structure-for-kobil-cardreader-driver.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stefan Bader <stefan.bader@canonical.com>

The device setup did miss to initialize the num_interrupt_out field, thus
failing to successfully complete the probe function.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/kobil_sct.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -114,6 +114,7 @@ static struct usb_serial_driver kobil_de
 	.usb_driver = 		&kobil_driver,
 	.id_table =		id_table,
 	.num_interrupt_in =	NUM_DONT_CARE,
+	.num_interrupt_out = 	NUM_DONT_CARE,
 	.num_bulk_in =		0,
 	.num_bulk_out =		0,
 	.num_ports =		1,

-- 
