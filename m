Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab0BDR2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:28:40 -0500
Received: from kroah.org ([198.145.64.141]:34860 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933316Ab0BDRWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:14 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:17 2010
Message-Id: <20100204171517.050168765@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
       Robert Richter <robert.richter@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [51/74] oprofile/x86: fix crash when profiling more than 28 events
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit d8cc108f4fab42b380c6b3f3356f99e8dd5372e2 upstream.

With multiplexing enabled oprofile crashs when profiling more than 28
events. This patch fixes this.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/nmi_int.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -222,7 +222,7 @@ static void nmi_cpu_switch(void *dummy)
 
 	/* move to next set */
 	si += model->num_counters;
-	if ((si > model->num_virt_counters) || (counter_config[si].count == 0))
+	if ((si >= model->num_virt_counters) || (counter_config[si].count == 0))
 		per_cpu(switch_index, cpu) = 0;
 	else
 		per_cpu(switch_index, cpu) = si;


