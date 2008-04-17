Return-Path: <linux-kernel-owner+w=401wt.eu-S932405AbYDQBSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbYDQBSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbYDQBIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:01 -0400
Received: from sous-sol.org ([216.99.217.87]:58898 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759712AbYDQBIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:00 -0400
Message-Id: <20080417010335.509793955@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:44 -0700
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
       Clark Rawlins <clark.rawlins@escient.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: USB: Allow initialization of broken keyspan serial adapters.
Content-Disposition: inline; filename=usb-allow-initialization-of-broken-keyspan-serial-adapters.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Clark Rawlins <clark.rawlins@escient.com>

upstream commit: 822470537d0fc1dee38a2a9c8b8c398bfbb332bb

Fixes the keyspan driver after the addition of additional
checking of driver requirements introduced in usb-serial.c
commit 063a2da8f01806906f7d7b1a1424b9afddebc443.  The initialization
of the keyspan usb_serial_driver structs were not initializing the
num_interrupt_out field and the additional checking was rejecting
the end point so the driver wouldn't finish initializing.

This commit initializes the fields to NUM_DONT_CARE.
It works for the keyspan USA-49WG and doesn't break the USA-19HS
which are the two keyspan devices I have to test with.

Signed-off-by: Clark Rawlins <clark.rawlins@escient.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/usb/serial/keyspan.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/keyspan.h
+++ b/drivers/usb/serial/keyspan.h
@@ -637,6 +637,7 @@ static struct usb_serial_driver keyspan_
 	.description		= "Keyspan - (without firmware)",
 	.id_table		= keyspan_pre_ids,
 	.num_interrupt_in	= NUM_DONT_CARE,
+	.num_interrupt_out	= NUM_DONT_CARE,
 	.num_bulk_in		= NUM_DONT_CARE,
 	.num_bulk_out		= NUM_DONT_CARE,
 	.num_ports		= 1,
@@ -651,6 +652,7 @@ static struct usb_serial_driver keyspan_
 	.description		= "Keyspan 1 port adapter",
 	.id_table		= keyspan_1port_ids,
 	.num_interrupt_in	= NUM_DONT_CARE,
+	.num_interrupt_out	= NUM_DONT_CARE,
 	.num_bulk_in		= NUM_DONT_CARE,
 	.num_bulk_out		= NUM_DONT_CARE,
 	.num_ports		= 1,
@@ -678,6 +680,7 @@ static struct usb_serial_driver keyspan_
 	.description		= "Keyspan 2 port adapter",
 	.id_table		= keyspan_2port_ids,
 	.num_interrupt_in	= NUM_DONT_CARE,
+	.num_interrupt_out	= NUM_DONT_CARE,
 	.num_bulk_in		= NUM_DONT_CARE,
 	.num_bulk_out		= NUM_DONT_CARE,
 	.num_ports		= 2,
@@ -705,6 +708,7 @@ static struct usb_serial_driver keyspan_
 	.description		= "Keyspan 4 port adapter",
 	.id_table		= keyspan_4port_ids,
 	.num_interrupt_in	= NUM_DONT_CARE,
+	.num_interrupt_out	= NUM_DONT_CARE,
 	.num_bulk_in		= NUM_DONT_CARE,
 	.num_bulk_out		= NUM_DONT_CARE,
 	.num_ports		= 4,

-- 
