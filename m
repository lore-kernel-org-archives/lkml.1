Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZJ1W2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZJ1W2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 18:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZJ1W2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 18:28:50 -0400
Received: from mailgw.kvados.cz ([194.213.53.146]:41506 "EHLO mailgw.kvados.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbZJ1W2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 18:28:49 -0400
From: Milan Dadok <milan@dadok.name>
To: "'Greg Kroah-Hartman'" <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>, "'Hank Janssen'" <hjanssen@microsoft.com>,
       "'Haiyang Zhang'" <haiyangz@microsoft.com>
Subject: [PATCH] 1/4 staging: hv: fix oops in vmbus - udev events
Date: Wed, 28 Oct 2009 23:23:27 +0100
Message-ID: <001401ca581d$456c45e0$d044d1a0$@name>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcpYHUUGwI6sw3PnR4SEuC//R6HTwg==
Content-Language: cs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typos in udev event send and guid variables copy

Signed-off-by: Milan Dadok <milan@dadok.name>

---
diff -uprN -X /usr/src/linux/Documentation/dontdiff
/usr/src/linux-2.6.32-rc5/drivers/staging/hv/vmbus_drv.c
/usr/src/linux/drivers/staging/hv/vmbus_drv.c
--- /usr/src/linux-2.6.32-rc5/drivers/staging/hv/vmbus_drv.c    2009-10-28
18:13:04.000000000 +0100
+++ /usr/src/linux/drivers/staging/hv/vmbus_drv.c       2009-10-28
17:53:29.000000000 +0100
@@ -507,12 +507,12 @@ static struct hv_device *vmbus_child_dev

        child_device_obj = &child_device_ctx->device_obj;
        child_device_obj->context = context;
-       memcpy(&child_device_obj->deviceType, &type, sizeof(struct
hv_guid));
-       memcpy(&child_device_obj->deviceInstance, &instance,
+       memcpy(&child_device_obj->deviceType, type, sizeof(struct hv_guid));
+       memcpy(&child_device_obj->deviceInstance, instance,
               sizeof(struct hv_guid));

-       memcpy(&child_device_ctx->class_id, &type, sizeof(struct hv_guid));
-       memcpy(&child_device_ctx->device_id, &instance, sizeof(struct
hv_guid));
+       memcpy(&child_device_ctx->class_id, type, sizeof(struct hv_guid));
+       memcpy(&child_device_ctx->device_id, instance, sizeof(struct
hv_guid));

        DPRINT_EXIT(VMBUS_DRV);

@@ -623,8 +611,6 @@ static void vmbus_child_device_destroy(s
 static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 {
        struct device_context *device_ctx =
device_to_device_context(device);
-       int i = 0;
-       int len = 0;
        int ret;

        DPRINT_ENTER(VMBUS_DRV);
@@ -644,8 +630,6 @@ static int vmbus_uevent(struct device *d
                    device_ctx->class_id.data[14],
                    device_ctx->class_id.data[15]);

-       env->envp_idx = i;
-       env->buflen = len;
        ret = add_uevent_var(env, "VMBUS_DEVICE_CLASS_GUID={"
                             "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
                             "%02x%02x%02x%02x%02x%02x%02x%02x}",
@@ -691,8 +675,6 @@ static int vmbus_uevent(struct device *d
        if (ret)
                return ret;

-       env->envp[env->envp_idx] = NULL;
-
        DPRINT_EXIT(VMBUS_DRV);

        return 0;
---


