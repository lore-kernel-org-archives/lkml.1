Return-Path: <linux-kernel-owner+w=401wt.eu-S934750AbZLQBWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934750AbZLQBWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763734AbZLQBVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:21:13 -0500
Received: from kroah.org ([198.145.64.141]:41476 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763701AbZLQBU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:59 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:08 2009
Message-Id: <20091217011608.038270093@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [77/90] drm/i915: Fix CRT hotplug detect by checking really no channels attached
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 8e9e0eea9955bffbe5e5cd6355157cabddc31f17 upstream.

For CRT hotplug detect status, we have four test results as blue
channel only, green channel only, both blue and green channel, and
no channel attached. Origin code only marks both blue and green channel
case as connected, but ignore other possible connected states. This one
trys to detect CRT by checking no channel attached case instead.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_crt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -234,8 +234,8 @@ static bool intel_crt_detect_hotplug(str
 		} while (time_after(timeout, jiffies));
 	}
 
-	if ((I915_READ(PORT_HOTPLUG_STAT) & CRT_HOTPLUG_MONITOR_MASK) ==
-	    CRT_HOTPLUG_MONITOR_COLOR)
+	if ((I915_READ(PORT_HOTPLUG_STAT) & CRT_HOTPLUG_MONITOR_MASK) !=
+	    CRT_HOTPLUG_MONITOR_NONE)
 		return true;
 
 	return false;


