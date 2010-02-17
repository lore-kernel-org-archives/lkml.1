Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0BQU0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:26:22 -0500
Received: from mail2.microsoft.com ([131.107.115.215]:44465 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab0BQU0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:26:20 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
CC: Hank Janssen <hjanssen@microsoft.com>, "'gregkh@suse.de'" <gregkh@suse.de>
Subject: [PATCH 1/1] Stage: hv: Rename struct device_context and re-arrange
 the fields inside
Thread-Topic: [PATCH 1/1] Stage: hv: Rename struct device_context and
 re-arrange the fields inside
Thread-Index: AQHKsA92fjypylifnk67hMVltM704Q==
Date: Wed, 17 Feb 2010 20:26:08 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF725A9089B4@TK5EX14MBXC126.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: Bgfm BwJo D0aq F/tr Ipkq MghN NVec OwO7 PZCw QZVW R0H/
 WcXg an8O dhrK g5Fc
 h7MQ;3;ZABlAHYAZQBsAEAAZAByAGkAdgBlAHIAZABlAHYALgBvAHMAdQBvAHMAbAAuAG8AcgBnADsAZwByAGUAZwBrAGgAQABzAHUAcwBlAC4AZABlADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{6E429C64-384D-4C81-A1F9-E97F5F3B7372};aABhAGkAeQBhAG4AZwB6AEAAbQBpAGMAcgBvAHMAbwBmAHQALgBjAG8AbQA=;Wed,
 17 Feb 2010 20:26:08
 GMT;WwBQAEEAVABDAEgAIAAxAC8AMQBdACAAUwB0AGEAZwBlADoAIABoAHYAOgAgAFIAZQBuAGEAbQBlACAAcwB0AHIAdQBjAHQAIABkAGUAdgBpAGMAZQBfAGMAbwBuAHQAZQB4AHQAIABhAG4AZAAgAHIAZQAtAGEAcgByAGEAbgBnAGUAIAB0AGgAZQAgAGYAaQBlAGwAZABzACAAaQBuAHMAaQBkAGUA
x-cr-puzzleid: {6E429C64-384D-4C81-A1F9-E97F5F3B7372}
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Rename struct device_context and re-arrange the fields inside.
Rename struct device_context to struct vm_device, and move
struct device field to the end according to Document/driver-model standard.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

---
 drivers/staging/hv/blkvsc_drv.c  |    8 ++++----
 drivers/staging/hv/netvsc_drv.c  |   10 +++++-----
 drivers/staging/hv/storvsc_drv.c |   14 +++++++-------
 drivers/staging/hv/vmbus.h       |   12 ++++++------
 drivers/staging/hv/vmbus_drv.c   |   36 ++++++++++++++++++------------------
 5 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c index 62b2828..764b13e 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -92,7 +92,7 @@ struct blkvsc_request {
 /* Per device structure */
 struct block_device_context {
        /* point back to our device context */
-       struct device_context *device_ctx;
+       struct vm_device *device_ctx;
        struct kmem_cache *request_pool;
        spinlock_t lock;
        struct gendisk *gd;
@@ -254,7 +254,7 @@ static int blkvsc_probe(struct device *device)
                                (struct blkvsc_driver_context *)driver_ctx;
        struct storvsc_driver_object *storvsc_drv_obj =
                                &blkvsc_drv_ctx->drv_obj;
-       struct device_context *device_ctx = device_to_device_context(device);
+       struct vm_device *device_ctx = device_to_vm_device(device);
        struct hv_device *device_obj = &device_ctx->device_obj;

        struct block_device_context *blkdev = NULL; @@ -745,7 +745,7 @@ static int blkvsc_remove(struct device *device)
                                (struct blkvsc_driver_context *)driver_ctx;
        struct storvsc_driver_object *storvsc_drv_obj =
                                &blkvsc_drv_ctx->drv_obj;
-       struct device_context *device_ctx = device_to_device_context(device);
+       struct vm_device *device_ctx = device_to_vm_device(device);
        struct hv_device *device_obj = &device_ctx->device_obj;
        struct block_device_context *blkdev = dev_get_drvdata(device);
        unsigned long flags;
@@ -865,7 +865,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
                        void (*request_completion)(struct hv_storvsc_request *))  {
        struct block_device_context *blkdev = blkvsc_req->dev;
-       struct device_context *device_ctx = blkdev->device_ctx;
+       struct vm_device *device_ctx = blkdev->device_ctx;
        struct driver_context *driver_ctx =
                        driver_to_driver_context(device_ctx->device.driver);
        struct blkvsc_driver_context *blkvsc_drv_ctx = diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c index 0d7459e..f86376d 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -42,7 +42,7 @@ MODULE_LICENSE("GPL");

 struct net_device_context {
        /* point back to our device context */
-       struct device_context *device_ctx;
+       struct vm_device *device_ctx;
        struct net_device_stats stats;
 };

@@ -282,7 +282,7 @@ retry_send:
 static void netvsc_linkstatus_callback(struct hv_device *device_obj,
                                       unsigned int status)
 {
-       struct device_context *device_ctx = to_device_context(device_obj);
+       struct vm_device *device_ctx = to_vm_device(device_obj);
        struct net_device *net = dev_get_drvdata(&device_ctx->device);

        DPRINT_ENTER(NETVSC_DRV);
@@ -309,7 +309,7 @@ static void netvsc_linkstatus_callback(struct hv_device *device_obj,  static int netvsc_recv_callback(struct hv_device *device_obj,
                                struct hv_netvsc_packet *packet)
 {
-       struct device_context *device_ctx = to_device_context(device_obj);
+       struct vm_device *device_ctx = to_vm_device(device_obj);
        struct net_device *net = dev_get_drvdata(&device_ctx->device);
        struct net_device_context *net_device_ctx;
        struct sk_buff *skb;
@@ -401,7 +401,7 @@ static int netvsc_probe(struct device *device)
        struct netvsc_driver_context *net_drv_ctx =
                (struct netvsc_driver_context *)driver_ctx;
        struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
-       struct device_context *device_ctx = device_to_device_context(device);
+       struct vm_device *device_ctx = device_to_vm_device(device);
        struct hv_device *device_obj = &device_ctx->device_obj;
        struct net_device *net = NULL;
        struct net_device_context *net_device_ctx; @@ -473,7 +473,7 @@ static int netvsc_remove(struct device *device)
        struct netvsc_driver_context *net_drv_ctx =
                (struct netvsc_driver_context *)driver_ctx;
        struct netvsc_driver *net_drv_obj = &net_drv_ctx->drv_obj;
-       struct device_context *device_ctx = device_to_device_context(device);
+       struct vm_device *device_ctx = device_to_vm_device(device);
        struct net_device *net = dev_get_drvdata(&device_ctx->device);
        struct hv_device *device_obj = &device_ctx->device_obj;
        int ret;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index d49dc21..c5123bc 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -42,7 +42,7 @@ struct host_device_context {
        struct work_struct host_rescan_work;

        /* point back to our device context */
-       struct device_context *device_ctx;
+       struct vm_device *device_ctx;
        struct kmem_cache *request_pool;
        unsigned int port;
        unsigned char path;
@@ -240,7 +240,7 @@ static int storvsc_probe(struct device *device)
                                (struct storvsc_driver_context *)driver_ctx;
        struct storvsc_driver_object *storvsc_drv_obj =
                                &storvsc_drv_ctx->drv_obj;
-       struct device_context *device_ctx = device_to_device_context(device);
+       struct vm_device *device_ctx = device_to_vm_device(device);
        struct hv_device *device_obj = &device_ctx->device_obj;
        struct Scsi_Host *host;
        struct host_device_context *host_device_ctx; @@ -339,7 +339,7 @@ static int storvsc_remove(struct device *device)
                        (struct storvsc_driver_context *)driver_ctx;
        struct storvsc_driver_object *storvsc_drv_obj =
                        &storvsc_drv_ctx->drv_obj;
-       struct device_context *device_ctx = device_to_device_context(device);
+       struct vm_device *device_ctx = device_to_vm_device(device);
        struct hv_device *device_obj = &device_ctx->device_obj;
        struct Scsi_Host *host = dev_get_drvdata(device);
        struct host_device_context *host_device_ctx = @@ -640,7 +640,7 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
        int ret;
        struct host_device_context *host_device_ctx =
                (struct host_device_context *)scmnd->device->host->hostdata;
-       struct device_context *device_ctx = host_device_ctx->device_ctx;
+       struct vm_device *device_ctx = host_device_ctx->device_ctx;
        struct driver_context *driver_ctx =
                driver_to_driver_context(device_ctx->device.driver);
        struct storvsc_driver_context *storvsc_drv_ctx = @@ -879,7 +879,7 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
        int ret;
        struct host_device_context *host_device_ctx =
                (struct host_device_context *)scmnd->device->host->hostdata;
-       struct device_context *device_ctx = host_device_ctx->device_ctx;
+       struct vm_device *device_ctx = host_device_ctx->device_ctx;
        struct driver_context *driver_ctx =
                        driver_to_driver_context(device_ctx->device.driver);
        struct storvsc_driver_context *storvsc_drv_ctx = @@ -916,7 +916,7 @@ static void storvsc_host_rescan_callback(struct work_struct *work)  {
        struct hv_device *device_obj =
            &((struct host_device_context *)work)->device_ctx->device_obj;
-       struct device_context *device_ctx = to_device_context(device_obj);
+       struct vm_device *device_ctx = to_vm_device(device_obj);
        struct Scsi_Host *host = dev_get_drvdata(&device_ctx->device);
        struct scsi_device *sdev;
        struct host_device_context *host_device_ctx; @@ -1083,7 +1083,7 @@ static int storvsc_report_luns(struct scsi_device *sdev, unsigned int luns[],

 static void storvsc_host_rescan(struct hv_device *device_obj)  {
-       struct device_context *device_ctx = to_device_context(device_obj);
+       struct vm_device *device_ctx = to_vm_device(device_obj);
        struct Scsi_Host *host = dev_get_drvdata(&device_ctx->device);
        struct host_device_context *host_device_ctx;

diff --git a/drivers/staging/hv/vmbus.h b/drivers/staging/hv/vmbus.h index ae0a896..6404b84 100644
--- a/drivers/staging/hv/vmbus.h
+++ b/drivers/staging/hv/vmbus.h
@@ -43,23 +43,23 @@ struct driver_context {
        void (*shutdown)(struct device *);
 };

-struct device_context {
+struct vm_device {
        struct work_struct probe_failed_work_item;
        struct hv_guid class_id;
        struct hv_guid device_id;
        int probe_error;
-       struct device device;
        struct hv_device device_obj;
+       struct device device;
 };

-static inline struct device_context *to_device_context(struct hv_device *d)
+static inline struct vm_device *to_vm_device(struct hv_device *d)
 {
-       return container_of(d, struct device_context, device_obj);
+       return container_of(d, struct vm_device, device_obj);
 }

-static inline struct device_context *device_to_device_context(struct device *d)
+static inline struct vm_device *device_to_vm_device(struct device *d)
 {
-       return container_of(d, struct device_context, device);
+       return container_of(d, struct vm_device, device);
 }

 static inline struct driver_context *driver_to_driver_context(struct device_driver *d) diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c index 894eecf..d752e52 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -47,7 +47,7 @@ struct vmbus_driver_context {
        struct tasklet_struct event_dpc;

        /* The bus root device */
-       struct device_context device_ctx;
+       struct vm_device device_ctx;
 };

 static int vmbus_match(struct device *device, struct device_driver *driver); @@ -135,7 +135,7 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
                                      struct device_attribute *dev_attr,
                                      char *buf)
 {
-       struct device_context *device_ctx = device_to_device_context(dev);
+       struct vm_device *device_ctx = device_to_vm_device(dev);
        struct hv_device_info device_info;

        memset(&device_info, 0, sizeof(struct hv_device_info)); @@ -245,7 +245,7 @@ static int vmbus_bus_init(int (*drv_init)(struct hv_driver *drv))  {
        struct vmbus_driver_context *vmbus_drv_ctx = &g_vmbus_drv;
        struct vmbus_driver *vmbus_drv_obj = &g_vmbus_drv.drv_obj;
-       struct device_context *dev_ctx = &g_vmbus_drv.device_ctx;
+       struct vm_device *dev_ctx = &g_vmbus_drv.device_ctx;
        int ret;
        unsigned int vector;

@@ -307,7 +307,7 @@ static int vmbus_bus_init(int (*drv_init)(struct hv_driver *drv))
        DPRINT_INFO(VMBUS_DRV, "irq 0x%x vector 0x%x", vmbus_irq, vector);

        /* Call to bus driver to add the root device */
-       memset(dev_ctx, 0, sizeof(struct device_context));
+       memset(dev_ctx, 0, sizeof(struct vm_device));

        ret = vmbus_drv_obj->Base.OnDeviceAdd(&dev_ctx->device_obj, &vector);
        if (ret != 0) {
@@ -368,7 +368,7 @@ static void vmbus_bus_exit(void)
        struct vmbus_driver *vmbus_drv_obj = &g_vmbus_drv.drv_obj;
        struct vmbus_driver_context *vmbus_drv_ctx = &g_vmbus_drv;

-       struct device_context *dev_ctx = &g_vmbus_drv.device_ctx;
+       struct vm_device *dev_ctx = &g_vmbus_drv.device_ctx;

        DPRINT_ENTER(VMBUS_DRV);

@@ -471,13 +471,13 @@ static struct hv_device *vmbus_child_device_create(struct hv_guid *type,
                                                   struct hv_guid *instance,
                                                   void *context)
 {
-       struct device_context *child_device_ctx;
+       struct vm_device *child_device_ctx;
        struct hv_device *child_device_obj;

        DPRINT_ENTER(VMBUS_DRV);

        /* Allocate the new child device */
-       child_device_ctx = kzalloc(sizeof(struct device_context), GFP_KERNEL);
+       child_device_ctx = kzalloc(sizeof(struct vm_device), GFP_KERNEL);
        if (!child_device_ctx) {
                DPRINT_ERR(VMBUS_DRV,
                        "unable to allocate device_context for child device"); @@ -526,10 +526,10 @@ static int vmbus_child_device_register(struct hv_device *root_device_obj,
                                       struct hv_device *child_device_obj)  {
        int ret = 0;
-       struct device_context *root_device_ctx =
-                               to_device_context(root_device_obj);
-       struct device_context *child_device_ctx =
-                               to_device_context(child_device_obj);
+       struct vm_device *root_device_ctx =
+                               to_vm_device(root_device_obj);
+       struct vm_device *child_device_ctx =
+                               to_vm_device(child_device_obj);
        static atomic_t device_num = ATOMIC_INIT(0);

        DPRINT_ENTER(VMBUS_DRV);
@@ -572,7 +572,7 @@ static int vmbus_child_device_register(struct hv_device *root_device_obj,
  */
 static void vmbus_child_device_unregister(struct hv_device *device_obj)  {
-       struct device_context *device_ctx = to_device_context(device_obj);
+       struct vm_device *device_ctx = to_vm_device(device_obj);

        DPRINT_ENTER(VMBUS_DRV);

@@ -610,7 +610,7 @@ static void vmbus_child_device_destroy(struct hv_device *device_obj)
  */
 static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)  {
-       struct device_context *device_ctx = device_to_device_context(device);
+       struct vm_device *device_ctx = device_to_vm_device(device);
        int ret;

        DPRINT_ENTER(VMBUS_DRV);
@@ -687,7 +687,7 @@ static int vmbus_match(struct device *device, struct device_driver *driver)  {
        int match = 0;
        struct driver_context *driver_ctx = driver_to_driver_context(driver);
-       struct device_context *device_ctx = device_to_device_context(device);
+       struct vm_device *device_ctx = device_to_vm_device(device);

        DPRINT_ENTER(VMBUS_DRV);

@@ -724,7 +724,7 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
  */
 static void vmbus_probe_failed_cb(struct work_struct *context)  {
-       struct device_context *device_ctx = (struct device_context *)context;
+       struct vm_device *device_ctx = (struct vm_device *)context;

        DPRINT_ENTER(VMBUS_DRV);

@@ -746,8 +746,8 @@ static int vmbus_probe(struct device *child_device)
        int ret = 0;
        struct driver_context *driver_ctx =
                        driver_to_driver_context(child_device->driver);
-       struct device_context *device_ctx =
-                       device_to_device_context(child_device);
+       struct vm_device *device_ctx =
+                       device_to_vm_device(child_device);

        DPRINT_ENTER(VMBUS_DRV);

@@ -871,7 +871,7 @@ static void vmbus_bus_release(struct device *device)
  */
 static void vmbus_device_release(struct device *device)  {
-       struct device_context *device_ctx = device_to_device_context(device);
+       struct vm_device *device_ctx = device_to_vm_device(device);

        DPRINT_ENTER(VMBUS_DRV);

--
1.6.3.2

