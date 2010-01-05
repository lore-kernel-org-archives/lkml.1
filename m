Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469Ab0AEUGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0AEUGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412Ab0AEUF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:05:58 -0500
Received: from kroah.org ([198.145.64.141]:49919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab0AEUF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:05:56 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:02:59 2010
Message-Id: <20100105200258.872417351@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:01:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Stefan Bader <stefan.bader@canonical.com>,
       Borislav Petkov <petkovbb@gmail.com>, Peter Feuerer <peter@piie.net>,
       Len Brown <len.brown@intel.com>
Subject: [01/39] acerhdf: limit modalias matching to supported
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Bader <stefan.bader@canonical.com>

commit bdc731bc5fcd1794e9ac8ac80c389d302381c123 upstream.

BugLink: https://bugs.launchpad.net/ubuntu/+bug/435958

The module alias currently matches any Acer computer but when loaded the
BIOS checks will only succeed on Aspire One models.  This causes a invalid
BIOS warning for all other models (seen on Aspire 4810T).  This is not
fatal but worries users that see this message.  Limiting the moule alias
to models starting with AOA or DOA for Packard Bell.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
Acked-by: Peter Feuerer <peter@piie.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/acerhdf.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -633,9 +633,10 @@ static void __exit acerhdf_exit(void)
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Feuerer");
 MODULE_DESCRIPTION("Aspire One temperature and fan driver");
-MODULE_ALIAS("dmi:*:*Acer*:*:");
-MODULE_ALIAS("dmi:*:*Gateway*:*:");
-MODULE_ALIAS("dmi:*:*Packard Bell*:*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOA*:");
 
 module_init(acerhdf_init);
 module_exit(acerhdf_exit);


