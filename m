Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936366Ab0CMBSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:18:46 -0500
Received: from kroah.org ([198.145.64.141]:60969 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934982Ab0CMAUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:42 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:12 2010
Message-Id: <20100313001512.150691225@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: [patch 080/123] eeepc-laptop: disable wireless hotplug for 1005PE
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

commit ced69c59811f05b2f8378467cbb82ac6ed3c6a5a upstream.

The wireless hotplug code is not needed on this model, and it disables
the wired ethernet card.  (Like on the 1005HA and 1201N).

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Reported-by: Ansgar Burchardt <ansgar@43-1.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/eeepc-laptop.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -1277,7 +1277,8 @@ static void eeepc_dmi_check(struct eeepc
 	 * hotplug code. In fact, current hotplug code seems to unplug another
 	 * device...
 	 */
-	if (strcmp(model, "1005HA") == 0 || strcmp(model, "1201N") == 0) {
+	if (strcmp(model, "1005HA") == 0 || strcmp(model, "1201N") == 0 ||
+	    strcmp(model, "1005PE") == 0) {
 		eeepc->hotplug_disabled = true;
 		pr_info("wlan hotplug disabled\n");
 	}


