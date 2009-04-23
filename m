Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZDWJlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZDWJlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 05:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZDWJlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 05:41:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:51121 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbZDWJli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 05:41:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,235,1239001200"; 
   d="scan'208";a="134916520"
From: "Shi, Alex" <alex.shi@intel.com>
To: "Shi, Alex" <alex.shi@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
CC: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       Len Brown <lenb@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Zhao, Yakui" <yakui.zhao@intel.com>,
       "Brown, Len" <len.brown@intel.com>
Date: Thu, 23 Apr 2009 17:40:24 +0800
Subject: RE: [patch 012/100] acpi: fix of pmtimer overflow that make Cx
 states time incorrect
Thread-Topic: [patch 012/100] acpi: fix of pmtimer overflow that make Cx
 states time incorrect
Thread-Index: AcnD5FbKB7gAH/4zQmKRfSxbbBMdKQAELJZgAACEMNA=
Message-ID: <F7C8A4D3A9905B45A80E4C194793FA6501D2FC03A1@PDSMSX501.ccr.corp.intel.com>
References: <20090423072020.428683652@sous-sol.org>
 <20090423072212.535803819@sous-sol.org> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3N9fvqu020680

Update: 
Len Brown's patch may fix this bug.
http://bugzilla.kernel.org/show_bug.cgi?id=13087#c41 

Alex 

>-----Original Message-----
>From: Shi, Alex
>Sent: 2009Äê4ÔÂ23ÈÕ 17:25
>To: 'Chris Wright'; linux-kernel@vger.kernel.org; stable@kernel.org
>Cc: Justin Forbes; Zwane Mwaikambo; Theodore Ts'o; Randy Dunlap; Dave Jones;
>Chuck Wolber; Chris Wedgwood; Michael Krufky; Chuck Ebbert; Domenico Andreoli;
>Willy Tarreau; Rodrigo Rubira Branco; Jake Edge; Eugene Teo;
>torvalds@linux-foundation.org; akpm@linux-foundation.org;
>alan@lxorguk.ukuu.org.uk; Len Brown; linux-acpi@vger.kernel.org; Pallipadi,
>Venkatesh; Zhao, Yakui; Brown, Len
>Subject: RE: [patch 012/100] acpi: fix of pmtimer overflow that make Cx states
>time incorrect
>
>It was reported make some latop booting hang. and is not root caused now. :(
>http://bugzilla.kernel.org/show_bug.cgi?id=13087
>
>Alex
>>-----Original Message-----
>>From: Chris Wright [mailto:chrisw@sous-sol.org]
>>Sent: 2009Äê4ÔÂ23ÈÕ 15:21
>>To: linux-kernel@vger.kernel.org; stable@kernel.org
>>Cc: Justin Forbes; Zwane Mwaikambo; Theodore Ts'o; Randy Dunlap; Dave Jones;
>>Chuck Wolber; Chris Wedgwood; Michael Krufky; Chuck Ebbert; Domenico Andreoli;
>>Willy Tarreau; Rodrigo Rubira Branco; Jake Edge; Eugene Teo;
>>torvalds@linux-foundation.org; akpm@linux-foundation.org;
>>alan@lxorguk.ukuu.org.uk; Len Brown; linux-acpi@vger.kernel.org; Shi, Alex;
>>Pallipadi, Venkatesh; Zhao, Yakui; Brown, Len
>>Subject: [patch 012/100] acpi: fix of pmtimer overflow that make Cx states time
>>incorrect
>>
>>-stable review patch.  If anyone has any objections, please let us know.
>>---------------------
>>
>>From: alex.shi <alex.shi@intel.com>
>>
>>upstream commit: ff69f2bba67bd45514923aaedbf40fe351787c59
>>
>>We found Cx states time abnormal in our some of machines which have 16
>>LCPUs, the C0 take too many time while system is really idle when kernel
>>enabled tickless and highres.  powertop output is below:
>>
>>     PowerTOP version 1.9       (C) 2007 Intel Corporation
>>
>>Cn                Avg residency       P-states (frequencies)
>>C0 (cpu running)        (40.5%)         2.53 Ghz     0.0%
>>C1                0.0ms ( 0.0%)         2.53 Ghz     0.0%
>>C2              128.8ms (59.5%)         2.40 Ghz     0.0%
>>                                        1.60 Ghz   100.0%
>>
>>Wakeups-from-idle per second :  4.7     interval: 20.0s
>>no ACPI power usage estimate available
>>
>>Top causes for wakeups:
>>  41.4% ( 24.9)       <interrupt> : extra timer interrupt
>>  20.2% ( 12.2)     <kernel core> : usb_hcd_poll_rh_status
>>(rh_timer_func)
>>
>>After tacking detailed for this issue, Yakui and I find it is due to 24
>>bit PM timer overflows when some of cpu sleep more than 4 seconds.  With
>>tickless kernel, the CPU want to sleep as much as possible when system
>>idle.  But the Cx sleep time are recorded by pmtimer which length is
>>determined by BIOS.  The current Cx time was gotten in the following
>>function from driver/acpi/processor_idle.c:
>>
>>static inline u32 ticks_elapsed(u32 t1, u32 t2)
>>{
>>       if (t2 >= t1)
>>               return (t2 - t1);
>>       else if (!(acpi_gbl_FADT.flags & ACPI_FADT_32BIT_TIMER))
>>               return (((0x00FFFFFF - t1) + t2) & 0x00FFFFFF);
>>       else
>>               return ((0xFFFFFFFF - t1) + t2);
>>}
>>
>>If pmtimer is 24 bits and it take 5 seconds from t1 to t2, in above
>>function, just about 1 seconds ticks was recorded.  So the Cx time will be
>>reduced about 4 seconds.  and this is why we see above powertop output.
>>
>>To resolve this problem, Yakui and I use ktime_get() to record the Cx
>>states time instead of PM timer as the following patch.  the patch was
>>tested with i386/x86_64 modes on several platforms.
>>
>>Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>>Tested-by: Alex Shi <alex.shi@intel.com>
>>Signed-off-by: Alex Shi <alex.shi@intel.com>
>>Signed-off-by: Yakui.zhao <yakui.zhao@intel.com>
>>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>Signed-off-by: Len Brown <len.brown@intel.com>
>>Signed-off-by: Chris Wright <chrisw@sous-sol.org>
>>---
>> drivers/acpi/processor_idle.c |   63
>>++++++++++++++++++------------------------
>> 1 file changed, 27 insertions(+), 36 deletions(-)
>>
>>--- a/drivers/acpi/processor_idle.c
>>+++ b/drivers/acpi/processor_idle.c
>>@@ -64,7 +64,6 @@
>> #define _COMPONENT              ACPI_PROCESSOR_COMPONENT
>> ACPI_MODULE_NAME("processor_idle");
>> #define ACPI_PROCESSOR_FILE_POWER	"power"
>>-#define US_TO_PM_TIMER_TICKS(t)		((t * (PM_TIMER_FREQUENCY/1000)) /
>>1000)
>> #define PM_TIMER_TICK_NS		(1000000000ULL/PM_TIMER_FREQUENCY)
>> #define C2_OVERHEAD			1	/* 1us */
>> #define C3_OVERHEAD			1	/* 1us */
>>@@ -78,6 +77,10 @@ module_param(nocst, uint, 0000);
>> static unsigned int latency_factor __read_mostly = 2;
>> module_param(latency_factor, uint, 0644);
>>
>>+static s64 us_to_pm_timer_ticks(s64 t)
>>+{
>>+	return div64_u64(t * PM_TIMER_FREQUENCY, 1000000);
>>+}
>> /*
>>  * IBM ThinkPad R40e crashes mysteriously when going into C2 or C3.
>>  * For now disable this. Probably a bug somewhere else.
>>@@ -159,25 +162,6 @@ static struct dmi_system_id __cpuinitdat
>> 	{},
>> };
>>
>>-static inline u32 ticks_elapsed(u32 t1, u32 t2)
>>-{
>>-	if (t2 >= t1)
>>-		return (t2 - t1);
>>-	else if (!(acpi_gbl_FADT.flags & ACPI_FADT_32BIT_TIMER))
>>-		return (((0x00FFFFFF - t1) + t2) & 0x00FFFFFF);
>>-	else
>>-		return ((0xFFFFFFFF - t1) + t2);
>>-}
>>-
>>-static inline u32 ticks_elapsed_in_us(u32 t1, u32 t2)
>>-{
>>-	if (t2 >= t1)
>>-		return PM_TIMER_TICKS_TO_US(t2 - t1);
>>-	else if (!(acpi_gbl_FADT.flags & ACPI_FADT_32BIT_TIMER))
>>-		return PM_TIMER_TICKS_TO_US(((0x00FFFFFF - t1) + t2) & 0x00FFFFFF);
>>-	else
>>-		return PM_TIMER_TICKS_TO_US((0xFFFFFFFF - t1) + t2);
>>-}
>>
>> /*
>>  * Callers should disable interrupts before the call and enable
>>@@ -853,7 +837,8 @@ static inline void acpi_idle_do_entry(st
>> static int acpi_idle_enter_c1(struct cpuidle_device *dev,
>> 			      struct cpuidle_state *state)
>> {
>>-	u32 t1, t2;
>>+	ktime_t  kt1, kt2;
>>+	s64 idle_time;
>> 	struct acpi_processor *pr;
>> 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
>>
>>@@ -871,14 +856,15 @@ static int acpi_idle_enter_c1(struct cpu
>> 		return 0;
>> 	}
>>
>>-	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
>>+	kt1 = ktime_get_real();
>> 	acpi_idle_do_entry(cx);
>>-	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
>>+	kt2 = ktime_get_real();
>>+	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
>>
>> 	local_irq_enable();
>> 	cx->usage++;
>>
>>-	return ticks_elapsed_in_us(t1, t2);
>>+	return idle_time;
>> }
>>
>> /**
>>@@ -891,8 +877,9 @@ static int acpi_idle_enter_simple(struct
>> {
>> 	struct acpi_processor *pr;
>> 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
>>-	u32 t1, t2;
>>-	int sleep_ticks = 0;
>>+	ktime_t  kt1, kt2;
>>+	s64 idle_time;
>>+	s64 sleep_ticks = 0;
>>
>> 	pr = __get_cpu_var(processors);
>>
>>@@ -925,18 +912,19 @@ static int acpi_idle_enter_simple(struct
>> 	if (cx->type == ACPI_STATE_C3)
>> 		ACPI_FLUSH_CPU_CACHE();
>>
>>-	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
>>+	kt1 = ktime_get_real();
>> 	/* Tell the scheduler that we are going deep-idle: */
>> 	sched_clock_idle_sleep_event();
>> 	acpi_idle_do_entry(cx);
>>-	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
>>+	kt2 = ktime_get_real();
>>+	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
>>
>> #if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86)
>> 	/* TSC could halt in idle, so notify users */
>> 	if (tsc_halts_in_c(cx->type))
>> 		mark_tsc_unstable("TSC halts in idle");;
>> #endif
>>-	sleep_ticks = ticks_elapsed(t1, t2);
>>+	sleep_ticks = us_to_pm_timer_ticks(idle_time);
>>
>> 	/* Tell the scheduler how much we idled: */
>> 	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
>>@@ -948,7 +936,7 @@ static int acpi_idle_enter_simple(struct
>>
>> 	acpi_state_timer_broadcast(pr, cx, 0);
>> 	cx->time += sleep_ticks;
>>-	return ticks_elapsed_in_us(t1, t2);
>>+	return idle_time;
>> }
>>
>> static int c3_cpu_count;
>>@@ -966,8 +954,10 @@ static int acpi_idle_enter_bm(struct cpu
>> {
>> 	struct acpi_processor *pr;
>> 	struct acpi_processor_cx *cx = cpuidle_get_statedata(state);
>>-	u32 t1, t2;
>>-	int sleep_ticks = 0;
>>+	ktime_t  kt1, kt2;
>>+	s64 idle_time;
>>+	s64 sleep_ticks = 0;
>>+
>>
>> 	pr = __get_cpu_var(processors);
>>
>>@@ -1034,9 +1024,10 @@ static int acpi_idle_enter_bm(struct cpu
>> 		ACPI_FLUSH_CPU_CACHE();
>> 	}
>>
>>-	t1 = inl(acpi_gbl_FADT.xpm_timer_block.address);
>>+	kt1 = ktime_get_real();
>> 	acpi_idle_do_entry(cx);
>>-	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
>>+	kt2 = ktime_get_real();
>>+	idle_time =  ktime_to_us(ktime_sub(kt2, kt1));
>>
>> 	/* Re-enable bus master arbitration */
>> 	if (pr->flags.bm_check && pr->flags.bm_control) {
>>@@ -1051,7 +1042,7 @@ static int acpi_idle_enter_bm(struct cpu
>> 	if (tsc_halts_in_c(ACPI_STATE_C3))
>> 		mark_tsc_unstable("TSC halts in idle");
>> #endif
>>-	sleep_ticks = ticks_elapsed(t1, t2);
>>+	sleep_ticks = us_to_pm_timer_ticks(idle_time);
>> 	/* Tell the scheduler how much we idled: */
>> 	sched_clock_idle_wakeup_event(sleep_ticks*PM_TIMER_TICK_NS);
>>
>>@@ -1062,7 +1053,7 @@ static int acpi_idle_enter_bm(struct cpu
>>
>> 	acpi_state_timer_broadcast(pr, cx, 0);
>> 	cx->time += sleep_ticks;
>>-	return ticks_elapsed_in_us(t1, t2);
>>+	return idle_time;
>> }
>>
>> struct cpuidle_driver acpi_idle_driver = {

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
