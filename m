Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZHSXOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZHSXOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 19:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZHSXOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 19:14:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34098 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZHSXO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 19:14:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 1/7] PM: Update kerneldoc comments in drivers/base/power/main.c
Date: Thu, 20 Aug 2009 01:14:51 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <Pine.LNX.4.44L0.0908191822520.26174-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0908191822520.26174-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908200114.51290.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Alan Stern wrote:
> On Wed, 19 Aug 2009, Rafael J. Wysocki wrote:
> 
> > On Monday 17 August 2009, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > Subject: PM: Update kerneldoc comments in drivers/base/power/main.c
> > > 
> > > The kerneldoc comments in drivers/base/power/main.c are generally
> > > outdated and some of them don't describe the functions very
> > > accurately.  Update them and standardize the format to use spaces
> > > instead of tabs.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Any objections to this patch from anyone?  Greg, Alan, Randy?
> 
> Just some very minor changes.

Thanks for spotting the mistakes.

> > >  /**
> > > - *	pm_op - execute the PM operation appropiate for given PM event
> > > - *	@dev:	Device.
> > > - *	@ops:	PM operations to choose from.
> > > - *	@state:	PM transition of the system being carried out.
> > > + * pm_op - Execute the PM operation appropiate for given PM event.
> > > + * @dev: Device to handle.
> > > + * @ops: PM operations to choose from.
> > > + * @state: PM transition of the system being carried out.
> > >   */
> 
> Here and in several places below, "appropriate" is missing an "r".
> 
> > >  /**
> > > - *	pm_noirq_op - execute the PM operation appropiate for given PM event
> > > - *	@dev:	Device.
> > > - *	@ops:	PM operations to choose from.
> > > - *	@state: PM transition of the system being carried out.
> > > + * pm_noirq_op - Execute the PM operation appropiate for given PM event.
> > > + * @dev: Device to handle.
> > > + * @ops: PM operations to choose from.
> > > + * @state: PM transition of the system being carried out.
> > >   *
> > > - *	The operation is executed with interrupts disabled by the only remaining
> > > - *	functional CPU in the system.
> > > + * The driver of @dev will not receive interrupts while this fuction is being
> > > + * executed.
> > >   */
> 
> Here and in several places below, "function" is missing an "n".
> 
> > >  /**
> > > - *	dpm_resume - Resume every device.
> > > - *	@state: PM transition of the system being carried out.
> > > + * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
> > > + * @state: PM transition of the system being carried out.
> > >   *
> > > - *	Execute the appropriate "resume" callback for all devices the status of
> > > - *	which indicates that they are inactive.
> > > + * Execute the appropriate "resume" callback for all devices the status of which
> > > + * indicates that they are suspended.
> > >   */
> 
> The phrasing is slightly awkward.  "... all devices whose status
> indicates..." would be better.  Below as well.
> 
> > >  /**
> > > - *	dpm_resume_end - Restore state of each device in system.
> > > - *	@state: PM transition of the system being carried out.
> > > + * dpm_resume_end - Execute "resume" callbacks and complete system transition.
> > > + * @state: PM transition of the system being carried out.
> > >   *
> > > - *	Resume all the devices, unlock them all, and allow new
> > > - *	devices to be registered once again.
> > > + * Resume all the devices, unlock them all, and complete the PM transition of
> > > + * the system.
> > >   */
> 
> The "unlock them all" part is a fossil.  It should be removed.

Agreed.

Updated patch is appended.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Update kerneldoc comments in drivers/base/power/main.c

The kerneldoc comments in drivers/base/power/main.c are generally
outdated and some of them don't describe the functions very
accurately.  Update them and standardize the format to use spaces
instead of tabs.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/main.c |  169 ++++++++++++++++++++++------------------------
 1 file changed, 84 insertions(+), 85 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -50,7 +50,7 @@ static DEFINE_MUTEX(dpm_list_mtx);
 static bool transition_started;
 
 /**
- * device_pm_init - Initialize the PM-related part of a device object
+ * device_pm_init - Initialize the PM-related part of a device object.
  * @dev: Device object being initialized.
  */
 void device_pm_init(struct device *dev)
@@ -60,7 +60,7 @@ void device_pm_init(struct device *dev)
 }
 
 /**
- *	device_pm_lock - lock the list of active devices used by the PM core
+ * device_pm_lock - Lock the list of active devices used by the PM core.
  */
 void device_pm_lock(void)
 {
@@ -68,7 +68,7 @@ void device_pm_lock(void)
 }
 
 /**
- *	device_pm_unlock - unlock the list of active devices used by the PM core
+ * device_pm_unlock - Unlock the list of active devices used by the PM core.
  */
 void device_pm_unlock(void)
 {
@@ -76,8 +76,8 @@ void device_pm_unlock(void)
 }
 
 /**
- *	device_pm_add - add a device to the list of active devices
- *	@dev:	Device to be added to the list
+ * device_pm_add - Add a device to the PM core's list of active devices.
+ * @dev: Device to add to the list.
  */
 void device_pm_add(struct device *dev)
 {
@@ -103,10 +103,8 @@ void device_pm_add(struct device *dev)
 }
 
 /**
- *	device_pm_remove - remove a device from the list of active devices
- *	@dev:	Device to be removed from the list
- *
- *	This function also removes the device's PM-related sysfs attributes.
+ * device_pm_remove - Remove a device from the PM core's list of active devices.
+ * @dev: Device to be removed from the list.
  */
 void device_pm_remove(struct device *dev)
 {
@@ -120,9 +118,9 @@ void device_pm_remove(struct device *dev
 }
 
 /**
- *	device_pm_move_before - move device in dpm_list
- *	@deva:  Device to move in dpm_list
- *	@devb:  Device @deva should come before
+ * device_pm_move_before - Move device in the PM core's list of active devices.
+ * @deva: Device to move in dpm_list.
+ * @devb: Device @deva should come before.
  */
 void device_pm_move_before(struct device *deva, struct device *devb)
 {
@@ -136,9 +134,9 @@ void device_pm_move_before(struct device
 }
 
 /**
- *	device_pm_move_after - move device in dpm_list
- *	@deva:  Device to move in dpm_list
- *	@devb:  Device @deva should come after
+ * device_pm_move_after - Move device in the PM core's list of active devices.
+ * @deva: Device to move in dpm_list.
+ * @devb: Device @deva should come after.
  */
 void device_pm_move_after(struct device *deva, struct device *devb)
 {
@@ -152,8 +150,8 @@ void device_pm_move_after(struct device 
 }
 
 /**
- * 	device_pm_move_last - move device to end of dpm_list
- * 	@dev:   Device to move in dpm_list
+ * device_pm_move_last - Move device to end of the PM core's list of devices.
+ * @dev: Device to move in dpm_list.
  */
 void device_pm_move_last(struct device *dev)
 {
@@ -164,10 +162,10 @@ void device_pm_move_last(struct device *
 }
 
 /**
- *	pm_op - execute the PM operation appropiate for given PM event
- *	@dev:	Device.
- *	@ops:	PM operations to choose from.
- *	@state:	PM transition of the system being carried out.
+ * pm_op - Execute the PM operation appropriate for given PM event.
+ * @dev: Device to handle.
+ * @ops: PM operations to choose from.
+ * @state: PM transition of the system being carried out.
  */
 static int pm_op(struct device *dev,
 		 const struct dev_pm_ops *ops,
@@ -225,13 +223,13 @@ static int pm_op(struct device *dev,
 }
 
 /**
- *	pm_noirq_op - execute the PM operation appropiate for given PM event
- *	@dev:	Device.
- *	@ops:	PM operations to choose from.
- *	@state: PM transition of the system being carried out.
+ * pm_noirq_op - Execute the PM operation appropriate for given PM event.
+ * @dev: Device to handle.
+ * @ops: PM operations to choose from.
+ * @state: PM transition of the system being carried out.
  *
- *	The operation is executed with interrupts disabled by the only remaining
- *	functional CPU in the system.
+ * The driver of @dev will not receive interrupts while this function is being
+ * executed.
  */
 static int pm_noirq_op(struct device *dev,
 			const struct dev_pm_ops *ops,
@@ -329,11 +327,12 @@ static void pm_dev_err(struct device *de
 /*------------------------- Resume routines -------------------------*/
 
 /**
- *	device_resume_noirq - Power on one device (early resume).
- *	@dev:	Device.
- *	@state: PM transition of the system being carried out.
+ * device_resume_noirq - Execute an "early resume" callback for given device.
+ * @dev: Device to handle.
+ * @state: PM transition of the system being carried out.
  *
- *	Must be called with interrupts disabled.
+ * The driver of @dev will not receive interrupts while this function is being
+ * executed.
  */
 static int device_resume_noirq(struct device *dev, pm_message_t state)
 {
@@ -355,14 +354,11 @@ static int device_resume_noirq(struct de
 }
 
 /**
- *	dpm_resume_noirq - Power on all regular (non-sysdev) devices.
- *	@state: PM transition of the system being carried out.
- *
- *	Call the "noirq" resume handlers for all devices marked as
- *	DPM_OFF_IRQ and enable device drivers to receive interrupts.
+ * dpm_resume_noirq - Execute "early resume" callbacks for non-sysdev devices.
+ * @state: PM transition of the system being carried out.
  *
- *	Must be called under dpm_list_mtx.  Device drivers should not receive
- *	interrupts while it's being executed.
+ * Call the "noirq" resume handlers for all devices marked as DPM_OFF_IRQ and
+ * enable device drivers to receive interrupts.
  */
 void dpm_resume_noirq(pm_message_t state)
 {
@@ -384,9 +380,9 @@ void dpm_resume_noirq(pm_message_t state
 EXPORT_SYMBOL_GPL(dpm_resume_noirq);
 
 /**
- *	device_resume - Restore state for one device.
- *	@dev:	Device.
- *	@state: PM transition of the system being carried out.
+ * device_resume - Execute "resume" callbacks for given device.
+ * @dev: Device to handle.
+ * @state: PM transition of the system being carried out.
  */
 static int device_resume(struct device *dev, pm_message_t state)
 {
@@ -435,11 +431,11 @@ static int device_resume(struct device *
 }
 
 /**
- *	dpm_resume - Resume every device.
- *	@state: PM transition of the system being carried out.
+ * dpm_resume - Execute "resume" callbacks for non-sysdev devices.
+ * @state: PM transition of the system being carried out.
  *
- *	Execute the appropriate "resume" callback for all devices the status of
- *	which indicates that they are inactive.
+ * Execute the appropriate "resume" callback for all devices whose status
+ * indicates that they are suspended.
  */
 static void dpm_resume(pm_message_t state)
 {
@@ -476,9 +472,9 @@ static void dpm_resume(pm_message_t stat
 }
 
 /**
- *	device_complete - Complete a PM transition for given device
- *	@dev:	Device.
- *	@state: PM transition of the system being carried out.
+ * device_complete - Complete a PM transition for given device.
+ * @dev: Device to handle.
+ * @state: PM transition of the system being carried out.
  */
 static void device_complete(struct device *dev, pm_message_t state)
 {
@@ -503,11 +499,11 @@ static void device_complete(struct devic
 }
 
 /**
- *	dpm_complete - Complete a PM transition for all devices.
- *	@state: PM transition of the system being carried out.
+ * dpm_complete - Complete a PM transition for all non-sysdev devices.
+ * @state: PM transition of the system being carried out.
  *
- *	Execute the ->complete() callbacks for all devices that are not marked
- *	as DPM_ON.
+ * Execute the ->complete() callbacks for all devices whose PM status is not
+ * DPM_ON (this allows new devices to be registered).
  */
 static void dpm_complete(pm_message_t state)
 {
@@ -537,11 +533,11 @@ static void dpm_complete(pm_message_t st
 }
 
 /**
- *	dpm_resume_end - Restore state of each device in system.
- *	@state: PM transition of the system being carried out.
+ * dpm_resume_end - Execute "resume" callbacks and complete system transition.
+ * @state: PM transition of the system being carried out.
  *
- *	Resume all the devices, unlock them all, and allow new
- *	devices to be registered once again.
+ * Execute "resume" callbacks for all devices and complete the PM transition of
+ * the system.
  */
 void dpm_resume_end(pm_message_t state)
 {
@@ -555,9 +551,11 @@ EXPORT_SYMBOL_GPL(dpm_resume_end);
 /*------------------------- Suspend routines -------------------------*/
 
 /**
- *	resume_event - return a PM message representing the resume event
- *	               corresponding to given sleep state.
- *	@sleep_state: PM message representing a sleep state.
+ * resume_event - Return a "resume" message for given "suspend" sleep state.
+ * @sleep_state: PM message representing a sleep state.
+ *
+ * Return a PM message representing the resume event corresponding to given
+ * sleep state.
  */
 static pm_message_t resume_event(pm_message_t sleep_state)
 {
@@ -574,11 +572,12 @@ static pm_message_t resume_event(pm_mess
 }
 
 /**
- *	device_suspend_noirq - Shut down one device (late suspend).
- *	@dev:	Device.
- *	@state: PM transition of the system being carried out.
+ * device_suspend_noirq - Execute a "late suspend" callback for given device.
+ * @dev: Device to handle.
+ * @state: PM transition of the system being carried out.
  *
- *	This is called with interrupts off and only a single CPU running.
+ * The driver of @dev will not receive interrupts while this function is being
+ * executed.
  */
 static int device_suspend_noirq(struct device *dev, pm_message_t state)
 {
@@ -595,13 +594,11 @@ static int device_suspend_noirq(struct d
 }
 
 /**
- *	dpm_suspend_noirq - Power down all regular (non-sysdev) devices.
- *	@state: PM transition of the system being carried out.
+ * dpm_suspend_noirq - Execute "late suspend" callbacks for non-sysdev devices.
+ * @state: PM transition of the system being carried out.
  *
- *	Prevent device drivers from receiving interrupts and call the "noirq"
- *	suspend handlers.
- *
- *	Must be called under dpm_list_mtx.
+ * Prevent device drivers from receiving interrupts and call the "noirq" suspend
+ * handlers for all non-sysdev devices.
  */
 int dpm_suspend_noirq(pm_message_t state)
 {
@@ -626,9 +623,9 @@ int dpm_suspend_noirq(pm_message_t state
 EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
 
 /**
- *	device_suspend - Save state of one device.
- *	@dev:	Device.
- *	@state: PM transition of the system being carried out.
+ * device_suspend - Execute "suspend" callbacks for given device.
+ * @dev: Device to handle.
+ * @state: PM transition of the system being carried out.
  */
 static int device_suspend(struct device *dev, pm_message_t state)
 {
@@ -675,10 +672,8 @@ static int device_suspend(struct device 
 }
 
 /**
- *	dpm_suspend - Suspend every device.
- *	@state: PM transition of the system being carried out.
- *
- *	Execute the appropriate "suspend" callbacks for all devices.
+ * dpm_suspend - Execute "suspend" callbacks for all non-sysdev devices.
+ * @state: PM transition of the system being carried out.
  */
 static int dpm_suspend(pm_message_t state)
 {
@@ -712,9 +707,12 @@ static int dpm_suspend(pm_message_t stat
 }
 
 /**
- *	device_prepare - Execute the ->prepare() callback(s) for given device.
- *	@dev:	Device.
- *	@state: PM transition of the system being carried out.
+ * device_prepare - Prepare a device for system power transition.
+ * @dev: Device to handle.
+ * @state: PM transition of the system being carried out.
+ *
+ * Execute the ->prepare() callback(s) for given device.  No new children of the
+ * device may be registered after this function has returned.
  */
 static int device_prepare(struct device *dev, pm_message_t state)
 {
@@ -750,10 +748,10 @@ static int device_prepare(struct device 
 }
 
 /**
- *	dpm_prepare - Prepare all devices for a PM transition.
- *	@state: PM transition of the system being carried out.
+ * dpm_prepare - Prepare all non-sysdev devices for a system PM transition.
+ * @state: PM transition of the system being carried out.
  *
- *	Execute the ->prepare() callback for all devices.
+ * Execute the ->prepare() callback(s) for all devices.
  */
 static int dpm_prepare(pm_message_t state)
 {
@@ -804,10 +802,11 @@ static int dpm_prepare(pm_message_t stat
 }
 
 /**
- *	dpm_suspend_start - Save state and stop all devices in system.
- *	@state: PM transition of the system being carried out.
+ * dpm_suspend_start - Prepare devices for PM transition and suspend them.
+ * @state: PM transition of the system being carried out.
  *
- *	Prepare and suspend all devices.
+ * Prepare all non-sysdev devices for system PM transition and execute "suspend"
+ * callbacks for them.
  */
 int dpm_suspend_start(pm_message_t state)
 {
