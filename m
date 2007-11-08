Return-Path: <linux-kernel-owner+w=401wt.eu-S1761846AbXKHRRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761846AbXKHRRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 12:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760955AbXKHRQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 12:16:43 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760741AbXKHRQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 12:16:36 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/6] USB: net2280 can't have a function called
	show_registers() [try #4]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Thu, 08 Nov 2007 17:16:27 +0000
Message-ID: <20071108171627.26590.4576.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071108171612.26590.4348.stgit@warthog.procyon.org.uk>
References: <20071108171612.26590.4348.stgit@warthog.procyon.org.uk>
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

 drivers/usb/gadget/net2280.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index d5d473f..9e14d98 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -1419,7 +1419,7 @@ show_function (struct device *_dev, struct device_attribute *attr, char *buf)
 static DEVICE_ATTR (function, S_IRUGO, show_function, NULL);
 
 static ssize_t
-show_registers (struct device *_dev, struct device_attribute *attr, char *buf)
+net2280_show_registers (struct device *_dev, struct device_attribute *attr, char *buf)
 {
 	struct net2280		*dev;
 	char			*next;
@@ -1571,7 +1571,7 @@ show_registers (struct device *_dev, struct device_attribute *attr, char *buf)
 
 	return PAGE_SIZE - size;
 }
-static DEVICE_ATTR (registers, S_IRUGO, show_registers, NULL);
+static DEVICE_ATTR (registers, S_IRUGO, net2280_show_registers, NULL);
 
 static ssize_t
 show_queues (struct device *_dev, struct device_attribute *attr, char *buf)

