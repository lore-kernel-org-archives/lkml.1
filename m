Return-Path: <linux-kernel-owner+w=401wt.eu-S1757862AbZKRQo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862AbZKRQo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757847AbZKRQo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:44:28 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:45256 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843AbZKRQoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:44:21 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Joe Perches <joe@perches.com>
Subject: [PATCH 3/3] sysctl: Drop & in front of every proc_handler.
Date: Wed, 18 Nov 2009 08:44:14 -0800
Message-Id: <1258562654-31370-3-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.6.5.2.143.g8cc62
In-Reply-To: <m1d43fbx8i.fsf@fess.ebiederm.org>
References: <m1d43fbx8i.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

For consistency drop & in front of every proc_handler.  Explicity
taking the address is unnecessary and it prevents optimizations
like stubbing the proc_handlers to NULL.

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/arm/kernel/isa.c              |    6 +-
 arch/arm/mach-bcmring/arch.c       |    2 +-
 arch/frv/kernel/pm.c               |    8 +-
 arch/frv/kernel/sysctl.c           |    4 +-
 arch/ia64/kernel/crash.c           |    4 +-
 arch/ia64/kernel/perfmon.c         |    8 +-
 arch/mips/lasat/sysctl.c           |   22 ++--
 arch/powerpc/kernel/idle.c         |    2 +-
 arch/s390/appldata/appldata_base.c |    4 +-
 arch/s390/kernel/debug.c           |    4 +-
 arch/s390/mm/cmm.c                 |    6 +-
 arch/sh/kernel/traps_64.c          |    6 +-
 crypto/proc.c                      |    2 +-
 drivers/cdrom/cdrom.c              |   12 +-
 drivers/char/hpet.c                |    2 +-
 drivers/char/ipmi/ipmi_poweroff.c  |    2 +-
 drivers/char/pty.c                 |    4 +-
 drivers/char/random.c              |   12 +-
 drivers/char/rtc.c                 |    2 +-
 drivers/macintosh/mac_hid.c        |    6 +-
 drivers/md/md.c                    |    4 +-
 drivers/misc/sgi-xp/xpc_main.c     |    6 +-
 drivers/net/wireless/arlan-proc.c  |   64 +++++-----
 drivers/parport/procfs.c           |   28 ++--
 drivers/scsi/scsi_sysctl.c         |    2 +-
 fs/coda/sysctl.c                   |    6 +-
 fs/eventpoll.c                     |    2 +-
 fs/lockd/svc.c                     |   12 +-
 fs/nfs/sysctl.c                    |    8 +-
 fs/notify/inotify/inotify_user.c   |    6 +-
 fs/ntfs/sysctl.c                   |    2 +-
 fs/ocfs2/stackglue.c               |    2 +-
 fs/quota/dquot.c                   |   18 ++--
 fs/xfs/linux-2.6/xfs_sysctl.c      |   30 ++--
 kernel/slow-work.c                 |    2 +-
 kernel/sysctl.c                    |  266 ++++++++++++++++++------------------
 net/rds/ib_sysctl.c                |   12 +-
 net/rds/iw_sysctl.c                |   12 +-
 net/rds/sysctl.c                   |   10 +-
 net/sctp/sysctl.c                  |    2 +-
 net/sunrpc/sysctl.c                |   10 +-
 net/sunrpc/xprtrdma/svc_rdma.c     |   24 ++--
 net/sunrpc/xprtrdma/transport.c    |   12 +-
 net/sunrpc/xprtsock.c              |   10 +-
 security/keys/sysctl.c             |   10 +-
 45 files changed, 339 insertions(+), 339 deletions(-)

diff --git a/arch/arm/kernel/isa.c b/arch/arm/kernel/isa.c
index 738dfcc..3464859 100644
--- a/arch/arm/kernel/isa.c
+++ b/arch/arm/kernel/isa.c
@@ -26,19 +26,19 @@ static ctl_table ctl_isa_vars[4] = {
 		.data		= &isa_membase, 
 		.maxlen		= sizeof(isa_membase),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	}, {
 		.procname	= "portbase",
 		.data		= &isa_portbase, 
 		.maxlen		= sizeof(isa_portbase),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	}, {
 		.procname	= "portshift",
 		.data		= &isa_portshift, 
 		.maxlen		= sizeof(isa_portshift),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	}, {}
 };
 
diff --git a/arch/arm/mach-bcmring/arch.c b/arch/arm/mach-bcmring/arch.c
index f3c1119..fbe6fa0 100644
--- a/arch/arm/mach-bcmring/arch.c
+++ b/arch/arm/mach-bcmring/arch.c
@@ -58,7 +58,7 @@ static struct ctl_table bcmring_sysctl_warm_reboot[] = {
 	 .data = &bcmring_arch_warm_reboot,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
-	 .proc_handler = &proc_dointvec},
+	 .proc_handler = proc_dointvec},
 	{}
 };
 
diff --git a/arch/frv/kernel/pm.c b/arch/frv/kernel/pm.c
index 940d8bb..5fa3889 100644
--- a/arch/frv/kernel/pm.c
+++ b/arch/frv/kernel/pm.c
@@ -303,28 +303,28 @@ static struct ctl_table pm_table[] =
 		.data		= NULL,
 		.maxlen		= 0,
 		.mode		= 0200,
-		.proc_handler	= &sysctl_pm_do_suspend,
+		.proc_handler	= sysctl_pm_do_suspend,
 	},
 	{
 		.procname	= "cmode",
 		.data		= &clock_cmode_current,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &cmode_procctl,
+		.proc_handler	= cmode_procctl,
 	},
 	{
 		.procname	= "p0",
 		.data		= &clock_p0_current,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &p0_procctl,
+		.proc_handler	= p0_procctl,
 	},
 	{
 		.procname	= "cm",
 		.data		= &clock_cm_current,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &cm_procctl,
+		.proc_handler	= cm_procctl,
 	},
 	{ }
 };
diff --git a/arch/frv/kernel/sysctl.c b/arch/frv/kernel/sysctl.c
index b30a4f2..035516c 100644
--- a/arch/frv/kernel/sysctl.c
+++ b/arch/frv/kernel/sysctl.c
@@ -180,7 +180,7 @@ static struct ctl_table frv_table[] =
 		.data		= NULL,
 		.maxlen		= 0,
 		.mode		= 0644,
-		.proc_handler	= &procctl_frv_cachemode,
+		.proc_handler	= procctl_frv_cachemode,
 	},
 #ifdef CONFIG_MMU
 	{
@@ -188,7 +188,7 @@ static struct ctl_table frv_table[] =
 		.data		= NULL,
 		.maxlen		= 0,
 		.mode		= 0644,
-		.proc_handler	= &procctl_frv_pin_cxnr
+		.proc_handler	= procctl_frv_pin_cxnr
 	},
 #endif
 	{}
diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index 7c7d6a6..b942f40 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -243,14 +243,14 @@ static ctl_table kdump_ctl_table[] = {
 		.data = &kdump_on_init,
 		.maxlen = sizeof(int),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec,
+		.proc_handler = proc_dointvec,
 	},
 	{
 		.procname = "kdump_on_fatal_mca",
 		.data = &kdump_on_fatal_mca,
 		.maxlen = sizeof(int),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec,
+		.proc_handler = proc_dointvec,
 	},
 	{ }
 };
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index ca30b36..402698b 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -526,28 +526,28 @@ static ctl_table pfm_ctl_table[]={
 		.data		= &pfm_sysctl.debug,
 		.maxlen		= sizeof(int),
 		.mode		= 0666,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "debug_ovfl",
 		.data		= &pfm_sysctl.debug_ovfl,
 		.maxlen		= sizeof(int),
 		.mode		= 0666,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "fastctxsw",
 		.data		= &pfm_sysctl.fastctxsw,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	=  &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "expert_mode",
 		.data		= &pfm_sysctl.expert_mode,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{}
 };
diff --git a/arch/mips/lasat/sysctl.c b/arch/mips/lasat/sysctl.c
index 1dbdd76..14b9a28 100644
--- a/arch/mips/lasat/sysctl.c
+++ b/arch/mips/lasat/sysctl.c
@@ -182,28 +182,28 @@ static ctl_table lasat_table[] = {
 		.data		= &lasat_board_info.li_cpu_hz,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "bus-hz",
 		.data		= &lasat_board_info.li_bus_hz,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "bmid",
 		.data		= &lasat_board_info.li_bmid,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "prid",
 		.data		= &lasat_board_info.li_prid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_lasat_prid,
+		.proc_handler	= proc_lasat_prid,
 .	},
 #ifdef CONFIG_INET
 	{
@@ -211,14 +211,14 @@ static ctl_table lasat_table[] = {
 		.data		= &lasat_board_info.li_eeprom_info.ipaddr,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_lasat_ip,
+		.proc_handler	= proc_lasat_ip,
 	},
 	{
 		.procname	= "netmask",
 		.data		= &lasat_board_info.li_eeprom_info.netmask,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_lasat_ip,
+		.proc_handler	= proc_lasat_ip,
 	},
 #endif
 	{
@@ -227,14 +227,14 @@ static ctl_table lasat_table[] = {
 		.maxlen		=
 			sizeof(lasat_board_info.li_eeprom_info.passwd_hash),
 		.mode		= 0600,
-		.proc_handler	= &proc_dolasatstring,
+		.proc_handler	= proc_dolasatstring,
 	},
 	{
 		.procname	= "boot-service",
 		.data		= &lasat_boot_to_service,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #ifdef CONFIG_DS1603
 	{
@@ -242,7 +242,7 @@ static ctl_table lasat_table[] = {
 		.data		= &rtctmp,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dolasatrtc,
+		.proc_handler	= proc_dolasatrtc,
 	},
 #endif
 	{
@@ -250,14 +250,14 @@ static ctl_table lasat_table[] = {
 		.data		= &lasat_board_info.li_namestr,
 		.maxlen		= sizeof(lasat_board_info.li_namestr),
 		.mode		= 0444,
-		.proc_handler	= &proc_dostring,
+		.proc_handler	= proc_dostring,
 	},
 	{
 		.procname	= "typestr",
 		.data		= &lasat_board_info.li_typestr,
 		.maxlen		= sizeof(lasat_board_info.li_typestr),
 		.mode		= 0444,
-		.proc_handler	= &proc_dostring,
+		.proc_handler	= proc_dostring,
 	},
 	{}
 };
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index cece9e2..049dda6 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -114,7 +114,7 @@ static ctl_table powersave_nap_ctl_table[]={
 		.data		= &powersave_nap,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{}
 };
diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index b55fd7e..4955899 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -61,12 +61,12 @@ static struct ctl_table appldata_table[] = {
 	{
 		.procname	= "timer",
 		.mode		= S_IRUGO | S_IWUSR,
-		.proc_handler	= &appldata_timer_handler,
+		.proc_handler	= appldata_timer_handler,
 	},
 	{
 		.procname	= "interval",
 		.mode		= S_IRUGO | S_IWUSR,
-		.proc_handler	= &appldata_interval_handler,
+		.proc_handler	= appldata_interval_handler,
 	},
 	{ },
 };
diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index adf1126..071c81f 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -897,14 +897,14 @@ static struct ctl_table s390dbf_table[] = {
 		.data		= &debug_stoppable,
 		.maxlen		= sizeof(int),
 		.mode           = S_IRUGO | S_IWUSR,
-		.proc_handler   = &proc_dointvec,
+		.proc_handler   = proc_dointvec,
 	},
 	 {
 		.procname       = "debug_active",
 		.data		= &debug_active,
 		.maxlen		= sizeof(int),
 		.mode           = S_IRUGO | S_IWUSR,
-		.proc_handler   = &s390dbf_procactive,
+		.proc_handler   = s390dbf_procactive,
 	},
 	{ }
 };
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index dab3e4a..ff58779 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -343,17 +343,17 @@ static struct ctl_table cmm_table[] = {
 	{
 		.procname	= "cmm_pages",
 		.mode		= 0644,
-		.proc_handler	= &cmm_pages_handler,
+		.proc_handler	= cmm_pages_handler,
 	},
 	{
 		.procname	= "cmm_timed_pages",
 		.mode		= 0644,
-		.proc_handler	= &cmm_pages_handler,
+		.proc_handler	= cmm_pages_handler,
 	},
 	{
 		.procname	= "cmm_timeout",
 		.mode		= 0644,
-		.proc_handler	= &cmm_timeout_handler,
+		.proc_handler	= cmm_timeout_handler,
 	},
 	{ }
 };
diff --git a/arch/sh/kernel/traps_64.c b/arch/sh/kernel/traps_64.c
index 080c8ee..75c0cbe 100644
--- a/arch/sh/kernel/traps_64.c
+++ b/arch/sh/kernel/traps_64.c
@@ -881,21 +881,21 @@ static ctl_table unaligned_table[] = {
 		.data		= &kernel_mode_unaligned_fixup_count,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 	{
 		.procname	= "user_reports",
 		.data		= &user_mode_unaligned_fixup_count,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 	{
 		.procname	= "user_enable",
 		.data		= &user_mode_unaligned_fixup_enable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec},
+		.proc_handler	= proc_dointvec},
 	{}
 };
 
diff --git a/crypto/proc.c b/crypto/proc.c
index fe95975..1c38733 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -29,7 +29,7 @@ static struct ctl_table crypto_sysctl_table[] = {
 		.data           = &fips_enabled,
 		.maxlen         = sizeof(int),
 		.mode           = 0444,
-		.proc_handler   = &proc_dointvec
+		.proc_handler   = proc_dointvec
 	},
 	{}
 };
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 1872b6d..e3749d0 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3557,42 +3557,42 @@ static ctl_table cdrom_table[] = {
 		.data		= &cdrom_sysctl_settings.info, 
 		.maxlen		= CDROM_STR_SIZE,
 		.mode		= 0444,
-		.proc_handler	= &cdrom_sysctl_info,
+		.proc_handler	= cdrom_sysctl_info,
 	},
 	{
 		.procname	= "autoclose",
 		.data		= &cdrom_sysctl_settings.autoclose,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &cdrom_sysctl_handler,
+		.proc_handler	= cdrom_sysctl_handler,
 	},
 	{
 		.procname	= "autoeject",
 		.data		= &cdrom_sysctl_settings.autoeject,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &cdrom_sysctl_handler,
+		.proc_handler	= cdrom_sysctl_handler,
 	},
 	{
 		.procname	= "debug",
 		.data		= &cdrom_sysctl_settings.debug,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &cdrom_sysctl_handler,
+		.proc_handler	= cdrom_sysctl_handler,
 	},
 	{
 		.procname	= "lock",
 		.data		= &cdrom_sysctl_settings.lock,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &cdrom_sysctl_handler,
+		.proc_handler	= cdrom_sysctl_handler,
 	},
 	{
 		.procname	= "check_media",
 		.data		= &cdrom_sysctl_settings.check,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &cdrom_sysctl_handler
+		.proc_handler	= cdrom_sysctl_handler
 	},
 	{ }
 };
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index a05a611..e481c59 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -679,7 +679,7 @@ static ctl_table hpet_table[] = {
 	 .data = &hpet_max_freq,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
-	 .proc_handler = &proc_dointvec,
+	 .proc_handler = proc_dointvec,
 	 },
 	{}
 };
diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
index aa39722..0dec5da 100644
--- a/drivers/char/ipmi/ipmi_poweroff.c
+++ b/drivers/char/ipmi/ipmi_poweroff.c
@@ -664,7 +664,7 @@ static ctl_table ipmi_table[] = {
 	  .data		= &poweroff_powercycle,
 	  .maxlen	= sizeof(poweroff_powercycle),
 	  .mode		= 0644,
-	  .proc_handler	= &proc_dointvec },
+	  .proc_handler	= proc_dointvec },
 	{ }
 };
 
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index d516e9c..d86c0bc 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -435,7 +435,7 @@ static struct ctl_table pty_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.data		= &pty_limit,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &pty_limit_min,
 		.extra2		= &pty_limit_max,
 	}, {
@@ -443,7 +443,7 @@ static struct ctl_table pty_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.data		= &pty_count,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	}, 
 	{}
 };
diff --git a/drivers/char/random.c b/drivers/char/random.c
index bcf680f..dcd0863 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1264,13 +1264,13 @@ ctl_table random_table[] = {
 		.data		= &sysctl_poolsize,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "entropy_avail",
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 		.data		= &input_pool.entropy_count,
 	},
 	{
@@ -1278,7 +1278,7 @@ ctl_table random_table[] = {
 		.data		= &random_read_wakeup_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_read_thresh,
 		.extra2		= &max_read_thresh,
 	},
@@ -1287,7 +1287,7 @@ ctl_table random_table[] = {
 		.data		= &random_write_wakeup_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_write_thresh,
 		.extra2		= &max_write_thresh,
 	},
@@ -1296,13 +1296,13 @@ ctl_table random_table[] = {
 		.data		= &sysctl_bootid,
 		.maxlen		= 16,
 		.mode		= 0444,
-		.proc_handler	= &proc_do_uuid,
+		.proc_handler	= proc_do_uuid,
 	},
 	{
 		.procname	= "uuid",
 		.maxlen		= 16,
 		.mode		= 0444,
-		.proc_handler	= &proc_do_uuid,
+		.proc_handler	= proc_do_uuid,
 	},
 	{ }
 };
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 37bfe23..95acb8c 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -286,7 +286,7 @@ static ctl_table rtc_table[] = {
 		.data		= &rtc_max_user_freq,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ }
 };
diff --git a/drivers/macintosh/mac_hid.c b/drivers/macintosh/mac_hid.c
index 2dd29b4..7b4ef5b 100644
--- a/drivers/macintosh/mac_hid.c
+++ b/drivers/macintosh/mac_hid.c
@@ -31,21 +31,21 @@ static ctl_table mac_hid_files[] = {
 		.data		= &mouse_emulate_buttons,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "mouse_button2_keycode",
 		.data		= &mouse_button2_keycode,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "mouse_button3_keycode",
 		.data		= &mouse_button3_keycode,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ }
 };
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1d52955..1d7b9a2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -102,14 +102,14 @@ static ctl_table raid_table[] = {
 		.data		= &sysctl_speed_limit_min,
 		.maxlen		= sizeof(int),
 		.mode		= S_IRUGO|S_IWUSR,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "speed_limit_max",
 		.data		= &sysctl_speed_limit_max,
 		.maxlen		= sizeof(int),
 		.mode		= S_IRUGO|S_IWUSR,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ }
 };
diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index ce98b93..832ed4c 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -93,7 +93,7 @@ static ctl_table xpc_sys_xpc_hb_dir[] = {
 	 .data = &xpc_hb_interval,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
-	 .proc_handler = &proc_dointvec_minmax,
+	 .proc_handler = proc_dointvec_minmax,
 	 .extra1 = &xpc_hb_min_interval,
 	 .extra2 = &xpc_hb_max_interval},
 	{
@@ -101,7 +101,7 @@ static ctl_table xpc_sys_xpc_hb_dir[] = {
 	 .data = &xpc_hb_check_interval,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
-	 .proc_handler = &proc_dointvec_minmax,
+	 .proc_handler = proc_dointvec_minmax,
 	 .extra1 = &xpc_hb_check_min_interval,
 	 .extra2 = &xpc_hb_check_max_interval},
 	{}
@@ -116,7 +116,7 @@ static ctl_table xpc_sys_xpc_dir[] = {
 	 .data = &xpc_disengage_timelimit,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
-	 .proc_handler = &proc_dointvec_minmax,
+	 .proc_handler = proc_dointvec_minmax,
 	 .extra1 = &xpc_disengage_min_timelimit,
 	 .extra2 = &xpc_disengage_max_timelimit},
 	{}
diff --git a/drivers/net/wireless/arlan-proc.c b/drivers/net/wireless/arlan-proc.c
index 66a0b33..b22983e 100644
--- a/drivers/net/wireless/arlan-proc.c
+++ b/drivers/net/wireless/arlan-proc.c
@@ -819,15 +819,15 @@ static int arlan_sysctl_reset(ctl_table * ctl, int write,
 #define CTBLN(card,nam) \
         { .procname = #nam,\
           .data = &(arlan_conf[card].nam),\
-          .maxlen = sizeof(int), .mode = 0600, .proc_handler = &proc_dointvec}
+          .maxlen = sizeof(int), .mode = 0600, .proc_handler = proc_dointvec}
 #ifdef ARLAN_DEBUGGING
 
 #define ARLAN_PROC_DEBUG_ENTRIES \
         { .procname = "entry_exit_debug",\
           .data = &arlan_entry_and_exit_debug,\
-          .maxlen = sizeof(int), .mode = 0600, .proc_handler = &proc_dointvec},\
+          .maxlen = sizeof(int), .mode = 0600, .proc_handler = proc_dointvec},\
 	{ .procname = "debug", .data = &arlan_debug,\
-          .maxlen = sizeof(int), .mode = 0600, .proc_handler = &proc_dointvec},
+          .maxlen = sizeof(int), .mode = 0600, .proc_handler = proc_dointvec},
 #else 
 #define ARLAN_PROC_DEBUG_ENTRIES
 #endif
@@ -864,7 +864,7 @@ static int arlan_sysctl_reset(ctl_table * ctl, int write,
 	CTBLN(cardNo, channelSet), \
 	{ .procname = "name",\
 	 .data = arlan_conf[cardNo].siteName,\
-	 .maxlen = 16, .mode = 0600, .proc_handler = &proc_dostring},\
+	 .maxlen = 16, .mode = 0600, .proc_handler = proc_dostring},\
 	CTBLN(cardNo,waitTime),\
 	CTBLN(cardNo,lParameter),\
 	CTBLN(cardNo,_15),\
@@ -906,35 +906,35 @@ static ctl_table arlan_conf_table0[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_infotxRing,
+		.proc_handler	= arlan_sysctl_infotxRing,
 	},
 	{
 		.procname	= "arlan0-rxRing",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_inforxRing,
+		.proc_handler	= arlan_sysctl_inforxRing,
 	},
 	{
 		.procname	= "arlan0-18",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info18,
+		.proc_handler	= arlan_sysctl_info18,
 	},
 	{
 		.procname	= "arlan0-ring",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info161719,
+		.proc_handler	= arlan_sysctl_info161719,
 	},
 	{
 		.procname	= "arlan0-shm-cpy",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info,
+		.proc_handler	= arlan_sysctl_info,
 	},
 #endif
 	{
@@ -942,14 +942,14 @@ static ctl_table arlan_conf_table0[] =
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_configure
+		.proc_handler	= arlan_configure
 	},
 	{
 		.procname	= "reset0",
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_reset,
+		.proc_handler	= arlan_sysctl_reset,
 	},
 	{  }
 };
@@ -965,35 +965,35 @@ static ctl_table arlan_conf_table1[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_infotxRing,
+		.proc_handler	= arlan_sysctl_infotxRing,
 	},
 	{
 		.procname	= "arlan1-rxRing",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_inforxRing,
+		.proc_handler	= arlan_sysctl_inforxRing,
 	},
 	{
 		.procname	= "arlan1-18",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info18,
+		.proc_handler	= arlan_sysctl_info18,
 	},
 	{
 		.procname	= "arlan1-ring",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info161719,
+		.proc_handler	= arlan_sysctl_info161719,
 	},
 	{
 		.procname	= "arlan1-shm-cpy",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info,
+		.proc_handler	= arlan_sysctl_info,
 	},
 #endif
 	{
@@ -1001,14 +1001,14 @@ static ctl_table arlan_conf_table1[] =
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_configure,
+		.proc_handler	= arlan_configure,
 	},
 	{
 		.procname	= "reset1",
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_reset,
+		.proc_handler	= arlan_sysctl_reset,
 	},
 	{ }
 };
@@ -1024,35 +1024,35 @@ static ctl_table arlan_conf_table2[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_infotxRing,
+		.proc_handler	= arlan_sysctl_infotxRing,
 	},
 	{
 		.procname	= "arlan2-rxRing",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_inforxRing,
+		.proc_handler	= arlan_sysctl_inforxRing,
 	},
 	{
 		.procname	= "arlan2-18",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info18,
+		.proc_handler	= arlan_sysctl_info18,
 	},
 	{
 		.procname	= "arlan2-ring",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info161719,
+		.proc_handler	= arlan_sysctl_info161719,
 	},
 	{
 		.procname	= "arlan2-shm-cpy",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info,
+		.proc_handler	= arlan_sysctl_info,
 	},
 #endif
 	{
@@ -1060,14 +1060,14 @@ static ctl_table arlan_conf_table2[] =
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_configure,
+		.proc_handler	= arlan_configure,
 	},
 	{
 		.procname	= "reset2",
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_reset,
+		.proc_handler	= arlan_sysctl_reset,
 	},
 	{ }
 };
@@ -1083,35 +1083,35 @@ static ctl_table arlan_conf_table3[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_infotxRing,
+		.proc_handler	= arlan_sysctl_infotxRing,
 	},
 	{
 		.procname	= "arlan3-rxRing",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_inforxRing,
+		.proc_handler	= arlan_sysctl_inforxRing,
 	},
 	{
 		.procname	= "arlan3-18",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info18,
+		.proc_handler	= arlan_sysctl_info18,
 	},
 	{
 		.procname	= "arlan3-ring",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info161719,
+		.proc_handler	= arlan_sysctl_info161719,
 	},
 	{
 		.procname	= "arlan3-shm-cpy",
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info,
+		.proc_handler	= arlan_sysctl_info,
 	},
 #endif
 	{
@@ -1119,14 +1119,14 @@ static ctl_table arlan_conf_table3[] =
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_configure,
+		.proc_handler	= arlan_configure,
 	},
 	{
 		.procname	= "reset3",
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_reset,
+		.proc_handler	= arlan_sysctl_reset,
 	},
 	{ }
 };
diff --git a/drivers/parport/procfs.c b/drivers/parport/procfs.c
index f808bdb..3f56bc0 100644
--- a/drivers/parport/procfs.c
+++ b/drivers/parport/procfs.c
@@ -270,7 +270,7 @@ static const struct parport_sysctl_table parport_sysctl_template = {
 			.data		= NULL,
 			.maxlen		= sizeof(int),
 			.mode		= 0644,
-			.proc_handler	= &proc_dointvec_minmax,
+			.proc_handler	= proc_dointvec_minmax,
 			.extra1		= (void*) &parport_min_spintime_value,
 			.extra2		= (void*) &parport_max_spintime_value
 		},
@@ -279,28 +279,28 @@ static const struct parport_sysctl_table parport_sysctl_template = {
 			.data		= NULL,
 			.maxlen		= 0,
 			.mode		= 0444,
-			.proc_handler	= &do_hardware_base_addr
+			.proc_handler	= do_hardware_base_addr
 		},
 		{
 			.procname	= "irq",
 			.data		= NULL,
 			.maxlen		= 0,
 			.mode		= 0444,
-			.proc_handler	= &do_hardware_irq
+			.proc_handler	= do_hardware_irq
 		},
 		{
 			.procname	= "dma",
 			.data		= NULL,
 			.maxlen		= 0,
 			.mode		= 0444,
-			.proc_handler	= &do_hardware_dma
+			.proc_handler	= do_hardware_dma
 		},
 		{
 			.procname	= "modes",
 			.data		= NULL,
 			.maxlen		= 0,
 			.mode		= 0444,
-			.proc_handler	= &do_hardware_modes
+			.proc_handler	= do_hardware_modes
 		},
 		PARPORT_DEVICES_ROOT_DIR,
 #ifdef CONFIG_PARPORT_1284
@@ -309,35 +309,35 @@ static const struct parport_sysctl_table parport_sysctl_template = {
 			.data		= NULL,
 			.maxlen		= 0,
 			.mode		= 0444,
-			.proc_handler	= &do_autoprobe
+			.proc_handler	= do_autoprobe
 		},
 		{
 			.procname	= "autoprobe0",
 			.data		= NULL,
 			.maxlen		= 0,
 			.mode		= 0444,
-			.proc_handler	=  &do_autoprobe
+			.proc_handler	= do_autoprobe
 		},
 		{
 			.procname	= "autoprobe1",
 			.data		= NULL,
 			.maxlen		= 0,
 			.mode		= 0444,
-			.proc_handler	= &do_autoprobe
+			.proc_handler	= do_autoprobe
 		},
 		{
 			.procname	= "autoprobe2",
 			.data		= NULL,
 			.maxlen		= 0,
 			.mode		= 0444,
-			.proc_handler	= &do_autoprobe
+			.proc_handler	= do_autoprobe
 		},
 		{
 			.procname	= "autoprobe3",
 			.data		= NULL,
 			.maxlen		= 0,
 			.mode		= 0444,
-			.proc_handler	= &do_autoprobe
+			.proc_handler	= do_autoprobe
 		},
 #endif /* IEEE 1284 support */
 		{}
@@ -348,7 +348,7 @@ static const struct parport_sysctl_table parport_sysctl_template = {
 			.data		= NULL,
 			.maxlen		= 0,
 			.mode		= 0444,
-			.proc_handler	= &do_active_device
+			.proc_handler	= do_active_device
 		},
 		{}
 	},
@@ -386,7 +386,7 @@ parport_device_sysctl_template = {
 			.data		= NULL,
 			.maxlen		= sizeof(unsigned long),
 			.mode		= 0644,
-			.proc_handler	= &proc_doulongvec_ms_jiffies_minmax,
+			.proc_handler	= proc_doulongvec_ms_jiffies_minmax,
 			.extra1		= (void*) &parport_min_timeslice_value,
 			.extra2		= (void*) &parport_max_timeslice_value
 		},
@@ -437,7 +437,7 @@ parport_default_sysctl_table = {
 			.data		= &parport_default_timeslice,
 			.maxlen		= sizeof(parport_default_timeslice),
 			.mode		= 0644,
-			.proc_handler	= &proc_doulongvec_ms_jiffies_minmax,
+			.proc_handler	= proc_doulongvec_ms_jiffies_minmax,
 			.extra1		= (void*) &parport_min_timeslice_value,
 			.extra2		= (void*) &parport_max_timeslice_value
 		},
@@ -446,7 +446,7 @@ parport_default_sysctl_table = {
 			.data		= &parport_default_spintime,
 			.maxlen		= sizeof(parport_default_spintime),
 			.mode		= 0644,
-			.proc_handler	= &proc_dointvec_minmax,
+			.proc_handler	= proc_dointvec_minmax,
 			.extra1		= (void*) &parport_min_spintime_value,
 			.extra2		= (void*) &parport_max_spintime_value
 		},
diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
index 42c31be..2b6b93f 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -17,7 +17,7 @@ static ctl_table scsi_table[] = {
 	  .data		= &scsi_logging_level,
 	  .maxlen	= sizeof(scsi_logging_level),
 	  .mode		= 0644,
-	  .proc_handler	= &proc_dointvec },
+	  .proc_handler	= proc_dointvec },
 	{ }
 };
 
diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index 354c050..c6405ce 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -21,21 +21,21 @@ static ctl_table coda_table[] = {
 		.data		= &coda_timeout,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 	{
 		.procname	= "hard",
 		.data		= &coda_hard,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 	{
 		.procname	= "fake_statfs",
 		.data		= &coda_fake_statfs,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 	{}
 };
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 70aa66c..366c503 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -251,7 +251,7 @@ ctl_table epoll_table[] = {
 		.data		= &max_user_watches,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 	{ }
diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 307ed4c..e50cfa3 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -375,7 +375,7 @@ static ctl_table nlm_sysctls[] = {
 		.data		= &nlm_grace_period,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 		.extra1		= (unsigned long *) &nlm_grace_period_min,
 		.extra2		= (unsigned long *) &nlm_grace_period_max,
 	},
@@ -384,7 +384,7 @@ static ctl_table nlm_sysctls[] = {
 		.data		= &nlm_timeout,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 		.extra1		= (unsigned long *) &nlm_timeout_min,
 		.extra2		= (unsigned long *) &nlm_timeout_max,
 	},
@@ -393,7 +393,7 @@ static ctl_table nlm_sysctls[] = {
 		.data		= &nlm_udpport,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= (int *) &nlm_port_min,
 		.extra2		= (int *) &nlm_port_max,
 	},
@@ -402,7 +402,7 @@ static ctl_table nlm_sysctls[] = {
 		.data		= &nlm_tcpport,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= (int *) &nlm_port_min,
 		.extra2		= (int *) &nlm_port_max,
 	},
@@ -411,14 +411,14 @@ static ctl_table nlm_sysctls[] = {
 		.data		= &nsm_use_hostnames,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "nsm_local_state",
 		.data		= &nsm_local_state,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ }
 };
diff --git a/fs/nfs/sysctl.c b/fs/nfs/sysctl.c
index af51e6a..70e1fbb 100644
--- a/fs/nfs/sysctl.c
+++ b/fs/nfs/sysctl.c
@@ -26,7 +26,7 @@ static ctl_table nfs_cb_sysctls[] = {
 		.data = &nfs_callback_set_tcpport,
 		.maxlen = sizeof(int),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec_minmax,
+		.proc_handler = proc_dointvec_minmax,
 		.extra1 = (int *)&nfs_set_port_min,
 		.extra2 = (int *)&nfs_set_port_max,
 	},
@@ -35,7 +35,7 @@ static ctl_table nfs_cb_sysctls[] = {
 		.data = &nfs_idmap_cache_timeout,
 		.maxlen = sizeof(int),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec_jiffies,
+		.proc_handler = proc_dointvec_jiffies,
 	},
 #endif
 	{
@@ -43,14 +43,14 @@ static ctl_table nfs_cb_sysctls[] = {
 		.data		= &nfs_mountpoint_expiry_timeout,
 		.maxlen		= sizeof(nfs_mountpoint_expiry_timeout),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "nfs_congestion_kb",
 		.data		= &nfs_congestion_kb,
 		.maxlen		= sizeof(nfs_congestion_kb),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ }
 };
diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 5275921..1d1d1a2 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -73,7 +73,7 @@ ctl_table inotify_table[] = {
 		.data		= &inotify_max_user_instances,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 	{
@@ -81,7 +81,7 @@ ctl_table inotify_table[] = {
 		.data		= &inotify_max_user_watches,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 	{
@@ -89,7 +89,7 @@ ctl_table inotify_table[] = {
 		.data		= &inotify_max_queued_events,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero
 	},
 	{ }
diff --git a/fs/ntfs/sysctl.c b/fs/ntfs/sysctl.c
index 99612ea..79a8918 100644
--- a/fs/ntfs/sysctl.c
+++ b/fs/ntfs/sysctl.c
@@ -40,7 +40,7 @@ static ctl_table ntfs_sysctls[] = {
 		.data		= &debug_msgs,		/* Data pointer and size. */
 		.maxlen		= sizeof(debug_msgs),
 		.mode		= 0644,			/* Mode, proc handler. */
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 	{}
 };
diff --git a/fs/ocfs2/stackglue.c b/fs/ocfs2/stackglue.c
index ed12c11..f3df0ba 100644
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -624,7 +624,7 @@ static ctl_table ocfs2_nm_table[] = {
 		.data		= ocfs2_hb_ctl_path,
 		.maxlen		= OCFS2_MAX_HB_CTL_PATH,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
+		.proc_handler	= proc_dostring,
 	},
 	{ }
 };
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 60940f8..f0eb200 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2477,56 +2477,56 @@ static ctl_table fs_dqstats_table[] = {
 		.data		= &dqstats.lookups,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "drops",
 		.data		= &dqstats.drops,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "reads",
 		.data		= &dqstats.reads,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "writes",
 		.data		= &dqstats.writes,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "cache_hits",
 		.data		= &dqstats.cache_hits,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "allocated_dquots",
 		.data		= &dqstats.allocated_dquots,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "free_dquots",
 		.data		= &dqstats.free_dquots,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "syncs",
 		.data		= &dqstats.syncs,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #ifdef CONFIG_PRINT_QUOTA_WARNING
 	{
@@ -2534,7 +2534,7 @@ static ctl_table fs_dqstats_table[] = {
 		.data		= &flag_print_warnings,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{ },
diff --git a/fs/xfs/linux-2.6/xfs_sysctl.c b/fs/xfs/linux-2.6/xfs_sysctl.c
index 6880147..7bb5092 100644
--- a/fs/xfs/linux-2.6/xfs_sysctl.c
+++ b/fs/xfs/linux-2.6/xfs_sysctl.c
@@ -59,7 +59,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.sgid_inherit.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.sgid_inherit.min,
 		.extra2		= &xfs_params.sgid_inherit.max
 	},
@@ -68,7 +68,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.symlink_mode.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.symlink_mode.min,
 		.extra2		= &xfs_params.symlink_mode.max
 	},
@@ -77,7 +77,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.panic_mask.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.panic_mask.min,
 		.extra2		= &xfs_params.panic_mask.max
 	},
@@ -87,7 +87,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.error_level.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.error_level.min,
 		.extra2		= &xfs_params.error_level.max
 	},
@@ -96,7 +96,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.syncd_timer.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.syncd_timer.min,
 		.extra2		= &xfs_params.syncd_timer.max
 	},
@@ -105,7 +105,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.inherit_sync.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.inherit_sync.min,
 		.extra2		= &xfs_params.inherit_sync.max
 	},
@@ -114,7 +114,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.inherit_nodump.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.inherit_nodump.min,
 		.extra2		= &xfs_params.inherit_nodump.max
 	},
@@ -123,7 +123,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.inherit_noatim.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.inherit_noatim.min,
 		.extra2		= &xfs_params.inherit_noatim.max
 	},
@@ -132,7 +132,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.xfs_buf_timer.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.xfs_buf_timer.min,
 		.extra2		= &xfs_params.xfs_buf_timer.max
 	},
@@ -141,7 +141,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.xfs_buf_age.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.xfs_buf_age.min,
 		.extra2		= &xfs_params.xfs_buf_age.max
 	},
@@ -150,7 +150,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.inherit_nosym.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.inherit_nosym.min,
 		.extra2		= &xfs_params.inherit_nosym.max
 	},
@@ -159,7 +159,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.rotorstep.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.rotorstep.min,
 		.extra2		= &xfs_params.rotorstep.max
 	},
@@ -168,7 +168,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.inherit_nodfrg.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.inherit_nodfrg.min,
 		.extra2		= &xfs_params.inherit_nodfrg.max
 	},
@@ -177,7 +177,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.fstrm_timer.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xfs_params.fstrm_timer.min,
 		.extra2		= &xfs_params.fstrm_timer.max,
 	},
@@ -188,7 +188,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.stats_clear.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &xfs_stats_clear_proc_handler,
+		.proc_handler	= xfs_stats_clear_proc_handler,
 		.extra1		= &xfs_params.stats_clear.min,
 		.extra2		= &xfs_params.stats_clear.max
 	},
diff --git a/kernel/slow-work.c b/kernel/slow-work.c
index 0134b15..ebd9a83 100644
--- a/kernel/slow-work.c
+++ b/kernel/slow-work.c
@@ -74,7 +74,7 @@ ctl_table slow_work_sysctls[] = {
 		.data		= &vslow_work_proportion,
 		.maxlen		= sizeof(unsigned),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= (void *) &slow_work_min_vslow,
 		.extra2		= (void *) &slow_work_max_vslow,
 	},
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b4a5763..e2ccc89 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -249,7 +249,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_child_runs_first,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #ifdef CONFIG_SCHED_DEBUG
 	{
@@ -257,7 +257,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_min_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &sched_nr_latency_handler,
+		.proc_handler	= sched_nr_latency_handler,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
 	},
@@ -266,7 +266,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_latency,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &sched_nr_latency_handler,
+		.proc_handler	= sched_nr_latency_handler,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
 	},
@@ -275,7 +275,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_wakeup_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_wakeup_granularity_ns,
 		.extra2		= &max_wakeup_granularity_ns,
 	},
@@ -284,14 +284,14 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_shares_ratelimit,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "sched_shares_thresh",
 		.data		= &sysctl_sched_shares_thresh,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 	{
@@ -299,35 +299,35 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_features,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "sched_migration_cost",
 		.data		= &sysctl_sched_migration_cost,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "sched_nr_migrate",
 		.data		= &sysctl_sched_nr_migrate,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "sched_time_avg",
 		.data		= &sysctl_sched_time_avg,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "timer_migration",
 		.data		= &sysctl_timer_migration,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -337,21 +337,21 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_rt_period,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &sched_rt_handler,
+		.proc_handler	= sched_rt_handler,
 	},
 	{
 		.procname	= "sched_rt_runtime_us",
 		.data		= &sysctl_sched_rt_runtime,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &sched_rt_handler,
+		.proc_handler	= sched_rt_handler,
 	},
 	{
 		.procname	= "sched_compat_yield",
 		.data		= &sysctl_sched_compat_yield,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #ifdef CONFIG_PROVE_LOCKING
 	{
@@ -359,7 +359,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &prove_locking,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_LOCK_STAT
@@ -368,7 +368,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &lock_stat,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -376,35 +376,35 @@ static struct ctl_table kern_table[] = {
 		.data		= &panic_timeout,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "core_uses_pid",
 		.data		= &core_uses_pid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "core_pattern",
 		.data		= core_pattern,
 		.maxlen		= CORENAME_MAX_SIZE,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
+		.proc_handler	= proc_dostring,
 	},
 	{
 		.procname	= "core_pipe_limit",
 		.data		= &core_pipe_limit,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #ifdef CONFIG_PROC_SYSCTL
 	{
 		.procname	= "tainted",
 		.maxlen 	= sizeof(long),
 		.mode		= 0644,
-		.proc_handler	= &proc_taint,
+		.proc_handler	= proc_taint,
 	},
 #endif
 #ifdef CONFIG_LATENCYTOP
@@ -413,7 +413,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &latencytop_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -422,7 +422,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &real_root_dev,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -430,7 +430,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &print_fatal_signals,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #ifdef CONFIG_SPARC
 	{
@@ -438,21 +438,21 @@ static struct ctl_table kern_table[] = {
 		.data		= reboot_command,
 		.maxlen		= 256,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
+		.proc_handler	= proc_dostring,
 	},
 	{
 		.procname	= "stop-a",
 		.data		= &stop_a_enabled,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "scons-poweroff",
 		.data		= &scons_pwroff,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_SPARC64
@@ -461,7 +461,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_tsb_ratio,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef __hppa__
@@ -470,14 +470,14 @@ static struct ctl_table kern_table[] = {
 		.data		= &pwrsw_enabled,
 		.maxlen		= sizeof (int),
 	 	.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "unaligned-trap",
 		.data		= &unaligned_enabled,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -485,7 +485,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &C_A_D,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #ifdef CONFIG_FUNCTION_TRACER
 	{
@@ -493,7 +493,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &ftrace_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &ftrace_enable_sysctl,
+		.proc_handler	= ftrace_enable_sysctl,
 	},
 #endif
 #ifdef CONFIG_STACK_TRACER
@@ -502,7 +502,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &stack_tracer_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &stack_trace_sysctl,
+		.proc_handler	= stack_trace_sysctl,
 	},
 #endif
 #ifdef CONFIG_TRACING
@@ -511,7 +511,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &ftrace_dump_on_oops,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_MODULES
@@ -520,7 +520,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &modprobe_path,
 		.maxlen		= KMOD_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
+		.proc_handler	= proc_dostring,
 	},
 	{
 		.procname	= "modules_disabled",
@@ -528,7 +528,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		/* only handle a transition from default "0" to "1" */
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &one,
 		.extra2		= &one,
 	},
@@ -539,7 +539,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &uevent_helper,
 		.maxlen		= UEVENT_HELPER_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
+		.proc_handler	= proc_dostring,
 	},
 #endif
 #ifdef CONFIG_CHR_DEV_SG
@@ -548,7 +548,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sg_big_buff,
 		.maxlen		= sizeof (int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
@@ -557,7 +557,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &acct_parm,
 		.maxlen		= 3*sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_MAGIC_SYSRQ
@@ -566,7 +566,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &__sysrq_enabled,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_PROC_SYSCTL
@@ -575,7 +575,7 @@ static struct ctl_table kern_table[] = {
 		.data		= NULL,
 		.maxlen		= sizeof (int),
 		.mode		= 0600,
-		.proc_handler	= &proc_do_cad_pid,
+		.proc_handler	= proc_do_cad_pid,
 	},
 #endif
 	{
@@ -583,7 +583,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &max_threads,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "random",
@@ -595,7 +595,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &overflowuid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
@@ -604,7 +604,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &overflowgid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
@@ -615,7 +615,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_ieee_emulation_warnings,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -623,7 +623,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_userprocess_debug,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -631,7 +631,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &pid_max,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &pid_max_min,
 		.extra2		= &pid_max_max,
 	},
@@ -640,7 +640,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &panic_on_oops,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #if defined CONFIG_PRINTK
 	{
@@ -648,28 +648,28 @@ static struct ctl_table kern_table[] = {
 		.data		= &console_loglevel,
 		.maxlen		= 4*sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "printk_ratelimit",
 		.data		= &printk_ratelimit_state.interval,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "printk_ratelimit_burst",
 		.data		= &printk_ratelimit_state.burst,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "printk_delay",
 		.data		= &printk_delay_msec,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &ten_thousand,
 	},
@@ -679,7 +679,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &ngroups_max,
 		.maxlen		= sizeof (int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
@@ -687,14 +687,14 @@ static struct ctl_table kern_table[] = {
 		.data           = &unknown_nmi_panic,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
+		.proc_handler   = proc_dointvec,
 	},
 	{
 		.procname       = "nmi_watchdog",
 		.data           = &nmi_watchdog_enabled,
 		.maxlen         = sizeof (int),
 		.mode           = 0644,
-		.proc_handler   = &proc_nmi_enabled,
+		.proc_handler   = proc_nmi_enabled,
 	},
 #endif
 #if defined(CONFIG_X86)
@@ -703,42 +703,42 @@ static struct ctl_table kern_table[] = {
 		.data		= &panic_on_unrecovered_nmi,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "panic_on_io_nmi",
 		.data		= &panic_on_io_nmi,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "bootloader_type",
 		.data		= &bootloader_type,
 		.maxlen		= sizeof (int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "bootloader_version",
 		.data		= &bootloader_version,
 		.maxlen		= sizeof (int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "kstack_depth_to_print",
 		.data		= &kstack_depth_to_print,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "io_delay_type",
 		.data		= &io_delay_type,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #if defined(CONFIG_MMU)
@@ -747,7 +747,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &randomize_va_space,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #if defined(CONFIG_S390) && defined(CONFIG_SMP)
@@ -756,7 +756,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &spin_retry,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #if	defined(CONFIG_ACPI_SLEEP) && defined(CONFIG_X86)
@@ -765,7 +765,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &acpi_realmode_flags,
 		.maxlen		= sizeof (unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 #endif
 #ifdef CONFIG_IA64
@@ -774,14 +774,14 @@ static struct ctl_table kern_table[] = {
 		.data		= &no_unaligned_warning,
 		.maxlen		= sizeof (int),
 	 	.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "unaligned-dump-stack",
 		.data		= &unaligned_dump_stack,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_DETECT_SOFTLOCKUP
@@ -790,7 +790,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &softlockup_panic,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -799,7 +799,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &softlockup_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dosoftlockup_thresh,
+		.proc_handler	= proc_dosoftlockup_thresh,
 		.extra1		= &neg_one,
 		.extra2		= &sixty,
 	},
@@ -810,7 +810,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_hung_task_panic,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -819,21 +819,21 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_hung_task_check_count,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 	{
 		.procname	= "hung_task_timeout_secs",
 		.data		= &sysctl_hung_task_timeout_secs,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_dohung_task_timeout_secs,
+		.proc_handler	= proc_dohung_task_timeout_secs,
 	},
 	{
 		.procname	= "hung_task_warnings",
 		.data		= &sysctl_hung_task_warnings,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 #endif
 #ifdef CONFIG_COMPAT
@@ -842,7 +842,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &compat_log,
 		.maxlen		= sizeof (int),
 	 	.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_RT_MUTEXES
@@ -851,7 +851,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &max_lock_depth,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -859,7 +859,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &poweroff_cmd,
 		.maxlen		= POWEROFF_CMD_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
+		.proc_handler	= proc_dostring,
 	},
 #ifdef CONFIG_KEYS
 	{
@@ -874,7 +874,7 @@ static struct ctl_table kern_table[] = {
 		.data           = &rcutorture_runnable,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_SLOW_WORK
@@ -890,21 +890,21 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_perf_event_paranoid,
 		.maxlen		= sizeof(sysctl_perf_event_paranoid),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "perf_event_mlock_kb",
 		.data		= &sysctl_perf_event_mlock,
 		.maxlen		= sizeof(sysctl_perf_event_mlock),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "perf_event_max_sample_rate",
 		.data		= &sysctl_perf_event_sample_rate,
 		.maxlen		= sizeof(sysctl_perf_event_sample_rate),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_KMEMCHECK
@@ -913,7 +913,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &kmemcheck_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_BLOCK
@@ -922,7 +922,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &blk_iopoll_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 /*
@@ -938,49 +938,49 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_overcommit_memory,
 		.maxlen		= sizeof(sysctl_overcommit_memory),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "panic_on_oom",
 		.data		= &sysctl_panic_on_oom,
 		.maxlen		= sizeof(sysctl_panic_on_oom),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "oom_kill_allocating_task",
 		.data		= &sysctl_oom_kill_allocating_task,
 		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "oom_dump_tasks",
 		.data		= &sysctl_oom_dump_tasks,
 		.maxlen		= sizeof(sysctl_oom_dump_tasks),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "overcommit_ratio",
 		.data		= &sysctl_overcommit_ratio,
 		.maxlen		= sizeof(sysctl_overcommit_ratio),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "page-cluster", 
 		.data		= &page_cluster,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "dirty_background_ratio",
 		.data		= &dirty_background_ratio,
 		.maxlen		= sizeof(dirty_background_ratio),
 		.mode		= 0644,
-		.proc_handler	= &dirty_background_ratio_handler,
+		.proc_handler	= dirty_background_ratio_handler,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
@@ -989,7 +989,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &dirty_background_bytes,
 		.maxlen		= sizeof(dirty_background_bytes),
 		.mode		= 0644,
-		.proc_handler	= &dirty_background_bytes_handler,
+		.proc_handler	= dirty_background_bytes_handler,
 		.extra1		= &one_ul,
 	},
 	{
@@ -997,7 +997,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &vm_dirty_ratio,
 		.maxlen		= sizeof(vm_dirty_ratio),
 		.mode		= 0644,
-		.proc_handler	= &dirty_ratio_handler,
+		.proc_handler	= dirty_ratio_handler,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
@@ -1006,7 +1006,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &vm_dirty_bytes,
 		.maxlen		= sizeof(vm_dirty_bytes),
 		.mode		= 0644,
-		.proc_handler	= &dirty_bytes_handler,
+		.proc_handler	= dirty_bytes_handler,
 		.extra1		= &dirty_bytes_min,
 	},
 	{
@@ -1014,28 +1014,28 @@ static struct ctl_table vm_table[] = {
 		.data		= &dirty_writeback_interval,
 		.maxlen		= sizeof(dirty_writeback_interval),
 		.mode		= 0644,
-		.proc_handler	= &dirty_writeback_centisecs_handler,
+		.proc_handler	= dirty_writeback_centisecs_handler,
 	},
 	{
 		.procname	= "dirty_expire_centisecs",
 		.data		= &dirty_expire_interval,
 		.maxlen		= sizeof(dirty_expire_interval),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "nr_pdflush_threads",
 		.data		= &nr_pdflush_threads,
 		.maxlen		= sizeof nr_pdflush_threads,
 		.mode		= 0444 /* read-only*/,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "swappiness",
 		.data		= &vm_swappiness,
 		.maxlen		= sizeof(vm_swappiness),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
@@ -1045,7 +1045,7 @@ static struct ctl_table vm_table[] = {
 		.data		= NULL,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &hugetlb_sysctl_handler,
+		.proc_handler	= hugetlb_sysctl_handler,
 		.extra1		= (void *)&hugetlb_zero,
 		.extra2		= (void *)&hugetlb_infinity,
 	 },
@@ -1054,21 +1054,21 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_hugetlb_shm_group,
 		.maxlen		= sizeof(gid_t),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	 },
 	 {
 		.procname	= "hugepages_treat_as_movable",
 		.data		= &hugepages_treat_as_movable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &hugetlb_treat_movable_handler,
+		.proc_handler	= hugetlb_treat_movable_handler,
 	},
 	{
 		.procname	= "nr_overcommit_hugepages",
 		.data		= NULL,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &hugetlb_overcommit_handler,
+		.proc_handler	= hugetlb_overcommit_handler,
 		.extra1		= (void *)&hugetlb_zero,
 		.extra2		= (void *)&hugetlb_infinity,
 	},
@@ -1078,7 +1078,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_lowmem_reserve_ratio,
 		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
 		.mode		= 0644,
-		.proc_handler	= &lowmem_reserve_ratio_sysctl_handler,
+		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
 	},
 	{
 		.procname	= "drop_caches",
@@ -1092,7 +1092,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &min_free_kbytes,
 		.maxlen		= sizeof(min_free_kbytes),
 		.mode		= 0644,
-		.proc_handler	= &min_free_kbytes_sysctl_handler,
+		.proc_handler	= min_free_kbytes_sysctl_handler,
 		.extra1		= &zero,
 	},
 	{
@@ -1100,7 +1100,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &percpu_pagelist_fraction,
 		.maxlen		= sizeof(percpu_pagelist_fraction),
 		.mode		= 0644,
-		.proc_handler	= &percpu_pagelist_fraction_sysctl_handler,
+		.proc_handler	= percpu_pagelist_fraction_sysctl_handler,
 		.extra1		= &min_percpu_pagelist_fract,
 	},
 #ifdef CONFIG_MMU
@@ -1109,7 +1109,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_max_map_count,
 		.maxlen		= sizeof(sysctl_max_map_count),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 #else
 	{
@@ -1117,7 +1117,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_nr_trim_pages,
 		.maxlen		= sizeof(sysctl_nr_trim_pages),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 #endif
@@ -1126,14 +1126,14 @@ static struct ctl_table vm_table[] = {
 		.data		= &laptop_mode,
 		.maxlen		= sizeof(laptop_mode),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{
 		.procname	= "block_dump",
 		.data		= &block_dump,
 		.maxlen		= sizeof(block_dump),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 		.extra1		= &zero,
 	},
 	{
@@ -1141,7 +1141,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_vfs_cache_pressure,
 		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 		.extra1		= &zero,
 	},
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
@@ -1150,7 +1150,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_legacy_va_layout,
 		.maxlen		= sizeof(sysctl_legacy_va_layout),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 		.extra1		= &zero,
 	},
 #endif
@@ -1160,7 +1160,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &zone_reclaim_mode,
 		.maxlen		= sizeof(zone_reclaim_mode),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 		.extra1		= &zero,
 	},
 	{
@@ -1168,7 +1168,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_min_unmapped_ratio,
 		.maxlen		= sizeof(sysctl_min_unmapped_ratio),
 		.mode		= 0644,
-		.proc_handler	= &sysctl_min_unmapped_ratio_sysctl_handler,
+		.proc_handler	= sysctl_min_unmapped_ratio_sysctl_handler,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
@@ -1177,7 +1177,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_min_slab_ratio,
 		.maxlen		= sizeof(sysctl_min_slab_ratio),
 		.mode		= 0644,
-		.proc_handler	= &sysctl_min_slab_ratio_sysctl_handler,
+		.proc_handler	= sysctl_min_slab_ratio_sysctl_handler,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
@@ -1188,7 +1188,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_stat_interval,
 		.maxlen		= sizeof(sysctl_stat_interval),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= proc_dointvec_jiffies,
 	},
 #endif
 	{
@@ -1196,7 +1196,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &dac_mmap_min_addr,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &mmap_min_addr_handler,
+		.proc_handler	= mmap_min_addr_handler,
 	},
 #ifdef CONFIG_NUMA
 	{
@@ -1204,7 +1204,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &numa_zonelist_order,
 		.maxlen		= NUMA_ZONELIST_ORDER_LEN,
 		.mode		= 0644,
-		.proc_handler	= &numa_zonelist_order_handler,
+		.proc_handler	= numa_zonelist_order_handler,
 	},
 #endif
 #if (defined(CONFIG_X86_32) && !defined(CONFIG_UML))|| \
@@ -1214,7 +1214,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &vdso_enabled,
 		.maxlen		= sizeof(vdso_enabled),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 		.extra1		= &zero,
 	},
 #endif
@@ -1224,7 +1224,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &vm_highmem_is_dirtyable,
 		.maxlen		= sizeof(vm_highmem_is_dirtyable),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -1234,7 +1234,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &scan_unevictable_pages,
 		.maxlen		= sizeof(scan_unevictable_pages),
 		.mode		= 0644,
-		.proc_handler	= &scan_unevictable_handler,
+		.proc_handler	= scan_unevictable_handler,
 	},
 #ifdef CONFIG_MEMORY_FAILURE
 	{
@@ -1242,7 +1242,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_memory_failure_early_kill,
 		.maxlen		= sizeof(sysctl_memory_failure_early_kill),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -1251,7 +1251,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_memory_failure_recovery,
 		.maxlen		= sizeof(sysctl_memory_failure_recovery),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -1276,35 +1276,35 @@ static struct ctl_table fs_table[] = {
 		.data		= &inodes_stat,
 		.maxlen		= 2*sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "inode-state",
 		.data		= &inodes_stat,
 		.maxlen		= 7*sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "file-nr",
 		.data		= &files_stat,
 		.maxlen		= 3*sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_nr_files,
+		.proc_handler	= proc_nr_files,
 	},
 	{
 		.procname	= "file-max",
 		.data		= &files_stat.max_files,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "nr_open",
 		.data		= &sysctl_nr_open,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &sysctl_nr_open_min,
 		.extra2		= &sysctl_nr_open_max,
 	},
@@ -1313,14 +1313,14 @@ static struct ctl_table fs_table[] = {
 		.data		= &dentry_stat,
 		.maxlen		= 6*sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "overflowuid",
 		.data		= &fs_overflowuid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
@@ -1329,7 +1329,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &fs_overflowgid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
@@ -1339,7 +1339,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &leases_enable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_DNOTIFY
@@ -1348,7 +1348,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &dir_notify_enable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_MMU
@@ -1358,7 +1358,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &lease_break_time,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_AIO
@@ -1367,14 +1367,14 @@ static struct ctl_table fs_table[] = {
 		.data		= &aio_nr,
 		.maxlen		= sizeof(aio_nr),
 		.mode		= 0444,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 	{
 		.procname	= "aio-max-nr",
 		.data		= &aio_max_nr,
 		.maxlen		= sizeof(aio_max_nr),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 #endif /* CONFIG_AIO */
 #ifdef CONFIG_INOTIFY_USER
@@ -1397,7 +1397,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
diff --git a/net/rds/ib_sysctl.c b/net/rds/ib_sysctl.c
index 517c6c9..03f01cb 100644
--- a/net/rds/ib_sysctl.c
+++ b/net/rds/ib_sysctl.c
@@ -71,7 +71,7 @@ ctl_table rds_ib_sysctl_table[] = {
 		.data		= &rds_ib_sysctl_max_send_wr,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_doulongvec_minmax,
+		.proc_handler   = proc_doulongvec_minmax,
 		.extra1		= &rds_ib_sysctl_max_wr_min,
 		.extra2		= &rds_ib_sysctl_max_wr_max,
 	},
@@ -80,7 +80,7 @@ ctl_table rds_ib_sysctl_table[] = {
 		.data		= &rds_ib_sysctl_max_recv_wr,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_doulongvec_minmax,
+		.proc_handler   = proc_doulongvec_minmax,
 		.extra1		= &rds_ib_sysctl_max_wr_min,
 		.extra2		= &rds_ib_sysctl_max_wr_max,
 	},
@@ -89,7 +89,7 @@ ctl_table rds_ib_sysctl_table[] = {
 		.data		= &rds_ib_sysctl_max_unsig_wrs,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_doulongvec_minmax,
+		.proc_handler   = proc_doulongvec_minmax,
 		.extra1		= &rds_ib_sysctl_max_unsig_wr_min,
 		.extra2		= &rds_ib_sysctl_max_unsig_wr_max,
 	},
@@ -98,7 +98,7 @@ ctl_table rds_ib_sysctl_table[] = {
 		.data		= &rds_ib_sysctl_max_unsig_bytes,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_doulongvec_minmax,
+		.proc_handler   = proc_doulongvec_minmax,
 		.extra1		= &rds_ib_sysctl_max_unsig_bytes_min,
 		.extra2		= &rds_ib_sysctl_max_unsig_bytes_max,
 	},
@@ -107,14 +107,14 @@ ctl_table rds_ib_sysctl_table[] = {
 		.data		= &rds_ib_sysctl_max_recv_allocation,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_doulongvec_minmax,
+		.proc_handler   = proc_doulongvec_minmax,
 	},
 	{
 		.procname	= "flow_control",
 		.data		= &rds_ib_sysctl_flow_control,
 		.maxlen		= sizeof(rds_ib_sysctl_flow_control),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ }
 };
diff --git a/net/rds/iw_sysctl.c b/net/rds/iw_sysctl.c
index 3e00b01..1c4428a 100644
--- a/net/rds/iw_sysctl.c
+++ b/net/rds/iw_sysctl.c
@@ -61,7 +61,7 @@ ctl_table rds_iw_sysctl_table[] = {
 		.data		= &rds_iw_sysctl_max_send_wr,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_doulongvec_minmax,
+		.proc_handler   = proc_doulongvec_minmax,
 		.extra1		= &rds_iw_sysctl_max_wr_min,
 		.extra2		= &rds_iw_sysctl_max_wr_max,
 	},
@@ -70,7 +70,7 @@ ctl_table rds_iw_sysctl_table[] = {
 		.data		= &rds_iw_sysctl_max_recv_wr,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_doulongvec_minmax,
+		.proc_handler   = proc_doulongvec_minmax,
 		.extra1		= &rds_iw_sysctl_max_wr_min,
 		.extra2		= &rds_iw_sysctl_max_wr_max,
 	},
@@ -79,7 +79,7 @@ ctl_table rds_iw_sysctl_table[] = {
 		.data		= &rds_iw_sysctl_max_unsig_wrs,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_doulongvec_minmax,
+		.proc_handler   = proc_doulongvec_minmax,
 		.extra1		= &rds_iw_sysctl_max_unsig_wr_min,
 		.extra2		= &rds_iw_sysctl_max_unsig_wr_max,
 	},
@@ -88,7 +88,7 @@ ctl_table rds_iw_sysctl_table[] = {
 		.data		= &rds_iw_sysctl_max_unsig_bytes,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_doulongvec_minmax,
+		.proc_handler   = proc_doulongvec_minmax,
 		.extra1		= &rds_iw_sysctl_max_unsig_bytes_min,
 		.extra2		= &rds_iw_sysctl_max_unsig_bytes_max,
 	},
@@ -97,14 +97,14 @@ ctl_table rds_iw_sysctl_table[] = {
 		.data		= &rds_iw_sysctl_max_recv_allocation,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_doulongvec_minmax,
+		.proc_handler   = proc_doulongvec_minmax,
 	},
 	{
 		.procname	= "flow_control",
 		.data		= &rds_iw_sysctl_flow_control,
 		.maxlen		= sizeof(rds_iw_sysctl_flow_control),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ }
 };
diff --git a/net/rds/sysctl.c b/net/rds/sysctl.c
index 8fb499e..7829a20 100644
--- a/net/rds/sysctl.c
+++ b/net/rds/sysctl.c
@@ -55,7 +55,7 @@ static ctl_table rds_sysctl_rds_table[] = {
 		.data		= &rds_sysctl_reconnect_min_jiffies,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_doulongvec_ms_jiffies_minmax,
+		.proc_handler   = proc_doulongvec_ms_jiffies_minmax,
 		.extra1		= &rds_sysctl_reconnect_min,
 		.extra2		= &rds_sysctl_reconnect_max_jiffies,
 	},
@@ -64,7 +64,7 @@ static ctl_table rds_sysctl_rds_table[] = {
 		.data		= &rds_sysctl_reconnect_max_jiffies,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_doulongvec_ms_jiffies_minmax,
+		.proc_handler   = proc_doulongvec_ms_jiffies_minmax,
 		.extra1		= &rds_sysctl_reconnect_min_jiffies,
 		.extra2		= &rds_sysctl_reconnect_max,
 	},
@@ -73,21 +73,21 @@ static ctl_table rds_sysctl_rds_table[] = {
 		.data		= &rds_sysctl_max_unacked_packets,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
+		.proc_handler   = proc_dointvec,
 	},
 	{
 		.procname	= "max_unacked_bytes",
 		.data		= &rds_sysctl_max_unacked_bytes,
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
+		.proc_handler   = proc_dointvec,
 	},
 	{
 		.procname	= "ping_enable",
 		.data		= &rds_sysctl_ping_enable,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
+		.proc_handler   = proc_dointvec,
 	},
 	{ }
 };
diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index c4ece98..d50a042 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -237,7 +237,7 @@ static ctl_table sctp_table[] = {
 		.data		= &sctp_scope_policy,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &addr_scope_max,
 	},
diff --git a/net/sunrpc/sysctl.c b/net/sunrpc/sysctl.c
index f0ce326..e65dcc6 100644
--- a/net/sunrpc/sysctl.c
+++ b/net/sunrpc/sysctl.c
@@ -139,34 +139,34 @@ static ctl_table debug_table[] = {
 		.data		= &rpc_debug,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dodebug
+		.proc_handler	= proc_dodebug
 	},
 	{
 		.procname	= "nfs_debug",
 		.data		= &nfs_debug,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dodebug
+		.proc_handler	= proc_dodebug
 	},
 	{
 		.procname	= "nfsd_debug",
 		.data		= &nfsd_debug,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dodebug
+		.proc_handler	= proc_dodebug
 	},
 	{
 		.procname	= "nlm_debug",
 		.data		= &nlm_debug,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dodebug
+		.proc_handler	= proc_dodebug
 	},
 	{
 		.procname	= "transports",
 		.maxlen		= 256,
 		.mode		= 0444,
-		.proc_handler	= &proc_do_xprt,
+		.proc_handler	= proc_do_xprt,
 	},
 	{ }
 };
diff --git a/net/sunrpc/xprtrdma/svc_rdma.c b/net/sunrpc/xprtrdma/svc_rdma.c
index 678cee2..5b8a8ff 100644
--- a/net/sunrpc/xprtrdma/svc_rdma.c
+++ b/net/sunrpc/xprtrdma/svc_rdma.c
@@ -120,7 +120,7 @@ static ctl_table svcrdma_parm_table[] = {
 		.data		= &svcrdma_max_requests,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_max_requests,
 		.extra2		= &max_max_requests
 	},
@@ -129,7 +129,7 @@ static ctl_table svcrdma_parm_table[] = {
 		.data		= &svcrdma_max_req_size,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_max_inline,
 		.extra2		= &max_max_inline
 	},
@@ -138,7 +138,7 @@ static ctl_table svcrdma_parm_table[] = {
 		.data		= &svcrdma_ord,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_ord,
 		.extra2		= &max_ord,
 	},
@@ -148,63 +148,63 @@ static ctl_table svcrdma_parm_table[] = {
 		.data		= &rdma_stat_read,
 		.maxlen		= sizeof(atomic_t),
 		.mode		= 0644,
-		.proc_handler	= &read_reset_stat,
+		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_recv",
 		.data		= &rdma_stat_recv,
 		.maxlen		= sizeof(atomic_t),
 		.mode		= 0644,
-		.proc_handler	= &read_reset_stat,
+		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_write",
 		.data		= &rdma_stat_write,
 		.maxlen		= sizeof(atomic_t),
 		.mode		= 0644,
-		.proc_handler	= &read_reset_stat,
+		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_sq_starve",
 		.data		= &rdma_stat_sq_starve,
 		.maxlen		= sizeof(atomic_t),
 		.mode		= 0644,
-		.proc_handler	= &read_reset_stat,
+		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_rq_starve",
 		.data		= &rdma_stat_rq_starve,
 		.maxlen		= sizeof(atomic_t),
 		.mode		= 0644,
-		.proc_handler	= &read_reset_stat,
+		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_rq_poll",
 		.data		= &rdma_stat_rq_poll,
 		.maxlen		= sizeof(atomic_t),
 		.mode		= 0644,
-		.proc_handler	= &read_reset_stat,
+		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_rq_prod",
 		.data		= &rdma_stat_rq_prod,
 		.maxlen		= sizeof(atomic_t),
 		.mode		= 0644,
-		.proc_handler	= &read_reset_stat,
+		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_sq_poll",
 		.data		= &rdma_stat_sq_poll,
 		.maxlen		= sizeof(atomic_t),
 		.mode		= 0644,
-		.proc_handler	= &read_reset_stat,
+		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_sq_prod",
 		.data		= &rdma_stat_sq_prod,
 		.maxlen		= sizeof(atomic_t),
 		.mode		= 0644,
-		.proc_handler	= &read_reset_stat,
+		.proc_handler	= read_reset_stat,
 	},
 	{ },
 };
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 4768160..7018eef 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -90,7 +90,7 @@ static ctl_table xr_tunables_table[] = {
 		.data		= &xprt_rdma_slot_table_entries,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_slot_table_size,
 		.extra2		= &max_slot_table_size
 	},
@@ -99,21 +99,21 @@ static ctl_table xr_tunables_table[] = {
 		.data		= &xprt_rdma_max_inline_read,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "rdma_max_inline_write",
 		.data		= &xprt_rdma_max_inline_write,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "rdma_inline_write_padding",
 		.data		= &xprt_rdma_inline_write_padding,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &max_padding,
 	},
@@ -122,7 +122,7 @@ static ctl_table xr_tunables_table[] = {
 		.data		= &xprt_rdma_memreg_strategy,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_memreg,
 		.extra2		= &max_memreg,
 	},
@@ -131,7 +131,7 @@ static ctl_table xr_tunables_table[] = {
 		.data		= &xprt_rdma_pad_optimize,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ },
 };
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 8b9a207..04732d0 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -85,7 +85,7 @@ static ctl_table xs_tunables_table[] = {
 		.data		= &xprt_udp_slot_table_entries,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_slot_table_size,
 		.extra2		= &max_slot_table_size
 	},
@@ -94,7 +94,7 @@ static ctl_table xs_tunables_table[] = {
 		.data		= &xprt_tcp_slot_table_entries,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_slot_table_size,
 		.extra2		= &max_slot_table_size
 	},
@@ -103,7 +103,7 @@ static ctl_table xs_tunables_table[] = {
 		.data		= &xprt_min_resvport,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xprt_min_resvport_limit,
 		.extra2		= &xprt_max_resvport_limit
 	},
@@ -112,7 +112,7 @@ static ctl_table xs_tunables_table[] = {
 		.data		= &xprt_max_resvport,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &xprt_min_resvport_limit,
 		.extra2		= &xprt_max_resvport_limit
 	},
@@ -121,7 +121,7 @@ static ctl_table xs_tunables_table[] = {
 		.data		= &xs_tcp_fin_timeout,
 		.maxlen		= sizeof(xs_tcp_fin_timeout),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
+		.proc_handler	= proc_dointvec_jiffies,
 	},
 	{ },
 };
diff --git a/security/keys/sysctl.c b/security/keys/sysctl.c
index 3565e2f..ee32d18 100644
--- a/security/keys/sysctl.c
+++ b/security/keys/sysctl.c
@@ -21,7 +21,7 @@ ctl_table key_sysctls[] = {
 		.data = &key_quota_maxkeys,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec_minmax,
+		.proc_handler = proc_dointvec_minmax,
 		.extra1 = (void *) &one,
 		.extra2 = (void *) &max,
 	},
@@ -30,7 +30,7 @@ ctl_table key_sysctls[] = {
 		.data = &key_quota_maxbytes,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec_minmax,
+		.proc_handler = proc_dointvec_minmax,
 		.extra1 = (void *) &one,
 		.extra2 = (void *) &max,
 	},
@@ -39,7 +39,7 @@ ctl_table key_sysctls[] = {
 		.data = &key_quota_root_maxkeys,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec_minmax,
+		.proc_handler = proc_dointvec_minmax,
 		.extra1 = (void *) &one,
 		.extra2 = (void *) &max,
 	},
@@ -48,7 +48,7 @@ ctl_table key_sysctls[] = {
 		.data = &key_quota_root_maxbytes,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec_minmax,
+		.proc_handler = proc_dointvec_minmax,
 		.extra1 = (void *) &one,
 		.extra2 = (void *) &max,
 	},
@@ -57,7 +57,7 @@ ctl_table key_sysctls[] = {
 		.data = &key_gc_delay,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec_minmax,
+		.proc_handler = proc_dointvec_minmax,
 		.extra1 = (void *) &zero,
 		.extra2 = (void *) &max,
 	},
-- 
1.6.5.2.143.g8cc62

