Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbZCTNLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbZCTNLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbZCTNLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:11:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:16314 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZCTNLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:11:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lUlCa+IPkCj/LcTZG6L6puCz8WOlKYrtuwjea+c+CoSmWaMgiWA5sGRzQYRFF0IVMN
         sv3FJRj0CB9yVpfz3GGMCPeridzo6JHK9jYG4AyvrSvxE1usZ1tcrTPNRy0SfstTywg0
         Lnoil6I7D+2tft9V1Mri26HZQ9xHJmo52dj80=
Date: Fri, 20 Mar 2009 16:11:08 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] Serial: fix build problem
Message-ID: <20090320131108.GA26565@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In file included from drivers/serial/mux.c:37:
include/linux/serial_core.h: In function 'uart_handle_sysrq_char':
include/linux/serial_core.h:467: error: 'struct uart_port' has no member named 'sysrq'
include/linux/serial_core.h:468: error: 'struct uart_port' has no member named 'sysrq'


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
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
 
