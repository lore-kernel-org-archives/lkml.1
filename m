Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbZBGW6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbZBGW6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 17:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753489AbZBGW6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 17:58:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:25635 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbZBGW60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 17:58:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=GzfaR2hb0nsMUrs2s2XbadLNXIf0BgCbNzrXPjdDlHhUkukpyZZMeqjhjNScoOaIsG
         H/PcEu0PvelRZPtQosPAz/kw039Y3Q9Qgpv+mBRc95HsMHb1phIvOKXYT/YjckmHPSUb
         3sb0Ssh23Dc03i99yn6BRkgef0GG5BQRuFzz8=
Date: Sun, 8 Feb 2009 02:04:26 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] sysctl: '&' redux
Message-ID: <20090207230426.GA4067@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove '&' in front of sysctl handlers. They aren't needed, they prevent
definining them to NULL depending on config option
(PROC_SYSCTL or SYSCTL_SYSCALL).

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/arm/kernel/isa.c              |    6 
 arch/frv/kernel/pm.c               |   14 -
 arch/frv/kernel/sysctl.c           |    4 
 arch/ia64/kernel/crash.c           |    4 
 arch/ia64/kernel/perfmon.c         |    8 
 arch/mips/lasat/sysctl.c           |   44 ++---
 arch/powerpc/kernel/idle.c         |    2 
 arch/s390/appldata/appldata_base.c |    4 
 arch/s390/kernel/debug.c           |    8 
 arch/s390/mm/cmm.c                 |    6 
 arch/sh/kernel/traps_64.c          |    6 
 crypto/proc.c                      |    2 
 drivers/cdrom/cdrom.c              |   12 -
 drivers/char/hpet.c                |    2 
 drivers/char/ipmi/ipmi_poweroff.c  |    2 
 drivers/char/pty.c                 |    6 
 drivers/char/random.c              |   20 +-
 drivers/char/rtc.c                 |    2 
 drivers/macintosh/mac_hid.c        |    6 
 drivers/md/md.c                    |    4 
 drivers/misc/sgi-xp/xpc_main.c     |   12 -
 drivers/net/wireless/arlan-proc.c  |   64 +++----
 drivers/parport/procfs.c           |   28 +--
 drivers/scsi/scsi_sysctl.c         |    2 
 fs/coda/sysctl.c                   |    6 
 fs/dquot.c                         |   18 +-
 fs/eventpoll.c                     |    2 
 fs/lockd/svc.c                     |   12 -
 fs/nfs/sysctl.c                    |   12 -
 fs/notify/inotify/inotify_user.c   |   12 -
 fs/ntfs/sysctl.c                   |    2 
 fs/ocfs2/stackglue.c               |    4 
 fs/xfs/linux-2.6/xfs_sysctl.c      |   60 +++---
 ipc/mqueue.c                       |    6 
 kernel/sysctl.c                    |  318 ++++++++++++++++++-------------------
 net/sunrpc/sysctl.c                |   10 -
 net/sunrpc/xprtrdma/svc_rdma.c     |   30 +--
 net/sunrpc/xprtrdma/transport.c    |   22 +-
 net/sunrpc/xprtsock.c              |   16 -
 security/keys/sysctl.c             |    8 
 40 files changed, 403 insertions(+), 403 deletions(-)

--- a/arch/arm/kernel/isa.c
+++ b/arch/arm/kernel/isa.c
@@ -27,21 +27,21 @@ static ctl_table ctl_isa_vars[4] = {
 		.data		= &isa_membase, 
 		.maxlen		= sizeof(isa_membase),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	}, {
 		.ctl_name	= BUS_ISA_PORT_BASE,
 		.procname	= "portbase",
 		.data		= &isa_portbase, 
 		.maxlen		= sizeof(isa_portbase),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	}, {
 		.ctl_name	= BUS_ISA_PORT_SHIFT,
 		.procname	= "portshift",
 		.data		= &isa_portshift, 
 		.maxlen		= sizeof(isa_portshift),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	}, {0}
 };
 
--- a/arch/frv/kernel/pm.c
+++ b/arch/frv/kernel/pm.c
@@ -398,7 +398,7 @@ static struct ctl_table pm_table[] =
 		.data		= NULL,
 		.maxlen		= 0,
 		.mode		= 0200,
-		.proc_handler	= &sysctl_pm_do_suspend,
+		.proc_handler	= sysctl_pm_do_suspend,
 	},
 	{
 		.ctl_name	= CTL_PM_CMODE,
@@ -406,8 +406,8 @@ static struct ctl_table pm_table[] =
 		.data		= &clock_cmode_current,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &cmode_procctl,
-		.strategy	= &cmode_sysctl,
+		.proc_handler	= cmode_procctl,
+		.strategy	= cmode_sysctl,
 	},
 	{
 		.ctl_name	= CTL_PM_P0,
@@ -415,8 +415,8 @@ static struct ctl_table pm_table[] =
 		.data		= &clock_p0_current,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &p0_procctl,
-		.strategy	= &p0_sysctl,
+		.proc_handler	= p0_procctl,
+		.strategy	= p0_sysctl,
 	},
 	{
 		.ctl_name	= CTL_PM_CM,
@@ -424,8 +424,8 @@ static struct ctl_table pm_table[] =
 		.data		= &clock_cm_current,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &cm_procctl,
-		.strategy	= &cm_sysctl,
+		.proc_handler	= cm_procctl,
+		.strategy	= cm_sysctl,
 	},
 	{ .ctl_name = 0}
 };
--- a/arch/frv/kernel/sysctl.c
+++ b/arch/frv/kernel/sysctl.c
@@ -181,7 +181,7 @@ static struct ctl_table frv_table[] =
 		.data		= NULL,
 		.maxlen		= 0,
 		.mode		= 0644,
-		.proc_handler	= &procctl_frv_cachemode,
+		.proc_handler	= procctl_frv_cachemode,
 	},
 #ifdef CONFIG_MMU
 	{
@@ -190,7 +190,7 @@ static struct ctl_table frv_table[] =
 		.data		= NULL,
 		.maxlen		= 0,
 		.mode		= 0644,
-		.proc_handler	= &procctl_frv_pin_cxnr
+		.proc_handler	= procctl_frv_pin_cxnr
 	},
 #endif
 	{}
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -213,7 +213,7 @@ static ctl_table kdump_ctl_table[] = {
 		.data = &kdump_on_init,
 		.maxlen = sizeof(int),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec,
+		.proc_handler = proc_dointvec,
 	},
 	{
 		.ctl_name = CTL_UNNUMBERED,
@@ -221,7 +221,7 @@ static ctl_table kdump_ctl_table[] = {
 		.data = &kdump_on_fatal_mca,
 		.maxlen = sizeof(int),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec,
+		.proc_handler = proc_dointvec,
 	},
 	{ .ctl_name = 0 }
 };
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -527,7 +527,7 @@ static ctl_table pfm_ctl_table[]={
 		.data		= &pfm_sysctl.debug,
 		.maxlen		= sizeof(int),
 		.mode		= 0666,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -535,7 +535,7 @@ static ctl_table pfm_ctl_table[]={
 		.data		= &pfm_sysctl.debug_ovfl,
 		.maxlen		= sizeof(int),
 		.mode		= 0666,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -543,7 +543,7 @@ static ctl_table pfm_ctl_table[]={
 		.data		= &pfm_sysctl.fastctxsw,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	=  &proc_dointvec,
+		.proc_handler	=  proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -551,7 +551,7 @@ static ctl_table pfm_ctl_table[]={
 		.data		= &pfm_sysctl.expert_mode,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{}
 };
--- a/arch/mips/lasat/sysctl.c
+++ b/arch/mips/lasat/sysctl.c
@@ -253,8 +253,8 @@ static ctl_table lasat_table[] = {
 		.data		= &lasat_board_info.li_cpu_hz,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec
+		.proc_handler	= proc_dointvec,
+		.strategy	= sysctl_intvec
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -262,8 +262,8 @@ static ctl_table lasat_table[] = {
 		.data		= &lasat_board_info.li_bus_hz,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec
+		.proc_handler	= proc_dointvec,
+		.strategy	= sysctl_intvec
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -271,8 +271,8 @@ static ctl_table lasat_table[] = {
 		.data		= &lasat_board_info.li_bmid,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec
+		.proc_handler	= proc_dointvec,
+		.strategy	= sysctl_intvec
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -280,8 +280,8 @@ static ctl_table lasat_table[] = {
 		.data		= &lasat_board_info.li_prid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_lasat_prid,
-		.strategy	= &sysctl_lasat_prid
+		.proc_handler	= proc_lasat_prid,
+		.strategy	= sysctl_lasat_prid
 	},
 #ifdef CONFIG_INET
 	{
@@ -290,8 +290,8 @@ static ctl_table lasat_table[] = {
 		.data		= &lasat_board_info.li_eeprom_info.ipaddr,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_lasat_ip,
-		.strategy	= &sysctl_lasat_intvec
+		.proc_handler	= proc_lasat_ip,
+		.strategy	= sysctl_lasat_intvec
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -299,8 +299,8 @@ static ctl_table lasat_table[] = {
 		.data		= &lasat_board_info.li_eeprom_info.netmask,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_lasat_ip,
-		.strategy	= &sysctl_lasat_intvec
+		.proc_handler	= proc_lasat_ip,
+		.strategy	= sysctl_lasat_intvec
 	},
 #endif
 	{
@@ -310,8 +310,8 @@ static ctl_table lasat_table[] = {
 		.maxlen		=
 			sizeof(lasat_board_info.li_eeprom_info.passwd_hash),
 		.mode		= 0600,
-		.proc_handler	= &proc_dolasatstring,
-		.strategy	= &sysctl_lasatstring
+		.proc_handler	= proc_dolasatstring,
+		.strategy	= sysctl_lasatstring
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -319,8 +319,8 @@ static ctl_table lasat_table[] = {
 		.data		= &lasat_boot_to_service,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec
+		.proc_handler	= proc_dointvec,
+		.strategy	= sysctl_intvec
 	},
 #ifdef CONFIG_DS1603
 	{
@@ -329,8 +329,8 @@ static ctl_table lasat_table[] = {
 		.data		= &rtctmp,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dolasatrtc,
-		.strategy	= &sysctl_lasat_rtc
+		.proc_handler	= proc_dolasatrtc,
+		.strategy	= sysctl_lasat_rtc
 	},
 #endif
 	{
@@ -339,8 +339,8 @@ static ctl_table lasat_table[] = {
 		.data		= &lasat_board_info.li_namestr,
 		.maxlen		= sizeof(lasat_board_info.li_namestr),
 		.mode		= 0444,
-		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string
+		.proc_handler	= proc_dostring,
+		.strategy	= sysctl_string
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -348,8 +348,8 @@ static ctl_table lasat_table[] = {
 		.data		= &lasat_board_info.li_typestr,
 		.maxlen		= sizeof(lasat_board_info.li_typestr),
 		.mode		= 0444,
-		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string
+		.proc_handler	= proc_dostring,
+		.strategy	= sysctl_string
 	},
 	{}
 };
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -115,7 +115,7 @@ static ctl_table powersave_nap_ctl_table[]={
 		.data		= &powersave_nap,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{}
 };
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -57,12 +57,12 @@ static struct ctl_table appldata_table[] = {
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
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -902,8 +902,8 @@ static struct ctl_table s390dbf_table[] = {
 		.data		= &debug_stoppable,
 		.maxlen		= sizeof(int),
 		.mode           = S_IRUGO | S_IWUSR,
-		.proc_handler   = &proc_dointvec,
-		.strategy	= &sysctl_intvec,
+		.proc_handler   = proc_dointvec,
+		.strategy	= sysctl_intvec,
 	},
 	 {
 		.ctl_name       = CTL_S390DBF_ACTIVE,
@@ -911,8 +911,8 @@ static struct ctl_table s390dbf_table[] = {
 		.data		= &debug_active,
 		.maxlen		= sizeof(int),
 		.mode           = S_IRUGO | S_IWUSR,
-		.proc_handler   = &s390dbf_procactive,
-		.strategy	= &sysctl_intvec,
+		.proc_handler   = s390dbf_procactive,
+		.strategy	= sysctl_intvec,
 	},
 	{ .ctl_name = 0 }
 };
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
 	{ .ctl_name = 0 }
 };
--- a/arch/sh/kernel/traps_64.c
+++ b/arch/sh/kernel/traps_64.c
@@ -905,7 +905,7 @@ static ctl_table unaligned_table[] = {
 		.data		= &kernel_mode_unaligned_fixup_count,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 #if defined(CONFIG_SH64_USER_MISALIGNED_FIXUP)
 	{
@@ -914,7 +914,7 @@ static ctl_table unaligned_table[] = {
 		.data		= &user_mode_unaligned_fixup_count,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -922,7 +922,7 @@ static ctl_table unaligned_table[] = {
 		.data		= &user_mode_unaligned_fixup_enable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec},
+		.proc_handler	= proc_dointvec},
 #endif
 	{}
 };
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -30,7 +30,7 @@ static struct ctl_table crypto_sysctl_table[] = {
 		.data           = &fips_enabled,
 		.maxlen         = sizeof(int),
 		.mode           = 0444,
-		.proc_handler   = &proc_dointvec
+		.proc_handler   = proc_dointvec
 	},
 	{
 		.ctl_name = 0,
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
 	{ .ctl_name = 0 }
 };
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -677,7 +677,7 @@ static ctl_table hpet_table[] = {
 	 .data = &hpet_max_freq,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
-	 .proc_handler = &proc_dointvec,
+	 .proc_handler = proc_dointvec,
 	 },
 	{.ctl_name = 0}
 };
--- a/drivers/char/ipmi/ipmi_poweroff.c
+++ b/drivers/char/ipmi/ipmi_poweroff.c
@@ -665,7 +665,7 @@ static ctl_table ipmi_table[] = {
 	  .data		= &poweroff_powercycle,
 	  .maxlen	= sizeof(poweroff_powercycle),
 	  .mode		= 0644,
-	  .proc_handler	= &proc_dointvec },
+	  .proc_handler	= proc_dointvec },
 	{ }
 };
 
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -443,8 +443,8 @@ static struct ctl_table pty_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.data		= &pty_limit,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &pty_limit_min,
 		.extra2		= &pty_limit_max,
 	}, {
@@ -453,7 +453,7 @@ static struct ctl_table pty_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.data		= &pty_count,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	}, {
 		.ctl_name	= 0
 	}
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1277,14 +1277,14 @@ ctl_table random_table[] = {
 		.data		= &sysctl_poolsize,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= RANDOM_ENTROPY_COUNT,
 		.procname	= "entropy_avail",
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 		.data		= &input_pool.entropy_count,
 	},
 	{
@@ -1293,8 +1293,8 @@ ctl_table random_table[] = {
 		.data		= &random_read_wakeup_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_read_thresh,
 		.extra2		= &max_read_thresh,
 	},
@@ -1304,8 +1304,8 @@ ctl_table random_table[] = {
 		.data		= &random_write_wakeup_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_write_thresh,
 		.extra2		= &max_write_thresh,
 	},
@@ -1315,16 +1315,16 @@ ctl_table random_table[] = {
 		.data		= &sysctl_bootid,
 		.maxlen		= 16,
 		.mode		= 0444,
-		.proc_handler	= &proc_do_uuid,
-		.strategy	= &uuid_strategy,
+		.proc_handler	= proc_do_uuid,
+		.strategy	= uuid_strategy,
 	},
 	{
 		.ctl_name	= RANDOM_UUID,
 		.procname	= "uuid",
 		.maxlen		= 16,
 		.mode		= 0444,
-		.proc_handler	= &proc_do_uuid,
-		.strategy	= &uuid_strategy,
+		.proc_handler	= proc_do_uuid,
+		.strategy	= uuid_strategy,
 	},
 	{ .ctl_name = 0 }
 };
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -286,7 +286,7 @@ static ctl_table rtc_table[] = {
 		.data		= &rtc_max_user_freq,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ .ctl_name = 0 }
 };
--- a/drivers/macintosh/mac_hid.c
+++ b/drivers/macintosh/mac_hid.c
@@ -32,7 +32,7 @@ static ctl_table mac_hid_files[] = {
 		.data		= &mouse_emulate_buttons,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= DEV_MAC_HID_MOUSE_BUTTON2_KEYCODE,
@@ -40,7 +40,7 @@ static ctl_table mac_hid_files[] = {
 		.data		= &mouse_button2_keycode,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= DEV_MAC_HID_MOUSE_BUTTON3_KEYCODE,
@@ -48,7 +48,7 @@ static ctl_table mac_hid_files[] = {
 		.data		= &mouse_button3_keycode,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ .ctl_name = 0 }
 };
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -104,7 +104,7 @@ static ctl_table raid_table[] = {
 		.data		= &sysctl_speed_limit_min,
 		.maxlen		= sizeof(int),
 		.mode		= S_IRUGO|S_IWUSR,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= DEV_RAID_SPEED_LIMIT_MAX,
@@ -112,7 +112,7 @@ static ctl_table raid_table[] = {
 		.data		= &sysctl_speed_limit_max,
 		.maxlen		= sizeof(int),
 		.mode		= S_IRUGO|S_IWUSR,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ .ctl_name = 0 }
 };
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -94,8 +94,8 @@ static ctl_table xpc_sys_xpc_hb_dir[] = {
 	 .data = &xpc_hb_interval,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
-	 .proc_handler = &proc_dointvec_minmax,
-	 .strategy = &sysctl_intvec,
+	 .proc_handler = proc_dointvec_minmax,
+	 .strategy = sysctl_intvec,
 	 .extra1 = &xpc_hb_min_interval,
 	 .extra2 = &xpc_hb_max_interval},
 	{
@@ -104,8 +104,8 @@ static ctl_table xpc_sys_xpc_hb_dir[] = {
 	 .data = &xpc_hb_check_interval,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
-	 .proc_handler = &proc_dointvec_minmax,
-	 .strategy = &sysctl_intvec,
+	 .proc_handler = proc_dointvec_minmax,
+	 .strategy = sysctl_intvec,
 	 .extra1 = &xpc_hb_check_min_interval,
 	 .extra2 = &xpc_hb_check_max_interval},
 	{}
@@ -122,8 +122,8 @@ static ctl_table xpc_sys_xpc_dir[] = {
 	 .data = &xpc_disengage_timelimit,
 	 .maxlen = sizeof(int),
 	 .mode = 0644,
-	 .proc_handler = &proc_dointvec_minmax,
-	 .strategy = &sysctl_intvec,
+	 .proc_handler = proc_dointvec_minmax,
+	 .strategy = sysctl_intvec,
 	 .extra1 = &xpc_disengage_min_timelimit,
 	 .extra2 = &xpc_disengage_max_timelimit},
 	{}
--- a/drivers/net/wireless/arlan-proc.c
+++ b/drivers/net/wireless/arlan-proc.c
@@ -820,15 +820,15 @@ static int arlan_sysctl_reset(ctl_table * ctl, int write, struct file *filp,
         { .ctl_name = num,\
           .procname = #nam,\
           .data = &(arlan_conf[card].nam),\
-          .maxlen = sizeof(int), .mode = 0600, .proc_handler = &proc_dointvec}
+          .maxlen = sizeof(int), .mode = 0600, .proc_handler = proc_dointvec}
 #ifdef ARLAN_DEBUGGING
 
 #define ARLAN_PROC_DEBUG_ENTRIES \
         { .ctl_name = 48, .procname = "entry_exit_debug",\
           .data = &arlan_entry_and_exit_debug,\
-          .maxlen = sizeof(int), .mode = 0600, .proc_handler = &proc_dointvec},\
+          .maxlen = sizeof(int), .mode = 0600, .proc_handler = proc_dointvec},\
 	{ .ctl_name = 49, .procname = "debug", .data = &arlan_debug,\
-          .maxlen = sizeof(int), .mode = 0600, .proc_handler = &proc_dointvec},
+          .maxlen = sizeof(int), .mode = 0600, .proc_handler = proc_dointvec},
 #else 
 #define ARLAN_PROC_DEBUG_ENTRIES
 #endif
@@ -865,7 +865,7 @@ static int arlan_sysctl_reset(ctl_table * ctl, int write, struct file *filp,
 	CTBLN(29,cardNo, channelSet), \
 	{.ctl_name = 30, .procname = "name",\
 	 .data = arlan_conf[cardNo].siteName,\
-	 .maxlen = 16, .mode = 0600, .proc_handler = &proc_dostring},\
+	 .maxlen = 16, .mode = 0600, .proc_handler = proc_dostring},\
 	CTBLN(31,cardNo,waitTime),\
 	CTBLN(32,cardNo,lParameter),\
 	CTBLN(33,cardNo,_15),\
@@ -908,7 +908,7 @@ static ctl_table arlan_conf_table0[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_infotxRing,
+		.proc_handler	= arlan_sysctl_infotxRing,
 	},
 	{
 		.ctl_name	= 151,
@@ -916,7 +916,7 @@ static ctl_table arlan_conf_table0[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_inforxRing,
+		.proc_handler	= arlan_sysctl_inforxRing,
 	},
 	{
 		.ctl_name	= 152,
@@ -924,7 +924,7 @@ static ctl_table arlan_conf_table0[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info18,
+		.proc_handler	= arlan_sysctl_info18,
 	},
 	{
 		.ctl_name	= 153,
@@ -932,7 +932,7 @@ static ctl_table arlan_conf_table0[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info161719,
+		.proc_handler	= arlan_sysctl_info161719,
 	},
 	{
 		.ctl_name	= 154,
@@ -940,7 +940,7 @@ static ctl_table arlan_conf_table0[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info,
+		.proc_handler	= arlan_sysctl_info,
 	},
 #endif
 	{
@@ -949,7 +949,7 @@ static ctl_table arlan_conf_table0[] =
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_configure
+		.proc_handler	= arlan_configure
 	},
 	{
 		.ctl_name	= 156,
@@ -957,7 +957,7 @@ static ctl_table arlan_conf_table0[] =
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_reset,
+		.proc_handler	= arlan_sysctl_reset,
 	},
 	{ .ctl_name = 0 }
 };
@@ -974,7 +974,7 @@ static ctl_table arlan_conf_table1[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_infotxRing,
+		.proc_handler	= arlan_sysctl_infotxRing,
 	},
 	{
 		.ctl_name	= 151,
@@ -982,7 +982,7 @@ static ctl_table arlan_conf_table1[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_inforxRing,
+		.proc_handler	= arlan_sysctl_inforxRing,
 	},
 	{
 		.ctl_name	= 152,
@@ -990,7 +990,7 @@ static ctl_table arlan_conf_table1[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info18,
+		.proc_handler	= arlan_sysctl_info18,
 	},
 	{
 		.ctl_name	= 153,
@@ -998,7 +998,7 @@ static ctl_table arlan_conf_table1[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info161719,
+		.proc_handler	= arlan_sysctl_info161719,
 	},
 	{
 		.ctl_name	= 154,
@@ -1006,7 +1006,7 @@ static ctl_table arlan_conf_table1[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info,
+		.proc_handler	= arlan_sysctl_info,
 	},
 #endif
 	{
@@ -1015,7 +1015,7 @@ static ctl_table arlan_conf_table1[] =
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_configure,
+		.proc_handler	= arlan_configure,
 	},
 	{
 		.ctl_name	= 156,
@@ -1023,7 +1023,7 @@ static ctl_table arlan_conf_table1[] =
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_reset,
+		.proc_handler	= arlan_sysctl_reset,
 	},
 	{ .ctl_name = 0 }
 };
@@ -1040,7 +1040,7 @@ static ctl_table arlan_conf_table2[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_infotxRing,
+		.proc_handler	= arlan_sysctl_infotxRing,
 	},
 	{
 		.ctl_name	= 151,
@@ -1048,7 +1048,7 @@ static ctl_table arlan_conf_table2[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_inforxRing,
+		.proc_handler	= arlan_sysctl_inforxRing,
 	},
 	{
 		.ctl_name	= 152,
@@ -1056,7 +1056,7 @@ static ctl_table arlan_conf_table2[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info18,
+		.proc_handler	= arlan_sysctl_info18,
 	},
 	{
 		.ctl_name	= 153,
@@ -1064,7 +1064,7 @@ static ctl_table arlan_conf_table2[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info161719,
+		.proc_handler	= arlan_sysctl_info161719,
 	},
 	{
 		.ctl_name	= 154,
@@ -1072,7 +1072,7 @@ static ctl_table arlan_conf_table2[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info,
+		.proc_handler	= arlan_sysctl_info,
 	},
 #endif
 	{
@@ -1081,7 +1081,7 @@ static ctl_table arlan_conf_table2[] =
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_configure,
+		.proc_handler	= arlan_configure,
 	},
 	{
 		.ctl_name	= 156,
@@ -1089,7 +1089,7 @@ static ctl_table arlan_conf_table2[] =
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_reset,
+		.proc_handler	= arlan_sysctl_reset,
 	},
 	{ .ctl_name = 0 }
 };
@@ -1106,7 +1106,7 @@ static ctl_table arlan_conf_table3[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_infotxRing,
+		.proc_handler	= arlan_sysctl_infotxRing,
 	},
 	{
 		.ctl_name	= 151,
@@ -1114,7 +1114,7 @@ static ctl_table arlan_conf_table3[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_inforxRing,
+		.proc_handler	= arlan_sysctl_inforxRing,
 	},
 	{
 		.ctl_name	= 152,
@@ -1122,7 +1122,7 @@ static ctl_table arlan_conf_table3[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info18,
+		.proc_handler	= arlan_sysctl_info18,
 	},
 	{
 		.ctl_name	= 153,
@@ -1130,7 +1130,7 @@ static ctl_table arlan_conf_table3[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info161719,
+		.proc_handler	= arlan_sysctl_info161719,
 	},
 	{
 		.ctl_name	= 154,
@@ -1138,7 +1138,7 @@ static ctl_table arlan_conf_table3[] =
 		.data		= &arlan_drive_info,
 		.maxlen		= ARLAN_STR_SIZE,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_info,
+		.proc_handler	= arlan_sysctl_info,
 	},
 #endif
 	{
@@ -1147,7 +1147,7 @@ static ctl_table arlan_conf_table3[] =
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_configure,
+		.proc_handler	= arlan_configure,
 	},
 	{
 		.ctl_name	= 156,
@@ -1155,7 +1155,7 @@ static ctl_table arlan_conf_table3[] =
 		.data		= &conf_reset_result,
 		.maxlen		= 100,
 		.mode		= 0400,
-		.proc_handler	= &arlan_sysctl_reset,
+		.proc_handler	= arlan_sysctl_reset,
 	},
 	{ .ctl_name = 0 }
 };
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
+			.proc_handler	=  do_autoprobe
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
@@ -438,7 +438,7 @@ parport_default_sysctl_table = {
 			.data		= &parport_default_timeslice,
 			.maxlen		= sizeof(parport_default_timeslice),
 			.mode		= 0644,
-			.proc_handler	= &proc_doulongvec_ms_jiffies_minmax,
+			.proc_handler	= proc_doulongvec_ms_jiffies_minmax,
 			.extra1		= (void*) &parport_min_timeslice_value,
 			.extra2		= (void*) &parport_max_timeslice_value
 		},
@@ -447,7 +447,7 @@ parport_default_sysctl_table = {
 			.data		= &parport_default_spintime,
 			.maxlen		= sizeof(parport_default_spintime),
 			.mode		= 0644,
-			.proc_handler	= &proc_dointvec_minmax,
+			.proc_handler	= proc_dointvec_minmax,
 			.extra1		= (void*) &parport_min_spintime_value,
 			.extra2		= (void*) &parport_max_spintime_value
 		},
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -18,7 +18,7 @@ static ctl_table scsi_table[] = {
 	  .data		= &scsi_logging_level,
 	  .maxlen	= sizeof(scsi_logging_level),
 	  .mode		= 0644,
-	  .proc_handler	= &proc_dointvec },
+	  .proc_handler	= proc_dointvec },
 	{ }
 };
 
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -22,7 +22,7 @@ static ctl_table coda_table[] = {
 		.data		= &coda_timeout,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -30,7 +30,7 @@ static ctl_table coda_table[] = {
 		.data		= &coda_hard,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -38,7 +38,7 @@ static ctl_table coda_table[] = {
 		.data		= &coda_fake_statfs,
 		.maxlen		= sizeof(int),
 		.mode		= 0600,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 	{}
 };
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -2237,7 +2237,7 @@ static ctl_table fs_dqstats_table[] = {
 		.data		= &dqstats.lookups,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= FS_DQ_DROPS,
@@ -2245,7 +2245,7 @@ static ctl_table fs_dqstats_table[] = {
 		.data		= &dqstats.drops,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= FS_DQ_READS,
@@ -2253,7 +2253,7 @@ static ctl_table fs_dqstats_table[] = {
 		.data		= &dqstats.reads,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= FS_DQ_WRITES,
@@ -2261,7 +2261,7 @@ static ctl_table fs_dqstats_table[] = {
 		.data		= &dqstats.writes,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= FS_DQ_CACHE_HITS,
@@ -2269,7 +2269,7 @@ static ctl_table fs_dqstats_table[] = {
 		.data		= &dqstats.cache_hits,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= FS_DQ_ALLOCATED,
@@ -2277,7 +2277,7 @@ static ctl_table fs_dqstats_table[] = {
 		.data		= &dqstats.allocated_dquots,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= FS_DQ_FREE,
@@ -2285,7 +2285,7 @@ static ctl_table fs_dqstats_table[] = {
 		.data		= &dqstats.free_dquots,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= FS_DQ_SYNCS,
@@ -2293,7 +2293,7 @@ static ctl_table fs_dqstats_table[] = {
 		.data		= &dqstats.syncs,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #ifdef CONFIG_PRINT_QUOTA_WARNING
 	{
@@ -2302,7 +2302,7 @@ static ctl_table fs_dqstats_table[] = {
 		.data		= &flag_print_warnings,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{ .ctl_name = 0 },
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -263,7 +263,7 @@ ctl_table epoll_table[] = {
 		.data		= &max_user_watches,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 	},
 	{ .ctl_name = 0 }
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -367,7 +367,7 @@ static ctl_table nlm_sysctls[] = {
 		.data		= &nlm_grace_period,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 		.extra1		= (unsigned long *) &nlm_grace_period_min,
 		.extra2		= (unsigned long *) &nlm_grace_period_max,
 	},
@@ -377,7 +377,7 @@ static ctl_table nlm_sysctls[] = {
 		.data		= &nlm_timeout,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 		.extra1		= (unsigned long *) &nlm_timeout_min,
 		.extra2		= (unsigned long *) &nlm_timeout_max,
 	},
@@ -387,7 +387,7 @@ static ctl_table nlm_sysctls[] = {
 		.data		= &nlm_udpport,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= (int *) &nlm_port_min,
 		.extra2		= (int *) &nlm_port_max,
 	},
@@ -397,7 +397,7 @@ static ctl_table nlm_sysctls[] = {
 		.data		= &nlm_tcpport,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= (int *) &nlm_port_min,
 		.extra2		= (int *) &nlm_port_max,
 	},
@@ -407,7 +407,7 @@ static ctl_table nlm_sysctls[] = {
 		.data		= &nsm_use_hostnames,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -415,7 +415,7 @@ static ctl_table nlm_sysctls[] = {
 		.data		= &nsm_local_state,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ .ctl_name = 0 }
 };
--- a/fs/nfs/sysctl.c
+++ b/fs/nfs/sysctl.c
@@ -27,7 +27,7 @@ static ctl_table nfs_cb_sysctls[] = {
 		.data = &nfs_callback_set_tcpport,
 		.maxlen = sizeof(int),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec_minmax,
+		.proc_handler = proc_dointvec_minmax,
 		.extra1 = (int *)&nfs_set_port_min,
 		.extra2 = (int *)&nfs_set_port_max,
 	},
@@ -37,8 +37,8 @@ static ctl_table nfs_cb_sysctls[] = {
 		.data = &nfs_idmap_cache_timeout,
 		.maxlen = sizeof(int),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec_jiffies,
-		.strategy = &sysctl_jiffies,
+		.proc_handler = proc_dointvec_jiffies,
+		.strategy = sysctl_jiffies,
 	},
 #endif
 	{
@@ -47,8 +47,8 @@ static ctl_table nfs_cb_sysctls[] = {
 		.data		= &nfs_mountpoint_expiry_timeout,
 		.maxlen		= sizeof(nfs_mountpoint_expiry_timeout),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-		.strategy	= &sysctl_jiffies,
+		.proc_handler	= proc_dointvec_jiffies,
+		.strategy	= sysctl_jiffies,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -56,7 +56,7 @@ static ctl_table nfs_cb_sysctls[] = {
 		.data		= &nfs_congestion_kb,
 		.maxlen		= sizeof(nfs_congestion_kb),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{ .ctl_name = 0 }
 };
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -121,8 +121,8 @@ ctl_table inotify_table[] = {
 		.data		= &inotify_max_user_instances,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
@@ -131,8 +131,8 @@ ctl_table inotify_table[] = {
 		.data		= &inotify_max_user_watches,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
@@ -141,8 +141,8 @@ ctl_table inotify_table[] = {
 		.data		= &inotify_max_queued_events,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero
 	},
 	{ .ctl_name = 0 }
--- a/fs/ntfs/sysctl.c
+++ b/fs/ntfs/sysctl.c
@@ -41,7 +41,7 @@ static ctl_table ntfs_sysctls[] = {
 		.data		= &debug_msgs,		/* Data pointer and size. */
 		.maxlen		= sizeof(debug_msgs),
 		.mode		= 0644,			/* Mode, proc handler. */
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 	{}
 };
--- a/fs/ocfs2/stackglue.c
+++ b/fs/ocfs2/stackglue.c
@@ -624,8 +624,8 @@ static ctl_table ocfs2_nm_table[] = {
 		.data		= ocfs2_hb_ctl_path,
 		.maxlen		= OCFS2_MAX_HB_CTL_PATH,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
+		.proc_handler	= proc_dostring,
+		.strategy	= sysctl_string,
 	},
 	{ .ctl_name = 0 }
 };
--- a/fs/xfs/linux-2.6/xfs_sysctl.c
+++ b/fs/xfs/linux-2.6/xfs_sysctl.c
@@ -61,8 +61,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.sgid_inherit.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.sgid_inherit.min,
 		.extra2		= &xfs_params.sgid_inherit.max
 	},
@@ -72,8 +72,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.symlink_mode.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.symlink_mode.min,
 		.extra2		= &xfs_params.symlink_mode.max
 	},
@@ -83,8 +83,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.panic_mask.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.panic_mask.min,
 		.extra2		= &xfs_params.panic_mask.max
 	},
@@ -95,8 +95,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.error_level.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.error_level.min,
 		.extra2		= &xfs_params.error_level.max
 	},
@@ -106,8 +106,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.syncd_timer.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.syncd_timer.min,
 		.extra2		= &xfs_params.syncd_timer.max
 	},
@@ -117,8 +117,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.inherit_sync.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.inherit_sync.min,
 		.extra2		= &xfs_params.inherit_sync.max
 	},
@@ -128,8 +128,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.inherit_nodump.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.inherit_nodump.min,
 		.extra2		= &xfs_params.inherit_nodump.max
 	},
@@ -139,8 +139,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.inherit_noatim.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.inherit_noatim.min,
 		.extra2		= &xfs_params.inherit_noatim.max
 	},
@@ -150,8 +150,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.xfs_buf_timer.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.xfs_buf_timer.min,
 		.extra2		= &xfs_params.xfs_buf_timer.max
 	},
@@ -161,8 +161,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.xfs_buf_age.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.xfs_buf_age.min,
 		.extra2		= &xfs_params.xfs_buf_age.max
 	},
@@ -172,8 +172,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.inherit_nosym.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.inherit_nosym.min,
 		.extra2		= &xfs_params.inherit_nosym.max
 	},
@@ -183,8 +183,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.rotorstep.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.rotorstep.min,
 		.extra2		= &xfs_params.rotorstep.max
 	},
@@ -194,8 +194,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.inherit_nodfrg.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.inherit_nodfrg.min,
 		.extra2		= &xfs_params.inherit_nodfrg.max
 	},
@@ -205,8 +205,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.fstrm_timer.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.fstrm_timer.min,
 		.extra2		= &xfs_params.fstrm_timer.max,
 	},
@@ -218,8 +218,8 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.stats_clear.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &xfs_stats_clear_proc_handler,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= xfs_stats_clear_proc_handler,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xfs_params.stats_clear.min,
 		.extra2		= &xfs_params.stats_clear.max
 	},
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1215,14 +1215,14 @@ static ctl_table mq_sysctls[] = {
 		.data		= &queues_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.procname	= "msg_max",
 		.data		= &msg_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &msg_max_limit_min,
 		.extra2		= &msg_max_limit_max,
 	},
@@ -1231,7 +1231,7 @@ static ctl_table mq_sysctls[] = {
 		.data		= &msgsize_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &msg_maxsize_limit_min,
 		.extra2		= &msg_maxsize_limit_max,
 	},
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -247,8 +247,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_min_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &sched_nr_latency_handler,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= sched_nr_latency_handler,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
 	},
@@ -258,8 +258,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_latency,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &sched_nr_latency_handler,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= sched_nr_latency_handler,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_sched_granularity_ns,
 		.extra2		= &max_sched_granularity_ns,
 	},
@@ -269,8 +269,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_wakeup_granularity,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_wakeup_granularity_ns,
 		.extra2		= &max_wakeup_granularity_ns,
 	},
@@ -280,7 +280,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_shares_ratelimit,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -288,8 +288,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_shares_thresh,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
@@ -298,7 +298,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_child_runs_first,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -306,7 +306,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_features,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -314,7 +314,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_migration_cost,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -322,7 +322,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_nr_migrate,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -331,7 +331,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_rt_period,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &sched_rt_handler,
+		.proc_handler	= sched_rt_handler,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -339,7 +339,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_rt_runtime,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &sched_rt_handler,
+		.proc_handler	= sched_rt_handler,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -347,7 +347,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_sched_compat_yield,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #ifdef CONFIG_PROVE_LOCKING
 	{
@@ -356,7 +356,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &prove_locking,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_LOCK_STAT
@@ -366,7 +366,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &lock_stat,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -375,7 +375,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &panic_timeout,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= KERN_CORE_USES_PID,
@@ -383,7 +383,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &core_uses_pid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= KERN_CORE_PATTERN,
@@ -391,15 +391,15 @@ static struct ctl_table kern_table[] = {
 		.data		= core_pattern,
 		.maxlen		= CORENAME_MAX_SIZE,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
+		.proc_handler	= proc_dostring,
+		.strategy	= sysctl_string,
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
@@ -408,7 +408,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &latencytop_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -418,7 +418,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &real_root_dev,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -427,7 +427,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &print_fatal_signals,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #ifdef CONFIG_SPARC
 	{
@@ -436,8 +436,8 @@ static struct ctl_table kern_table[] = {
 		.data		= reboot_command,
 		.maxlen		= 256,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
+		.proc_handler	= proc_dostring,
+		.strategy	= sysctl_string,
 	},
 	{
 		.ctl_name	= KERN_SPARC_STOP_A,
@@ -445,7 +445,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &stop_a_enabled,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= KERN_SPARC_SCONS_PWROFF,
@@ -453,7 +453,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &scons_pwroff,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_SPARC64
@@ -463,7 +463,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_tsb_ratio,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef __hppa__
@@ -473,7 +473,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &pwrsw_enabled,
 		.maxlen		= sizeof (int),
 	 	.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= KERN_HPPA_UNALIGNED,
@@ -481,7 +481,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &unaligned_enabled,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -490,7 +490,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &C_A_D,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #ifdef CONFIG_FUNCTION_TRACER
 	{
@@ -499,7 +499,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &ftrace_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &ftrace_enable_sysctl,
+		.proc_handler	= ftrace_enable_sysctl,
 	},
 #endif
 #ifdef CONFIG_STACK_TRACER
@@ -509,7 +509,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &stack_tracer_enabled,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &stack_trace_sysctl,
+		.proc_handler	= stack_trace_sysctl,
 	},
 #endif
 #ifdef CONFIG_TRACING
@@ -519,7 +519,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &ftrace_dump_on_oops,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_MODULES
@@ -529,8 +529,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &modprobe_path,
 		.maxlen		= KMOD_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
+		.proc_handler	= proc_dostring,
+		.strategy	= sysctl_string,
 	},
 #endif
 #if defined(CONFIG_HOTPLUG) && defined(CONFIG_NET)
@@ -540,8 +540,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &uevent_helper,
 		.maxlen		= UEVENT_HELPER_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
+		.proc_handler	= proc_dostring,
+		.strategy	= sysctl_string,
 	},
 #endif
 #ifdef CONFIG_CHR_DEV_SG
@@ -551,7 +551,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sg_big_buff,
 		.maxlen		= sizeof (int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
@@ -561,7 +561,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &acct_parm,
 		.maxlen		= 3*sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_MAGIC_SYSRQ
@@ -571,7 +571,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &__sysrq_enabled,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_PROC_SYSCTL
@@ -580,7 +580,7 @@ static struct ctl_table kern_table[] = {
 		.data		= NULL,
 		.maxlen		= sizeof (int),
 		.mode		= 0600,
-		.proc_handler	= &proc_do_cad_pid,
+		.proc_handler	= proc_do_cad_pid,
 	},
 #endif
 	{
@@ -589,7 +589,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &max_threads,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= KERN_RANDOM,
@@ -603,8 +603,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &overflowuid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
@@ -614,8 +614,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &overflowgid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
@@ -627,7 +627,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_ieee_emulation_warnings,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -636,7 +636,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_userprocess_debug,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -645,7 +645,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &pid_max,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.strategy	= sysctl_intvec,
 		.extra1		= &pid_max_min,
 		.extra2		= &pid_max_max,
@@ -656,7 +656,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &panic_on_oops,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #if defined CONFIG_PRINTK
 	{
@@ -665,7 +665,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &console_loglevel,
 		.maxlen		= 4*sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= KERN_PRINTK_RATELIMIT,
@@ -673,8 +673,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &printk_ratelimit_state.interval,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-		.strategy	= &sysctl_jiffies,
+		.proc_handler	= proc_dointvec_jiffies,
+		.strategy	= sysctl_jiffies,
 	},
 	{
 		.ctl_name	= KERN_PRINTK_RATELIMIT_BURST,
@@ -682,7 +682,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &printk_ratelimit_state.burst,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -691,7 +691,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &ngroups_max,
 		.maxlen		= sizeof (int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
 	{
@@ -700,14 +700,14 @@ static struct ctl_table kern_table[] = {
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
@@ -717,7 +717,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &panic_on_unrecovered_nmi,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= KERN_BOOTLOADER_TYPE,
@@ -725,7 +725,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &bootloader_type,
 		.maxlen		= sizeof (int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -733,7 +733,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &kstack_depth_to_print,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -741,7 +741,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &io_delay_type,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #if defined(CONFIG_MMU)
@@ -751,7 +751,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &randomize_va_space,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #if defined(CONFIG_S390) && defined(CONFIG_SMP)
@@ -761,7 +761,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &spin_retry,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #if	defined(CONFIG_ACPI_SLEEP) && defined(CONFIG_X86)
@@ -770,7 +770,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &acpi_realmode_flags,
 		.maxlen		= sizeof (unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 #endif
 #ifdef CONFIG_IA64
@@ -780,7 +780,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &no_unaligned_warning,
 		.maxlen		= sizeof (int),
 	 	.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -788,7 +788,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &unaligned_dump_stack,
 		.maxlen		= sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_DETECT_SOFTLOCKUP
@@ -798,8 +798,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &softlockup_panic,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -809,8 +809,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &softlockup_thresh,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dosoftlockup_thresh,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dosoftlockup_thresh,
+		.strategy	= sysctl_intvec,
 		.extra1		= &neg_one,
 		.extra2		= &sixty,
 	},
@@ -820,8 +820,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_hung_task_check_count,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_doulongvec_minmax,
+		.strategy	= sysctl_intvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -829,8 +829,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_hung_task_timeout_secs,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_doulongvec_minmax,
+		.strategy	= sysctl_intvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -838,8 +838,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_hung_task_warnings,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_doulongvec_minmax,
+		.strategy	= sysctl_intvec,
 	},
 #endif
 #ifdef CONFIG_COMPAT
@@ -849,7 +849,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &compat_log,
 		.maxlen		= sizeof (int),
 	 	.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_RT_MUTEXES
@@ -859,7 +859,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &max_lock_depth,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 	{
@@ -868,8 +868,8 @@ static struct ctl_table kern_table[] = {
 		.data		= &poweroff_cmd,
 		.maxlen		= POWEROFF_CMD_PATH_LEN,
 		.mode		= 0644,
-		.proc_handler	= &proc_dostring,
-		.strategy	= &sysctl_string,
+		.proc_handler	= proc_dostring,
+		.strategy	= sysctl_string,
 	},
 #ifdef CONFIG_KEYS
 	{
@@ -886,7 +886,7 @@ static struct ctl_table kern_table[] = {
 		.data           = &rcutorture_runnable,
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
-		.proc_handler   = &proc_dointvec,
+		.proc_handler   = proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_UNEVICTABLE_LRU
@@ -896,7 +896,7 @@ static struct ctl_table kern_table[] = {
 		.data		= &scan_unevictable_pages,
 		.maxlen		= sizeof(scan_unevictable_pages),
 		.mode		= 0644,
-		.proc_handler	= &scan_unevictable_handler,
+		.proc_handler	= scan_unevictable_handler,
 	},
 #endif
 /*
@@ -913,7 +913,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_overcommit_memory,
 		.maxlen		= sizeof(sysctl_overcommit_memory),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= VM_PANIC_ON_OOM,
@@ -921,7 +921,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_panic_on_oom,
 		.maxlen		= sizeof(sysctl_panic_on_oom),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -929,7 +929,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_oom_kill_allocating_task,
 		.maxlen		= sizeof(sysctl_oom_kill_allocating_task),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -937,7 +937,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_oom_dump_tasks,
 		.maxlen		= sizeof(sysctl_oom_dump_tasks),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= VM_OVERCOMMIT_RATIO,
@@ -945,7 +945,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_overcommit_ratio,
 		.maxlen		= sizeof(sysctl_overcommit_ratio),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= VM_PAGE_CLUSTER,
@@ -953,7 +953,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &page_cluster,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= VM_DIRTY_BACKGROUND,
@@ -961,8 +961,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &dirty_background_ratio,
 		.maxlen		= sizeof(dirty_background_ratio),
 		.mode		= 0644,
-		.proc_handler	= &dirty_background_ratio_handler,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= dirty_background_ratio_handler,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
@@ -972,8 +972,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &dirty_background_bytes,
 		.maxlen		= sizeof(dirty_background_bytes),
 		.mode		= 0644,
-		.proc_handler	= &dirty_background_bytes_handler,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= dirty_background_bytes_handler,
+		.strategy	= sysctl_intvec,
 		.extra1		= &one,
 	},
 	{
@@ -982,8 +982,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &vm_dirty_ratio,
 		.maxlen		= sizeof(vm_dirty_ratio),
 		.mode		= 0644,
-		.proc_handler	= &dirty_ratio_handler,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= dirty_ratio_handler,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
@@ -993,8 +993,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &vm_dirty_bytes,
 		.maxlen		= sizeof(vm_dirty_bytes),
 		.mode		= 0644,
-		.proc_handler	= &dirty_bytes_handler,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= dirty_bytes_handler,
+		.strategy	= sysctl_intvec,
 		.extra1		= &one,
 	},
 	{
@@ -1002,14 +1002,14 @@ static struct ctl_table vm_table[] = {
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
-		.proc_handler	= &proc_dointvec_userhz_jiffies,
+		.proc_handler	= proc_dointvec_userhz_jiffies,
 	},
 	{
 		.ctl_name	= VM_NR_PDFLUSH_THREADS,
@@ -1017,7 +1017,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &nr_pdflush_threads,
 		.maxlen		= sizeof nr_pdflush_threads,
 		.mode		= 0444 /* read-only*/,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= VM_SWAPPINESS,
@@ -1025,8 +1025,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &vm_swappiness,
 		.maxlen		= sizeof(vm_swappiness),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
@@ -1036,7 +1036,7 @@ static struct ctl_table vm_table[] = {
 		.data		= NULL,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &hugetlb_sysctl_handler,
+		.proc_handler	= hugetlb_sysctl_handler,
 		.extra1		= (void *)&hugetlb_zero,
 		.extra2		= (void *)&hugetlb_infinity,
 	 },
@@ -1046,7 +1046,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_hugetlb_shm_group,
 		.maxlen		= sizeof(gid_t),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	 },
 	 {
 		.ctl_name	= CTL_UNNUMBERED,
@@ -1054,7 +1054,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &hugepages_treat_as_movable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &hugetlb_treat_movable_handler,
+		.proc_handler	= hugetlb_treat_movable_handler,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -1062,7 +1062,7 @@ static struct ctl_table vm_table[] = {
 		.data		= NULL,
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &hugetlb_overcommit_handler,
+		.proc_handler	= hugetlb_overcommit_handler,
 		.extra1		= (void *)&hugetlb_zero,
 		.extra2		= (void *)&hugetlb_infinity,
 	},
@@ -1073,8 +1073,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_lowmem_reserve_ratio,
 		.maxlen		= sizeof(sysctl_lowmem_reserve_ratio),
 		.mode		= 0644,
-		.proc_handler	= &lowmem_reserve_ratio_sysctl_handler,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= lowmem_reserve_ratio_sysctl_handler,
+		.strategy	= sysctl_intvec,
 	},
 	{
 		.ctl_name	= VM_DROP_PAGECACHE,
@@ -1083,7 +1083,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= drop_caches_sysctl_handler,
-		.strategy	= &sysctl_intvec,
+		.strategy	= sysctl_intvec,
 	},
 	{
 		.ctl_name	= VM_MIN_FREE_KBYTES,
@@ -1091,8 +1091,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &min_free_kbytes,
 		.maxlen		= sizeof(min_free_kbytes),
 		.mode		= 0644,
-		.proc_handler	= &min_free_kbytes_sysctl_handler,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= min_free_kbytes_sysctl_handler,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
@@ -1101,8 +1101,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &percpu_pagelist_fraction,
 		.maxlen		= sizeof(percpu_pagelist_fraction),
 		.mode		= 0644,
-		.proc_handler	= &percpu_pagelist_fraction_sysctl_handler,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= percpu_pagelist_fraction_sysctl_handler,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_percpu_pagelist_fract,
 	},
 #ifdef CONFIG_MMU
@@ -1112,7 +1112,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_max_map_count,
 		.maxlen		= sizeof(sysctl_max_map_count),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
+		.proc_handler	= proc_dointvec
 	},
 #else
 	{
@@ -1121,8 +1121,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_nr_trim_pages,
 		.maxlen		= sizeof(sysctl_nr_trim_pages),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 	},
 #endif
@@ -1132,8 +1132,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &laptop_mode,
 		.maxlen		= sizeof(laptop_mode),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-		.strategy	= &sysctl_jiffies,
+		.proc_handler	= proc_dointvec_jiffies,
+		.strategy	= sysctl_jiffies,
 	},
 	{
 		.ctl_name	= VM_BLOCK_DUMP,
@@ -1141,8 +1141,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &block_dump,
 		.maxlen		= sizeof(block_dump),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
@@ -1151,8 +1151,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_vfs_cache_pressure,
 		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 	},
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
@@ -1162,8 +1162,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_legacy_va_layout,
 		.maxlen		= sizeof(sysctl_legacy_va_layout),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 	},
 #endif
@@ -1174,8 +1174,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &zone_reclaim_mode,
 		.maxlen		= sizeof(zone_reclaim_mode),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
@@ -1184,8 +1184,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_min_unmapped_ratio,
 		.maxlen		= sizeof(sysctl_min_unmapped_ratio),
 		.mode		= 0644,
-		.proc_handler	= &sysctl_min_unmapped_ratio_sysctl_handler,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= sysctl_min_unmapped_ratio_sysctl_handler,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
@@ -1195,8 +1195,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_min_slab_ratio,
 		.maxlen		= sizeof(sysctl_min_slab_ratio),
 		.mode		= 0644,
-		.proc_handler	= &sysctl_min_slab_ratio_sysctl_handler,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= sysctl_min_slab_ratio_sysctl_handler,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
@@ -1208,8 +1208,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &sysctl_stat_interval,
 		.maxlen		= sizeof(sysctl_stat_interval),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_jiffies,
-		.strategy	= &sysctl_jiffies,
+		.proc_handler	= proc_dointvec_jiffies,
+		.strategy	= sysctl_jiffies,
 	},
 #endif
 #ifdef CONFIG_SECURITY
@@ -1219,7 +1219,7 @@ static struct ctl_table vm_table[] = {
 		.data		= &mmap_min_addr,
 		.maxlen         = sizeof(unsigned long),
 		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
+		.proc_handler	= proc_doulongvec_minmax,
 	},
 #endif
 #ifdef CONFIG_NUMA
@@ -1229,8 +1229,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &numa_zonelist_order,
 		.maxlen		= NUMA_ZONELIST_ORDER_LEN,
 		.mode		= 0644,
-		.proc_handler	= &numa_zonelist_order_handler,
-		.strategy	= &sysctl_string,
+		.proc_handler	= numa_zonelist_order_handler,
+		.strategy	= sysctl_string,
 	},
 #endif
 #if (defined(CONFIG_X86_32) && !defined(CONFIG_UML))|| \
@@ -1241,8 +1241,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &vdso_enabled,
 		.maxlen		= sizeof(vdso_enabled),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 	},
 #endif
@@ -1253,8 +1253,8 @@ static struct ctl_table vm_table[] = {
 		.data		= &vm_highmem_is_dirtyable,
 		.maxlen		= sizeof(vm_highmem_is_dirtyable),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
@@ -1279,7 +1279,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &inodes_stat,
 		.maxlen		= 2*sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= FS_STATINODE,
@@ -1287,14 +1287,14 @@ static struct ctl_table fs_table[] = {
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
 		.ctl_name	= FS_MAXFILE,
@@ -1302,7 +1302,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &files_stat.max_files,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -1310,7 +1310,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &sysctl_nr_open,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &sysctl_nr_open_min,
 		.extra2		= &sysctl_nr_open_max,
 	},
@@ -1320,7 +1320,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &dentry_stat,
 		.maxlen		= 6*sizeof(int),
 		.mode		= 0444,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name	= FS_OVERFLOWUID,
@@ -1328,8 +1328,8 @@ static struct ctl_table fs_table[] = {
 		.data		= &fs_overflowuid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
@@ -1339,8 +1339,8 @@ static struct ctl_table fs_table[] = {
 		.data		= &fs_overflowgid,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &minolduid,
 		.extra2		= &maxolduid,
 	},
@@ -1351,7 +1351,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &leases_enable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_DNOTIFY
@@ -1361,7 +1361,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &dir_notify_enable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_MMU
@@ -1372,8 +1372,8 @@ static struct ctl_table fs_table[] = {
 		.data		= &lease_break_time,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
@@ -1384,14 +1384,14 @@ static struct ctl_table fs_table[] = {
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
@@ -1416,7 +1416,7 @@ static struct ctl_table fs_table[] = {
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{
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
 	{ .ctl_name = 0 }
 };
--- a/net/sunrpc/xprtrdma/svc_rdma.c
+++ b/net/sunrpc/xprtrdma/svc_rdma.c
@@ -120,8 +120,8 @@ static ctl_table svcrdma_parm_table[] = {
 		.data		= &svcrdma_max_requests,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_max_requests,
 		.extra2		= &max_max_requests
 	},
@@ -130,8 +130,8 @@ static ctl_table svcrdma_parm_table[] = {
 		.data		= &svcrdma_max_req_size,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_max_inline,
 		.extra2		= &max_max_inline
 	},
@@ -140,8 +140,8 @@ static ctl_table svcrdma_parm_table[] = {
 		.data		= &svcrdma_ord,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_ord,
 		.extra2		= &max_ord,
 	},
@@ -151,63 +151,63 @@ static ctl_table svcrdma_parm_table[] = {
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
 	{
 		.ctl_name = 0,
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -91,8 +91,8 @@ static ctl_table xr_tunables_table[] = {
 		.data		= &xprt_rdma_slot_table_entries,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_slot_table_size,
 		.extra2		= &max_slot_table_size
 	},
@@ -102,8 +102,8 @@ static ctl_table xr_tunables_table[] = {
 		.data		= &xprt_rdma_max_inline_read,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec,
+		.strategy	= sysctl_intvec,
 	},
 	{
 		.ctl_name       = CTL_UNNUMBERED,
@@ -111,8 +111,8 @@ static ctl_table xr_tunables_table[] = {
 		.data		= &xprt_rdma_max_inline_write,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec,
+		.strategy	= sysctl_intvec,
 	},
 	{
 		.ctl_name       = CTL_UNNUMBERED,
@@ -120,8 +120,8 @@ static ctl_table xr_tunables_table[] = {
 		.data		= &xprt_rdma_inline_write_padding,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &zero,
 		.extra2		= &max_padding,
 	},
@@ -131,8 +131,8 @@ static ctl_table xr_tunables_table[] = {
 		.data		= &xprt_rdma_memreg_strategy,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_memreg,
 		.extra2		= &max_memreg,
 	},
@@ -142,7 +142,7 @@ static ctl_table xr_tunables_table[] = {
 		.data		= &xprt_rdma_pad_optimize,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= proc_dointvec,
 	},
 	{
 		.ctl_name = 0,
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -78,8 +78,8 @@ static ctl_table xs_tunables_table[] = {
 		.data		= &xprt_udp_slot_table_entries,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_slot_table_size,
 		.extra2		= &max_slot_table_size
 	},
@@ -89,8 +89,8 @@ static ctl_table xs_tunables_table[] = {
 		.data		= &xprt_tcp_slot_table_entries,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &min_slot_table_size,
 		.extra2		= &max_slot_table_size
 	},
@@ -100,8 +100,8 @@ static ctl_table xs_tunables_table[] = {
 		.data		= &xprt_min_resvport,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xprt_min_resvport_limit,
 		.extra2		= &xprt_max_resvport_limit
 	},
@@ -111,8 +111,8 @@ static ctl_table xs_tunables_table[] = {
 		.data		= &xprt_max_resvport,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
+		.proc_handler	= proc_dointvec_minmax,
+		.strategy	= sysctl_intvec,
 		.extra1		= &xprt_min_resvport_limit,
 		.extra2		= &xprt_max_resvport_limit
 	},
--- a/security/keys/sysctl.c
+++ b/security/keys/sysctl.c
@@ -20,7 +20,7 @@ ctl_table key_sysctls[] = {
 		.data = &key_quota_maxkeys,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec,
+		.proc_handler = proc_dointvec,
 	},
 	{
 		.ctl_name = CTL_UNNUMBERED,
@@ -28,7 +28,7 @@ ctl_table key_sysctls[] = {
 		.data = &key_quota_maxbytes,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec,
+		.proc_handler = proc_dointvec,
 	},
 	{
 		.ctl_name = CTL_UNNUMBERED,
@@ -36,7 +36,7 @@ ctl_table key_sysctls[] = {
 		.data = &key_quota_root_maxkeys,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec,
+		.proc_handler = proc_dointvec,
 	},
 	{
 		.ctl_name = CTL_UNNUMBERED,
@@ -44,7 +44,7 @@ ctl_table key_sysctls[] = {
 		.data = &key_quota_root_maxbytes,
 		.maxlen = sizeof(unsigned),
 		.mode = 0644,
-		.proc_handler = &proc_dointvec,
+		.proc_handler = proc_dointvec,
 	},
 	{ .ctl_name = 0 }
 };
-- 
1.5.6.5

