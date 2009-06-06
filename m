Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZFFKv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZFFKv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 06:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZFFKvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 06:51:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:6329 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbZFFKvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 06:51:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=K+XjpADwp9f2LdoG6OV1ZeFID01RMEX4m4X5oFLAk8vDWXHcVRFYYayrktRH5fQMN5
         9eL/o+YtR1NqmdcFVbgKshoQIqTAX0Ne8f+q1wM8Yn3AvexuA+rvGCbw844lPXPPVWNS
         TqNRtSCTdeFqGs1RA8OyXNk7FTKAKHZoWIKhQ=
Subject: [PATCH] no need for checking it
From: "Figo.zhang" <figo1802@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Ian Abbott <abbotti@mev.co.uk>,
       Frank Mori Hess <fmhess@users.sourceforge.net>,
       David Schleef <ds@schleef.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 18:51:11 +0800
Message-Id: <1244285472.3185.36.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfree() does it's own NULL checking,so no need for check before
calling it.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---  
 drivers/staging/comedi/drivers.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c
b/drivers/staging/comedi/drivers.c
index 6e13e45..ce50e85 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -495,9 +495,9 @@ int comedi_buf_alloc(struct comedi_device *dev,
struct comedi_subdevice *s,
 				vmap(pages, n_pages, VM_MAP,
 				PAGE_KERNEL_NOCACHE);
 		}
-		if (pages) {
-			vfree(pages);
-		}
+		vfree(pages);
+		pages = NULL;
+		
 		if (async->prealloc_buf == NULL) {
 			/* Some allocation failed above. */
 			if (async->buf_page_list) {


