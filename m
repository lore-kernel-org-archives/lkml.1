Return-Path: <linux-kernel-owner+w=401wt.eu-S1765621AbZDAOPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765621AbZDAOPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765907AbZDAOHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:07:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37793 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765619AbZDAOHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:07:20 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 21/24] mux: fix build problem
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:07:34 +0100
Message-ID: <20090401140730.22882.84147.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

Fixes:

In file included from drivers/serial/mux.c:37:
include/linux/serial_core.h: In function 'uart_handle_sysrq_char':
include/linux/serial_core.h:467: error: 'struct uart_port' has no member named 'sysrq'
include/linux/serial_core.h:468: error: 'struct uart_port' has no member named 'sysrq'


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 include/linux/serial_core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index df9245c..83e4b3f 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -277,7 +277,7 @@ struct uart_port {
 	struct uart_icount	icount;			/* statistics */
 
 	struct console		*cons;			/* struct console, if any */
-#ifdef CONFIG_SERIAL_CORE_CONSOLE
+#if defined(CONFIG_SERIAL_CORE_CONSOLE) || defined(SUPPORT_SYSRQ)
 	unsigned long		sysrq;			/* sysrq timeout */
 #endif
 

