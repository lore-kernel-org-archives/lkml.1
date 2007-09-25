Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbXIYOpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbXIYOpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbXIYOpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:45:25 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:44406 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751554AbXIYOpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:45:22 -0400
Message-ID: <46F91EFB.2050802@suse.de>
Date: Tue, 25 Sep 2007 18:45:15 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alexey Starikovskiy <aystarik@gmail.com>,
       Damien Wyart <damien.wyart@free.fr>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>, linux-acpi@vger.kernel.org
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
References: <20070925065109.GA3080@localhost.localdomain> <200709251618.06064.rjw@sisk.pl> <46F918F8.1080808@suse.de> <200709251652.05589.rjw@sisk.pl>
In-Reply-To: <200709251652.05589.rjw@sisk.pl>
Content-Type: multipart/mixed;
 boundary="------------010405040701090104030505"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010405040701090104030505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Rafael J. Wysocki wrote:
> On Tuesday, 25 September 2007 16:19, Alexey Starikovskiy wrote:
>> Rafael J. Wysocki wrote:
>>> On Tuesday, 25 September 2007 15:15, Alexey Starikovskiy wrote:
>>>> Rafael J. Wysocki wrote:
>>>>> On Tuesday, 25 September 2007 14:53, Alexey Starikovskiy wrote:
>>>>>> Rafael J. Wysocki wrote:
>>>>>>> On Tuesday, 25 September 2007 14:05, Alexey Starikovskiy wrote:
>>>>>>>> Rafael J. Wysocki wrote:
>>>>>>>>> On Tuesday, 25 September 2007 13:45, Rafael J. Wysocki wrote:
>>>>>>>>>> On Tuesday, 25 September 2007 11:58, Damien Wyart wrote:
>>>>>>>>>>>>> No, I do not have CONFIG_ACPI_SLEEP set,
>>>>>>>>>>>>> because I do not have CONFIG_PM_SLEEP set,
>>>>>>>>>>>>> because I do not want SUSPEND and/or HIBERNATION.
>>>>>>>>>>>> Same answer from my side: I do not have CONFIG_ACPI_SLEEP for the same
>>>>>>>>>>>> reason (and this worked fine without them in rc7). I do not think
>>>>>>>>>>>> these settings should have changed between rc7 and rc8.
>>>>>>>>>> Well, we haven't changed much.
>>>>>>>>>>
>>>>>>>>>>> Also, another test I just did: on another computer, rc8 is fine
>>>>>>>>>>> regarding ACPI power off, even if CONFIG_ACPI_SLEEP is not set. I can
>>>>>>>>>>> provide config if needed.
>>>>>>>>>> On the box that fails to power off, can you please test -rc8 with these two
>>>>>>>>>> commits reverted:
>>>>>>>>>>
>>>>>>>>>> commit 5a50fe709d527f31169263e36601dd83446d5744
>>>>>>>>>> ACPI: suspend: consolidate handling of Sx states addendum
>>>>>>>>>>
>>>>>>>>>> commit f216cc3748a3a22c2b99390fddcdafa0583791a2
>>>>>>>>>> ACPI: suspend: consolidate handling of Sx states.
>>>>>>>>>>
>>>>>>>>>> and see if it works?
>>>>>>>>> If it does, please test the patch from this message
>>>>>>>>>
>>>>>>>>> http://marc.info/?l=linux-kernel&m=119052978117735&w=4
>>>>>>>>>
>>>>>>>>> on top of vanilla 2.6.23-rc8.
>>>>>>>> You will need one more patch on top of just mentioned one.
>>>>>>> Hm, why did you put acpi_target_sleep_state under CONFIG_SUSPEND?
>>>>>>>
>>>>>>> CONFIG_HIBERNATION needs acpi_target_sleep_state  too.
>>>>>> Agree, attaching updated patch.
>>>>> Well, please use "ifdef CONFIG_PM_SLEEP" instead of
>>>>> "if defined(CONFIG_SUSPEND)||defined(CONFIG_HIBERNATION)",
>>>>> as you did with the second block.
>>>> I was thinking about that, but it seem to be less clear... 
>>>> We need this variable only for suspend or hibernation, nothing else.
>>>> with pm_sleep it is not visible at all.
>>>>
>>>> Thoughts?
>>> Well, PM_SLEEP is defined as (SUSPEND || HIBERNATION), please have a look
>>> at kernel/power/Kconfig, and it was introduced exactly for the conditions like
>>> this.
>> I've seen this then I wrote the patch :) See my point, it is not clear, 
>> that PM_SLEEP is equivalent to SUSPEND || HIBERNATION, one needs to 
>> grep Kconfig files to find that -- it means that code becomes less readable, 
>> and I would like to avoid that.
> 
> I see your point.  Still, you are using PM_SLEEP in the same file, so someone
> reading the code for the first time will have to find out what it is anyway.
In the second place it depends on header file using PM_SLEEP, so it makes sense.
> 
> OTOH, the only function of PM_SLEEP is to be a replacement for
> (SUSPEND || HIBERNATION).  It has no other meaning whatsoever.
> 
> [Well, sorry, I couldn't invent a better name.]
>  
>>> IOW, if we want something to be used for anything else than suspend or
>>> hibernation, it shouldn't be defined under PM_SLEEP.
>> Agree, but we should distinguish there it is better to use PM_SLEEP, 
>> and there it is better to use (SUSPEND || HIBERNATION) just to be more expressive...
> 
> Well, since PM_SLEEP is used as (SUSPEND || HIBERNATION) everywhere else,
> I think that it would actually be confusing not to use it here. :-)
Ok, patch is here.

Regards,
Alex.

--------------010405040701090104030505
Content-Type: text/x-patch;
 name="fix-ACPI_SLEEP_states.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-ACPI_SLEEP_states.patch"

ACPI: suspend: fix ACPI_SLEEP states

From: Alexey Starikovskiy <astarikovskiy@suse.de>

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/sleep/Makefile |    2 +-
 drivers/acpi/sleep/main.c   |    4 ++++
 include/acpi/acpi_drivers.h |    4 ----
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/sleep/Makefile b/drivers/acpi/sleep/Makefile
index ba9bd40..f1fb888 100644
--- a/drivers/acpi/sleep/Makefile
+++ b/drivers/acpi/sleep/Makefile
@@ -1,5 +1,5 @@
 obj-y					:= wakeup.o
-obj-$(CONFIG_ACPI_SLEEP)		+= main.o
+obj-y					+= main.o
 obj-$(CONFIG_ACPI_SLEEP)		+= proc.o
 
 EXTRA_CFLAGS += $(ACPI_CFLAGS)
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index c79edcb..2cbb9aa 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -24,7 +24,9 @@
 
 u8 sleep_states[ACPI_S_STATE_COUNT];
 
+#ifdef CONFIG_PM_SLEEP
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
+#endif
 
 int acpi_sleep_prepare(u32 acpi_state)
 {
@@ -299,6 +301,7 @@ int acpi_suspend(u32 acpi_state)
 	return -EINVAL;
 }
 
+#ifdef CONFIG_PM_SLEEP
 /**
  *	acpi_pm_device_sleep_state - return preferred power state of ACPI device
  *		in the system sleep state given by %acpi_target_sleep_state
@@ -373,6 +376,7 @@ int acpi_pm_device_sleep_state(struct device *dev, int wake, int *d_min_p)
 		*d_min_p = d_min;
 	return d_max;
 }
+#endif
 
 static void acpi_power_off_prepare(void)
 {
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 202acb9..f85f77a 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -147,10 +147,6 @@ static inline void unregister_hotplug_dock_device(acpi_handle handle)
 /*--------------------------------------------------------------------------
                                   Suspend/Resume
   -------------------------------------------------------------------------- */
-#ifdef CONFIG_ACPI_SLEEP
 extern int acpi_sleep_init(void);
-#else
-static inline int acpi_sleep_init(void) { return 0; }
-#endif
 
 #endif /*__ACPI_DRIVERS_H__*/

--------------010405040701090104030505--
