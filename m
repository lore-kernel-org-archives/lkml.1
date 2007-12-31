Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbXLaUsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbXLaUsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 15:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXLaUsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 15:48:07 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:63262 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbXLaUsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 15:48:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=uztJJfipS62p3uPcd37E9x/UTWi9gfIODEshOtpJWt16D1VmBZbdv5zlj5jUauxtNHsUGivxiWbc8EkYWJTW6uK81r6qCrm+QVe8q+V2N/+H8pvJPTcs39V0TmmyMSEjQvDAMA0p7wRMksOLR0ITmuGEUwI937p6xu7XpeYD3aI=
Date: Mon, 31 Dec 2007 23:47:53 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [x86] get rid of checkpatch.pl complains on apm_32.c
Message-ID: <20071231204753.GA7411@cvg.cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch eliminates most of code-style errors
discovered by checkpatch.pl on arch/x86/kernel/apm_32.c

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
Any comments are welcome


 arch/x86/kernel/apm_32.c |  368 +++++++++++++++++++++++++---------------------
 1 files changed, 197 insertions(+), 171 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 3492a00..1ddf785 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -323,7 +323,7 @@ extern int (*console_blank_hook)(int);
 /*
  * Ignore suspend events for this amount of time after a resume
  */
-#define DEFAULT_BOUNCE_INTERVAL		(3 * HZ)
+#define DEFAULT_BOUNCE_INTERVAL	(3 * HZ)
 
 /*
  * Maximum number of events stored
@@ -335,7 +335,7 @@ extern int (*console_blank_hook)(int);
  */
 struct apm_user {
 	int		magic;
-	struct apm_user *	next;
+	struct apm_user *next;
 	unsigned int	suser: 1;
 	unsigned int	writer: 1;
 	unsigned int	reader: 1;
@@ -371,44 +371,44 @@ struct apm_user {
 static struct {
 	unsigned long	offset;
 	unsigned short	segment;
-}				apm_bios_entry;
-static int			clock_slowed;
-static int			idle_threshold __read_mostly = DEFAULT_IDLE_THRESHOLD;
-static int			idle_period __read_mostly = DEFAULT_IDLE_PERIOD;
-static int			set_pm_idle;
-static int			suspends_pending;
-static int			standbys_pending;
-static int			ignore_sys_suspend;
-static int			ignore_normal_resume;
-static int			bounce_interval __read_mostly = DEFAULT_BOUNCE_INTERVAL;
-
-static int			debug __read_mostly;
-static int			smp __read_mostly;
-static int			apm_disabled = -1;
+} apm_bios_entry;
+static int clock_slowed;
+static int idle_threshold __read_mostly = DEFAULT_IDLE_THRESHOLD;
+static int idle_period __read_mostly = DEFAULT_IDLE_PERIOD;
+static int set_pm_idle;
+static int suspends_pending;
+static int standbys_pending;
+static int ignore_sys_suspend;
+static int ignore_normal_resume;
+static int bounce_interval __read_mostly = DEFAULT_BOUNCE_INTERVAL;
+
+static int debug __read_mostly;
+static int smp __read_mostly;
+static int apm_disabled = -1;
 #ifdef CONFIG_SMP
-static int			power_off;
+static int power_off;
 #else
-static int			power_off = 1;
+static int power_off = 1;
 #endif
 #ifdef CONFIG_APM_REAL_MODE_POWER_OFF
-static int			realmode_power_off = 1;
+static int realmode_power_off = 1;
 #else
-static int			realmode_power_off;
+static int realmode_power_off;
 #endif
 #ifdef CONFIG_APM_ALLOW_INTS
-static int			allow_ints = 1;
+static int allow_ints = 1;
 #else
-static int			allow_ints;
+static int allow_ints;
 #endif
-static int			broken_psr;
+static int broken_psr;
 
 static DECLARE_WAIT_QUEUE_HEAD(apm_waitqueue);
 static DECLARE_WAIT_QUEUE_HEAD(apm_suspend_waitqueue);
-static struct apm_user *	user_list;
+static struct apm_user *user_list;
 static DEFINE_SPINLOCK(user_list_lock);
 static const struct desc_struct	bad_bios_desc = { { { 0, 0x00409200 } } };
 
-static const char		driver_version[] = "1.16ac";	/* no spaces */
+static const char driver_version[] = "1.16ac";	/* no spaces */
 
 static struct task_struct *kapmd_task;
 
@@ -416,7 +416,7 @@ static struct task_struct *kapmd_task;
  *	APM event names taken from the APM 1.2 specification. These are
  *	the message codes that the BIOS uses to tell us about events
  */
-static const char *	const apm_event_name[] = {
+static const char * const apm_event_name[] = {
 	"system standby",
 	"system suspend",
 	"normal resume",
@@ -434,14 +434,14 @@ static const char *	const apm_event_name[] = {
 
 typedef struct lookup_t {
 	int	key;
-	char *	msg;
+	char 	*msg;
 } lookup_t;
 
 /*
  *	The BIOS returns a set of standard error codes in AX when the
  *	carry flag is set.
  */
- 
+
 static const lookup_t error_table[] = {
 /* N/A	{ APM_SUCCESS,		"Operation succeeded" }, */
 	{ APM_DISABLED,		"Power management disabled" },
@@ -471,24 +471,25 @@ static const lookup_t error_table[] = {
  *	Write a meaningful log entry to the kernel log in the event of
  *	an APM error.
  */
- 
+
 static void apm_error(char *str, int err)
 {
-	int	i;
+	int i;
 
 	for (i = 0; i < ERROR_COUNT; i++)
-		if (error_table[i].key == err) break;
+		if (error_table[i].key == err)
+			break;
 	if (i < ERROR_COUNT)
 		printk(KERN_NOTICE "apm: %s: %s\n", str, error_table[i].msg);
 	else
 		printk(KERN_NOTICE "apm: %s: unknown error code %#2.2x\n",
-			str, err);
+		       str, err);
 }
 
 /*
  * Lock APM functionality to physical CPU 0
  */
- 
+
 #ifdef CONFIG_SMP
 
 static cpumask_t apm_save_cpus(void)
@@ -510,7 +511,7 @@ static inline void apm_restore_cpus(cpumask_t mask)
 /*
  *	No CPU lockdown needed on a uniprocessor
  */
- 
+
 #define apm_save_cpus()		(current->cpus_allowed)
 #define apm_restore_cpus(x)	(void)(x)
 
@@ -589,7 +590,7 @@ static inline void apm_irq_restore(unsigned long flags)
  *	code is returned in AH (bits 8-15 of eax) and this function
  *	returns non-zero.
  */
- 
+
 static u8 apm_bios_call(u32 func, u32 ebx_in, u32 ecx_in,
 	u32 *eax, u32 *ebx, u32 *ecx, u32 *edx, u32 *esi)
 {
@@ -601,7 +602,7 @@ static u8 apm_bios_call(u32 func, u32 ebx_in, u32 ecx_in,
 	struct desc_struct	*gdt;
 
 	cpus = apm_save_cpus();
-	
+
 	cpu = get_cpu();
 	gdt = get_cpu_gdt_table(cpu);
 	save_desc_40 = gdt[0x40 / 8];
@@ -615,7 +616,7 @@ static u8 apm_bios_call(u32 func, u32 ebx_in, u32 ecx_in,
 	gdt[0x40 / 8] = save_desc_40;
 	put_cpu();
 	apm_restore_cpus(cpus);
-	
+
 	return *eax & 0xff;
 }
 
@@ -644,7 +645,7 @@ static u8 apm_bios_call_simple(u32 func, u32 ebx_in, u32 ecx_in, u32 *eax)
 	struct desc_struct	*gdt;
 
 	cpus = apm_save_cpus();
-	
+
 	cpu = get_cpu();
 	gdt = get_cpu_gdt_table(cpu);
 	save_desc_40 = gdt[0x40 / 8];
@@ -679,7 +680,7 @@ static u8 apm_bios_call_simple(u32 func, u32 ebx_in, u32 ecx_in, u32 *eax)
 
 static int apm_driver_version(u_short *val)
 {
-	u32	eax;
+	u32 eax;
 
 	if (apm_bios_call_simple(APM_FUNC_VERSION, 0, *val, &eax))
 		return (eax >> 8) & 0xff;
@@ -703,16 +704,16 @@ static int apm_driver_version(u_short *val)
  *	that APM 1.2 is in use. If no messges are pending the value 0x80
  *	is returned (No power management events pending).
  */
- 
+
 static int apm_get_event(apm_event_t *event, apm_eventinfo_t *info)
 {
-	u32	eax;
-	u32	ebx;
-	u32	ecx;
-	u32	dummy;
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 dummy;
 
 	if (apm_bios_call(APM_FUNC_GET_EVENT, 0, 0, &eax, &ebx, &ecx,
-			&dummy, &dummy))
+			  &dummy, &dummy))
 		return (eax >> 8) & 0xff;
 	*event = ebx;
 	if (apm_info.connection_version < 0x0102)
@@ -735,10 +736,10 @@ static int apm_get_event(apm_event_t *event, apm_eventinfo_t *info)
  *	The state holds the state to transition to, which may in fact
  *	be an acceptance of a BIOS requested state change.
  */
- 
+
 static int set_power_state(u_short what, u_short state)
 {
-	u32	eax;
+	u32 eax;
 
 	if (apm_bios_call_simple(APM_FUNC_SET_STATE, what, state, &eax))
 		return (eax >> 8) & 0xff;
@@ -751,7 +752,7 @@ static int set_power_state(u_short what, u_short state)
  *
  *	Transition the entire system into a new APM power state.
  */
- 
+
 static int set_system_power_state(u_short state)
 {
 	return set_power_state(APM_DEVICE_ALL, state);
@@ -765,13 +766,13 @@ static int set_system_power_state(u_short state)
  *	to handle the idle request. On a success the function returns 1
  *	if the BIOS did clock slowing or 0 otherwise.
  */
- 
+
 static int apm_do_idle(void)
 {
-	u32	eax;
-	u8	ret = 0;
-	int	idled = 0;
-	int	polling;
+	u32 eax;
+	u8 ret = 0;
+	int idled = 0;
+	int polling;
 
 	polling = !!(current_thread_info()->status & TS_POLLING);
 	if (polling) {
@@ -798,10 +799,9 @@ static int apm_do_idle(void)
 		/* This always fails on some SMP boards running UP kernels.
 		 * Only report the failure the first 5 times.
 		 */
-		if (++t < 5)
-		{
+		if (++t < 5) {
 			printk(KERN_DEBUG "apm_do_idle failed (%d)\n",
-					(eax >> 8) & 0xff);
+			       (eax >> 8) & 0xff);
 			t = jiffies;
 		}
 		return -1;
@@ -813,15 +813,15 @@ static int apm_do_idle(void)
 /**
  *	apm_do_busy	-	inform the BIOS the CPU is busy
  *
- *	Request that the BIOS brings the CPU back to full performance. 
+ *	Request that the BIOS brings the CPU back to full performance.
  */
- 
+
 static void apm_do_busy(void)
 {
-	u32	dummy;
+	u32 dummy;
 
 	if (clock_slowed || ALWAYS_CALL_BUSY) {
-		(void) apm_bios_call_simple(APM_FUNC_BUSY, 0, 0, &dummy);
+		(void)apm_bios_call_simple(APM_FUNC_BUSY, 0, 0, &dummy);
 		clock_slowed = 0;
 	}
 }
@@ -832,15 +832,15 @@ static void apm_do_busy(void)
  * power management - we probably want
  * to conserve power.
  */
-#define IDLE_CALC_LIMIT   (HZ * 100)
-#define IDLE_LEAKY_MAX    16
+#define IDLE_CALC_LIMIT	(HZ * 100)
+#define IDLE_LEAKY_MAX	16
 
 static void (*original_pm_idle)(void) __read_mostly;
 
 /**
  * apm_cpu_idle		-	cpu idling for APM capable Linux
  *
- * This is the idling function the kernel executes when APM is available. It 
+ * This is the idling function the kernel executes when APM is available. It
  * tries to do BIOS powermanagement based on the average system idle time.
  * Furthermore it calls the system default idle routine.
  */
@@ -881,7 +881,8 @@ recalc:
 
 			t = jiffies;
 			switch (apm_do_idle()) {
-			case 0: apm_idle_done = 1;
+			case 0:
+				apm_idle_done = 1;
 				if (t != jiffies) {
 					if (bucket) {
 						bucket = IDLE_LEAKY_MAX;
@@ -892,7 +893,8 @@ recalc:
 					continue;
 				}
 				break;
-			case 1: apm_idle_done = 1;
+			case 1:
+				apm_idle_done = 1;
 				break;
 			default: /* BIOS refused */
 				break;
@@ -920,10 +922,10 @@ recalc:
  *	the SMP call on CPU0 as some systems will only honour this call
  *	on their first cpu.
  */
- 
+
 static void apm_power_off(void)
 {
-	unsigned char	po_bios_call[] = {
+	unsigned char po_bios_call[] = {
 		0xb8, 0x00, 0x10,	/* movw  $0x1000,ax  */
 		0x8e, 0xd0,		/* movw  ax,ss       */
 		0xbc, 0x00, 0xf0,	/* movw  $0xf000,sp  */
@@ -934,13 +936,12 @@ static void apm_power_off(void)
 	};
 
 	/* Some bioses don't like being called from CPU != 0 */
-	if (apm_info.realmode_power_off)
-	{
+	if (apm_info.realmode_power_off) {
 		(void)apm_save_cpus();
 		machine_real_restart(po_bios_call, sizeof(po_bios_call));
+	} else {
+		(void)set_system_power_state(APM_STATE_OFF);
 	}
-	else
-		(void) set_system_power_state(APM_STATE_OFF);
 }
 
 #ifdef CONFIG_APM_DO_ENABLE
@@ -949,17 +950,17 @@ static void apm_power_off(void)
  *	apm_enable_power_management - enable BIOS APM power management
  *	@enable: enable yes/no
  *
- *	Enable or disable the APM BIOS power services. 
+ *	Enable or disable the APM BIOS power services.
  */
- 
+
 static int apm_enable_power_management(int enable)
 {
-	u32	eax;
+	u32 eax;
 
 	if ((enable == 0) && (apm_info.bios.flags & APM_BIOS_DISENGAGED))
 		return APM_NOT_ENGAGED;
 	if (apm_bios_call_simple(APM_FUNC_ENABLE_PM, APM_DEVICE_BALL,
-			enable, &eax))
+				 enable, &eax))
 		return (eax >> 8) & 0xff;
 	if (enable)
 		apm_info.bios.flags &= ~APM_BIOS_DISABLED;
@@ -982,19 +983,19 @@ static int apm_enable_power_management(int enable)
  *	if reported is a lifetime in secodnds/minutes at current powwer
  *	consumption.
  */
- 
+
 static int apm_get_power_status(u_short *status, u_short *bat, u_short *life)
 {
-	u32	eax;
-	u32	ebx;
-	u32	ecx;
-	u32	edx;
-	u32	dummy;
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 edx;
+	u32 dummy;
 
 	if (apm_info.get_power_status_broken)
 		return APM_32_UNSUPPORTED;
 	if (apm_bios_call(APM_FUNC_GET_STATUS, APM_DEVICE_ALL, 0,
-			&eax, &ebx, &ecx, &edx, &dummy))
+			  &eax, &ebx, &ecx, &edx, &dummy))
 		return (eax >> 8) & 0xff;
 	*status = ebx;
 	*bat = ecx;
@@ -1010,11 +1011,11 @@ static int apm_get_power_status(u_short *status, u_short *bat, u_short *life)
 static int apm_get_battery_status(u_short which, u_short *status,
 				  u_short *bat, u_short *life, u_short *nbat)
 {
-	u32	eax;
-	u32	ebx;
-	u32	ecx;
-	u32	edx;
-	u32	esi;
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 edx;
+	u32 esi;
 
 	if (apm_info.connection_version < 0x0102) {
 		/* pretend we only have one battery. */
@@ -1025,7 +1026,7 @@ static int apm_get_battery_status(u_short which, u_short *status,
 	}
 
 	if (apm_bios_call(APM_FUNC_GET_STATUS, (0x8000 | (which)), 0, &eax,
-			&ebx, &ecx, &edx, &esi))
+			  &ebx, &ecx, &edx, &esi))
 		return (eax >> 8) & 0xff;
 	*status = ebx;
 	*bat = ecx;
@@ -1043,10 +1044,10 @@ static int apm_get_battery_status(u_short which, u_short *status,
  *	Activate or deactive power management on either a specific device
  *	or the entire system (%APM_DEVICE_ALL).
  */
- 
+
 static int apm_engage_power_management(u_short device, int enable)
 {
-	u32	eax;
+	u32 eax;
 
 	if ((enable == 0) && (device == APM_DEVICE_ALL)
 	    && (apm_info.bios.flags & APM_BIOS_DISABLED))
@@ -1073,7 +1074,7 @@ static int apm_engage_power_management(u_short device, int enable)
  *	all video devices. Typically the BIOS will do laptop backlight and
  *	monitor powerdown for us.
  */
- 
+
 static int apm_console_blank(int blank)
 {
 	int error = APM_NOT_ENGAGED; /* silence gcc */
@@ -1125,7 +1126,7 @@ static apm_event_t get_queued_event(struct apm_user *as)
 
 static void queue_event(apm_event_t event, struct apm_user *sender)
 {
-	struct apm_user *	as;
+	struct apm_user *as;
 
 	spin_lock(&user_list_lock);
 	if (user_list == NULL)
@@ -1185,7 +1186,7 @@ static void reinit_timer(void)
 
 static int suspend(int vetoable)
 {
-	int		err;
+	int err;
 	struct apm_user	*as;
 
 	if (pm_send_all(PM_SUSPEND, (void *)3)) {
@@ -1238,7 +1239,7 @@ static int suspend(int vetoable)
 
 static void standby(void)
 {
-	int	err;
+	int err;
 
 	local_irq_disable();
 	device_power_down(PMSG_SUSPEND);
@@ -1255,8 +1256,8 @@ static void standby(void)
 
 static apm_event_t get_event(void)
 {
-	int		error;
-	apm_event_t	event = APM_NO_EVENTS; /* silence gcc */
+	int error;
+	apm_event_t event = APM_NO_EVENTS; /* silence gcc */
 	apm_eventinfo_t	info;
 
 	static int notified;
@@ -1274,9 +1275,9 @@ static apm_event_t get_event(void)
 
 static void check_events(void)
 {
-	apm_event_t		event;
-	static unsigned long	last_resume;
-	static int		ignore_bounce;
+	apm_event_t event;
+	static unsigned long last_resume;
+	static int ignore_bounce;
 
 	while ((event = get_event()) != 0) {
 		if (debug) {
@@ -1356,7 +1357,7 @@ static void check_events(void)
 			/*
 			 * We are not allowed to reject a critical suspend.
 			 */
-			(void) suspend(0);
+			(void)suspend(0);
 			break;
 		}
 	}
@@ -1364,12 +1365,12 @@ static void check_events(void)
 
 static void apm_event_handler(void)
 {
-	static int	pending_count = 4;
-	int		err;
+	static int pending_count = 4;
+	int err;
 
 	if ((standbys_pending > 0) || (suspends_pending > 0)) {
 		if ((apm_info.connection_version > 0x100) &&
-				(pending_count-- <= 0)) {
+		    (pending_count-- <= 0)) {
 			pending_count = 4;
 			if (debug)
 				printk(KERN_DEBUG "apm: setting state busy\n");
@@ -1417,9 +1418,9 @@ static int check_apm_user(struct apm_user *as, const char *func)
 
 static ssize_t do_read(struct file *fp, char __user *buf, size_t count, loff_t *ppos)
 {
-	struct apm_user *	as;
-	int			i;
-	apm_event_t		event;
+	struct apm_user *as;
+	int i;
+	apm_event_t event;
 
 	as = fp->private_data;
 	if (check_apm_user(as, "read"))
@@ -1458,9 +1459,9 @@ static ssize_t do_read(struct file *fp, char __user *buf, size_t count, loff_t *
 	return 0;
 }
 
-static unsigned int do_poll(struct file *fp, poll_table * wait)
+static unsigned int do_poll(struct file *fp, poll_table *wait)
 {
-	struct apm_user * as;
+	struct apm_user *as;
 
 	as = fp->private_data;
 	if (check_apm_user(as, "poll"))
@@ -1471,10 +1472,10 @@ static unsigned int do_poll(struct file *fp, poll_table * wait)
 	return 0;
 }
 
-static int do_ioctl(struct inode * inode, struct file *filp,
+static int do_ioctl(struct inode *inode, struct file *filp,
 		    u_int cmd, u_long arg)
 {
-	struct apm_user *	as;
+	struct apm_user *as;
 
 	as = filp->private_data;
 	if (check_apm_user(as, "ioctl"))
@@ -1514,9 +1515,9 @@ static int do_ioctl(struct inode * inode, struct file *filp,
 	return 0;
 }
 
-static int do_release(struct inode * inode, struct file * filp)
+static int do_release(struct inode *inode, struct file *filp)
 {
-	struct apm_user *	as;
+	struct apm_user *as;
 
 	as = filp->private_data;
 	if (check_apm_user(as, "release"))
@@ -1532,11 +1533,11 @@ static int do_release(struct inode * inode, struct file * filp)
 		if (suspends_pending <= 0)
 			(void) suspend(1);
 	}
-  	spin_lock(&user_list_lock);
+	spin_lock(&user_list_lock);
 	if (user_list == as)
 		user_list = as->next;
 	else {
-		struct apm_user *	as1;
+		struct apm_user *as1;
 
 		for (as1 = user_list;
 		     (as1 != NULL) && (as1->next != as);
@@ -1552,9 +1553,9 @@ static int do_release(struct inode * inode, struct file * filp)
 	return 0;
 }
 
-static int do_open(struct inode * inode, struct file * filp)
+static int do_open(struct inode *inode, struct file *filp)
 {
-	struct apm_user *	as;
+	struct apm_user *as;
 
 	as = kmalloc(sizeof(*as), GFP_KERNEL);
 	if (as == NULL) {
@@ -1568,7 +1569,7 @@ static int do_open(struct inode * inode, struct file * filp)
 	as->suspends_read = as->standbys_read = 0;
 	/*
 	 * XXX - this is a tiny bit broken, when we consider BSD
-         * process accounting. If the device is opened by root, we
+	 * process accounting. If the device is opened by root, we
 	 * instantly flag that we used superuser privs. Who knows,
 	 * we might close the device immediately without doing a
 	 * privileged operation -- cevans
@@ -1651,16 +1652,16 @@ static int proc_apm_show(struct seq_file *m, void *v)
 	   8) min = minutes; sec = seconds */
 
 	seq_printf(m, "%s %d.%d 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
-		     driver_version,
-		     (apm_info.bios.version >> 8) & 0xff,
-		     apm_info.bios.version & 0xff,
-		     apm_info.bios.flags,
-		     ac_line_status,
-		     battery_status,
-		     battery_flag,
-		     percentage,
-		     time_units,
-		     units);
+		   driver_version,
+		   (apm_info.bios.version >> 8) & 0xff,
+		   apm_info.bios.version & 0xff,
+		   apm_info.bios.flags,
+		   ac_line_status,
+		   battery_status,
+		   battery_flag,
+		   percentage,
+		   time_units,
+		   units);
 	return 0;
 }
 
@@ -1683,8 +1684,8 @@ static int apm(void *unused)
 	unsigned short	cx;
 	unsigned short	dx;
 	int		error;
-	char *		power_stat;
-	char *		bat_stat;
+	char 		*power_stat;
+	char 		*bat_stat;
 
 #ifdef CONFIG_SMP
 	/* 2002/08/01 - WT
@@ -1743,23 +1744,41 @@ static int apm(void *unused)
 		}
 	}
 
-	if (debug && (num_online_cpus() == 1 || smp )) {
+	if (debug && (num_online_cpus() == 1 || smp)) {
 		error = apm_get_power_status(&bx, &cx, &dx);
 		if (error)
 			printk(KERN_INFO "apm: power status not available\n");
 		else {
 			switch ((bx >> 8) & 0xff) {
-			case 0: power_stat = "off line"; break;
-			case 1: power_stat = "on line"; break;
-			case 2: power_stat = "on backup power"; break;
-			default: power_stat = "unknown"; break;
+			case 0:
+				power_stat = "off line";
+				break;
+			case 1:
+				power_stat = "on line";
+				break;
+			case 2:
+				power_stat = "on backup power";
+				break;
+			default:
+				power_stat = "unknown";
+				break;
 			}
 			switch (bx & 0xff) {
-			case 0: bat_stat = "high"; break;
-			case 1: bat_stat = "low"; break;
-			case 2: bat_stat = "critical"; break;
-			case 3: bat_stat = "charging"; break;
-			default: bat_stat = "unknown"; break;
+			case 0:
+				bat_stat = "high";
+				break;
+			case 1:
+				bat_stat = "low";
+				break;
+			case 2:
+				bat_stat = "critical";
+				break;
+			case 3:
+				bat_stat = "charging";
+				break;
+			default:
+				bat_stat = "unknown";
+				break;
 			}
 			printk(KERN_INFO
 			       "apm: AC %s, battery status %s, battery life ",
@@ -1776,8 +1795,8 @@ static int apm(void *unused)
 					printk("unknown\n");
 				else
 					printk("%d %s\n", dx & 0x7fff,
-						(dx & 0x8000) ?
-						"minutes" : "seconds");
+					       (dx & 0x8000) ?
+					       "minutes" : "seconds");
 			}
 		}
 	}
@@ -1802,7 +1821,7 @@ static int apm(void *unused)
 #ifndef MODULE
 static int __init apm_setup(char *str)
 {
-	int	invert;
+	int invert;
 
 	while ((str != NULL) && (*str != '\0')) {
 		if (strncmp(str, "off", 3) == 0)
@@ -1827,14 +1846,13 @@ static int __init apm_setup(char *str)
 		if ((strncmp(str, "power-off", 9) == 0) ||
 		    (strncmp(str, "power_off", 9) == 0))
 			power_off = !invert;
-		if (strncmp(str, "smp", 3) == 0)
-		{
+		if (strncmp(str, "smp", 3) == 0) {
 			smp = !invert;
 			idle_threshold = 100;
 		}
 		if ((strncmp(str, "allow-ints", 10) == 0) ||
 		    (strncmp(str, "allow_ints", 10) == 0))
- 			apm_info.allow_ints = !invert;
+			apm_info.allow_ints = !invert;
 		if ((strncmp(str, "broken-psr", 10) == 0) ||
 		    (strncmp(str, "broken_psr", 10) == 0))
 			apm_info.get_power_status_broken = !invert;
@@ -1880,7 +1898,8 @@ static int __init print_if_true(const struct dmi_system_id *d)
  */
 static int __init broken_ps2_resume(const struct dmi_system_id *d)
 {
-	printk(KERN_INFO "%s machine detected. Mousepad Resume Bug workaround hopefully not needed.\n", d->ident);
+	printk(KERN_INFO "%s machine detected. Mousepad Resume Bug "
+	       "workaround hopefully not needed.\n", d->ident);
 	return 0;
 }
 
@@ -1889,7 +1908,8 @@ static int __init set_realmode_power_off(const struct dmi_system_id *d)
 {
 	if (apm_info.realmode_power_off == 0) {
 		apm_info.realmode_power_off = 1;
-		printk(KERN_INFO "%s bios detected. Using realmode poweroff only.\n", d->ident);
+		printk(KERN_INFO "%s bios detected. "
+		       "Using realmode poweroff only.\n", d->ident);
 	}
 	return 0;
 }
@@ -1899,7 +1919,8 @@ static int __init set_apm_ints(const struct dmi_system_id *d)
 {
 	if (apm_info.allow_ints == 0) {
 		apm_info.allow_ints = 1;
-		printk(KERN_INFO "%s machine detected. Enabling interrupts during APM calls.\n", d->ident);
+		printk(KERN_INFO "%s machine detected. "
+		       "Enabling interrupts during APM calls.\n", d->ident);
 	}
 	return 0;
 }
@@ -1909,7 +1930,8 @@ static int __init apm_is_horked(const struct dmi_system_id *d)
 {
 	if (apm_info.disabled == 0) {
 		apm_info.disabled = 1;
-		printk(KERN_INFO "%s machine detected. Disabling APM.\n", d->ident);
+		printk(KERN_INFO "%s machine detected. "
+		       "Disabling APM.\n", d->ident);
 	}
 	return 0;
 }
@@ -1918,8 +1940,9 @@ static int __init apm_is_horked_d850md(const struct dmi_system_id *d)
 {
 	if (apm_info.disabled == 0) {
 		apm_info.disabled = 1;
-		printk(KERN_INFO "%s machine detected. Disabling APM.\n", d->ident);
-		printk(KERN_INFO "This bug is fixed in bios P15 which is available for \n");
+		printk(KERN_INFO "%s machine detected. "
+		       "Disabling APM.\n", d->ident);
+		printk(KERN_INFO "This bug is fixed in bios P15 which is available for\n");
 		printk(KERN_INFO "download from support.intel.com \n");
 	}
 	return 0;
@@ -1930,7 +1953,8 @@ static int __init apm_likes_to_melt(const struct dmi_system_id *d)
 {
 	if (apm_info.forbid_idle == 0) {
 		apm_info.forbid_idle = 1;
-		printk(KERN_INFO "%s machine detected. Disabling APM idle calls.\n", d->ident);
+		printk(KERN_INFO "%s machine detected. "
+		       "Disabling APM idle calls.\n", d->ident);
 	}
 	return 0;
 }
@@ -1953,7 +1977,8 @@ static int __init apm_likes_to_melt(const struct dmi_system_id *d)
 static int __init broken_apm_power(const struct dmi_system_id *d)
 {
 	apm_info.get_power_status_broken = 1;
-	printk(KERN_WARNING "BIOS strings suggest APM bugs, disabling power status reporting.\n");
+	printk(KERN_WARNING "BIOS strings suggest APM bugs, "
+	       "disabling power status reporting.\n");
 	return 0;
 }
 
@@ -1964,7 +1989,8 @@ static int __init broken_apm_power(const struct dmi_system_id *d)
 static int __init swab_apm_power_in_minutes(const struct dmi_system_id *d)
 {
 	apm_info.get_power_status_swabinminutes = 1;
-	printk(KERN_WARNING "BIOS strings suggest APM reports battery life in minutes and wrong byte order.\n");
+	printk(KERN_WARNING "BIOS strings suggest APM reports battery life "
+	       "in minutes and wrong byte order.\n");
 	return 0;
 }
 
@@ -1989,8 +2015,8 @@ static struct dmi_system_id __initdata apm_dmi_table[] = {
 		apm_is_horked, "Dell Inspiron 2500",
 		{	DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 2500"),
-			DMI_MATCH(DMI_BIOS_VENDOR,"Phoenix Technologies LTD"),
-			DMI_MATCH(DMI_BIOS_VERSION,"A11"), },
+			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
+			DMI_MATCH(DMI_BIOS_VERSION, "A11"), },
 	},
 	{	/* Allow interrupts during suspend on Dell Inspiron laptops*/
 		set_apm_ints, "Dell Inspiron", {
@@ -2013,15 +2039,15 @@ static struct dmi_system_id __initdata apm_dmi_table[] = {
 		apm_is_horked, "Dell Dimension 4100",
 		{	DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "XPS-Z"),
-			DMI_MATCH(DMI_BIOS_VENDOR,"Intel Corp."),
-			DMI_MATCH(DMI_BIOS_VERSION,"A11"), },
+			DMI_MATCH(DMI_BIOS_VENDOR, "Intel Corp."),
+			DMI_MATCH(DMI_BIOS_VERSION, "A11"), },
 	},
 	{	/* Allow interrupts during suspend on Compaq Laptops*/
 		set_apm_ints, "Compaq 12XL125",
 		{	DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Compaq PC"),
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
-			DMI_MATCH(DMI_BIOS_VERSION,"4.06"), },
+			DMI_MATCH(DMI_BIOS_VERSION, "4.06"), },
 	},
 	{	/* Allow interrupts during APM or the clock goes slow */
 		set_apm_ints, "ASUSTeK",
@@ -2063,15 +2089,15 @@ static struct dmi_system_id __initdata apm_dmi_table[] = {
 		apm_is_horked, "Sharp PC-PJ/AX",
 		{	DMI_MATCH(DMI_SYS_VENDOR, "SHARP"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "PC-PJ/AX"),
-			DMI_MATCH(DMI_BIOS_VENDOR,"SystemSoft"),
-			DMI_MATCH(DMI_BIOS_VERSION,"Version R2.08"), },
+			DMI_MATCH(DMI_BIOS_VENDOR, "SystemSoft"),
+			DMI_MATCH(DMI_BIOS_VERSION, "Version R2.08"), },
 	},
 	{	/* APM crashes */
 		apm_is_horked, "Dell Inspiron 2500",
 		{	DMI_MATCH(DMI_SYS_VENDOR, "Dell Computer Corporation"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 2500"),
-			DMI_MATCH(DMI_BIOS_VENDOR,"Phoenix Technologies LTD"),
-			DMI_MATCH(DMI_BIOS_VERSION,"A11"), },
+			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
+			DMI_MATCH(DMI_BIOS_VERSION, "A11"), },
 	},
 	{	/* APM idle hangs */
 		apm_likes_to_melt, "Jabil AMD",
@@ -2202,11 +2228,11 @@ static int __init apm_init(void)
 		return -ENODEV;
 	}
 	printk(KERN_INFO
-		"apm: BIOS version %d.%d Flags 0x%02x (Driver version %s)\n",
-		((apm_info.bios.version >> 8) & 0xff),
-		(apm_info.bios.version & 0xff),
-		apm_info.bios.flags,
-		driver_version);
+	       "apm: BIOS version %d.%d Flags 0x%02x (Driver version %s)\n",
+	       ((apm_info.bios.version >> 8) & 0xff),
+	       (apm_info.bios.version & 0xff),
+	       apm_info.bios.flags,
+	       driver_version);
 	if ((apm_info.bios.flags & APM_32_BIT_SUPPORT) == 0) {
 		printk(KERN_INFO "apm: no 32 bit BIOS support\n");
 		return -ENODEV;
@@ -2313,9 +2339,9 @@ static int __init apm_init(void)
 	}
 	wake_up_process(kapmd_task);
 
-	if (num_online_cpus() > 1 && !smp ) {
+	if (num_online_cpus() > 1 && !smp) {
 		printk(KERN_NOTICE
-		   "apm: disabled - APM is not SMP safe (power off active).\n");
+		       "apm: disabled - APM is not SMP safe (power off active).\n");
 		return 0;
 	}
 
@@ -2340,7 +2366,7 @@ static int __init apm_init(void)
 
 static void __exit apm_exit(void)
 {
-	int	error;
+	int error;
 
 	if (set_pm_idle) {
 		pm_idle = original_pm_idle;
