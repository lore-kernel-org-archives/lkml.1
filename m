Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbYHDRlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbYHDRlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbYHDRlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:41:12 -0400
Received: from mga07.intel.com ([143.182.124.22]:39715 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754626AbYHDRlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:41:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,306,1215414000"; 
   d="scan'208";a="29519721"
Date: Mon, 4 Aug 2008 10:41:10 -0700
From: mark gross <mgross@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, richard@hughsie.com
Subject: Re: spell check patch to pm_qos_params.c
Message-ID: <20080804174110.GA20970@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080801175245.GC23227@linux.intel.com> <20080801134617.e82c802c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801134617.e82c802c.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 04 Aug 2008 17:41:10.0572 (UTC) FILETIME=[484F06C0:01C8F659]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 01:46:17PM -0700, Randy Dunlap wrote:
> On Fri, 1 Aug 2008 10:52:45 -0700 mark gross wrote:
> 
> > This is a documentation clean up patch form Richard Hughes.
> 
> from

yes.

> 
> > 
> > With a minor tweak to clarify units for kbs.
> > 
> > Please apply.
> > 
> > thanks,
> > 
> > --mgross
> > 
> > 
> > Signed-off-by: mark gross <mgross@linux.intel.com>
> > 
> >  Documentation/power/pm_qos_interface.txt |    7 ++++++-
> >  include/linux/pm_qos_params.h            |    2 +-
> >  kernel/pm_qos_params.c                   |   16 ++++++++--------
> >  3 files changed, 15 insertions(+), 10 deletions(-)
> > 
> > 
> > Index: linux-2.6/Documentation/power/pm_qos_interface.txt
> > ===================================================================
> > --- linux-2.6.orig/Documentation/power/pm_qos_interface.txt	2008-08-01 09:28:42.000000000 -0700
> > +++ linux-2.6/Documentation/power/pm_qos_interface.txt	2008-08-01 10:46:04.000000000 -0700
> 
> > @@ -7,6 +7,11 @@
> >  Currently we have {cpu_dma_latency, network_latency, network_throughput} as the
> >  initial set of pm_qos parameters.
> >  
> > +Each parameters have defined units:
> 
>    Each parameter has defined units:

fixed.

> 
> > + * latency: usec
> > + * timeout: usec
> > + * throughput: kbs (kilo bit / sec)
> > +
> >  The infrastructure exposes multiple misc device nodes one per implemented
> >  parameter.  The set of parameters implement is defined by pm_qos_power_init()
> >  and pm_qos_params.h.  This is done because having the available parameters
>


--mgross


 Documentation/power/pm_qos_interface.txt |    7 ++++++-
 include/linux/pm_qos_params.h            |    2 +-
 kernel/pm_qos_params.c                   |   16 ++++++++--------
 3 files changed, 15 insertions(+), 10 deletions(-)

Signed-off-by: mark gross <mgross@linux.intel.com>


Index: linux-2.6/Documentation/power/pm_qos_interface.txt
===================================================================
--- linux-2.6.orig/Documentation/power/pm_qos_interface.txt	2008-08-01 09:28:42.000000000 -0700
+++ linux-2.6/Documentation/power/pm_qos_interface.txt	2008-08-04 10:35:56.000000000 -0700
@@ -1,4 +1,4 @@
-PM quality of Service interface.
+PM Quality Of Service Interface.
 
 This interface provides a kernel and user mode interface for registering
 performance expectations by drivers, subsystems and user space applications on
@@ -7,6 +7,11 @@
 Currently we have {cpu_dma_latency, network_latency, network_throughput} as the
 initial set of pm_qos parameters.
 
+Each parameters has defined units:
+ * latency: usec
+ * timeout: usec
+ * throughput: kbs (kilo bit / sec)
+
 The infrastructure exposes multiple misc device nodes one per implemented
 parameter.  The set of parameters implement is defined by pm_qos_power_init()
 and pm_qos_params.h.  This is done because having the available parameters
Index: linux-2.6/include/linux/pm_qos_params.h
===================================================================
--- linux-2.6.orig/include/linux/pm_qos_params.h	2008-08-01 09:28:48.000000000 -0700
+++ linux-2.6/include/linux/pm_qos_params.h	2008-08-01 10:27:36.000000000 -0700
@@ -1,6 +1,6 @@
 /* interface for the pm_qos_power infrastructure of the linux kernel.
  *
- * Mark Gross
+ * Mark Gross <mgross@linux.intel.com>
  */
 #include <linux/list.h>
 #include <linux/notifier.h>
Index: linux-2.6/kernel/pm_qos_params.c
===================================================================
--- linux-2.6.orig/kernel/pm_qos_params.c	2008-08-01 09:28:49.000000000 -0700
+++ linux-2.6/kernel/pm_qos_params.c	2008-08-04 10:37:16.000000000 -0700
@@ -24,7 +24,7 @@
  * requirement that the application has is cleaned up when closes the file
  * pointer or exits the pm_qos_object will get an opportunity to clean up.
  *
- * mark gross mgross@linux.intel.com
+ * Mark Gross <mgross@linux.intel.com>
  */
 
 #include <linux/pm_qos_params.h>
@@ -211,8 +211,8 @@
  * @value: defines the qos request
  *
  * This function inserts a new entry in the pm_qos_class list of requested qos
- * performance charactoistics.  It recomputes the agregate QoS expectations for
- * the pm_qos_class of parrameters.
+ * performance characteristics.  It recomputes the aggregate QoS expectations
+ * for the pm_qos_class of parameters.
  */
 int pm_qos_add_requirement(int pm_qos_class, char *name, s32 value)
 {
@@ -250,10 +250,10 @@
  * @name: identifies the request
  * @value: defines the qos request
  *
- * Updates an existing qos requierement for the pm_qos_class of parameters along
+ * Updates an existing qos requirement for the pm_qos_class of parameters along
  * with updating the target pm_qos_class value.
  *
- * If the named request isn't in the lest then no change is made.
+ * If the named request isn't in the list then no change is made.
  */
 int pm_qos_update_requirement(int pm_qos_class, char *name, s32 new_value)
 {
@@ -287,7 +287,7 @@
  * @pm_qos_class: identifies which list of qos request to us
  * @name: identifies the request
  *
- * Will remove named qos request from pm_qos_class list of parrameters and
+ * Will remove named qos request from pm_qos_class list of parameters and
  * recompute the current target value for the pm_qos_class.
  */
 void pm_qos_remove_requirement(int pm_qos_class, char *name)
@@ -319,7 +319,7 @@
  * @notifier: notifier block managed by caller.
  *
  * will register the notifier into a notification chain that gets called
- * uppon changes to the pm_qos_class target value.
+ * upon changes to the pm_qos_class target value.
  */
  int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
@@ -338,7 +338,7 @@
  * @notifier: notifier block to be removed.
  *
  * will remove the notifier from the notification chain that gets called
- * uppon changes to the pm_qos_class target value.
+ * upon changes to the pm_qos_class target value.
  */
 int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
