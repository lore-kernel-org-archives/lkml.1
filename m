Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbYBKG3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbYBKG3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 01:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYBKG3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 01:29:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39441 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYBKG3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 01:29:36 -0500
Date: Sun, 10 Feb 2008 22:27:43 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.16
Message-ID: <20080211062743.GB8516@kroah.com>
References: <20080211062653.GA8516@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211062653.GA8516@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 8920cb8..3a932c7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 23
-EXTRAVERSION = .15
+EXTRAVERSION = .16
 NAME = Arr Matey! A Hairy Bilge Rat!
 
 # *DOCUMENTATION*
diff --git a/fs/splice.c b/fs/splice.c
index 2aa8f5a..1a9c0e6 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1289,7 +1289,7 @@ static int get_iovec_page_array(const struct iovec __user *iov,
 		if (unlikely(!len))
 			break;
 		error = -EFAULT;
-		if (unlikely(!base))
+		if (!access_ok(VERIFY_READ, base, len))
 			break;
 
 		/*
