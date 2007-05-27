Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbXE0JsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbXE0JsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 05:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbXE0JsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 05:48:08 -0400
Received: from nicole.bmts.com ([216.183.128.225]:51819 "EHLO nicole.bmts.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbXE0JsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 05:48:07 -0400
Date: Sun, 27 May 2007 05:47:46 -0400
From: Mike Houston <mikeserv@bmts.com>
To: linux-kernel@vger.kernel.org
Cc: zach@vmware.com
Subject: 2.6.22-rc3 - VMI does not compile unless himem enabled
Message-Id: <20070527054746.632f06f8.mikeserv@bmts.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-brucetelecom.com-MailScanner-Information: Please contact Bruce Telecom 519.368.2000 for more information
X-brucetelecom.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-brucetelecom.com-MailScanner-From: mikeserv@bmts.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While building kernels for vmware guests, I noticed that the
paravirt VMI driver in 2.6.22-rc3 does not compile when highmem
support is disabled. This did not occur in 2.6.21

  CC      arch/i386/kernel/vmi.o
arch/i386/kernel/vmi.c: In function `vmi_update_pte':
arch/i386/kernel/vmi.c:422: error: dereferencing pointer to
incomplete type
arch/i386/kernel/vmi.c:422: error: `init_mm' undeclared (first use in
this function)
arch/i386/kernel/vmi.c:422: error: (Each undeclared identifier is
reported only once
arch/i386/kernel/vmi.c:422: error: for each function it appears in.)
arch/i386/kernel/vmi.c: In function `vmi_update_pte_defer':
arch/i386/kernel/vmi.c:428: error: dereferencing pointer to
incomplete type
arch/i386/kernel/vmi.c:428: error: `init_mm' undeclared (first use in
this function)
arch/i386/kernel/vmi.c: In function `vmi_set_pte_at':
arch/i386/kernel/vmi.c:441: error: dereferencing pointer to
incomplete type
arch/i386/kernel/vmi.c:441: error: `init_mm' undeclared (first use in
this function)
make[1]: *** [arch/i386/kernel/vmi.o] Error 1
make: *** [arch/i386/kernel] Error 2

This does not occur if himem support is enabled.

Mike Houston
