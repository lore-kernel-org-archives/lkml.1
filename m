Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbYGEL6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbYGEL6Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYGEL5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:57:35 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:23986 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbYGEL5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=UAMBUWSreab2v7Ve6vb6b2tRyzfHcALCqzU1qapk9av5oBzRfDOlHWS0kgy1q2J7Hx
         7lYOEfrPRPOGC2UdlDmWTDHazeghCIgyz+8LgVHDLSS6VycYPuDYSsdiyNJYEVo8cVep
         o36I6oU+owB3eHdH1BGgfcSHXCz+DTHfZCFLI=
References: <20080705115334.892720771@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Jul 2008 15:53:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, akpm@linux-foundation.org, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 3/5] x86: io delay - add checking for NULL early param
Content-Disposition: inline; filename=ep-io-delay
Message-ID: <486f61aa.2134440a.2343.ffffbc57@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/io_delay.c
====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_delay.c	2008-06-23 22:30:14.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_delay.c	2008-07-05 12:49:06.000000000 +0400
@@ -103,6 +103,9 @@ void __init io_delay_init(void)
 
 static int __init io_delay_param(char *s)
 {
+	if (!s)
+		return -EINVAL;
+
 	if (!strcmp(s, "0x80"))
 		io_delay_type = CONFIG_IO_DELAY_TYPE_0X80;
 	else if (!strcmp(s, "0xed"))

-- 
