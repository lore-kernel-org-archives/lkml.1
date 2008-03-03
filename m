Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbYCCU1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbYCCU1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYCCU1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:27:34 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:40734 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbYCCU1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:27:33 -0500
Date: Mon, 3 Mar 2008 15:27:27 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] KBUILD:  Allow generalization of "unifdef" utility.
Message-ID: <alpine.LFD.1.00.0803031523050.27901@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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


Allow the user to override the selection of "unifdef" utility when
generating user-space header files.  This allows the user to select
the more powerful "sunifdef" program, which is more stringent with
respect to cleaning and syntax checking.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  obviously, if a user chooses to not take advantage of this feature,
it should make no difference whatsoever.  but "sunifdef" is more
strict in terms of cleaning compound preprocessor directives, and it
also flags questionable preprocessor directives like this:

  UNIFDEF include/linux/netlink.h
sunifdef: /home/rpjday/k/git/include/linux/netlink.h: line 206:
warning 0x02070: Garbage following preprocessor directive in "#if
PAGE_SIZE < 8192UL" (#if line 152 depth 2)


diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 53dae3e..e98e6b2 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -7,7 +7,8 @@
 #
 # ==========================================================================

-UNIFDEF := scripts/unifdef -U__KERNEL__
+UNIFDEF_CMD ?= scripts/unifdef
+UNIFDEF := $(UNIFDEF_CMD) -U__KERNEL__

 # Eliminate the contents of (and inclusions of) compiler.h
 HDRSED  := sed 	-e "s/ inline / __inline__ /g" \


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
