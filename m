Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZAUWxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZAUWxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 17:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZAUWxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 17:53:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:63069 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbZAUWxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 17:53:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EaIwE2M2bqlNZJh9Ri1jTArAoc1M8/U2g8ckSR6FeYpL7Xfz1UtDuZSMv+OKiC2bAM
         vKQKbH6fgag/K4E+xwrepqthW1Ey4ApGxZmhzW0JZ0gAOYhsxZy5hx7jXmgaj0LeMlJj
         q+Eo83lSWENfE7YbsO0fo0GztVEuu03xOLyVM=
Date: Thu, 22 Jan 2009 01:58:36 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org
Subject: [PATCH] Fix longstanding "error: storage size of
	'__mod_dmi_device_table' isn't known"
Message-ID: <20090121225836.GA14105@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 3.4.6 doesn't like MODULE_DEVICE_TABLE(dmi, x) expansion enough to error out.
Shut it up in a most simple way.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/mod_devicetable.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -443,6 +443,13 @@ struct dmi_system_id {
 	struct dmi_strmatch matches[4];
 	void *driver_data;
 };
+/*
+ * struct dmi_device_id appears during expansion of
+ * "MODULE_DEVICE_TABLE(dmi, x)". Compiler doesn't look inside it
+ * but this is enough for gcc 3.4.6 to error out:
+ *	error: storage size of '__mod_dmi_device_table' isn't known
+ */
+#define dmi_device_id dmi_system_id
 #endif
 
 #define DMI_MATCH(a, b)	{ a, b }
