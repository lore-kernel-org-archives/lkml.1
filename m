Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbYJHWEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbYJHWEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYJHWER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:04:17 -0400
Received: from smtp2f.orange.fr ([80.12.242.151]:17941 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbYJHWEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:04:16 -0400
X-ME-UUID: 20081008220414887.D8B167000088@mwinf2f13.orange.fr
Message-ID: <48ED2E5E.3040600@yahoo.fr>
Date: Thu, 09 Oct 2008 00:04:14 +0200
From: trem <tremyfr@yahoo.fr>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Subject: [patch] clean hex output of ftrace
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the output of ftrace in hex mode. Without this patch, the ouput of ftrace is :

raw mode : 6474 0 141531612444 0 140 + 6402 120 S
hex mode : 000091a4 00000000 000000023f1f50c1 00000000 c8 000000b2 00009120 87 ffff00c8 00000035

There is an inversion on ouput hex(6474) is 194a

Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
---

Index: linux-2.6.26/kernel/trace/trace.c
===================================================================
--- linux-2.6.26/kernel/trace/trace.c
+++ linux-2.6.26/kernel/trace/trace.c   2008-10-08 22:30:29.000000000 +0200
@@ -415,8 +415,8 @@
 #endif
                byte = data[i];
 
-               hex[j++] = hex2asc[byte & 0x0f];
                hex[j++] = hex2asc[byte >> 4];
+               hex[j++] = hex2asc[byte & 0x0f];
        }
        hex[j++] = ' ';


