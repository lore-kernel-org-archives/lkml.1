Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbYGLVUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbYGLVUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 17:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYGLVT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 17:19:58 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:40295 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbYGLVT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 17:19:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
	b=kVCiXnylHOFDjxr+hL0nCzVLXU+vrgbD/D5u23YvZwYgzy6yQsK7OrumDbSRa+8Vm2Up8ITKZXkhMZIbSDrcbz8URBUkZg//8MRaDn6KE8SCsZsdnTQi7CWiTXGVWI8w;
Message-ID: <48791FF4.2080503@simon.arlott.org.uk>
Date: Sat, 12 Jul 2008 22:19:48 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080706)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cxacru: Fix printk format flag in error message
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"#%x" should have been "%#x"

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 5ea3093..2ba43c4 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -602,7 +602,7 @@ static int cxacru_cm_get_array(struct cxacru_data *instance, enum cxacru_cm_requ
 			offd = le32_to_cpu(buf[offb++]);
 			if (offd >= size) {
 				if (printk_ratelimit())
-					usb_err(instance->usbatm, "wrong index #%x in response to cm #%x\n",
+					usb_err(instance->usbatm, "wrong index %#x in response to cm %#x\n",
 						offd, cm);
 				ret = -EIO;
 				goto cleanup;
-- 
1.5.6.1

-- 
Simon Arlott
