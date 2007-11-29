Return-Path: <linux-kernel-owner+w=401wt.eu-S934166AbXK2Wzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166AbXK2Wzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933664AbXK2WxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:53:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933485AbXK2WxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:53:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 5/9] USB: net2280 can't have a function called
	show_registers() [2.6.24-rc3-mm2]
To: akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Thu, 29 Nov 2007 22:52:40 +0000
Message-ID: <20071129225240.21536.25336.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071129225219.21536.58653.stgit@warthog.procyon.org.uk>
References: <20071129225219.21536.58653.stgit@warthog.procyon.org.uk>
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
index 33469cf..e018623 100644
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

