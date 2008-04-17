Return-Path: <linux-kernel-owner+w=401wt.eu-S933868AbYDQB0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbYDQB0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761062AbYDQBJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:18 -0400
Received: from sous-sol.org ([216.99.217.87]:58985 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760139AbYDQBJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:17 -0400
Message-Id: <20080417010337.278890290@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:46 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Spanton <rspanton@zepler.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: USB: serial: ti_usb_3410_5052: Correct TUSB3410 endpoint requirements.
Content-Disposition: inline; filename=usb-serial-ti_usb_3410_5052-correct-tusb3410-endpoint-requirements.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Robert Spanton <rspanton@zepler.net>

upstream commit: 1bfd6693cd66f1e79abce62d3e8c3647e1f59a55

The changes introduced in commit
063a2da8f01806906f7d7b1a1424b9afddebc443 changed the semantics of the
num_interrupt_in, num_interrupt_out, num_bulk_in and num_bulk_out
entries of the usb_serial_driver struct to be the number of endpoints
the device has when probed.

This patch changes the ti_1port_device usb_serial_driver struct to
reflect this change.  The single port devices only have 1
bulk_out endpoint in their initial configuration, and so this patch
changes the number of other types to NUM_DONT_CARE.

The same change probably needs doing to the ti_2port_device struct,
but I don't have a two port device at hand.

Signed-off-by: Robert Spanton <rspanton@zepler.net>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/serial/ti_usb_3410_5052.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -264,8 +264,8 @@ static struct usb_serial_driver ti_1port
 	.description		= "TI USB 3410 1 port adapter",
 	.usb_driver		= &ti_usb_driver,
 	.id_table		= ti_id_table_3410,
-	.num_interrupt_in	= 1,
-	.num_bulk_in		= 1,
+	.num_interrupt_in	= NUM_DONT_CARE,
+	.num_bulk_in		= NUM_DONT_CARE,
 	.num_bulk_out		= 1,
 	.num_ports		= 1,
 	.attach			= ti_startup,

-- 
