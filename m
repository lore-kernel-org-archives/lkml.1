Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbYLNUr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbYLNUr1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 15:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYLNUrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 15:47:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38750 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbYLNUrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 15:47:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Dec 2008 21:47:04 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/4] firewire: remove line breaks before function names
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.aa7114dbd92c6a7d@s5r6.in-berlin.de>
Message-ID: <tkrat.8aba31ec4c42206b@s5r6.in-berlin.de>
References: <tkrat.aa7114dbd92c6a7d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    type
    function_name(parameters);

is nice to look at but was not used consistently.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c        |   68 ++++++------------
 drivers/firewire/fw-cdev.c        |   88 ++++++++++--------------
 drivers/firewire/fw-device.c      |   40 ++++-------
 drivers/firewire/fw-device.h      |    3 
 drivers/firewire/fw-iso.c         |   28 +++----
 drivers/firewire/fw-ohci.c        |  100 ++++++++++++---------------
 drivers/firewire/fw-sbp2.c        |   57 ++++++---------
 drivers/firewire/fw-topology.c    |   28 +++----
 drivers/firewire/fw-topology.h    |   13 +--
 drivers/firewire/fw-transaction.c |   92 ++++++++++---------------
 drivers/firewire/fw-transaction.h |  109 +++++++++---------------------
 11 files changed, 249 insertions(+), 377 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -63,8 +63,7 @@ static int descriptor_count;
 #define BIB_CMC			((1) << 30)
 #define BIB_IMC			((1) << 31)
 
-static u32 *
-generate_config_rom(struct fw_card *card, size_t *config_rom_length)
+static u32 *generate_config_rom(struct fw_card *card, size_t *config_rom_length)
 {
 	struct fw_descriptor *desc;
 	static u32 config_rom[256];
@@ -128,8 +127,7 @@ generate_config_rom(struct fw_card *card
 	return config_rom;
 }
 
-static void
-update_config_roms(void)
+static void update_config_roms(void)
 {
 	struct fw_card *card;
 	u32 *config_rom;
@@ -141,8 +139,7 @@ update_config_roms(void)
 	}
 }
 
-int
-fw_core_add_descriptor(struct fw_descriptor *desc)
+int fw_core_add_descriptor(struct fw_descriptor *desc)
 {
 	size_t i;
 
@@ -171,8 +168,7 @@ fw_core_add_descriptor(struct fw_descrip
 	return 0;
 }
 
-void
-fw_core_remove_descriptor(struct fw_descriptor *desc)
+void fw_core_remove_descriptor(struct fw_descriptor *desc)
 {
 	mutex_lock(&card_mutex);
 
@@ -189,8 +185,7 @@ static const char gap_count_table[] = {
 	63, 5, 7, 8, 10, 13, 16, 18, 21, 24, 26, 29, 32, 35, 37, 40
 };
 
-void
-fw_schedule_bm_work(struct fw_card *card, unsigned long delay)
+void fw_schedule_bm_work(struct fw_card *card, unsigned long delay)
 {
 	int scheduled;
 
@@ -200,8 +195,7 @@ fw_schedule_bm_work(struct fw_card *card
 		fw_card_put(card);
 }
 
-static void
-fw_card_bm_work(struct work_struct *work)
+static void fw_card_bm_work(struct work_struct *work)
 {
 	struct fw_card *card = container_of(work, struct fw_card, work.work);
 	struct fw_device *root_device;
@@ -370,17 +364,16 @@ fw_card_bm_work(struct work_struct *work
 	fw_card_put(card);
 }
 
-static void
-flush_timer_callback(unsigned long data)
+static void flush_timer_callback(unsigned long data)
 {
 	struct fw_card *card = (struct fw_card *)data;
 
 	fw_flush_transactions(card);
 }
 
-void
-fw_card_initialize(struct fw_card *card, const struct fw_card_driver *driver,
-		   struct device *device)
+void fw_card_initialize(struct fw_card *card,
+			const struct fw_card_driver *driver,
+			struct device *device)
 {
 	static atomic_t index = ATOMIC_INIT(-1);
 
@@ -405,9 +398,8 @@ fw_card_initialize(struct fw_card *card,
 }
 EXPORT_SYMBOL(fw_card_initialize);
 
-int
-fw_card_add(struct fw_card *card,
-	    u32 max_receive, u32 link_speed, u64 guid)
+int fw_card_add(struct fw_card *card,
+		u32 max_receive, u32 link_speed, u64 guid)
 {
 	u32 *config_rom;
 	size_t length;
@@ -434,23 +426,20 @@ EXPORT_SYMBOL(fw_card_add);
  * dummy driver just fails all IO.
  */
 
-static int
-dummy_enable(struct fw_card *card, u32 *config_rom, size_t length)
+static int dummy_enable(struct fw_card *card, u32 *config_rom, size_t length)
 {
 	BUG();
 	return -1;
 }
 
-static int
-dummy_update_phy_reg(struct fw_card *card, int address,
-		     int clear_bits, int set_bits)
+static int dummy_update_phy_reg(struct fw_card *card, int address,
+				int clear_bits, int set_bits)
 {
 	return -ENODEV;
 }
 
-static int
-dummy_set_config_rom(struct fw_card *card,
-		     u32 *config_rom, size_t length)
+static int dummy_set_config_rom(struct fw_card *card,
+				u32 *config_rom, size_t length)
 {
 	/*
 	 * We take the card out of card_list before setting the dummy
@@ -460,27 +449,23 @@ dummy_set_config_rom(struct fw_card *car
 	return -1;
 }
 
-static void
-dummy_send_request(struct fw_card *card, struct fw_packet *packet)
+static void dummy_send_request(struct fw_card *card, struct fw_packet *packet)
 {
 	packet->callback(packet, card, -ENODEV);
 }
 
-static void
-dummy_send_response(struct fw_card *card, struct fw_packet *packet)
+static void dummy_send_response(struct fw_card *card, struct fw_packet *packet)
 {
 	packet->callback(packet, card, -ENODEV);
 }
 
-static int
-dummy_cancel_packet(struct fw_card *card, struct fw_packet *packet)
+static int dummy_cancel_packet(struct fw_card *card, struct fw_packet *packet)
 {
 	return -ENOENT;
 }
 
-static int
-dummy_enable_phys_dma(struct fw_card *card,
-		      int node_id, int generation)
+static int dummy_enable_phys_dma(struct fw_card *card,
+				 int node_id, int generation)
 {
 	return -ENODEV;
 }
@@ -495,16 +480,14 @@ static struct fw_card_driver dummy_drive
 	.enable_phys_dma = dummy_enable_phys_dma,
 };
 
-void
-fw_card_release(struct kref *kref)
+void fw_card_release(struct kref *kref)
 {
 	struct fw_card *card = container_of(kref, struct fw_card, kref);
 
 	complete(&card->done);
 }
 
-void
-fw_core_remove_card(struct fw_card *card)
+void fw_core_remove_card(struct fw_card *card)
 {
 	card->driver->update_phy_reg(card, 4,
 				     PHY_LINK_ACTIVE | PHY_CONTENDER, 0);
@@ -528,8 +511,7 @@ fw_core_remove_card(struct fw_card *card
 }
 EXPORT_SYMBOL(fw_core_remove_card);
 
-int
-fw_core_initiate_bus_reset(struct fw_card *card, int short_reset)
+int fw_core_initiate_bus_reset(struct fw_card *card, int short_reset)
 {
 	int reg = short_reset ? 5 : 1;
 	int bit = short_reset ? PHY_BUS_SHORT_RESET : PHY_BUS_RESET;
Index: linux/drivers/firewire/fw-cdev.c
===================================================================
--- linux.orig/drivers/firewire/fw-cdev.c
+++ linux/drivers/firewire/fw-cdev.c
@@ -96,14 +96,12 @@ struct client {
 	struct list_head link;
 };
 
-static inline void __user *
-u64_to_uptr(__u64 value)
+static inline void __user *u64_to_uptr(__u64 value)
 {
 	return (void __user *)(unsigned long)value;
 }
 
-static inline __u64
-uptr_to_u64(void __user *ptr)
+static inline __u64 uptr_to_u64(void __user *ptr)
 {
 	return (__u64)(unsigned long)ptr;
 }
@@ -163,8 +161,8 @@ static void queue_event(struct client *c
 	wake_up_interruptible(&client->wait);
 }
 
-static int
-dequeue_event(struct client *client, char __user *buffer, size_t count)
+static int dequeue_event(struct client *client,
+			 char __user *buffer, size_t count)
 {
 	unsigned long flags;
 	struct event *event;
@@ -203,18 +201,16 @@ dequeue_event(struct client *client, cha
 	return ret;
 }
 
-static ssize_t
-fw_device_op_read(struct file *file,
-		  char __user *buffer, size_t count, loff_t *offset)
+static ssize_t fw_device_op_read(struct file *file, char __user *buffer,
+				 size_t count, loff_t *offset)
 {
 	struct client *client = file->private_data;
 
 	return dequeue_event(client, buffer, count);
 }
 
-static void
-fill_bus_reset_event(struct fw_cdev_event_bus_reset *event,
-		     struct client *client)
+static void fill_bus_reset_event(struct fw_cdev_event_bus_reset *event,
+				 struct client *client)
 {
 	struct fw_card *card = client->device->card;
 	unsigned long flags;
@@ -233,9 +229,8 @@ fill_bus_reset_event(struct fw_cdev_even
 	spin_unlock_irqrestore(&card->lock, flags);
 }
 
-static void
-for_each_client(struct fw_device *device,
-		void (*callback)(struct client *client))
+static void for_each_client(struct fw_device *device,
+			    void (*callback)(struct client *client))
 {
 	struct client *c;
 
@@ -245,8 +240,7 @@ for_each_client(struct fw_device *device
 	mutex_unlock(&device->client_list_mutex);
 }
 
-static void
-queue_bus_reset_event(struct client *client)
+static void queue_bus_reset_event(struct client *client)
 {
 	struct bus_reset *bus_reset;
 
@@ -316,9 +310,8 @@ static int ioctl_get_info(struct client 
 	return 0;
 }
 
-static int
-add_client_resource(struct client *client, struct client_resource *resource,
-		    gfp_t gfp_mask)
+static int add_client_resource(struct client *client,
+			       struct client_resource *resource, gfp_t gfp_mask)
 {
 	unsigned long flags;
 	int ret;
@@ -341,10 +334,9 @@ add_client_resource(struct client *clien
 	return ret < 0 ? ret : 0;
 }
 
-static int
-release_client_resource(struct client *client, u32 handle,
-			client_resource_release_fn_t release,
-			struct client_resource **resource)
+static int release_client_resource(struct client *client, u32 handle,
+				   client_resource_release_fn_t release,
+				   struct client_resource **resource)
 {
 	struct client_resource *r;
 	unsigned long flags;
@@ -369,8 +361,8 @@ release_client_resource(struct client *c
 	return 0;
 }
 
-static void
-release_transaction(struct client *client, struct client_resource *resource)
+static void release_transaction(struct client *client,
+				struct client_resource *resource)
 {
 	struct response *response =
 		container_of(resource, struct response, resource);
@@ -378,9 +370,8 @@ release_transaction(struct client *clien
 	fw_cancel_transaction(client->device->card, &response->transaction);
 }
 
-static void
-complete_transaction(struct fw_card *card, int rcode,
-		     void *payload, size_t length, void *data)
+static void complete_transaction(struct fw_card *card, int rcode,
+				 void *payload, size_t length, void *data)
 {
 	struct response *response = data;
 	struct client *client = response->client;
@@ -506,8 +497,8 @@ struct request_event {
 	struct fw_cdev_event_request request;
 };
 
-static void
-release_request(struct client *client, struct client_resource *resource)
+static void release_request(struct client *client,
+			    struct client_resource *resource)
 {
 	struct request *request =
 		container_of(resource, struct request, resource);
@@ -517,12 +508,11 @@ release_request(struct client *client, s
 	kfree(request);
 }
 
-static void
-handle_request(struct fw_card *card, struct fw_request *r,
-	       int tcode, int destination, int source,
-	       int generation, int speed,
-	       unsigned long long offset,
-	       void *payload, size_t length, void *callback_data)
+static void handle_request(struct fw_card *card, struct fw_request *r,
+			   int tcode, int destination, int source,
+			   int generation, int speed,
+			   unsigned long long offset,
+			   void *payload, size_t length, void *callback_data)
 {
 	struct address_handler *handler = callback_data;
 	struct request *request;
@@ -561,9 +551,8 @@ handle_request(struct fw_card *card, str
 	fw_send_response(card, r, RCODE_CONFLICT_ERROR);
 }
 
-static void
-release_address_handler(struct client *client,
-			struct client_resource *resource)
+static void release_address_handler(struct client *client,
+				    struct client_resource *resource)
 {
 	struct address_handler *handler =
 		container_of(resource, struct address_handler, resource);
@@ -716,9 +705,8 @@ static int ioctl_remove_descriptor(struc
 				       release_descriptor, NULL);
 }
 
-static void
-iso_callback(struct fw_iso_context *context, u32 cycle,
-	     size_t header_length, void *header, void *data)
+static void iso_callback(struct fw_iso_context *context, u32 cycle,
+			 size_t header_length, void *header, void *data)
 {
 	struct client *client = data;
 	struct iso_interrupt *irq;
@@ -954,8 +942,8 @@ static int (* const ioctl_handlers[])(st
 	ioctl_get_cycle_timer,
 };
 
-static int
-dispatch_ioctl(struct client *client, unsigned int cmd, void __user *arg)
+static int dispatch_ioctl(struct client *client,
+			  unsigned int cmd, void __user *arg)
 {
 	char buffer[256];
 	int ret;
@@ -983,9 +971,8 @@ dispatch_ioctl(struct client *client, un
 	return ret;
 }
 
-static long
-fw_device_op_ioctl(struct file *file,
-		   unsigned int cmd, unsigned long arg)
+static long fw_device_op_ioctl(struct file *file,
+			       unsigned int cmd, unsigned long arg)
 {
 	struct client *client = file->private_data;
 
@@ -996,9 +983,8 @@ fw_device_op_ioctl(struct file *file,
 }
 
 #ifdef CONFIG_COMPAT
-static long
-fw_device_op_compat_ioctl(struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long fw_device_op_compat_ioctl(struct file *file,
+				      unsigned int cmd, unsigned long arg)
 {
 	struct client *client = file->private_data;
 
Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -133,8 +133,7 @@ static int get_modalias(struct fw_unit *
 			vendor, model, specifier_id, version);
 }
 
-static int
-fw_unit_uevent(struct device *dev, struct kobj_uevent_env *env)
+static int fw_unit_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct fw_unit *unit = fw_unit(dev);
 	char modalias[64];
@@ -191,8 +190,8 @@ struct config_rom_attribute {
 	u32 key;
 };
 
-static ssize_t
-show_immediate(struct device *dev, struct device_attribute *dattr, char *buf)
+static ssize_t show_immediate(struct device *dev,
+			      struct device_attribute *dattr, char *buf)
 {
 	struct config_rom_attribute *attr =
 		container_of(dattr, struct config_rom_attribute, attr);
@@ -223,8 +222,8 @@ show_immediate(struct device *dev, struc
 #define IMMEDIATE_ATTR(name, key)				\
 	{ __ATTR(name, S_IRUGO, show_immediate, NULL), key }
 
-static ssize_t
-show_text_leaf(struct device *dev, struct device_attribute *dattr, char *buf)
+static ssize_t show_text_leaf(struct device *dev,
+			      struct device_attribute *dattr, char *buf)
 {
 	struct config_rom_attribute *attr =
 		container_of(dattr, struct config_rom_attribute, attr);
@@ -293,10 +292,9 @@ static struct config_rom_attribute confi
 	TEXT_LEAF_ATTR(hardware_version_name, CSR_HARDWARE_VERSION),
 };
 
-static void
-init_fw_attribute_group(struct device *dev,
-			struct device_attribute *attrs,
-			struct fw_attribute_group *group)
+static void init_fw_attribute_group(struct device *dev,
+				    struct device_attribute *attrs,
+				    struct fw_attribute_group *group)
 {
 	struct device_attribute *attr;
 	int i, j;
@@ -319,9 +317,8 @@ init_fw_attribute_group(struct device *d
 	dev->groups = group->groups;
 }
 
-static ssize_t
-modalias_show(struct device *dev,
-	      struct device_attribute *attr, char *buf)
+static ssize_t modalias_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
 {
 	struct fw_unit *unit = fw_unit(dev);
 	int length;
@@ -332,9 +329,8 @@ modalias_show(struct device *dev,
 	return length + 1;
 }
 
-static ssize_t
-rom_index_show(struct device *dev,
-	       struct device_attribute *attr, char *buf)
+static ssize_t rom_index_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
 {
 	struct fw_device *device = fw_device(dev->parent);
 	struct fw_unit *unit = fw_unit(dev);
@@ -349,8 +345,8 @@ static struct device_attribute fw_unit_a
 	__ATTR_NULL,
 };
 
-static ssize_t
-config_rom_show(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t config_rom_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
 {
 	struct fw_device *device = fw_device(dev);
 	size_t length;
@@ -363,8 +359,8 @@ config_rom_show(struct device *dev, stru
 	return length;
 }
 
-static ssize_t
-guid_show(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t guid_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
 {
 	struct fw_device *device = fw_device(dev);
 	int ret;
@@ -383,8 +379,8 @@ static struct device_attribute fw_device
 	__ATTR_NULL,
 };
 
-static int
-read_rom(struct fw_device *device, int generation, int index, u32 *data)
+static int read_rom(struct fw_device *device,
+		    int generation, int index, u32 *data)
 {
 	int rcode;
 
Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -179,8 +179,7 @@ struct fw_driver {
 	const struct fw_device_id *id_table;
 };
 
-static inline struct fw_driver *
-fw_driver(struct device_driver *drv)
+static inline struct fw_driver *fw_driver(struct device_driver *drv)
 {
 	return container_of(drv, struct fw_driver, driver);
 }
Index: linux/drivers/firewire/fw-iso.c
===================================================================
--- linux.orig/drivers/firewire/fw-iso.c
+++ linux/drivers/firewire/fw-iso.c
@@ -28,9 +28,8 @@
 #include "fw-topology.h"
 #include "fw-device.h"
 
-int
-fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
-		   int page_count, enum dma_data_direction direction)
+int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
+		       int page_count, enum dma_data_direction direction)
 {
 	int i, j;
 	dma_addr_t address;
@@ -105,10 +104,9 @@ void fw_iso_buffer_destroy(struct fw_iso
 	buffer->pages = NULL;
 }
 
-struct fw_iso_context *
-fw_iso_context_create(struct fw_card *card, int type,
-		      int channel, int speed, size_t header_size,
-		      fw_iso_callback_t callback, void *callback_data)
+struct fw_iso_context *fw_iso_context_create(struct fw_card *card,
+		int type, int channel, int speed, size_t header_size,
+		fw_iso_callback_t callback, void *callback_data)
 {
 	struct fw_iso_context *ctx;
 
@@ -134,25 +132,23 @@ void fw_iso_context_destroy(struct fw_is
 	card->driver->free_iso_context(ctx);
 }
 
-int
-fw_iso_context_start(struct fw_iso_context *ctx, int cycle, int sync, int tags)
+int fw_iso_context_start(struct fw_iso_context *ctx,
+			 int cycle, int sync, int tags)
 {
 	return ctx->card->driver->start_iso(ctx, cycle, sync, tags);
 }
 
-int
-fw_iso_context_queue(struct fw_iso_context *ctx,
-		     struct fw_iso_packet *packet,
-		     struct fw_iso_buffer *buffer,
-		     unsigned long payload)
+int fw_iso_context_queue(struct fw_iso_context *ctx,
+			 struct fw_iso_packet *packet,
+			 struct fw_iso_buffer *buffer,
+			 unsigned long payload)
 {
 	struct fw_card *card = ctx->card;
 
 	return card->driver->queue_iso(ctx, packet, buffer, payload);
 }
 
-int
-fw_iso_context_stop(struct fw_iso_context *ctx)
+int fw_iso_context_stop(struct fw_iso_context *ctx)
 {
 	return ctx->card->driver->stop_iso(ctx);
 }
Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -441,9 +441,8 @@ static inline void flush_writes(const st
 	reg_read(ohci, OHCI1394_Version);
 }
 
-static int
-ohci_update_phy_reg(struct fw_card *card, int addr,
-		    int clear_bits, int set_bits)
+static int ohci_update_phy_reg(struct fw_card *card, int addr,
+			       int clear_bits, int set_bits)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
 	u32 val, old;
@@ -658,8 +657,8 @@ static void ar_context_tasklet(unsigned 
 	}
 }
 
-static int
-ar_context_init(struct ar_context *ctx, struct fw_ohci *ohci, u32 regs)
+static int ar_context_init(struct ar_context *ctx,
+			   struct fw_ohci *ohci, u32 regs)
 {
 	struct ar_buffer ab;
 
@@ -690,8 +689,7 @@ static void ar_context_run(struct ar_con
 	flush_writes(ctx->ohci);
 }
 
-static struct descriptor *
-find_branch_descriptor(struct descriptor *d, int z)
+static struct descriptor *find_branch_descriptor(struct descriptor *d, int z)
 {
 	int b, key;
 
@@ -751,8 +749,7 @@ static void context_tasklet(unsigned lon
  * Allocate a new buffer and add it to the list of free buffers for this
  * context.  Must be called with ohci->lock held.
  */
-static int
-context_add_buffer(struct context *ctx)
+static int context_add_buffer(struct context *ctx)
 {
 	struct descriptor_buffer *desc;
 	dma_addr_t uninitialized_var(bus_addr);
@@ -781,9 +778,8 @@ context_add_buffer(struct context *ctx)
 	return 0;
 }
 
-static int
-context_init(struct context *ctx, struct fw_ohci *ohci,
-	     u32 regs, descriptor_callback_t callback)
+static int context_init(struct context *ctx, struct fw_ohci *ohci,
+			u32 regs, descriptor_callback_t callback)
 {
 	ctx->ohci = ohci;
 	ctx->regs = regs;
@@ -814,8 +810,7 @@ context_init(struct context *ctx, struct
 	return 0;
 }
 
-static void
-context_release(struct context *ctx)
+static void context_release(struct context *ctx)
 {
 	struct fw_card *card = &ctx->ohci->card;
 	struct descriptor_buffer *desc, *tmp;
@@ -827,8 +822,8 @@ context_release(struct context *ctx)
 }
 
 /* Must be called with ohci->lock held */
-static struct descriptor *
-context_get_descriptors(struct context *ctx, int z, dma_addr_t *d_bus)
+static struct descriptor *context_get_descriptors(struct context *ctx,
+						  int z, dma_addr_t *d_bus)
 {
 	struct descriptor *d = NULL;
 	struct descriptor_buffer *desc = ctx->buffer_tail;
@@ -912,8 +907,8 @@ struct driver_data {
  * Must always be called with the ochi->lock held to ensure proper
  * generation handling and locking around packet queue manipulation.
  */
-static int
-at_context_queue_packet(struct context *ctx, struct fw_packet *packet)
+static int at_context_queue_packet(struct context *ctx,
+				   struct fw_packet *packet)
 {
 	struct fw_ohci *ohci = ctx->ohci;
 	dma_addr_t d_bus, uninitialized_var(payload_bus);
@@ -1095,8 +1090,8 @@ static int handle_at_packet(struct conte
 #define HEADER_GET_DATA_LENGTH(q)	(((q) >> 16) & 0xffff)
 #define HEADER_GET_EXTENDED_TCODE(q)	(((q) >> 0) & 0xffff)
 
-static void
-handle_local_rom(struct fw_ohci *ohci, struct fw_packet *packet, u32 csr)
+static void handle_local_rom(struct fw_ohci *ohci,
+			     struct fw_packet *packet, u32 csr)
 {
 	struct fw_packet response;
 	int tcode, length, i;
@@ -1122,8 +1117,8 @@ handle_local_rom(struct fw_ohci *ohci, s
 	fw_core_handle_response(&ohci->card, &response);
 }
 
-static void
-handle_local_lock(struct fw_ohci *ohci, struct fw_packet *packet, u32 csr)
+static void handle_local_lock(struct fw_ohci *ohci,
+			      struct fw_packet *packet, u32 csr)
 {
 	struct fw_packet response;
 	int tcode, length, ext_tcode, sel;
@@ -1164,8 +1159,7 @@ handle_local_lock(struct fw_ohci *ohci, 
 	fw_core_handle_response(&ohci->card, &response);
 }
 
-static void
-handle_local_request(struct context *ctx, struct fw_packet *packet)
+static void handle_local_request(struct context *ctx, struct fw_packet *packet)
 {
 	u64 offset;
 	u32 csr;
@@ -1205,8 +1199,7 @@ handle_local_request(struct context *ctx
 	}
 }
 
-static void
-at_context_transmit(struct context *ctx, struct fw_packet *packet)
+static void at_context_transmit(struct context *ctx, struct fw_packet *packet)
 {
 	unsigned long flags;
 	int ret;
@@ -1590,8 +1583,8 @@ static int ohci_enable(struct fw_card *c
 	return 0;
 }
 
-static int
-ohci_set_config_rom(struct fw_card *card, u32 *config_rom, size_t length)
+static int ohci_set_config_rom(struct fw_card *card,
+			       u32 *config_rom, size_t length)
 {
 	struct fw_ohci *ohci;
 	unsigned long flags;
@@ -1711,8 +1704,8 @@ static int ohci_cancel_packet(struct fw_
 	return ret;
 }
 
-static int
-ohci_enable_phys_dma(struct fw_card *card, int node_id, int generation)
+static int ohci_enable_phys_dma(struct fw_card *card,
+				int node_id, int generation)
 {
 #ifdef CONFIG_FIREWIRE_OHCI_REMOTE_DMA
 	return 0;
@@ -1752,8 +1745,7 @@ ohci_enable_phys_dma(struct fw_card *car
 #endif /* CONFIG_FIREWIRE_OHCI_REMOTE_DMA */
 }
 
-static u64
-ohci_get_bus_time(struct fw_card *card)
+static u64 ohci_get_bus_time(struct fw_card *card)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
 	u32 cycle_time;
@@ -1884,8 +1876,8 @@ static int handle_it_packet(struct conte
 	return 1;
 }
 
-static struct fw_iso_context *
-ohci_allocate_iso_context(struct fw_card *card, int type, size_t header_size)
+static struct fw_iso_context *ohci_allocate_iso_context(struct fw_card *card,
+						int type, size_t header_size)
 {
 	struct fw_ohci *ohci = fw_ohci(card);
 	struct iso_context *ctx, *list;
@@ -2025,11 +2017,10 @@ static void ohci_free_iso_context(struct
 	spin_unlock_irqrestore(&ohci->lock, flags);
 }
 
-static int
-ohci_queue_iso_transmit(struct fw_iso_context *base,
-			struct fw_iso_packet *packet,
-			struct fw_iso_buffer *buffer,
-			unsigned long payload)
+static int ohci_queue_iso_transmit(struct fw_iso_context *base,
+				   struct fw_iso_packet *packet,
+				   struct fw_iso_buffer *buffer,
+				   unsigned long payload)
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
 	struct descriptor *d, *last, *pd;
@@ -2124,11 +2115,10 @@ ohci_queue_iso_transmit(struct fw_iso_co
 	return 0;
 }
 
-static int
-ohci_queue_iso_receive_dualbuffer(struct fw_iso_context *base,
-				  struct fw_iso_packet *packet,
-				  struct fw_iso_buffer *buffer,
-				  unsigned long payload)
+static int ohci_queue_iso_receive_dualbuffer(struct fw_iso_context *base,
+					     struct fw_iso_packet *packet,
+					     struct fw_iso_buffer *buffer,
+					     unsigned long payload)
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
 	struct db_descriptor *db = NULL;
@@ -2205,11 +2195,10 @@ ohci_queue_iso_receive_dualbuffer(struct
 	return 0;
 }
 
-static int
-ohci_queue_iso_receive_packet_per_buffer(struct fw_iso_context *base,
-					 struct fw_iso_packet *packet,
-					 struct fw_iso_buffer *buffer,
-					 unsigned long payload)
+static int ohci_queue_iso_receive_packet_per_buffer(struct fw_iso_context *base,
+					struct fw_iso_packet *packet,
+					struct fw_iso_buffer *buffer,
+					unsigned long payload)
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
 	struct descriptor *d = NULL, *pd = NULL;
@@ -2283,11 +2272,10 @@ ohci_queue_iso_receive_packet_per_buffer
 	return 0;
 }
 
-static int
-ohci_queue_iso(struct fw_iso_context *base,
-	       struct fw_iso_packet *packet,
-	       struct fw_iso_buffer *buffer,
-	       unsigned long payload)
+static int ohci_queue_iso(struct fw_iso_context *base,
+			  struct fw_iso_packet *packet,
+			  struct fw_iso_buffer *buffer,
+			  unsigned long payload)
 {
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
 	unsigned long flags;
@@ -2353,8 +2341,8 @@ static void ohci_pmac_off(struct pci_dev
 #define ohci_pmac_off(dev)
 #endif /* CONFIG_PPC_PMAC */
 
-static int __devinit
-pci_probe(struct pci_dev *dev, const struct pci_device_id *ent)
+static int __devinit pci_probe(struct pci_dev *dev,
+			       const struct pci_device_id *ent)
 {
 	struct fw_ohci *ohci;
 	u32 bus_options, max_receive, link_speed, version;
Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -387,20 +387,18 @@ static const struct {
 	}
 };
 
-static void
-free_orb(struct kref *kref)
+static void free_orb(struct kref *kref)
 {
 	struct sbp2_orb *orb = container_of(kref, struct sbp2_orb, kref);
 
 	kfree(orb);
 }
 
-static void
-sbp2_status_write(struct fw_card *card, struct fw_request *request,
-		  int tcode, int destination, int source,
-		  int generation, int speed,
-		  unsigned long long offset,
-		  void *payload, size_t length, void *callback_data)
+static void sbp2_status_write(struct fw_card *card, struct fw_request *request,
+			      int tcode, int destination, int source,
+			      int generation, int speed,
+			      unsigned long long offset,
+			      void *payload, size_t length, void *callback_data)
 {
 	struct sbp2_logical_unit *lu = callback_data;
 	struct sbp2_orb *orb;
@@ -446,9 +444,8 @@ sbp2_status_write(struct fw_card *card, 
 	fw_send_response(card, request, RCODE_COMPLETE);
 }
 
-static void
-complete_transaction(struct fw_card *card, int rcode,
-		     void *payload, size_t length, void *data)
+static void complete_transaction(struct fw_card *card, int rcode,
+				 void *payload, size_t length, void *data)
 {
 	struct sbp2_orb *orb = data;
 	unsigned long flags;
@@ -477,9 +474,8 @@ complete_transaction(struct fw_card *car
 	kref_put(&orb->kref, free_orb);
 }
 
-static void
-sbp2_send_orb(struct sbp2_orb *orb, struct sbp2_logical_unit *lu,
-	      int node_id, int generation, u64 offset)
+static void sbp2_send_orb(struct sbp2_orb *orb, struct sbp2_logical_unit *lu,
+			  int node_id, int generation, u64 offset)
 {
 	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	unsigned long flags;
@@ -526,8 +522,8 @@ static int sbp2_cancel_orbs(struct sbp2_
 	return retval;
 }
 
-static void
-complete_management_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
+static void complete_management_orb(struct sbp2_orb *base_orb,
+				    struct sbp2_status *status)
 {
 	struct sbp2_management_orb *orb =
 		container_of(base_orb, struct sbp2_management_orb, base);
@@ -537,10 +533,9 @@ complete_management_orb(struct sbp2_orb 
 	complete(&orb->done);
 }
 
-static int
-sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
-			 int generation, int function, int lun_or_login_id,
-			 void *response)
+static int sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
+				    int generation, int function,
+				    int lun_or_login_id, void *response)
 {
 	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_management_orb *orb;
@@ -647,9 +642,8 @@ static void sbp2_agent_reset(struct sbp2
 			   &d, sizeof(d));
 }
 
-static void
-complete_agent_reset_write_no_wait(struct fw_card *card, int rcode,
-				   void *payload, size_t length, void *data)
+static void complete_agent_reset_write_no_wait(struct fw_card *card,
+		int rcode, void *payload, size_t length, void *data)
 {
 	kfree(data);
 }
@@ -1273,8 +1267,7 @@ static struct fw_driver sbp2_driver = {
 	.id_table = sbp2_id_table,
 };
 
-static unsigned int
-sbp2_status_to_sense_data(u8 *sbp2_status, u8 *sense_data)
+static unsigned int sbp2_status_to_sense_data(u8 *sbp2_status, u8 *sense_data)
 {
 	int sam_status;
 
@@ -1311,8 +1304,8 @@ sbp2_status_to_sense_data(u8 *sbp2_statu
 	}
 }
 
-static void
-complete_command_orb(struct sbp2_orb *base_orb, struct sbp2_status *status)
+static void complete_command_orb(struct sbp2_orb *base_orb,
+				 struct sbp2_status *status)
 {
 	struct sbp2_command_orb *orb =
 		container_of(base_orb, struct sbp2_command_orb, base);
@@ -1366,9 +1359,8 @@ complete_command_orb(struct sbp2_orb *ba
 	orb->done(orb->cmd);
 }
 
-static int
-sbp2_map_scatterlist(struct sbp2_command_orb *orb, struct fw_device *device,
-		     struct sbp2_logical_unit *lu)
+static int sbp2_map_scatterlist(struct sbp2_command_orb *orb,
+		struct fw_device *device, struct sbp2_logical_unit *lu)
 {
 	struct scatterlist *sg = scsi_sglist(orb->cmd);
 	int i, n;
@@ -1573,9 +1565,8 @@ static int sbp2_scsi_abort(struct scsi_c
  * This is the concatenation of target port identifier and logical unit
  * identifier as per SAM-2...SAM-4 annex A.
  */
-static ssize_t
-sbp2_sysfs_ieee1394_id_show(struct device *dev, struct device_attribute *attr,
-			    char *buf)
+static ssize_t sbp2_sysfs_ieee1394_id_show(struct device *dev,
+			struct device_attribute *attr, char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct sbp2_logical_unit *lu;
Index: linux/drivers/firewire/fw-topology.c
===================================================================
--- linux.orig/drivers/firewire/fw-topology.c
+++ linux/drivers/firewire/fw-topology.c
@@ -314,9 +314,8 @@ typedef void (*fw_node_callback_t)(struc
 				   struct fw_node * node,
 				   struct fw_node * parent);
 
-static void
-for_each_fw_node(struct fw_card *card, struct fw_node *root,
-		 fw_node_callback_t callback)
+static void for_each_fw_node(struct fw_card *card, struct fw_node *root,
+			     fw_node_callback_t callback)
 {
 	struct list_head list;
 	struct fw_node *node, *next, *child, *parent;
@@ -349,9 +348,8 @@ for_each_fw_node(struct fw_card *card, s
 		fw_node_put(node);
 }
 
-static void
-report_lost_node(struct fw_card *card,
-		 struct fw_node *node, struct fw_node *parent)
+static void report_lost_node(struct fw_card *card,
+			     struct fw_node *node, struct fw_node *parent)
 {
 	fw_node_event(card, node, FW_NODE_DESTROYED);
 	fw_node_put(node);
@@ -360,9 +358,8 @@ report_lost_node(struct fw_card *card,
 	card->bm_retries = 0;
 }
 
-static void
-report_found_node(struct fw_card *card,
-		  struct fw_node *node, struct fw_node *parent)
+static void report_found_node(struct fw_card *card,
+			      struct fw_node *node, struct fw_node *parent)
 {
 	int b_path = (node->phy_speed == SCODE_BETA);
 
@@ -415,8 +412,7 @@ static void move_tree(struct fw_node *no
  * found, lost or updated.  Update the nodes in the card topology tree
  * as we go.
  */
-static void
-update_tree(struct fw_card *card, struct fw_node *root)
+static void update_tree(struct fw_card *card, struct fw_node *root)
 {
 	struct list_head list0, list1;
 	struct fw_node *node0, *node1, *next1;
@@ -497,8 +493,8 @@ update_tree(struct fw_card *card, struct
 	}
 }
 
-static void
-update_topology_map(struct fw_card *card, u32 *self_ids, int self_id_count)
+static void update_topology_map(struct fw_card *card,
+				u32 *self_ids, int self_id_count)
 {
 	int node_count;
 
@@ -510,10 +506,8 @@ update_topology_map(struct fw_card *card
 	fw_compute_block_crc(card->topology_map);
 }
 
-void
-fw_core_handle_bus_reset(struct fw_card *card,
-			 int node_id, int generation,
-			 int self_id_count, u32 * self_ids)
+void fw_core_handle_bus_reset(struct fw_card *card, int node_id, int generation,
+			      int self_id_count, u32 *self_ids)
 {
 	struct fw_node *local_node;
 	unsigned long flags;
Index: linux/drivers/firewire/fw-topology.h
===================================================================
--- linux.orig/drivers/firewire/fw-topology.h
+++ linux/drivers/firewire/fw-topology.h
@@ -51,26 +51,21 @@ struct fw_node {
 	struct fw_node *ports[0];
 };
 
-static inline struct fw_node *
-fw_node_get(struct fw_node *node)
+static inline struct fw_node *fw_node_get(struct fw_node *node)
 {
 	atomic_inc(&node->ref_count);
 
 	return node;
 }
 
-static inline void
-fw_node_put(struct fw_node *node)
+static inline void fw_node_put(struct fw_node *node)
 {
 	if (atomic_dec_and_test(&node->ref_count))
 		kfree(node);
 }
 
-void
-fw_destroy_nodes(struct fw_card *card);
-
-int
-fw_compute_block_crc(u32 *block);
+void fw_destroy_nodes(struct fw_card *card);
 
+int fw_compute_block_crc(u32 *block);
 
 #endif /* __fw_topology_h */
Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -64,10 +64,9 @@
 #define PHY_CONFIG_ROOT_ID(node_id)	((((node_id) & 0x3f) << 24) | (1 << 23))
 #define PHY_IDENTIFIER(id)		((id) << 30)
 
-static int
-close_transaction(struct fw_transaction *transaction,
-		  struct fw_card *card, int rcode,
-		  u32 *payload, size_t length)
+static int close_transaction(struct fw_transaction *transaction,
+			     struct fw_card *card, int rcode,
+			     u32 *payload, size_t length)
 {
 	struct fw_transaction *t;
 	unsigned long flags;
@@ -94,9 +93,8 @@ close_transaction(struct fw_transaction 
  * Only valid for transactions that are potentially pending (ie have
  * been sent).
  */
-int
-fw_cancel_transaction(struct fw_card *card,
-		      struct fw_transaction *transaction)
+int fw_cancel_transaction(struct fw_card *card,
+			  struct fw_transaction *transaction)
 {
 	/*
 	 * Cancel the packet transmission if it's still queued.  That
@@ -116,9 +114,8 @@ fw_cancel_transaction(struct fw_card *ca
 }
 EXPORT_SYMBOL(fw_cancel_transaction);
 
-static void
-transmit_complete_callback(struct fw_packet *packet,
-			   struct fw_card *card, int status)
+static void transmit_complete_callback(struct fw_packet *packet,
+				       struct fw_card *card, int status)
 {
 	struct fw_transaction *t =
 	    container_of(packet, struct fw_transaction, packet);
@@ -151,8 +148,7 @@ transmit_complete_callback(struct fw_pac
 	}
 }
 
-static void
-fw_fill_request(struct fw_packet *packet, int tcode, int tlabel,
+static void fw_fill_request(struct fw_packet *packet, int tcode, int tlabel,
 		int destination_id, int source_id, int generation, int speed,
 		unsigned long long offset, void *payload, size_t length)
 {
@@ -247,12 +243,10 @@ fw_fill_request(struct fw_packet *packet
  * @param callback_data pointer to arbitrary data, which will be
  *   passed to the callback
  */
-void
-fw_send_request(struct fw_card *card, struct fw_transaction *t,
-		int tcode, int destination_id, int generation, int speed,
-		unsigned long long offset,
-		void *payload, size_t length,
-		fw_transaction_callback_t callback, void *callback_data)
+void fw_send_request(struct fw_card *card, struct fw_transaction *t, int tcode,
+		     int destination_id, int generation, int speed,
+		     unsigned long long offset, void *payload, size_t length,
+		     fw_transaction_callback_t callback, void *callback_data)
 {
 	unsigned long flags;
 	int tlabel;
@@ -322,8 +316,8 @@ static void transaction_callback(struct 
  * Returns the RCODE.
  */
 int fw_run_transaction(struct fw_card *card, int tcode, int destination_id,
-		int generation, int speed, unsigned long long offset,
-		void *data, size_t length)
+		       int generation, int speed, unsigned long long offset,
+		       void *data, size_t length)
 {
 	struct transaction_callback_data d;
 	struct fw_transaction t;
@@ -399,9 +393,8 @@ void fw_flush_transactions(struct fw_car
 	}
 }
 
-static struct fw_address_handler *
-lookup_overlapping_address_handler(struct list_head *list,
-				   unsigned long long offset, size_t length)
+static struct fw_address_handler *lookup_overlapping_address_handler(
+	struct list_head *list, unsigned long long offset, size_t length)
 {
 	struct fw_address_handler *handler;
 
@@ -414,9 +407,8 @@ lookup_overlapping_address_handler(struc
 	return NULL;
 }
 
-static struct fw_address_handler *
-lookup_enclosing_address_handler(struct list_head *list,
-				 unsigned long long offset, size_t length)
+static struct fw_address_handler *lookup_enclosing_address_handler(
+	struct list_head *list, unsigned long long offset, size_t length)
 {
 	struct fw_address_handler *handler;
 
@@ -463,9 +455,8 @@ const struct fw_address_region fw_unit_s
  * The start offset of the handler's address region is determined by
  * fw_core_add_address_handler() and is returned in handler->offset.
  */
-int
-fw_core_add_address_handler(struct fw_address_handler *handler,
-			    const struct fw_address_region *region)
+int fw_core_add_address_handler(struct fw_address_handler *handler,
+				const struct fw_address_region *region)
 {
 	struct fw_address_handler *other;
 	unsigned long flags;
@@ -522,9 +513,8 @@ struct fw_request {
 	u32 data[0];
 };
 
-static void
-free_response_callback(struct fw_packet *packet,
-		       struct fw_card *card, int status)
+static void free_response_callback(struct fw_packet *packet,
+				   struct fw_card *card, int status)
 {
 	struct fw_request *request;
 
@@ -532,9 +522,8 @@ free_response_callback(struct fw_packet 
 	kfree(request);
 }
 
-void
-fw_fill_response(struct fw_packet *response, u32 *request_header,
-		 int rcode, void *payload, size_t length)
+void fw_fill_response(struct fw_packet *response, u32 *request_header,
+		      int rcode, void *payload, size_t length)
 {
 	int tcode, tlabel, extended_tcode, source, destination;
 
@@ -592,8 +581,7 @@ fw_fill_response(struct fw_packet *respo
 }
 EXPORT_SYMBOL(fw_fill_response);
 
-static struct fw_request *
-allocate_request(struct fw_packet *p)
+static struct fw_request *allocate_request(struct fw_packet *p)
 {
 	struct fw_request *request;
 	u32 *data, length;
@@ -653,8 +641,8 @@ allocate_request(struct fw_packet *p)
 	return request;
 }
 
-void
-fw_send_response(struct fw_card *card, struct fw_request *request, int rcode)
+void fw_send_response(struct fw_card *card,
+		      struct fw_request *request, int rcode)
 {
 	/* unified transaction or broadcast transaction: don't respond */
 	if (request->ack != ACK_PENDING ||
@@ -674,8 +662,7 @@ fw_send_response(struct fw_card *card, s
 }
 EXPORT_SYMBOL(fw_send_response);
 
-void
-fw_core_handle_request(struct fw_card *card, struct fw_packet *p)
+void fw_core_handle_request(struct fw_card *card, struct fw_packet *p)
 {
 	struct fw_address_handler *handler;
 	struct fw_request *request;
@@ -723,8 +710,7 @@ fw_core_handle_request(struct fw_card *c
 }
 EXPORT_SYMBOL(fw_core_handle_request);
 
-void
-fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
+void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
 {
 	struct fw_transaction *t;
 	unsigned long flags;
@@ -797,12 +783,10 @@ static const struct fw_address_region to
 	{ .start = CSR_REGISTER_BASE | CSR_TOPOLOGY_MAP,
 	  .end   = CSR_REGISTER_BASE | CSR_TOPOLOGY_MAP_END, };
 
-static void
-handle_topology_map(struct fw_card *card, struct fw_request *request,
-		    int tcode, int destination, int source,
-		    int generation, int speed,
-		    unsigned long long offset,
-		    void *payload, size_t length, void *callback_data)
+static void handle_topology_map(struct fw_card *card, struct fw_request *request,
+		int tcode, int destination, int source, int generation,
+		int speed, unsigned long long offset,
+		void *payload, size_t length, void *callback_data)
 {
 	int i, start, end;
 	__be32 *map;
@@ -836,12 +820,10 @@ static const struct fw_address_region re
 	{ .start = CSR_REGISTER_BASE,
 	  .end   = CSR_REGISTER_BASE | CSR_CONFIG_ROM, };
 
-static void
-handle_registers(struct fw_card *card, struct fw_request *request,
-		 int tcode, int destination, int source,
-		 int generation, int speed,
-		 unsigned long long offset,
-		 void *payload, size_t length, void *callback_data)
+static void handle_registers(struct fw_card *card, struct fw_request *request,
+		int tcode, int destination, int source, int generation,
+		int speed, unsigned long long offset,
+		void *payload, size_t length, void *callback_data)
 {
 	int reg = offset & ~CSR_REGISTER_BASE;
 	unsigned long long bus_time;
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -88,8 +88,7 @@
 #define fw_notify(s, args...) printk(KERN_NOTICE KBUILD_MODNAME ": " s, ## args)
 #define fw_error(s, args...) printk(KERN_ERR KBUILD_MODNAME ": " s, ## args)
 
-static inline void
-fw_memcpy_from_be32(void *_dst, void *_src, size_t size)
+static inline void fw_memcpy_from_be32(void *_dst, void *_src, size_t size)
 {
 	u32    *dst = _dst;
 	__be32 *src = _src;
@@ -99,8 +98,7 @@ fw_memcpy_from_be32(void *_dst, void *_s
 		dst[i] = be32_to_cpu(src[i]);
 }
 
-static inline void
-fw_memcpy_to_be32(void *_dst, void *_src, size_t size)
+static inline void fw_memcpy_to_be32(void *_dst, void *_src, size_t size)
 {
 	fw_memcpy_from_be32(_dst, _src, size);
 }
@@ -125,8 +123,7 @@ typedef void (*fw_packet_callback_t)(str
 				     struct fw_card *card, int status);
 
 typedef void (*fw_transaction_callback_t)(struct fw_card *card, int rcode,
-					  void *data,
-					  size_t length,
+					  void *data, size_t length,
 					  void *callback_data);
 
 /*
@@ -201,7 +198,6 @@ struct fw_address_handler {
 	struct list_head link;
 };
 
-
 struct fw_address_region {
 	u64 start;
 	u64 end;
@@ -315,10 +311,8 @@ struct fw_iso_packet {
 struct fw_iso_context;
 
 typedef void (*fw_iso_callback_t)(struct fw_iso_context *context,
-				  u32 cycle,
-				  size_t header_length,
-				  void *header,
-				  void *data);
+				  u32 cycle, size_t header_length,
+				  void *header, void *data);
 
 /*
  * An iso buffer is just a set of pages mapped for DMA in the
@@ -344,36 +338,22 @@ struct fw_iso_context {
 	void *callback_data;
 };
 
-int
-fw_iso_buffer_init(struct fw_iso_buffer *buffer,
-		   struct fw_card *card,
-		   int page_count,
-		   enum dma_data_direction direction);
-int
-fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma);
-void
-fw_iso_buffer_destroy(struct fw_iso_buffer *buffer, struct fw_card *card);
-
-struct fw_iso_context *
-fw_iso_context_create(struct fw_card *card, int type,
-		      int channel, int speed, size_t header_size,
-		      fw_iso_callback_t callback, void *callback_data);
-
-void
-fw_iso_context_destroy(struct fw_iso_context *ctx);
-
-int
-fw_iso_context_queue(struct fw_iso_context *ctx,
-		     struct fw_iso_packet *packet,
-		     struct fw_iso_buffer *buffer,
-		     unsigned long payload);
-
-int
-fw_iso_context_start(struct fw_iso_context *ctx,
-		     int cycle, int sync, int tags);
-
-int
-fw_iso_context_stop(struct fw_iso_context *ctx);
+int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
+		       int page_count, enum dma_data_direction direction);
+int fw_iso_buffer_map(struct fw_iso_buffer *buffer, struct vm_area_struct *vma);
+void fw_iso_buffer_destroy(struct fw_iso_buffer *buffer, struct fw_card *card);
+
+struct fw_iso_context *fw_iso_context_create(struct fw_card *card,
+		int type, int channel, int speed, size_t header_size,
+		fw_iso_callback_t callback, void *callback_data);
+int fw_iso_context_queue(struct fw_iso_context *ctx,
+			 struct fw_iso_packet *packet,
+			 struct fw_iso_buffer *buffer,
+			 unsigned long payload);
+int fw_iso_context_start(struct fw_iso_context *ctx,
+			 int cycle, int sync, int tags);
+int fw_iso_context_stop(struct fw_iso_context *ctx);
+void fw_iso_context_destroy(struct fw_iso_context *ctx);
 
 struct fw_card_driver {
 	/*
@@ -429,24 +409,18 @@ struct fw_card_driver {
 	int (*stop_iso)(struct fw_iso_context *ctx);
 };
 
-int
-fw_core_initiate_bus_reset(struct fw_card *card, int short_reset);
+int fw_core_initiate_bus_reset(struct fw_card *card, int short_reset);
 
-void
-fw_send_request(struct fw_card *card, struct fw_transaction *t,
+void fw_send_request(struct fw_card *card, struct fw_transaction *t,
 		int tcode, int destination_id, int generation, int speed,
 		unsigned long long offset, void *data, size_t length,
 		fw_transaction_callback_t callback, void *callback_data);
-
-int fw_run_transaction(struct fw_card *card, int tcode, int destination_id,
-		       int generation, int speed, unsigned long long offset,
-		       void *data, size_t length);
-
 int fw_cancel_transaction(struct fw_card *card,
 			  struct fw_transaction *transaction);
-
 void fw_flush_transactions(struct fw_card *card);
-
+int fw_run_transaction(struct fw_card *card, int tcode, int destination_id,
+		       int generation, int speed, unsigned long long offset,
+		       void *data, size_t length);
 void fw_send_phy_config(struct fw_card *card,
 			int node_id, int generation, int gap_count);
 
@@ -454,29 +428,18 @@ void fw_send_phy_config(struct fw_card *
  * Called by the topology code to inform the device code of node
  * activity; found, lost, or updated nodes.
  */
-void
-fw_node_event(struct fw_card *card, struct fw_node *node, int event);
+void fw_node_event(struct fw_card *card, struct fw_node *node, int event);
 
 /* API used by card level drivers */
 
-void
-fw_card_initialize(struct fw_card *card, const struct fw_card_driver *driver,
-		   struct device *device);
-int
-fw_card_add(struct fw_card *card,
-	    u32 max_receive, u32 link_speed, u64 guid);
-
-void
-fw_core_remove_card(struct fw_card *card);
-
-void
-fw_core_handle_bus_reset(struct fw_card *card,
-			 int node_id, int generation,
-			 int self_id_count, u32 *self_ids);
-void
-fw_core_handle_request(struct fw_card *card, struct fw_packet *request);
-
-void
-fw_core_handle_response(struct fw_card *card, struct fw_packet *packet);
+void fw_card_initialize(struct fw_card *card,
+		const struct fw_card_driver *driver, struct device *device);
+int fw_card_add(struct fw_card *card,
+		u32 max_receive, u32 link_speed, u64 guid);
+void fw_core_remove_card(struct fw_card *card);
+void fw_core_handle_bus_reset(struct fw_card *card, int node_id,
+		int generation, int self_id_count, u32 *self_ids);
+void fw_core_handle_request(struct fw_card *card, struct fw_packet *request);
+void fw_core_handle_response(struct fw_card *card, struct fw_packet *packet);
 
 #endif /* __fw_transaction_h */

-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/

