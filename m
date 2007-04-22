Return-Path: <linux-kernel-owner+w=401wt.eu-S965537AbXDVJPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537AbXDVJPE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 05:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965564AbXDVJPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 05:15:04 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:36171 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965537AbXDVJPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 05:15:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=OewyopZVPtRbhnpFIkSEr4NiVJcnJ9bZHRnyWU7e4nLUwAQgQ+romUf7Xzc9cZBSxvyd+Is7MPq1cNd6hvHMoeHWnCW70/ZEHNOzbzWkVZa9Qtg3Y0TKA5FCS9Q2Q+L0oB6jHGhSCLZJBD8QEbsIxyOy1R4OmlLUWnmKSptw/tw=
Date: Sun, 22 Apr 2007 18:09:30 +0900
To: Andi Kleen <andi@firstfloor.org>,
       Scott Porter <scott@opengridcomputing.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org
Subject: [PATCH] fault injection: disable stacktrace filter for x86-64
Message-ID: <20070422090930.GA4246@APFDCB5C>
Mail-Followup-To: Akinobu Mita <Akinobu.Mita@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Scott Porter <scott@opengridcomputing.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org
References: <1177095354.25165.48.camel@scott-desktop.site> <1177192363.25165.101.camel@scott-desktop.site> <20070421221033.GA30496@one.firstfloor.org> <20070422070603.GA30662@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070422070603.GA30662@APFDCB5C>
User-Agent: Mutt/1.4.2.2i
From: Akinobu Mita <akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Disable stacktrace filter support for x86-64 for now.
Will be enable when we can get the dwarf2 unwinder back.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6-git/lib/Kconfig.debug
===================================================================
--- 2.6-git.orig/lib/Kconfig.debug
+++ 2.6-git/lib/Kconfig.debug
@@ -442,6 +442,7 @@ config FAULT_INJECTION_DEBUG_FS
 config FAULT_INJECTION_STACKTRACE_FILTER
 	bool "stacktrace filter for fault-injection capabilities"
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
+	depends on !X86_64
 	select STACKTRACE
 	select FRAME_POINTER
 	help
