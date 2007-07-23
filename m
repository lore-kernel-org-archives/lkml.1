Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbXGWPpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbXGWPpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbXGWPpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:45:06 -0400
Received: from main.gmane.org ([80.91.229.2]:51515 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbXGWPpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:45:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ed Swierk <eswierk@arastra.com>
Subject: Longer command line for kexec on i386
Date: Mon, 23 Jul 2007 15:42:09 +0000 (UTC)
Message-ID: <loom.20070723T172709-232@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 68.166.32.218 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.5) Gecko/20070718 Fedora/2.0.0.5-1.fc7 Firefox/2.0.0.5)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm attempting to get kexec to pass a command line longer than 256 bytes to the
new kernel, using kexec-tools-testing-20070330 and kernel 2.6.22.1.  The new
kernel is a bzImage, and I'm using kexec to tack on a command line and an initrd.

I made the following change to kexec:

--- kexec-tools-testing-20070330.orig/include/x86/x86-linux.h
+++ kexec-tools-testing-20070330/include/x86/x86-linux.h
@@ -148,14 +148,13 @@
 #endif
        struct e820entry e820_map[E820MAX];     /* 0x2d0 */
                                                /* 0x550 */
-#define COMMAND_LINE_SIZE 256
+#define COMMAND_LINE_SIZE 2048
 };

 struct x86_linux_faked_param_header {
        struct x86_linux_param_header hdr;      /* 0x00 */
        uint8_t reserved16[688];                /* 0x550 */
-       uint8_t command_line[COMMAND_LINE_SIZE]; /* 0x800 */
-       uint8_t reserved17[1792];               /* 0x900 - 0x1000 */
+       uint8_t command_line[COMMAND_LINE_SIZE]; /* 0x800 - 0x1000 */
 };

 struct x86_linux_header {

but I'm now seeing intermittent corruption of the initrd in the new kernel--a
few bytes at different locations each time.

I suspect I've neglected some other important changes to the boot protocol.  Any
clues would be appreciated.

Thanks,
--Ed


