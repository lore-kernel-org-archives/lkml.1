Return-Path: <linux-kernel-owner+w=401wt.eu-S1946506AbXEAECG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946506AbXEAECG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946213AbXEAEB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:01:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:48953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946345AbXEAD6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:58:04 -0400
From: Andi Kleen <ak@suse.de>
References: <20070501557.815359000@suse.de>
In-Reply-To: <20070501557.815359000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/30] x86_64: Shut up 32bit emulation for SIOCGIFCOUNT
Message-Id: <20070501035803.809EB15146@wotan.suse.de>
Date: Tue,  1 May 2007 05:58:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The kernel doesn't implement it, but some programs like java use it 
anyways. Shut the code up.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/compat_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/fs/compat_ioctl.c
===================================================================
--- linux.orig/fs/compat_ioctl.c
+++ linux/fs/compat_ioctl.c
@@ -2602,6 +2602,8 @@ HANDLE_IOCTL(SIOCGIWENCODEEXT, do_wirele
 HANDLE_IOCTL(SIOCSIWPMKSA, do_wireless_ioctl)
 HANDLE_IOCTL(SIOCSIFBR, old_bridge_ioctl)
 HANDLE_IOCTL(SIOCGIFBR, old_bridge_ioctl)
+/* Not implemented in the native kernel */
+IGNORE_IOCTL(SIOCGIFCOUNT)
 HANDLE_IOCTL(RTC_IRQP_READ32, rtc_ioctl)
 HANDLE_IOCTL(RTC_IRQP_SET32, rtc_ioctl)
 HANDLE_IOCTL(RTC_EPOCH_READ32, rtc_ioctl)
