Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab0CBXdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:33:24 -0500
Received: from kroah.org ([198.145.64.141]:38687 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335Ab0CBX3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 48/62] sysfs: windfarm: init sysfs attributes
Date: Tue,  2 Mar 2010 15:28:47 -0800
Message-Id: <1267572541-410-48-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

This is required for lockdep.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/macintosh/windfarm_core.c         |    1 +
 drivers/macintosh/windfarm_smu_controls.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/macintosh/windfarm_core.c b/drivers/macintosh/windfarm_core.c
index 437f55c..419795f 100644
--- a/drivers/macintosh/windfarm_core.c
+++ b/drivers/macintosh/windfarm_core.c
@@ -321,6 +321,7 @@ int wf_register_sensor(struct wf_sensor *new_sr)
 	kref_init(&new_sr->ref);
 	list_add(&new_sr->link, &wf_sensors);
 
+	sysfs_attr_init(&new_sr->attr.attr);
 	new_sr->attr.attr.name = new_sr->name;
 	new_sr->attr.attr.mode = 0444;
 	new_sr->attr.show = wf_show_sensor;
diff --git a/drivers/macintosh/windfarm_smu_controls.c b/drivers/macintosh/windfarm_smu_controls.c
index 6c68b9e..43137b4 100644
--- a/drivers/macintosh/windfarm_smu_controls.c
+++ b/drivers/macintosh/windfarm_smu_controls.c
@@ -173,6 +173,7 @@ static struct smu_fan_control *smu_fan_create(struct device_node *node,
 
 	fct->fan_type = pwm_fan;
 	fct->ctrl.type = pwm_fan ? WF_CONTROL_PWM_FAN : WF_CONTROL_RPM_FAN;
+	sysfs_attr_init(&fct->ctrl.attr.attr);
 
 	/* We use the name & location here the same way we do for SMU sensors,
 	 * see the comment in windfarm_smu_sensors.c. The locations are a bit
-- 
1.7.0.1

