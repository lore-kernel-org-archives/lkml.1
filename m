Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab0CLCxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 21:53:34 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:59457 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab0CLCxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 21:53:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BLSriFngZBfHmvgtGG5ucZGve6FkEHJuAkh0deyfm/kWzFErofcszZ6Ykc1hX3jyMC
         FvwMxA4IvZakgBEL315idbNOcJNaS/2D1k1jFCHwtOOslUpqv455Qhp3QVd/EM20G84o
         O6GD09dxXeWFOOOtI2+p21CzW3uLkNJabk86w=
Date: Fri, 12 Mar 2010 10:53:24 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, jeremy@xensource.com
Subject: [PATCH] XEN: Make handle_vcpu_hotplug_event() to check the sscanf() return value
Message-ID: <20100312025324.GC2712@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems handle_vcpu_hotplug_event() not check the sscanf() return value.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 drivers/xen/cpu_hotplug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index 14e2d99..99773a6 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -69,8 +69,8 @@ static void handle_vcpu_hotplug_event(struct xenbus_watch *watch,
 
 	cpustr = strstr(node, "cpu/");
 	if (cpustr != NULL) {
-		sscanf(cpustr, "cpu/%u", &cpu);
-		vcpu_hotplug(cpu);
+		if (sscanf(cpustr, "cpu/%u", &cpu) == 1)
+			vcpu_hotplug(cpu);
 	}
 }
 
-- 
1.6.5.3

