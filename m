Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbXE1GdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbXE1GdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 02:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbXE1GdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 02:33:15 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:56542 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbXE1GdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 02:33:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=DE81imNnlUSO8//UA9MLqnNRvKMLnemlJo/LADlIOIxVplUWWKaZCFdHj2BAZMecOnDm5Gpt2Im4bMHgStpbEpMvsCt8RxbkC7dJJOQ97C86j3r+8n/mx3tS2qFXLs+UUsouzcY2WRhIgr/3mb9jXQoWW8giYOvhe1wAGHa2kLw=
Message-ID: <465A77A2.1090805@gmail.com>
Date: Mon, 28 May 2007 14:33:06 +0800
From: "Antonino A. Daplas" <adaplas@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 9/9] fbcon: Allow fbcon to use the primary display driver
 fix
References: <4658D8E2.3020608@gmail.com>
In-Reply-To: <4658D8E2.3020608@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

unbind_con_driver() should be EXPORT_SYBOL.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
---

Antonino A. Daplas wrote:
> Allow fbcon to select the primary display adapter using the
> fb_is_primary_device() arch-specific helper.  If a a primary adapter is
> detected, fbcon will unbind the old adapter from the VT layer, then rebind
> using the new adapter. This requires that bind_/unbind_con_driver() be made
> public.
> 
> Because this feature may produce unexpected behavior (from the user's POV),
> this must be explicitly enabled in Kconfig.
> 

link errors if compiled as a module.  Here's the fix.

Tony

 drivers/char/vt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 45baf04..e5f36e7 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2962,6 +2962,7 @@ err:
 	module_put(owner);
 	return retval;
 };
+EXPORT_SYMBOL(bind_con_driver);
 
 #ifdef CONFIG_VT_HW_CONSOLE_BINDING
 static int con_is_graphics(const struct consw *csw, int first, int last)
