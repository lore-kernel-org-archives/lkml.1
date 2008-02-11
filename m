Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbYBKHqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbYBKHqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 02:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYBKHpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 02:45:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60518 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYBKHpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 02:45:42 -0500
Date: Sun, 10 Feb 2008 23:43:46 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.18
Message-ID: <20080211074346.GB23195@kroah.com>
References: <20080211074313.GA23195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211074313.GA23195@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 6a949eb..99c5e87 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 22
-EXTRAVERSION = .17
+EXTRAVERSION = .18
 NAME = Holy Dancing Manatees, Batman!
 
 # *DOCUMENTATION*
diff --git a/fs/splice.c b/fs/splice.c
index e263d3b..dbbe267 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1182,6 +1182,9 @@ static int get_iovec_page_array(const struct iovec __user *iov,
 		if (unlikely(!base))
 			break;
 
+		if (!access_ok(VERIFY_READ, base, len))
+			break;
+
 		/*
 		 * Get this base offset and number of pages, then map
 		 * in the user pages.
