Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbZKDRf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbZKDRf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:35:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932399AbZKDRfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:35:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:40568 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbZKDRfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:35:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=izWAsP2YEQo83jn7DuDj6V5DikfCrDg5vgA+g/9xbiYx0i0qMFDiJBSSQ3PMK8vRi6
         qJOKDRH88S29k9CmiKlmfgJMLyEnxrvgnisSaOWfB6NYjgEiXdCcc6rAdoYNyh8xi3ch
         PuAhooXZGlDe4RAn7AVvTYeNXj130eV9Yn6uQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:35:32 +0100
Message-Id: <20091104173532.28463.33083.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 29/41] rt2800: add rt2800lib.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800: add rt2800lib.h

Code unification.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.h |   99 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 
 drivers/net/wireless/rt2x00/rt2800pci.h |   76 ------------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 
 drivers/net/wireless/rt2x00/rt2800usb.h |   75 ------------------------
 5 files changed, 101 insertions(+), 151 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2800lib.h
===================================================================
--- /dev/null
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -0,0 +1,99 @@
+/*
+	Copyright (C) 2009 Bartlomiej Zolnierkiewicz
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the
+	Free Software Foundation, Inc.,
+	59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef RT2800LIB_H
+#define RT2800LIB_H
+
+struct rt2800_ops {
+	void (*register_read)(struct rt2x00_dev *rt2x00dev,
+			      const unsigned int offset, u32 *value);
+	void (*register_write)(struct rt2x00_dev *rt2x00dev,
+			       const unsigned int offset, u32 value);
+	void (*register_write_lock)(struct rt2x00_dev *rt2x00dev,
+				    const unsigned int offset, u32 value);
+
+	void (*register_multiread)(struct rt2x00_dev *rt2x00dev,
+				   const unsigned int offset,
+				   void *value, const u32 length);
+	void (*register_multiwrite)(struct rt2x00_dev *rt2x00dev,
+				    const unsigned int offset,
+				    const void *value, const u32 length);
+
+	int (*regbusy_read)(struct rt2x00_dev *rt2x00dev,
+			    const unsigned int offset,
+			    const struct rt2x00_field32 field, u32 *reg);
+};
+
+static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
+					const unsigned int offset,
+					u32 *value)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_read(rt2x00dev, offset, value);
+}
+
+static inline void rt2800_register_write(struct rt2x00_dev *rt2x00dev,
+					 const unsigned int offset,
+					 u32 value)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_write(rt2x00dev, offset, value);
+}
+
+static inline void rt2800_register_write_lock(struct rt2x00_dev *rt2x00dev,
+					      const unsigned int offset,
+					      u32 value)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_write_lock(rt2x00dev, offset, value);
+}
+
+static inline void rt2800_register_multiread(struct rt2x00_dev *rt2x00dev,
+					     const unsigned int offset,
+					     void *value, const u32 length)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_multiread(rt2x00dev, offset, value, length);
+}
+
+static inline void rt2800_register_multiwrite(struct rt2x00_dev *rt2x00dev,
+					      const unsigned int offset,
+					      const void *value,
+					      const u32 length)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	rt2800ops->register_multiwrite(rt2x00dev, offset, value, length);
+}
+
+static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
+				      const unsigned int offset,
+				      const struct rt2x00_field32 field,
+				      u32 *reg)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
+}
+
+#endif /* RT2800LIB_H */
Index: b/drivers/net/wireless/rt2x00/rt2800pci.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -37,6 +37,7 @@
 #include "rt2x00.h"
 #include "rt2x00pci.h"
 #include "rt2x00soc.h"
+#include "rt2800lib.h"
 #include "rt2800pci.h"
 
 #ifdef CONFIG_RT2800PCI_PCI_MODULE
Index: b/drivers/net/wireless/rt2x00/rt2800pci.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800pci.h
+++ b/drivers/net/wireless/rt2x00/rt2800pci.h
@@ -27,82 +27,6 @@
 #ifndef RT2800PCI_H
 #define RT2800PCI_H
 
-struct rt2800_ops {
-	void (*register_read)(struct rt2x00_dev *rt2x00dev,
-			      const unsigned int offset, u32 *value);
-	void (*register_write)(struct rt2x00_dev *rt2x00dev,
-			       const unsigned int offset, u32 value);
-	void (*register_write_lock)(struct rt2x00_dev *rt2x00dev,
-				    const unsigned int offset, u32 value);
-
-	void (*register_multiread)(struct rt2x00_dev *rt2x00dev,
-				   const unsigned int offset,
-				   void *value, const u32 length);
-	void (*register_multiwrite)(struct rt2x00_dev *rt2x00dev,
-				    const unsigned int offset,
-				    const void *value, const u32 length);
-
-	int (*regbusy_read)(struct rt2x00_dev *rt2x00dev,
-			    const unsigned int offset,
-			    const struct rt2x00_field32 field, u32 *reg);
-};
-
-static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
-					const unsigned int offset,
-					u32 *value)
-{
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
-
-	rt2800ops->register_read(rt2x00dev, offset, value);
-}
-
-static inline void rt2800_register_write(struct rt2x00_dev *rt2x00dev,
-					 const unsigned int offset,
-					 u32 value)
-{
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
-
-	rt2800ops->register_write(rt2x00dev, offset, value);
-}
-
-static inline void rt2800_register_write_lock(struct rt2x00_dev *rt2x00dev,
-					      const unsigned int offset,
-					      u32 value)
-{
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
-
-	rt2800ops->register_write_lock(rt2x00dev, offset, value);
-}
-
-static inline void rt2800_register_multiread(struct rt2x00_dev *rt2x00dev,
-					     const unsigned int offset,
-					     void *value, const u32 length)
-{
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
-
-	rt2800ops->register_multiread(rt2x00dev, offset, value, length);
-}
-
-static inline void rt2800_register_multiwrite(struct rt2x00_dev *rt2x00dev,
-					      const unsigned int offset,
-					      const void *value,
-					      const u32 length)
-{
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
-
-	rt2800ops->register_multiwrite(rt2x00dev, offset, value, length);
-}
-
-static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
-				      const unsigned int offset,
-				      const struct rt2x00_field32 field,
-				      u32 *reg)
-{
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
-
-	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
-}
-
 /*
  * RF chip defines.
  *
Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -34,6 +34,7 @@
 
 #include "rt2x00.h"
 #include "rt2x00usb.h"
+#include "rt2800lib.h"
 #include "rt2800usb.h"
 
 /*
Index: b/drivers/net/wireless/rt2x00/rt2800usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -27,81 +27,6 @@
 #ifndef RT2800USB_H
 #define RT2800USB_H
 
-struct rt2800_ops {
-	void (*register_read)(struct rt2x00_dev *rt2x00dev,
-			      const unsigned int offset, u32 *value);
-	void (*register_write)(struct rt2x00_dev *rt2x00dev,
-			       const unsigned int offset, u32 value);
-	void (*register_write_lock)(struct rt2x00_dev *rt2x00dev,
-				    const unsigned int offset, u32 value);
-
-	void (*register_multiread)(struct rt2x00_dev *rt2x00dev,
-				   const unsigned int offset,
-				   void *value, const u32 length);
-	void (*register_multiwrite)(struct rt2x00_dev *rt2x00dev,
-				    const unsigned int offset,
-				    const void *value, const u32 length);
-
-	int (*regbusy_read)(struct rt2x00_dev *rt2x00dev,
-			    const unsigned int offset,
-			    const struct rt2x00_field32 field, u32 *reg);
-};
-
-static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
-					const unsigned int offset,
-					u32 *value)
-{
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
-
-	rt2800ops->register_read(rt2x00dev, offset, value);
-}
-
-static inline void rt2800_register_write(struct rt2x00_dev *rt2x00dev,
-					 const unsigned int offset,
-					 u32 value)
-{
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
-
-	rt2800ops->register_write(rt2x00dev, offset, value);
-}
-
-static inline void rt2800_register_write_lock(struct rt2x00_dev *rt2x00dev,
-					      const unsigned int offset,
-					      u32 value)
-{
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
-
-	rt2800ops->register_write_lock(rt2x00dev, offset, value);
-}
-
-static inline void rt2800_register_multiread(struct rt2x00_dev *rt2x00dev,
-					     const unsigned int offset,
-					     void *value, const u32 length)
-{
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
-
-	rt2800ops->register_multiread(rt2x00dev, offset, value, length);
-}
-
-static inline void rt2800_register_multiwrite(struct rt2x00_dev *rt2x00dev,
-					      const unsigned int offset,
-					      void *value, const u32 length)
-{
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
-
-	rt2800ops->register_multiwrite(rt2x00dev, offset, value, length);
-}
-
-static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
-				      const unsigned int offset,
-				      struct rt2x00_field32 field,
-				      u32 *reg)
-{
-	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
-
-	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
-}
-
 /*
  * RF chip defines.
  *
