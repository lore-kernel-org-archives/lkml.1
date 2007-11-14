Return-Path: <linux-kernel-owner+w=401wt.eu-S1763175AbXKNAV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763175AbXKNAV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759740AbXKNATL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:19:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762004AbXKNATJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:19:09 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/9] USB: net2280 can't have a function called
	show_registers() [try #6]
To: torvalds@osdl.org, akpm@linux-foundation.org, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Wed, 14 Nov 2007 00:19:03 +0000
Message-ID: <20071114001903.27662.50965.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
References: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

net2280 can't have a function called show_registers() because this can produce
a namespace clash with an arch function of the same name.

All this driver's functions and variables should really be prefixed with
"net2280_" to avoid such a problem in future.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/usb/gadget/net2280.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index d5d473f..8afe3a4 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -1418,8 +1418,8 @@ show_function (struct device *_dev, struct device_attribute *attr, char *buf)
 }
 static DEVICE_ATTR (function, S_IRUGO, show_function, NULL);
 
-static ssize_t
-show_registers (struct device *_dev, struct device_attribute *attr, char *buf)
+static ssize_t net2280_show_registers(struct device *_dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct net2280		*dev;
 	char			*next;
@@ -1571,7 +1571,7 @@ show_registers (struct device *_dev, struct device_attribute *attr, char *buf)
 
 	return PAGE_SIZE - size;
 }
-static DEVICE_ATTR (registers, S_IRUGO, show_registers, NULL);
+static DEVICE_ATTR(registers, S_IRUGO, net2280_show_registers, NULL);
 
 static ssize_t
 show_queues (struct device *_dev, struct device_attribute *attr, char *buf)

