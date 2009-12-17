Return-Path: <linux-kernel-owner+w=401wt.eu-S935776AbZLQEY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935776AbZLQEY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935786AbZLQEFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:05:01 -0500
Received: from kroah.org ([198.145.64.141]:55749 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935705AbZLQEEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:52 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:54 2009
Message-Id: <20091217035654.709032930@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [091/151] xen: register runstate info for boot CPU early
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

commit 499d19b82b586aef18727b9ae1437f8f37b66e91 upstream.

printk timestamping uses sched_clock, which in turn relies on runstate
info under Xen.  So make sure we set it up before any printks can
be called.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/enlighten.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1181,6 +1181,8 @@ asmlinkage void __init xen_start_kernel(
 
 	xen_raw_console_write("about to get started...\n");
 
+	xen_setup_runstate_info(0);
+
 	/* Start the world */
 #ifdef CONFIG_X86_32
 	i386_start_kernel();


