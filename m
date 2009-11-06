Return-Path: <linux-kernel-owner+w=401wt.eu-S1759988AbZKFWWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbZKFWWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759964AbZKFWWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:19 -0500
Received: from kroah.org ([198.145.64.141]:56614 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758434AbZKFWWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:18 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:39 2009
Message-Id: <20091106221538.993410171@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Yinghai Lu <yinghai@kernel.org>
Subject: [02/99] pci: increase alignment to make more space for hidden code
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=pci-increase-alignment-to-make-more-space-for-hidden-code.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Yinghai Lu <yinghai@kernel.org>

commit 15b812f1d0a5ca8f5efe7f5882f468af10682ca8 upstream.

As reported in

	http://bugzilla.kernel.org/show_bug.cgi?id=13940

on some system when acpi are enabled, acpi clears some BAR for some
devices without reason, and kernel will need to allocate devices for
them.  It then apparently hits some undocumented resource conflict,
resulting in non-working devices.

Try to increase alignment to get more safe range for unassigned devices.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 arch/x86/kernel/e820.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1378,8 +1378,8 @@ static unsigned long ram_alignment(resou
 	if (mb < 16)
 		return 1024*1024;
 
-	/* To 32MB for anything above that */
-	return 32*1024*1024;
+	/* To 64MB for anything above that */
+	return 64*1024*1024;
 }
 
 #define MAX_RESOURCE_SIZE ((resource_size_t)-1)


