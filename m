Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbZJBBj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbZJBBj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbZJBBj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:39:26 -0400
Received: from kroah.org ([198.145.64.141]:33510 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899AbZJBBeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:25 2009
Message-Id: <20091002012425.415933698@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [116/136] USB: Fix SS endpoint companion descriptor parsing.
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=usb-fix-ss-endpoint-companion-descriptor-parsing.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 6682bb39e111b34290e25c4d275c5bcf8bbccbe1 upstream.

When there's a descriptor after the SuperSpeed endpoint companion
descriptor, the previous code would have skipped over twice the length it
was supposed to.  This code fixes crashes seen with UASP devices (which
have a UASP descriptor after the SS endpoint companion descriptor).

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -105,7 +105,7 @@ static int usb_parse_ss_endpoint_compani
 	ep->ss_ep_comp->extralen = i;
 	buffer += i;
 	size -= i;
-	retval = buffer - buffer_start + i;
+	retval = buffer - buffer_start;
 	if (num_skipped > 0)
 		dev_dbg(ddev, "skipped %d descriptor%s after %s\n",
 				num_skipped, plural(num_skipped),


