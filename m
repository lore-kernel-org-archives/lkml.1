Return-Path: <linux-kernel-owner+w=401wt.eu-S1758943AbXI0Wva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943AbXI0Wva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759785AbXI0WvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:51:21 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:58130 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759991AbXI0WvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:51:19 -0400
Message-ID: <46FC33E1.8010309@tiscali.nl>
Date: Fri, 28 Sep 2007 00:51:13 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] removes array_size duplicates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some ARRAY_SIZE macro duplicates. There is also one in
arch/um/include/user.h, which isn't fixed here because comments in that file
explicitly state a preference for the 'less fancy' version. If that's the
case as well for any of the other replacements please comment.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---

 Documentation/spi/spidev_test.c    |    2 --
 arch/i386/boot/compressed/relocs.c |    1 -
 arch/m68k/amiga/amisound.c         |    3 +--
 arch/powerpc/boot/types.h          |    2 --
 arch/sparc64/kernel/pci.c          |    6 ++----
 drivers/acpi/utilities/uteval.c    |    4 ++--
 drivers/net/irda/actisys-sir.c     |    6 ++----
 drivers/net/lp486e.c               |    4 +---
 drivers/net/sk98lin/skgemib.c      |    5 -----
 drivers/net/skfp/smt.c             |    4 +---
 drivers/net/skfp/srf.c             |   18 +++++++-----------
 drivers/net/wireless/ipw2100.c     |   13 ++++---------
 drivers/serial/68328serial.c       |    6 ++----
 drivers/video/sgivwfb.c            |    4 ++--
 include/acpi/acmacros.h            |    2 --
 include/linux/netfilter/xt_sctp.h  |   12 +++++-------
 include/net/ip_vs.h                |    1 -
 include/video/sgivw.h              |    1 -
 net/ipv4/ipvs/ip_vs_proto_tcp.c    |    2 +-
 scripts/mod/file2alias.c           |    2 --
 20 files changed, 30 insertions(+), 68 deletions(-)

diff --git a/Documentation/spi/spidev_test.c b/Documentation/spi/spidev_test.c
index 218e862..0f23aac 100644
--- a/Documentation/spi/spidev_test.c
+++ b/Documentation/spi/spidev_test.c
@@ -21,8 +21,6 @@
 #include <linux/types.h>
 #include <linux/spi/spidev.h>
 
-#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))
-
 static void pabort(const char *s)
 {
 	perror(s);
diff --git a/arch/i386/boot/compressed/relocs.c b/arch/i386/boot/compressed/relocs.c
index 2d77ee7..5d8dbff 100644
--- a/arch/i386/boot/compressed/relocs.c
+++ b/arch/i386/boot/compressed/relocs.c
@@ -11,7 +11,6 @@
 #include <endian.h>
 
 #define MAX_SHDRS 100
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 static Elf32_Ehdr ehdr;
 static Elf32_Shdr shdr[MAX_SHDRS];
 static Elf32_Sym  *symtab[MAX_SHDRS];
diff --git a/arch/m68k/amiga/amisound.c b/arch/m68k/amiga/amisound.c
index 1f5bfb5..8d013a1 100644
--- a/arch/m68k/amiga/amisound.c
+++ b/arch/m68k/amiga/amisound.c
@@ -21,7 +21,6 @@ static const signed char sine_data[] = {
 	0,  39,  75,  103,  121,  127,  121,  103,  75,  39,
 	0, -39, -75, -103, -121, -127, -121, -103, -75, -39
 };
-#define DATA_SIZE	(sizeof(sine_data)/sizeof(sine_data[0]))
 
 #define custom amiga_custom
 
@@ -55,7 +54,7 @@ void __init amiga_init_sound(void)
 	memcpy (snd_data, sine_data, sizeof(sine_data));
 
 	/* setup divisor */
-	clock_constant = (amiga_colorclock+DATA_SIZE/2)/DATA_SIZE;
+	clock_constant = (amiga_colorclock + ARRAY_SIZE(sine_data) /2) / ARRAY_SIZE(sine_data);
 
 	/* without amifb, turn video off and enable high quality sound */
 #ifndef CONFIG_FB_AMIGA
diff --git a/arch/powerpc/boot/types.h b/arch/powerpc/boot/types.h
index 31393d1..733622a 100644
--- a/arch/powerpc/boot/types.h
+++ b/arch/powerpc/boot/types.h
@@ -1,8 +1,6 @@
 #ifndef _TYPES_H_
 #define _TYPES_H_
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-
 typedef unsigned char		u8;
 typedef unsigned short		u16;
 typedef unsigned int		u32;
diff --git a/arch/sparc64/kernel/pci.c b/arch/sparc64/kernel/pci.c
index e8dac81..5c8c433 100644
--- a/arch/sparc64/kernel/pci.c
+++ b/arch/sparc64/kernel/pci.c
@@ -209,14 +209,12 @@ static struct {
 	{ "SUNW,sun4v-pci", sun4v_pci_init },
 	{ "pciex108e,80f0", fire_pci_init },
 };
-#define PCI_NUM_CONTROLLER_TYPES (sizeof(pci_controller_table) / \
-				  sizeof(pci_controller_table[0]))
 
 static int __init pci_controller_init(const char *model_name, int namelen, struct device_node *dp)
 {
 	int i;
 
-	for (i = 0; i < PCI_NUM_CONTROLLER_TYPES; i++) {
+	for (i = 0; i < ARRAY_SIZE(pci_controller_table); i++) {
 		if (!strncmp(model_name,
 			     pci_controller_table[i].model_name,
 			     namelen)) {
@@ -232,7 +230,7 @@ static int __init pci_is_controller(const char *model_name, int namelen, struct
 {
 	int i;
 
-	for (i = 0; i < PCI_NUM_CONTROLLER_TYPES; i++) {
+	for (i = 0; i < ARRAY_SIZE(pci_controller_table); i++) {
 		if (!strncmp(model_name,
 			     pci_controller_table[i].model_name,
 			     namelen)) {
diff --git a/drivers/acpi/utilities/uteval.c b/drivers/acpi/utilities/uteval.c
index 0042b7e..5da86d5 100644
--- a/drivers/acpi/utilities/uteval.c
+++ b/drivers/acpi/utilities/uteval.c
@@ -122,7 +122,7 @@ acpi_status acpi_ut_osi_implementation(struct acpi_walk_state *walk_state)
 
 	/* Compare input string to static table of supported interfaces */
 
-	for (i = 0; i < ACPI_ARRAY_LENGTH(acpi_interfaces_supported); i++) {
+	for (i = 0; i < ARRAY_SIZE(acpi_interfaces_supported); i++) {
 		if (!ACPI_STRCMP
 		    (string_desc->string.pointer,
 		     acpi_interfaces_supported[i])) {
@@ -168,7 +168,7 @@ acpi_status acpi_osi_invalidate(char *interface)
 {
 	int i;
 
-	for (i = 0; i < ACPI_ARRAY_LENGTH(acpi_interfaces_supported); i++) {
+	for (i = 0; i < ARRAY_SIZE(acpi_interfaces_supported); i++) {
 		if (!ACPI_STRCMP(interface, acpi_interfaces_supported[i])) {
 			*acpi_interfaces_supported[i] = '\0';
 			return AE_OK;
diff --git a/drivers/net/irda/actisys-sir.c b/drivers/net/irda/actisys-sir.c
index 9715ab5..44bf0c2 100644
--- a/drivers/net/irda/actisys-sir.c
+++ b/drivers/net/irda/actisys-sir.c
@@ -67,8 +67,6 @@ static int actisys_reset(struct sir_dev *);
 /* Note : the 220L doesn't support 38400, but we will fix that below */
 static unsigned baud_rates[] = { 9600, 19200, 57600, 115200, 38400 };
 
-#define MAX_SPEEDS (sizeof(baud_rates)/sizeof(baud_rates[0]))
-
 static struct dongle_driver act220l = {
 	.owner		= THIS_MODULE,
 	.driver_name	= "Actisys ACT-220L",
@@ -176,7 +174,7 @@ static int actisys_change_speed(struct sir_dev *dev, unsigned speed)
 	 * Now, we can set the speed requested. Send RTS pulses until we
          * reach the target speed 
 	 */
-	for (i = 0; i < MAX_SPEEDS; i++) {
+	for (i = 0; i < ARRAY_SIZE(baud_rates); i++) {
 		if (speed == baud_rates[i]) {
 			dev->speed = speed;
 			break;
@@ -191,7 +189,7 @@ static int actisys_change_speed(struct sir_dev *dev, unsigned speed)
 	}
 
 	/* Check if life is sweet... */
-	if (i >= MAX_SPEEDS) {
+	if (i >= ARRAY_SIZE(baud_rates)) {
 		actisys_reset(dev);
 		ret = -EINVAL;  /* This should not happen */
 	}
diff --git a/drivers/net/lp486e.c b/drivers/net/lp486e.c
index 5fc18da..408ae6e 100644
--- a/drivers/net/lp486e.c
+++ b/drivers/net/lp486e.c
@@ -515,8 +515,6 @@ CLEAR_INT(void) {
 	outb(0, IOADDR+8);
 }
 
-#define SIZE(x)	(sizeof(x)/sizeof((x)[0]))
-
 #if 0
 /* selftest or dump */
 static void
@@ -532,7 +530,7 @@ i596_port_do(struct net_device *dev, int portcmd, char *cmdname) {
 	mdelay(30);             /* random, unmotivated */
 
 	printk("lp486e i82596 %s result:\n", cmdname);
-	for (m = SIZE(lp->dump.dump); m && lp->dump.dump[m-1] == 0; m--)
+	for (m = ARRAY_SIZE(lp->dump.dump); m && lp->dump.dump[m-1] == 0; m--)
 		;
 	for (i = 0; i < m; i++) {
 		printk(" %04x", lp->dump.dump[i]);
diff --git a/drivers/net/sk98lin/skgemib.c b/drivers/net/sk98lin/skgemib.c
index 0a6f67a..db36474 100644
--- a/drivers/net/sk98lin/skgemib.c
+++ b/drivers/net/sk98lin/skgemib.c
@@ -80,11 +80,6 @@ PNMI_STATIC int DiagActions(SK_AC *pAC, SK_IOC IoC, int action, SK_U32 Id,
 	unsigned int TableIndex, SK_U32 NetIndex);
 #endif /* SK_DIAG_SUPPORT */
 
-
-/* defines *******************************************************************/
-#define ID_TABLE_SIZE (sizeof(IdTable)/sizeof(IdTable[0]))
-
-
 /* global variables **********************************************************/
 
 /*
diff --git a/drivers/net/skfp/smt.c b/drivers/net/skfp/smt.c
index 75afc1f..a1c49ed 100644
--- a/drivers/net/skfp/smt.c
+++ b/drivers/net/skfp/smt.c
@@ -1654,8 +1654,6 @@ static const struct smt_pdef {
 	{ SMT_P4053,	0,	SWAP_SMT_P4053			} ,
 } ;
 
-#define N_SMT_PLEN	(sizeof(smt_pdef)/sizeof(smt_pdef[0]))
-
 int smt_check_para(struct s_smc *smc, struct smt_header	*sm,
 		   const u_short list[])
 {
@@ -1881,7 +1879,7 @@ void smt_swap_para(struct smt_header *sm, int len, int direction)
 		if (plen < 0)
 			break ;
 		plen += PARA_LEN ;
-		for (i = N_SMT_PLEN, pd = smt_pdef; i ; i--,pd++) {
+		for (i = ARRAY_SIZE(smt_pdef), pd = smt_pdef; i ; i--,pd++) {
 			if (pd->ptype == type)
 				break ;
 		}
diff --git a/drivers/net/skfp/srf.c b/drivers/net/skfp/srf.c
index 16573ac..ee6c84b 100644
--- a/drivers/net/skfp/srf.c
+++ b/drivers/net/skfp/srf.c
@@ -43,8 +43,6 @@ static void clear_reported(struct s_smc *smc);
 static void smt_send_srf(struct s_smc *smc);
 static struct s_srf_evc *smt_get_evc(struct s_smc *smc, int code, int index);
 
-#define MAX_EVCS	(sizeof(smc->evcs)/sizeof(smc->evcs[0]))
-
 struct evc_init {
 	u_char code ;
 	u_char index ;
@@ -67,8 +65,6 @@ static const struct evc_init evc_inits[] = {
 	{ SMT_EVENT_PORT_PATH_CHANGE,		INDEX_PORT,NUMPHYS,SMT_P4053 } ,
 } ;
 
-#define MAX_INIT_EVC	(sizeof(evc_inits)/sizeof(evc_inits[0]))
-
 void smt_init_evc(struct s_smc *smc)
 {
 	struct s_srf_evc	*evc ;
@@ -84,7 +80,7 @@ void smt_init_evc(struct s_smc *smc)
 	evc = smc->evcs ;
 	init = evc_inits ;
 
-	for (i = 0 ; (unsigned) i < MAX_INIT_EVC ; i++) {
+	for (i = 0 ; (unsigned) i < ARRAY_SIZE(evc_inits) ; i++) {
 		for (index = 0 ; index < init->n ; index++) {
 			evc->evc_code = init->code ;
 			evc->evc_para = init->para ;
@@ -98,7 +94,7 @@ void smt_init_evc(struct s_smc *smc)
 		init++ ;
 	}
 
-	if ((unsigned) (evc - smc->evcs) > MAX_EVCS) {
+	if ((unsigned) (evc - smc->evcs) > ARRAY_SIZE(smc->evcs)) {
 		SMT_PANIC(smc,SMT_E0127, SMT_E0127_MSG) ;
 	}
 
@@ -139,7 +135,7 @@ void smt_init_evc(struct s_smc *smc)
 		offset++ ;
 	}
 #ifdef	DEBUG
-	for (i = 0, evc = smc->evcs ; (unsigned) i < MAX_EVCS ; i++, evc++) {
+	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
 		if (SMT_IS_CONDITION(evc->evc_code)) {
 			if (!evc->evc_cond_state) {
 				SMT_PANIC(smc,SMT_E0128, SMT_E0128_MSG) ;
@@ -163,7 +159,7 @@ static struct s_srf_evc *smt_get_evc(struct s_smc *smc, int code, int index)
 	int			i ;
 	struct s_srf_evc	*evc ;
 
-	for (i = 0, evc = smc->evcs ; (unsigned) i < MAX_EVCS ; i++, evc++) {
+	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
 		if (evc->evc_code == code && evc->evc_index == index)
 			return(evc) ;
 	}
@@ -337,7 +333,7 @@ static void clear_all_rep(struct s_smc *smc)
 	struct s_srf_evc	*evc ;
 	int			i ;
 
-	for (i = 0, evc = smc->evcs ; (unsigned) i < MAX_EVCS ; i++, evc++) {
+	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
 		evc->evc_rep_required = FALSE ;
 		if (SMT_IS_CONDITION(evc->evc_code))
 			*evc->evc_cond_state = FALSE ;
@@ -351,7 +347,7 @@ static void clear_reported(struct s_smc *smc)
 	int			i ;
 
 	smc->srf.any_report = FALSE ;
-	for (i = 0, evc = smc->evcs ; (unsigned) i < MAX_EVCS ; i++, evc++) {
+	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
 		if (SMT_IS_CONDITION(evc->evc_code)) {
 			if (*evc->evc_cond_state == FALSE)
 				evc->evc_rep_required = FALSE ;
@@ -405,7 +401,7 @@ static void smt_send_srf(struct s_smc *smc)
 	smt_add_para(smc,&pcon,(u_short) SMT_P1033,0,0) ;
 	smt_add_para(smc,&pcon,(u_short) SMT_P1034,0,0) ;
 
-	for (i = 0, evc = smc->evcs ; (unsigned) i < MAX_EVCS ; i++, evc++) {
+	for (i = 0, evc = smc->evcs ; (unsigned) i < ARRAY_SIZE(smc->evcs) ; i++, evc++) {
 		if (evc->evc_rep_required) {
 			smt_add_para(smc,&pcon,evc->evc_para,
 				(int)evc->evc_index,0) ;
diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index 8990585..309fa71 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -6581,9 +6581,6 @@ static const long ipw2100_frequencies[] = {
 	2472, 2484
 };
 
-#define FREQ_COUNT (sizeof(ipw2100_frequencies) / \
-                    sizeof(ipw2100_frequencies[0]))
-
 static const long ipw2100_rates_11b[] = {
 	1000000,
 	2000000,
@@ -6591,8 +6588,6 @@ static const long ipw2100_rates_11b[] = {
 	11000000
 };
 
-#define RATE_COUNT ARRAY_SIZE(ipw2100_rates_11b)
-
 static int ipw2100_wx_get_name(struct net_device *dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *wrqu, char *extra)
@@ -6797,9 +6792,9 @@ static int ipw2100_wx_get_range(struct net_device *dev,
 	range->avg_qual.noise = 0;
 	range->avg_qual.updated = 7;	/* Updated all three */
 
-	range->num_bitrates = RATE_COUNT;
+	range->num_bitrates = ARRAY_SIZE(ipw2100_rates);
 
-	for (i = 0; i < RATE_COUNT && i < IW_MAX_BITRATES; i++) {
+	for (i = 0; i < ARRAY_SIZE(ipw2100_rates) && i < IW_MAX_BITRATES; i++) {
 		range->bitrate[i] = ipw2100_rates_11b[i];
 	}
 
@@ -6852,10 +6847,10 @@ static int ipw2100_wx_get_range(struct net_device *dev,
 //      range->min_r_time;      /* Minimal retry lifetime */
 //      range->max_r_time;      /* Maximal retry lifetime */
 
-	range->num_channels = FREQ_COUNT;
+	range->num_channels = ARRAY_SIZE(ipw2100_frequencies);
 
 	val = 0;
-	for (i = 0; i < FREQ_COUNT; i++) {
+	for (i = 0; i < ARRAY_SIZE(ipw2100_frequencies); i++) {
 		// TODO: Include only legal frequencies for some countries
 //              if (local->channel_mask & (1 << i)) {
 		range->freq[val].i = i + 1;
diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index aad4012..52f8c79 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -157,8 +157,6 @@ static int baud_table[] = {
 	0, 50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400, 4800,
 	9600, 19200, 38400, 57600, 115200, 0 };
 
-#define BAUD_TABLE_SIZE (sizeof(baud_table)/sizeof(baud_table[0]))
-
 /* Sets or clears DTR/RTS on the requested line */
 static inline void m68k_rtsdtr(struct m68k_serial *ss, int set)
 {
@@ -1460,10 +1458,10 @@ int m68328_console_setup(struct console *cp, char *arg)
 	if (arg)
 		n = simple_strtoul(arg,NULL,0);
 
-	for (i = 0; i < BAUD_TABLE_SIZE; i++)
+	for (i = 0; i < ARRAY_SIZE(baud_table); i++)
 		if (baud_table[i] == n)
 			break;
-	if (i < BAUD_TABLE_SIZE) {
+	if (i < ARRAY_SIZE(baud_table)) {
 		m68328_console_baud = n;
 		m68328_console_cbaud = 0;
 		if (i > 15) {
diff --git a/drivers/video/sgivwfb.c b/drivers/video/sgivwfb.c
index 4fb1624..a7b18e4 100644
--- a/drivers/video/sgivwfb.c
+++ b/drivers/video/sgivwfb.c
@@ -261,13 +261,13 @@ static int sgivwfb_check_var(struct fb_var_screeninfo *var,
 	var->grayscale = 0;	/* No grayscale for now */
 
 	/* determine valid resolution and timing */
-	for (min_mode = 0; min_mode < DBE_VT_SIZE; min_mode++) {
+	for (min_mode = 0; min_mode < ARRAY_SIZE(dbeVTimings); min_mode++) {
 		if (dbeVTimings[min_mode].width >= var->xres &&
 		    dbeVTimings[min_mode].height >= var->yres)
 			break;
 	}
 
-	if (min_mode == DBE_VT_SIZE)
+	if (min_mode == ARRAY_SIZE(dbeVTimings))
 		return -EINVAL;	/* Resolution to high */
 
 	/* XXX FIXME - should try to pick best refresh rate */
diff --git a/include/acpi/acmacros.h b/include/acpi/acmacros.h
index 45662f6..53e79c5 100644
--- a/include/acpi/acmacros.h
+++ b/include/acpi/acmacros.h
@@ -59,8 +59,6 @@
 
 /* Size calculation */
 
-#define ACPI_ARRAY_LENGTH(x)            (sizeof(x) / sizeof((x)[0]))
-
 #ifdef ACPI_NO_INTEGER64_SUPPORT
 /*
  * acpi_integer is 32-bits, no 64-bit support on this platform
diff --git a/include/linux/netfilter/xt_sctp.h b/include/linux/netfilter/xt_sctp.h
index b157897..a4d8689 100644
--- a/include/linux/netfilter/xt_sctp.h
+++ b/include/linux/netfilter/xt_sctp.h
@@ -7,8 +7,6 @@
 
 #define XT_SCTP_VALID_FLAGS		0x07
 
-#define ELEMCOUNT(x) (sizeof(x)/sizeof(x[0]))
-
 
 struct xt_sctp_flag_info {
 	u_int8_t chunktype;
@@ -59,21 +57,21 @@ struct xt_sctp_info {
 #define SCTP_CHUNKMAP_RESET(chunkmap) 				\
 	do {							\
 		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++)	\
+		for (i = 0; i < ARRAY_SIZE(chunkmap); i++)	\
 			chunkmap[i] = 0;			\
 	} while (0)
 
 #define SCTP_CHUNKMAP_SET_ALL(chunkmap) 			\
 	do {							\
 		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++) 	\
+		for (i = 0; i < ARRAY_SIZE(chunkmap); i++) 	\
 			chunkmap[i] = ~0;			\
 	} while (0)
 
 #define SCTP_CHUNKMAP_COPY(destmap, srcmap) 			\
 	do {							\
 		int i; 						\
-		for (i = 0; i < ELEMCOUNT(chunkmap); i++) 	\
+		for (i = 0; i < ARRAY_SIZE(chunkmap); i++) 	\
 			destmap[i] = srcmap[i];			\
 	} while (0)
 
@@ -81,7 +79,7 @@ struct xt_sctp_info {
 ({							\
 	int i; 						\
 	int flag = 1;					\
-	for (i = 0; i < ELEMCOUNT(chunkmap); i++) {	\
+	for (i = 0; i < ARRAY_SIZE(chunkmap); i++) {	\
 		if (chunkmap[i]) {			\
 			flag = 0;			\
 			break;				\
@@ -94,7 +92,7 @@ struct xt_sctp_info {
 ({							\
 	int i; 						\
 	int flag = 1;					\
-	for (i = 0; i < ELEMCOUNT(chunkmap); i++) {	\
+	for (i = 0; i < ARRAY_SIZE(chunkmap); i++) {	\
 		if (chunkmap[i] != ~0) {		\
 			flag = 0;			\
 				break;			\
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 672564e..cf43bf0 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -704,7 +704,6 @@ struct ip_vs_app
  */
 extern const char *ip_vs_proto_name(unsigned proto);
 extern void ip_vs_init_hash_table(struct list_head *table, int rows);
-#define IP_VS_INIT_HASH_TABLE(t) ip_vs_init_hash_table(t, sizeof(t)/sizeof(t[0]))
 
 #define IP_VS_APP_TYPE_UNSPEC	0
 #define IP_VS_APP_TYPE_FTP	1
diff --git a/include/video/sgivw.h b/include/video/sgivw.h
index 55f2a7c..7c9b763 100644
--- a/include/video/sgivw.h
+++ b/include/video/sgivw.h
@@ -676,7 +676,6 @@ struct dbe_timing_info dbeVTimings[] = {
   }
 };
 
-#define DBE_VT_SIZE  (sizeof(dbeVTimings)/sizeof(dbeVTimings[0]))
 #endif // INCLUDE_TIMING_TABLE_DATA
 
 #endif // ! __SGIVWFB_H__
diff --git a/net/ipv4/ipvs/ip_vs_proto_tcp.c b/net/ipv4/ipvs/ip_vs_proto_tcp.c
index e65577a..3d523e4 100644
--- a/net/ipv4/ipvs/ip_vs_proto_tcp.c
+++ b/net/ipv4/ipvs/ip_vs_proto_tcp.c
@@ -584,7 +584,7 @@ void ip_vs_tcp_conn_listen(struct ip_vs_conn *cp)
 
 static void ip_vs_tcp_init(struct ip_vs_protocol *pp)
 {
-	IP_VS_INIT_HASH_TABLE(tcp_apps);
+	ip_vs_init_hash_table(tcp_apps, ARRAY_SIZE(tcp_apps));
 	pp->timeout_table = tcp_timeouts;
 }
 
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 8a09021..34600e5 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -403,8 +403,6 @@ static int do_i2c_entry(const char *filename, struct i2c_device_id *i2c, char *a
 	return 1;
 }
 
-#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
-
 static void do_input(char *alias,
 		     kernel_ulong_t *arr, unsigned int min, unsigned int max)
 {
