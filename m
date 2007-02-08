Return-Path: <linux-kernel-owner+w=401wt.eu-S1423485AbXBHV4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423485AbXBHV4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 16:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423487AbXBHV4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 16:56:15 -0500
Received: from marvin.h-e-r-e-s-y.com ([87.106.62.5]:39342 "EHLO
	marvin.h-e-r-e-s-y.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423485AbXBHV4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 16:56:14 -0500
X-Greylist: delayed 1486 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Feb 2007 16:56:14 EST
From: Andrew Walrond <andrew@walrond.org>
To: linux-kernel@vger.kernel.org
Subject: Linux header change breaks linux-atm userspace build
Date: Thu, 8 Feb 2007 21:31:25 +0000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702082131.25192.andrew@walrond.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sometime between 2.6.18.3 and 2.6.20, this change...

--- /include/linux/atmarp.h     2007-01-10 16:32:05.000000000 +0000
+++ pkg/linux/include/linux/atmarp.h    2007-02-08 20:02:08.000000000 +0000
@@ -34,7 +34,7 @@
 struct atmarp_ctrl {
        enum atmarp_ctrl_type   type;   /* message type */
        int                     itf_num;/* interface number (if present) */
-       uint32_t                ip;     /* IP address (act_need only) */
+       __be32                  ip;     /* IP address (act_need only) */
 };

 #endif

was introduced, but __be32 is undefined, so atmarp.h should include 
linux/types.h

I've cc'ed Adrian Bunk since he seemed interested last time I reported 
something like this.

	http://lkml.org/lkml/2007/1/19/39

Hope that is useful. 

Andrew Walrond
