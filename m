Return-Path: <linux-kernel-owner+w=401wt.eu-S1765799AbYAYIVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765799AbYAYIVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760897AbYAYIAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:54 -0500
Received: from ns2.suse.de ([195.135.220.15]:53686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763723AbYAYH7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 193/196] Driver core: fix coding style issues in device.h
Date: Thu, 24 Jan 2008 23:33:42 -0800
Message-Id: <1201246425-5058-114-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally clean up the odd spaces and other mess in device.h

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/device.h |  283 +++++++++++++++++++++++++-----------------------
 1 files changed, 145 insertions(+), 138 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index cdaf57b..1880208 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -25,7 +25,8 @@
 #include <asm/device.h>
 
 #define DEVICE_NAME_SIZE	50
-#define DEVICE_NAME_HALF	__stringify(20)	/* Less than half to accommodate slop */
+/* DEVICE_NAME_HALF is really less than half to accommodate slop */
+#define DEVICE_NAME_HALF	__stringify(20)
 #define DEVICE_ID_SIZE		32
 #define BUS_ID_SIZE		KOBJ_NAME_LEN
 
@@ -40,52 +41,53 @@ struct bus_type_private;
 
 struct bus_attribute {
 	struct attribute	attr;
-	ssize_t (*show)(struct bus_type *, char * buf);
-	ssize_t (*store)(struct bus_type *, const char * buf, size_t count);
+	ssize_t (*show)(struct bus_type *bus, char *buf);
+	ssize_t (*store)(struct bus_type *bus, const char *buf, size_t count);
 };
 
-#define BUS_ATTR(_name,_mode,_show,_store)	\
-struct bus_attribute bus_attr_##_name = __ATTR(_name,_mode,_show,_store)
+#define BUS_ATTR(_name, _mode, _show, _store)	\
+struct bus_attribute bus_attr_##_name = __ATTR(_name, _mode, _show, _store)
 
 extern int __must_check bus_create_file(struct bus_type *,
 					struct bus_attribute *);
 extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
 
 struct bus_type {
-	const char		* name;
-	struct bus_attribute	* bus_attrs;
-	struct device_attribute	* dev_attrs;
-	struct driver_attribute	* drv_attrs;
-
-	int		(*match)(struct device * dev, struct device_driver * drv);
-	int		(*uevent)(struct device *dev, struct kobj_uevent_env *env);
-	int		(*probe)(struct device * dev);
-	int		(*remove)(struct device * dev);
-	void		(*shutdown)(struct device * dev);
-
-	int (*suspend)(struct device * dev, pm_message_t state);
-	int (*suspend_late)(struct device * dev, pm_message_t state);
-	int (*resume_early)(struct device * dev);
-	int (*resume)(struct device * dev);
+	const char		*name;
+	struct bus_attribute	*bus_attrs;
+	struct device_attribute	*dev_attrs;
+	struct driver_attribute	*drv_attrs;
+
+	int (*match)(struct device *dev, struct device_driver *drv);
+	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
+	int (*probe)(struct device *dev);
+	int (*remove)(struct device *dev);
+	void (*shutdown)(struct device *dev);
+
+	int (*suspend)(struct device *dev, pm_message_t state);
+	int (*suspend_late)(struct device *dev, pm_message_t state);
+	int (*resume_early)(struct device *dev);
+	int (*resume)(struct device *dev);
 
 	struct bus_type_private *p;
 };
 
-extern int __must_check bus_register(struct bus_type * bus);
-extern void bus_unregister(struct bus_type * bus);
+extern int __must_check bus_register(struct bus_type *bus);
+extern void bus_unregister(struct bus_type *bus);
 
-extern int __must_check bus_rescan_devices(struct bus_type * bus);
+extern int __must_check bus_rescan_devices(struct bus_type *bus);
 
 /* iterator helpers for buses */
 
-int bus_for_each_dev(struct bus_type * bus, struct device * start, void * data,
-		     int (*fn)(struct device *, void *));
-struct device * bus_find_device(struct bus_type *bus, struct device *start,
-				void *data, int (*match)(struct device *, void *));
+int bus_for_each_dev(struct bus_type *bus, struct device *start, void *data,
+		     int (*fn)(struct device *dev, void *data));
+struct device *bus_find_device(struct bus_type *bus, struct device *start,
+			       void *data,
+			       int (*match)(struct device *dev, void *data));
 
 int __must_check bus_for_each_drv(struct bus_type *bus,
-		struct device_driver *start, void *data,
-		int (*fn)(struct device_driver *, void *));
+				  struct device_driver *start, void *data,
+				  int (*fn)(struct device_driver *, void *));
 
 /*
  * Bus notifiers: Get notified of addition/removal of devices
@@ -120,57 +122,63 @@ struct device_driver {
 	struct module		*owner;
 	const char 		*mod_name;	/* used for built-in modules */
 
-	int	(*probe)	(struct device * dev);
-	int	(*remove)	(struct device * dev);
-	void	(*shutdown)	(struct device * dev);
-	int	(*suspend)	(struct device * dev, pm_message_t state);
-	int	(*resume)	(struct device * dev);
+	int (*probe) (struct device *dev);
+	int (*remove) (struct device *dev);
+	void (*shutdown) (struct device *dev);
+	int (*suspend) (struct device *dev, pm_message_t state);
+	int (*resume) (struct device *dev);
 	struct attribute_group **groups;
 
 	struct driver_private *p;
 };
 
 
-extern int __must_check driver_register(struct device_driver * drv);
-extern void driver_unregister(struct device_driver * drv);
+extern int __must_check driver_register(struct device_driver *drv);
+extern void driver_unregister(struct device_driver *drv);
 
-extern struct device_driver * get_driver(struct device_driver * drv);
-extern void put_driver(struct device_driver * drv);
-extern struct device_driver *driver_find(const char *name, struct bus_type *bus);
+extern struct device_driver *get_driver(struct device_driver *drv);
+extern void put_driver(struct device_driver *drv);
+extern struct device_driver *driver_find(const char *name,
+					 struct bus_type *bus);
 extern int driver_probe_done(void);
 
 /* sysfs interface for exporting driver attributes */
 
 struct driver_attribute {
-	struct attribute	attr;
-	ssize_t (*show)(struct device_driver *, char * buf);
-	ssize_t (*store)(struct device_driver *, const char * buf, size_t count);
+	struct attribute attr;
+	ssize_t (*show)(struct device_driver *driver, char *buf);
+	ssize_t (*store)(struct device_driver *driver, const char *buf,
+			 size_t count);
 };
 
-#define DRIVER_ATTR(_name,_mode,_show,_store)	\
-struct driver_attribute driver_attr_##_name = __ATTR(_name,_mode,_show,_store)
+#define DRIVER_ATTR(_name, _mode, _show, _store)	\
+struct driver_attribute driver_attr_##_name =		\
+	__ATTR(_name, _mode, _show, _store)
 
-extern int __must_check driver_create_file(struct device_driver *,
-					struct driver_attribute *);
-extern void driver_remove_file(struct device_driver *, struct driver_attribute *);
+extern int __must_check driver_create_file(struct device_driver *driver,
+					   struct driver_attribute *attr);
+extern void driver_remove_file(struct device_driver *driver,
+			       struct driver_attribute *attr);
 
 extern int __must_check driver_add_kobj(struct device_driver *drv,
 					struct kobject *kobj,
 					const char *fmt, ...);
 
-extern int __must_check driver_for_each_device(struct device_driver * drv,
-		struct device *start, void *data,
-		int (*fn)(struct device *, void *));
-struct device * driver_find_device(struct device_driver *drv,
-				   struct device *start, void *data,
-				   int (*match)(struct device *, void *));
+extern int __must_check driver_for_each_device(struct device_driver *drv,
+					       struct device *start,
+					       void *data,
+					       int (*fn)(struct device *dev,
+							 void *));
+struct device *driver_find_device(struct device_driver *drv,
+				  struct device *start, void *data,
+				  int (*match)(struct device *dev, void *data));
 
 /*
  * device classes
  */
 struct class {
-	const char		* name;
-	struct module		* owner;
+	const char		*name;
+	struct module		*owner;
 
 	struct kset		subsys;
 	struct list_head	children;
@@ -178,23 +186,23 @@ struct class {
 	struct list_head	interfaces;
 	struct kset		class_dirs;
 	struct semaphore	sem; /* locks children, devices, interfaces */
-	struct class_attribute		* class_attrs;
-	struct class_device_attribute	* class_dev_attrs;
-	struct device_attribute		* dev_attrs;
+	struct class_attribute		*class_attrs;
+	struct class_device_attribute	*class_dev_attrs;
+	struct device_attribute		*dev_attrs;
 
-	int	(*uevent)(struct class_device *dev, struct kobj_uevent_env *env);
-	int	(*dev_uevent)(struct device *dev, struct kobj_uevent_env *env);
+	int (*uevent)(struct class_device *dev, struct kobj_uevent_env *env);
+	int (*dev_uevent)(struct device *dev, struct kobj_uevent_env *env);
 
-	void	(*release)(struct class_device *dev);
-	void	(*class_release)(struct class *class);
-	void	(*dev_release)(struct device *dev);
+	void (*release)(struct class_device *dev);
+	void (*class_release)(struct class *class);
+	void (*dev_release)(struct device *dev);
 
-	int	(*suspend)(struct device *, pm_message_t state);
-	int	(*resume)(struct device *);
+	int (*suspend)(struct device *dev, pm_message_t state);
+	int (*resume)(struct device *dev);
 };
 
-extern int __must_check class_register(struct class *);
-extern void class_unregister(struct class *);
+extern int __must_check class_register(struct class *class);
+extern void class_unregister(struct class *class);
 extern int class_for_each_device(struct class *class, void *data,
 				 int (*fn)(struct device *dev, void *data));
 extern struct device *class_find_device(struct class *class, void *data,
@@ -204,27 +212,28 @@ extern struct class_device *class_find_child(struct class *class, void *data,
 
 
 struct class_attribute {
-	struct attribute	attr;
-	ssize_t (*show)(struct class *, char * buf);
-	ssize_t (*store)(struct class *, const char * buf, size_t count);
+	struct attribute attr;
+	ssize_t (*show)(struct class *class, char *buf);
+	ssize_t (*store)(struct class *class, const char *buf, size_t count);
 };
 
-#define CLASS_ATTR(_name,_mode,_show,_store)			\
-struct class_attribute class_attr_##_name = __ATTR(_name,_mode,_show,_store) 
+#define CLASS_ATTR(_name, _mode, _show, _store)			\
+struct class_attribute class_attr_##_name = __ATTR(_name, _mode, _show, _store)
 
-extern int __must_check class_create_file(struct class *,
-					const struct class_attribute *);
-extern void class_remove_file(struct class *, const struct class_attribute *);
+extern int __must_check class_create_file(struct class *class,
+					  const struct class_attribute *attr);
+extern void class_remove_file(struct class *class,
+			      const struct class_attribute *attr);
 
 struct class_device_attribute {
-	struct attribute	attr;
-	ssize_t (*show)(struct class_device *, char * buf);
-	ssize_t (*store)(struct class_device *, const char * buf, size_t count);
+	struct attribute attr;
+	ssize_t (*show)(struct class_device *, char *buf);
+	ssize_t (*store)(struct class_device *, const char *buf, size_t count);
 };
 
-#define CLASS_DEVICE_ATTR(_name,_mode,_show,_store)		\
+#define CLASS_DEVICE_ATTR(_name, _mode, _show, _store)		\
 struct class_device_attribute class_device_attr_##_name = 	\
-	__ATTR(_name,_mode,_show,_store)
+	__ATTR(_name, _mode, _show, _store)
 
 extern int __must_check class_device_create_file(struct class_device *,
 				    const struct class_device_attribute *);
@@ -257,26 +266,24 @@ struct class_device {
 	struct list_head	node;
 
 	struct kobject		kobj;
-	struct class		* class;	/* required */
-	dev_t			devt;		/* dev_t, creates the sysfs "dev" */
-	struct device		* dev;		/* not necessary, but nice to have */
-	void			* class_data;	/* class-specific data */
-	struct class_device	*parent;	/* parent of this child device, if there is one */
-	struct attribute_group  ** groups;	/* optional groups */
-
-	void	(*release)(struct class_device *dev);
-	int	(*uevent)(struct class_device *dev, struct kobj_uevent_env *env);
-	char	class_id[BUS_ID_SIZE];	/* unique to this class */
+	struct class		*class;
+	dev_t			devt;
+	struct device		*dev;
+	void			*class_data;
+	struct class_device	*parent;
+	struct attribute_group  **groups;
+
+	void (*release)(struct class_device *dev);
+	int (*uevent)(struct class_device *dev, struct kobj_uevent_env *env);
+	char class_id[BUS_ID_SIZE];
 };
 
-static inline void *
-class_get_devdata (struct class_device *dev)
+static inline void *class_get_devdata(struct class_device *dev)
 {
 	return dev->class_data;
 }
 
-static inline void
-class_set_devdata (struct class_device *dev, void *data)
+static inline void class_set_devdata(struct class_device *dev, void *data)
 {
 	dev->class_data = data;
 }
@@ -288,10 +295,10 @@ extern void class_device_initialize(struct class_device *);
 extern int __must_check class_device_add(struct class_device *);
 extern void class_device_del(struct class_device *);
 
-extern struct class_device * class_device_get(struct class_device *);
+extern struct class_device *class_device_get(struct class_device *);
 extern void class_device_put(struct class_device *);
 
-extern void class_device_remove_file(struct class_device *, 
+extern void class_device_remove_file(struct class_device *,
 				     const struct class_device_attribute *);
 extern int __must_check class_device_create_bin_file(struct class_device *,
 					struct bin_attribute *);
@@ -318,7 +325,7 @@ extern struct class_device *class_device_create(struct class *cls,
 						dev_t devt,
 						struct device *device,
 						const char *fmt, ...)
-					__attribute__((format(printf,5,6)));
+					__attribute__((format(printf, 5, 6)));
 extern void class_device_destroy(struct class *cls, dev_t devt);
 
 /*
@@ -335,8 +342,8 @@ struct device_type {
 	struct attribute_group **groups;
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
 	void (*release)(struct device *dev);
-	int (*suspend)(struct device * dev, pm_message_t state);
-	int (*resume)(struct device * dev);
+	int (*suspend)(struct device *dev, pm_message_t state);
+	int (*resume)(struct device *dev);
 };
 
 /* interface for exporting device attributes */
@@ -348,18 +355,19 @@ struct device_attribute {
 			 const char *buf, size_t count);
 };
 
-#define DEVICE_ATTR(_name,_mode,_show,_store) \
-struct device_attribute dev_attr_##_name = __ATTR(_name,_mode,_show,_store)
+#define DEVICE_ATTR(_name, _mode, _show, _store) \
+struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
 
 extern int __must_check device_create_file(struct device *device,
-					struct device_attribute * entry);
-extern void device_remove_file(struct device * dev, struct device_attribute * attr);
+					   struct device_attribute *entry);
+extern void device_remove_file(struct device *dev,
+			       struct device_attribute *attr);
 extern int __must_check device_create_bin_file(struct device *dev,
 					       struct bin_attribute *attr);
 extern void device_remove_bin_file(struct device *dev,
 				   struct bin_attribute *attr);
 extern int device_schedule_callback_owner(struct device *dev,
-		void (*func)(struct device *), struct module *owner);
+		void (*func)(struct device *dev), struct module *owner);
 
 /* This is a macro to avoid include problems with THIS_MODULE */
 #define device_schedule_callback(dev, func)			\
@@ -370,21 +378,21 @@ typedef void (*dr_release_t)(struct device *dev, void *res);
 typedef int (*dr_match_t)(struct device *dev, void *res, void *match_data);
 
 #ifdef CONFIG_DEBUG_DEVRES
-extern void * __devres_alloc(dr_release_t release, size_t size, gfp_t gfp,
+extern void *__devres_alloc(dr_release_t release, size_t size, gfp_t gfp,
 			     const char *name);
 #define devres_alloc(release, size, gfp) \
 	__devres_alloc(release, size, gfp, #release)
 #else
-extern void * devres_alloc(dr_release_t release, size_t size, gfp_t gfp);
+extern void *devres_alloc(dr_release_t release, size_t size, gfp_t gfp);
 #endif
 extern void devres_free(void *res);
 extern void devres_add(struct device *dev, void *res);
-extern void * devres_find(struct device *dev, dr_release_t release,
-			  dr_match_t match, void *match_data);
-extern void * devres_get(struct device *dev, void *new_res,
+extern void *devres_find(struct device *dev, dr_release_t release,
 			 dr_match_t match, void *match_data);
-extern void * devres_remove(struct device *dev, dr_release_t release,
-			    dr_match_t match, void *match_data);
+extern void *devres_get(struct device *dev, void *new_res,
+			dr_match_t match, void *match_data);
+extern void *devres_remove(struct device *dev, dr_release_t release,
+			   dr_match_t match, void *match_data);
 extern int devres_destroy(struct device *dev, dr_release_t release,
 			  dr_match_t match, void *match_data);
 
@@ -401,7 +409,7 @@ extern void devm_kfree(struct device *dev, void *p);
 
 struct device {
 	struct klist		klist_children;
-	struct klist_node	knode_parent;		/* node in sibling list */
+	struct klist_node	knode_parent;	/* node in sibling list */
 	struct klist_node	knode_driver;
 	struct klist_node	knode_bus;
 	struct device		*parent;
@@ -416,7 +424,7 @@ struct device {
 					 * its driver.
 					 */
 
-	struct bus_type	* bus;		/* type of bus device is on */
+	struct bus_type	*bus;		/* type of bus device is on */
 	struct device_driver *driver;	/* which driver has allocated this
 					   device */
 	void		*driver_data;	/* data private to the driver */
@@ -447,10 +455,10 @@ struct device {
 	/* class_device migration path */
 	struct list_head	node;
 	struct class		*class;
-	dev_t			devt;		/* dev_t, creates the sysfs "dev" */
+	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
 	struct attribute_group	**groups;	/* optional groups */
 
-	void	(*release)(struct device * dev);
+	void	(*release)(struct device *dev);
 };
 
 #ifdef CONFIG_NUMA
@@ -472,14 +480,12 @@ static inline void set_dev_node(struct device *dev, int node)
 }
 #endif
 
-static inline void *
-dev_get_drvdata (struct device *dev)
+static inline void *dev_get_drvdata(struct device *dev)
 {
 	return dev->driver_data;
 }
 
-static inline void
-dev_set_drvdata (struct device *dev, void *data)
+static inline void dev_set_drvdata(struct device *dev, void *data)
 {
 	dev->driver_data = data;
 }
@@ -494,15 +500,15 @@ void driver_init(void);
 /*
  * High level routines for use by the bus drivers
  */
-extern int __must_check device_register(struct device * dev);
-extern void device_unregister(struct device * dev);
-extern void device_initialize(struct device * dev);
-extern int __must_check device_add(struct device * dev);
-extern void device_del(struct device * dev);
-extern int device_for_each_child(struct device *, void *,
-		     int (*fn)(struct device *, void *));
-extern struct device *device_find_child(struct device *, void *data,
-					int (*match)(struct device *, void *));
+extern int __must_check device_register(struct device *dev);
+extern void device_unregister(struct device *dev);
+extern void device_initialize(struct device *dev);
+extern int __must_check device_add(struct device *dev);
+extern void device_del(struct device *dev);
+extern int device_for_each_child(struct device *dev, void *data,
+		     int (*fn)(struct device *dev, void *data));
+extern struct device *device_find_child(struct device *dev, void *data,
+				int (*match)(struct device *dev, void *data));
 extern int device_rename(struct device *dev, char *new_name);
 extern int device_move(struct device *dev, struct device *new_parent);
 
@@ -511,8 +517,8 @@ extern int device_move(struct device *dev, struct device *new_parent);
  * for information on use.
  */
 extern int __must_check device_bind_driver(struct device *dev);
-extern void device_release_driver(struct device * dev);
-extern int  __must_check device_attach(struct device * dev);
+extern void device_release_driver(struct device *dev);
+extern int  __must_check device_attach(struct device *dev);
 extern int __must_check driver_attach(struct device_driver *drv);
 extern int __must_check device_reprobe(struct device *dev);
 
@@ -521,7 +527,7 @@ extern int __must_check device_reprobe(struct device *dev);
  */
 extern struct device *device_create(struct class *cls, struct device *parent,
 				    dev_t devt, const char *fmt, ...)
-				    __attribute__((format(printf,4,5)));
+				    __attribute__((format(printf, 4, 5)));
 extern void device_destroy(struct class *cls, dev_t devt);
 #ifdef CONFIG_PM_SLEEP
 extern void destroy_suspended_device(struct class *cls, dev_t devt);
@@ -538,17 +544,17 @@ static inline void destroy_suspended_device(struct class *cls, dev_t devt)
  * know about.
  */
 /* Notify platform of device discovery */
-extern int (*platform_notify)(struct device * dev);
+extern int (*platform_notify)(struct device *dev);
 
-extern int (*platform_notify_remove)(struct device * dev);
+extern int (*platform_notify_remove)(struct device *dev);
 
 
 /**
  * get_device - atomically increment the reference count for the device.
  *
  */
-extern struct device * get_device(struct device * dev);
-extern void put_device(struct device * dev);
+extern struct device *get_device(struct device *dev);
+extern void put_device(struct device *dev);
 
 
 /* drivers/base/power/shutdown.c */
@@ -560,7 +566,8 @@ extern void sysdev_shutdown(void);
 /* debugging and troubleshooting/diagnostic helpers. */
 extern const char *dev_driver_string(struct device *dev);
 #define dev_printk(level, dev, format, arg...)	\
-	printk(level "%s %s: " format , dev_driver_string(dev) , (dev)->bus_id , ## arg)
+	printk(level "%s %s: " format , dev_driver_string(dev) , \
+	       (dev)->bus_id , ## arg)
 
 #define dev_emerg(dev, format, arg...)		\
 	dev_printk(KERN_EMERG , dev , format , ## arg)
@@ -582,7 +589,7 @@ extern const char *dev_driver_string(struct device *dev);
 	dev_printk(KERN_DEBUG , dev , format , ## arg)
 #else
 static inline int __attribute__ ((format (printf, 2, 3)))
-dev_dbg(struct device * dev, const char * fmt, ...)
+dev_dbg(struct device *dev, const char *fmt, ...)
 {
 	return 0;
 }
@@ -592,7 +599,7 @@ dev_dbg(struct device * dev, const char * fmt, ...)
 #define dev_vdbg	dev_dbg
 #else
 static inline int __attribute__ ((format (printf, 2, 3)))
-dev_vdbg(struct device * dev, const char * fmt, ...)
+dev_vdbg(struct device *dev, const char *fmt, ...)
 {
 	return 0;
 }
-- 
1.5.3.8

