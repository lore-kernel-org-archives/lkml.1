Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbYEEPZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbYEEPZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759553AbYEEPZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:25:01 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:18607 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760013AbYEEPZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:25:00 -0400
Message-ID: <481F26A0.5010402@de.ibm.com>
Date: Mon, 05 May 2008 17:24:16 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: ltp-list@lists.sourceforge.net, ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org
Subject: [RFC PATCH 2/6] kbuild: let addtree result in absolute paths only
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 scripts/Kbuild.include |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.26-rc1/scripts/Kbuild.include
===================================================================
--- linux-2.6.26-rc1.orig/scripts/Kbuild.include
+++ linux-2.6.26-rc1/scripts/Kbuild.include
@@ -144,7 +144,7 @@ ld-option = $(call try-run,\
 build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
 
 # Prefix -I with $(srctree) if it is not an absolute path.
-addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
+addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1)),$(1))
 
 # Find all -I options and call addtree
 flags = $(foreach o,$($(1)),$(if $(filter -I%,$(o)),$(call addtree,$(o)),$(o)))



