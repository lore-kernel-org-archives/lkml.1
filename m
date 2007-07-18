Return-Path: <linux-kernel-owner+w=401wt.eu-S936442AbXGRXbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936442AbXGRXbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935850AbXGRX1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:27:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:57445 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936406AbXGRX1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:27:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/14] dev_vdbg() documentation
Date: Wed, 18 Jul 2007 16:25:46 -0700
Message-Id: <1184801188568-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11848011842017-git-send-email-gregkh@suse.de>
References: <20070718232400.GC4620@kroah.com>
 <11848011502972-git-send-email-gregkh@suse.de>
 <11848011551094-git-send-email-gregkh@suse.de>
 <11848011593154-git-send-email-gregkh@suse.de>
 <118480116414-git-send-email-gregkh@suse.de>
 <1184801169806-git-send-email-gregkh@suse.de>
 <11848011731698-git-send-email-gregkh@suse.de>
 <1184801177102-git-send-email-gregkh@suse.de>
 <11848011802979-git-send-email-gregkh@suse.de>
 <11848011842017-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

Update CodingStyle to talk about "-DDEBUG" message conventions and the
new "-DVERBOSE_DEBUG" convention.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/CodingStyle |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index a667eb1..7f1730f 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -633,12 +633,27 @@ covers RTL which is used frequently with assembly language in the kernel.
 
 Kernel developers like to be seen as literate. Do mind the spelling
 of kernel messages to make a good impression. Do not use crippled
-words like "dont" and use "do not" or "don't" instead.
+words like "dont"; use "do not" or "don't" instead.  Make the messages
+concise, clear, and unambiguous.
 
 Kernel messages do not have to be terminated with a period.
 
 Printing numbers in parentheses (%d) adds no value and should be avoided.
 
+There are a number of driver model diagnostic macros in <linux/device.h>
+which you should use to make sure messages are matched to the right device
+and driver, and are tagged with the right level:  dev_err(), dev_warn(),
+dev_info(), and so forth.  For messages that aren't associated with a
+particular device, <linux/kernel.h> defines pr_debug() and pr_info().
+
+Coming up with good debugging messages can be quite a challenge; and once
+you have them, they can be a huge help for remote troubleshooting.  Such
+messages should be compiled out when the DEBUG symbol is not defined (that
+is, by default they are not included).  When you use dev_dbg() or pr_debug(),
+that's automatic.  Many subsystems have Kconfig options to turn on -DDEBUG.
+A related convention uses VERBOSE_DEBUG to add dev_vdbg() messages to the
+ones already enabled by DEBUG.
+
 
 		Chapter 14: Allocating memory
 
@@ -790,4 +805,5 @@ Kernel CodingStyle, by greg@kroah.com at OLS 2002:
 http://www.kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/
 
 --
-Last updated on 2006-December-06.
+Last updated on 2007-July-13.
+
-- 
1.5.2.2

