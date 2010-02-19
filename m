Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab0BSRIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:08:44 -0500
Received: from kroah.org ([198.145.64.141]:57661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab0BSRAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:51 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:46 2010
Message-Id: <20100219163246.376039962@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>, Anisse Astier <anisse@astier.eu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: [56/93] wmi: Free the allocated acpi objects through wmi_get_event_data
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Anisse Astier <anisse@astier.eu>

commit 3e9b988e4edf065d39c1343937f717319b1c1065 upstream

[ backported to 2.6.32 ]

These function allocate an acpi object by calling wmi_get_event_data, which
then calls acpi_evaluate_object, and it is not freed afterwards.

And kernel doc is fixed for parameters of wmi_get_event_data.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/dell-wmi.c |    1 +
 drivers/platform/x86/hp-wmi.c   |    2 ++
 drivers/platform/x86/wmi.c      |    4 ++--
 3 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -180,6 +180,7 @@ static void dell_wmi_notify(u32 value, v
 			printk(KERN_INFO "dell-wmi: Unknown key %x pressed\n",
 			       buffer[1] & 0xFFFF);
 	}
+	kfree(obj);
 }
 
 static int __init dell_wmi_input_setup(void)
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -377,6 +377,8 @@ static void hp_wmi_notify(u32 value, voi
 			       eventcode);
 	} else
 		printk(KERN_INFO "HP WMI: Unknown response received\n");
+
+	kfree(obj);
 }
 
 static int __init hp_wmi_input_setup(void)
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -510,8 +510,8 @@ EXPORT_SYMBOL_GPL(wmi_remove_notify_hand
 /**
  * wmi_get_event_data - Get WMI data associated with an event
  *
- * @event - Event to find
- * &out - Buffer to hold event data
+ * @event: Event to find
+ * @out: Buffer to hold event data. out->pointer should be freed with kfree()
  *
  * Returns extra data associated with an event in WMI.
  */


