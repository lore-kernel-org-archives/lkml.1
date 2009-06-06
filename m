Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZFFLMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZFFLMW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 07:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZFFLMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 07:12:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:56753 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbZFFLMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 07:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SK+fjuyEZ1AyL4EHGruVWPRo0Ku0OhbZOcjAeeOieKwefpYhRQhLe9DybJVo8MNNDb
         2m2JGVKvLZ/RNIpujIVgsE+39nGJijjrxqRuVS1oiqrBFY+U+K1h+7aIJoJ9i37vNHs4
         ix8A6T/j3eYC7k94QvegAWnYaqnJZgHDHYboM=
Subject: [PATCH V2] no need for checking it
From: "Figo.zhang" <figo1802@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       David Schleef <ds@schleef.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1244285472.3185.36.camel@myhost>
References: <1244285472.3185.36.camel@myhost>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 19:11:31 +0800
Message-Id: <1244286691.3185.42.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfree() does it's own NULL checking,so no need for check before
calling it.

'pages' is local variable argment,so in v2, it is no need assignment
 to NULL.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---   
drivers/staging/comedi/drivers.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 6e13e45..587283a 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -495,9 +495,8 @@ int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 				vmap(pages, n_pages, VM_MAP,
 				PAGE_KERNEL_NOCACHE);
 		}
-		if (pages) {
-			vfree(pages);
-		}
+		vfree(pages);
+		
 		if (async->prealloc_buf == NULL) {
 			/* Some allocation failed above. */
 			if (async->buf_page_list) {


