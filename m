Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217Ab0ANQSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab0ANQSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 11:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757174Ab0ANQSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 11:18:48 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:48144 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab0ANQSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 11:18:47 -0500
Date: Thu, 14 Jan 2010 08:18:19 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -mmotm] tty.h: make function static
Message-Id: <20100114081819.e9ff37a0.randy.dunlap@oracle.com>
In-Reply-To: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org>
References: <201001132042.o0DKgaSR027272@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4B4F43DD.00D1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

I get a few dozen of these warnings when using
  gcc (GCC) 4.4.1 20090725 (Red Hat 4.4.1-2):

In file included from mmotm-2010-0113-1217/init/do_mounts.c:5:
mmotm-2010-0113-1217/include/linux/tty.h: In function 'tty_port_get':
mmotm-2010-0113-1217/include/linux/tty.h:469: warning: '______f' is static but declared in inline function 'tty_port_get' which is not static

so make the function static inline.

(may be needed in mainline also; or a gcc problem?)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/tty.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2010-0113-1217.orig/include/linux/tty.h
+++ mmotm-2010-0113-1217/include/linux/tty.h
@@ -464,7 +464,7 @@ extern int tty_port_alloc_xmit_buf(struc
 extern void tty_port_free_xmit_buf(struct tty_port *port);
 extern void tty_port_put(struct tty_port *port);
 
-extern inline struct tty_port *tty_port_get(struct tty_port *port)
+static inline struct tty_port *tty_port_get(struct tty_port *port)
 {
 	if (port)
 		kref_get(&port->kref);
---
~Randy
