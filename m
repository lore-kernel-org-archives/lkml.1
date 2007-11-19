Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbXKSMxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbXKSMxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 07:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbXKSMxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 07:53:33 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:52587 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXKSMxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 07:53:32 -0500
Date: Mon, 19 Nov 2007 13:53:30 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Mackerras <paulus@samba.org>,
       David Howells <dhowells@redhat.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 2/3] tty: Let architectures override the user/kernel macros.
Message-ID: <20071119125330.GB8623@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Give architectures that support the new termios2 the possibilty
to overide the user_termios_to_kernel_termios and
kernel_termios_to_user_termios macros. As soon as all architectures
that use the generic variant have been converted the ifdefs can
go away again. Architectures in question are avr32, frv, powerpc
and s390.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Mackerras <paulus@samba.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 include/asm-generic/termios.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/include/asm-generic/termios.h
===================================================================
--- linux-2.6.orig/include/asm-generic/termios.h
+++ linux-2.6/include/asm-generic/termios.h
@@ -61,8 +61,14 @@ static inline int kernel_termios_to_user
 	return 0;
 }
 
+#ifndef user_termios_to_kernel_termios
 #define user_termios_to_kernel_termios(k, u) copy_from_user(k, u, sizeof(struct termios))
+#endif
+
+#ifndef kernel_termios_to_user_termios
 #define kernel_termios_to_user_termios(u, k) copy_to_user(u, k, sizeof(struct termios))
+#endif
+
 #define user_termios_to_kernel_termios_1(k, u) copy_from_user(k, u, sizeof(struct termios))
 #define kernel_termios_to_user_termios_1(u, k) copy_to_user(u, k, sizeof(struct termios))
 
