Return-Path: <linux-kernel-owner+w=401wt.eu-S932071AbZJRWz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbZJRWz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZJRWz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:55:28 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:48907 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZJRWz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Fvyn7o1BAe8/6TKbd3SGZ0SD3JonuPyJbUwDviW7KAtpN5QIp1ygi4Y2w5q2PWW2uE
         KZTogN6DXjYOOpwfxJBzRA6e8b84rPHS6riukq5MwHyspp9IoIZvWWwye2G1LIShV40/
         oi7TBwReYFRg8ctHdlADbiKnCUPNnNHBJue/s=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org
Subject: [PATCH 1/7] usb: trivial cleanups
Date: Mon, 19 Oct 2009 01:54:28 +0300
Message-Id: <1255906474-25091-2-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems 'min_t' was used before, and looks cleaner, plus white-space
stuff.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/usb/core/hcd.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 34de475..e6d754e 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -396,8 +396,7 @@ rh_string(int id, struct usb_hcd const *hcd, u8 *data, unsigned len)
 	case 0:
 		/* Array of LANGID codes (0x0409 is MSFT-speak for "en-us") */
 		/* See http://www.usb.org/developers/docs/USB_LANGIDs.pdf */
-		if (len > 4)
-			len = 4;
+		len = min_t(unsigned, len, sizeof(langids));
 		memcpy(data, langids, len);
 		return len;
 	case 1:
@@ -410,8 +409,8 @@ rh_string(int id, struct usb_hcd const *hcd, u8 *data, unsigned len)
 		break;
 	case 3:
 		/* Manufacturer */
-		snprintf (buf, sizeof buf, "%s %s %s", init_utsname()->sysname,
-			init_utsname()->release, hcd->driver->description);
+		snprintf(buf, sizeof buf, "%s %s %s", init_utsname()->sysname,
+			 init_utsname()->release, hcd->driver->description);
 		s = buf;
 		break;
 	default:
-- 
1.6.5.1

