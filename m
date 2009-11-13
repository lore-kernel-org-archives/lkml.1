Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbZKMMh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbZKMMh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 07:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZKMMhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 07:37:50 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:36668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZKMMhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 07:37:50 -0500
Subject: [PATCH 2.6.32] ftrace: fix event format export
From: Johannes Berg <johannes@sipsolutions.net>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 Nov 2009 13:37:50 +0100
Message-ID: <1258115870.6167.4.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason the export of the event print
format to userspace uses '#fmt' which breaks
if the format string is anything but a plain
string, for example if it is built with macros
then the macro names are exported instead of
their contents.

Use
	"\"%s\"", fmt
instead of
	"%s", #fmt
to export the string and not the way it is built.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This is making the export of a bunch of events (only checked the
wireless ones but those are all affected) unusable, so please apply to
2.6.32.

 include/trace/ftrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/include/trace/ftrace.h	2009-11-13 13:15:21.000000000 +0100
+++ wireless-testing/include/trace/ftrace.h	2009-11-13 13:34:03.000000000 +0100
@@ -159,7 +159,7 @@
 #undef __get_str
 
 #undef TP_printk
-#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
+#define TP_printk(fmt, args...) "\"%s\", %s\n", fmt, __stringify(args)
 
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args


