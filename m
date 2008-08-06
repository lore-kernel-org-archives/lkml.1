Return-Path: <linux-kernel-owner+w=401wt.eu-S1763124AbYHFCWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763124AbYHFCWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 22:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbYHFCVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 22:21:18 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:34535 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbYHFCVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 22:21:15 -0400
Date: Tue, 5 Aug 2008 22:19:32 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Define a macro for subsys_initcall_sync() ->
 module_init().
Message-ID: <alpine.LFD.1.10.0808052211290.20955@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Define the macro subsys_initcall_sync() to map to module_init() so
that module code can stop horrifically abusing fs_initcall().

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

currently, a number of source files under drivers/ will use a call to
fs_initcall() instead of module_init() to get precise control over
when that code runs if it is compiled into the kernel -- that is, to
*guarantee* that that code runs after all subsys initcalls but before
any device initcalls.

it's not clear that that level of fine-grained control is truly
necessary in *all* of those cases but, if it is, then it makes more
sense to use subsys_initcall_sync(), since it semantically makes more
sense in showing when that happens.  using fs_initcall() is just an
ugly hack.

this seems like it wouldn't introduce any problems since there are no
invocations of subsys_initcall_sync() anywhere in the source tree at
the moment.

diff --git a/include/linux/init.h b/include/linux/init.h
index 11b84e1..38e4550 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -276,6 +276,7 @@ void __init parse_early_param(void);
 #define postcore_initcall(fn)		module_init(fn)
 #define arch_initcall(fn)		module_init(fn)
 #define subsys_initcall(fn)		module_init(fn)
+#define subsys_initcall_sync(fn)	module_init(fn)
 #define fs_initcall(fn)			module_init(fn)
 #define device_initcall(fn)		module_init(fn)
 #define late_initcall(fn)		module_init(fn)

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
