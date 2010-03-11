Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0CKC6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 21:58:41 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:64042 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab0CKC6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 21:58:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dDgT49ldlaPwHWapEDYP12wkc1rMEPPp4jf4FDh38QWEYx1eiuqI0zYTLiqsgKUwts
         0ldqRCZAJUdJW1miXQsUb8w6+NzEms8CNntWLLYbpMqgTFXAd5gx0FV/uEaLsREVM6Cl
         0VBu+Co/kMDwf7vzLzlopqFsu6sAzaN8EHKrc=
From: =?UTF-8?q?Andr=C3=A9=20Silva?= <andre.beat@gmail.com>
To: gregkh@suse.de, linville@tuxdriver.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Andre Silva <andre.beat@gmail.com>
Subject: [PATCH] Staging: arlan: fixed coding style issues in arlan-proc.c This is a patch to the arlan-proc.c file that fixes up multiple coding style errors and warnings found by the checkpatch.pl tool Signed-off-by: Andre Silva <andre.beat@gmail.com>
Date: Thu, 11 Mar 2010 02:58:26 +0000
Message-Id: <1268276306-14324-1-git-send-email-andre.beat@gmail.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Silva <andre.beat@gmail.com>

---
 drivers/staging/arlan/arlan-proc.c |  623 ++++++++++++++++++------------------
 1 files changed, 306 insertions(+), 317 deletions(-)

diff --git a/drivers/staging/arlan/arlan-proc.c b/drivers/staging/arlan/arlan-proc.c
index b22983e..62cd1d0 100644
--- a/drivers/staging/arlan/arlan-proc.c
+++ b/drivers/staging/arlan/arlan-proc.c
@@ -9,48 +9,55 @@
 
 
 
-#define ARLAN_STR_SIZE 	0x2ff0
-#define DEV_ARLAN_INFO 	1
-#define DEV_ARLAN 	1
-#define SARLG(type,var) {\
-	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x%x\n", #var, READSHMB(priva->card->var));	\
+#define ARLAN_STR_SIZE 0x2ff0
+#define DEV_ARLAN_INFO 1
+#define DEV_ARLAN 1
+#define SARLG(type, var) {\
+	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x%x\n", #var,\
+		READSHMB(priva->card->var));\
 	}
 
-#define SARLBN(type,var,nn) {\
-	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x",#var);\
-	for (i=0; i < nn; i++ ) pos += sprintf(arlan_drive_info+pos, "%02x",READSHMB(priva->card->var[i]));\
-	pos += sprintf(arlan_drive_info+pos, "\n");	\
+#define SARLBN(type, var, nn) {\
+	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x", #var);\
+	for (i = 0; i < nn; i++)\
+		pos += sprintf(arlan_drive_info+pos, "%02x",\
+			READSHMB(priva->card->var[i]));\
+		pos += sprintf(arlan_drive_info+pos, "\n");\
 	}
 
-#define SARLBNpln(type,var,nn) {\
-	for (i=0; i < nn; i++ ) pos += sprintf(arlan_drive_info+pos, "%02x",READSHMB(priva->card->var[i]));\
+#define SARLBNpln(type, var, nn) {\
+	for (i = 0; i < nn; i++)\
+		pos += sprintf(arlan_drive_info+pos, "%02x",\
+			READSHMB(priva->card->var[i]));\
 	}
 
-#define SARLSTR(var,nn) {\
+#define SARLSTR(var, nn) {\
 	char tmpStr[400];\
 	int  tmpLn = nn;\
-	if (nn > 399 ) tmpLn = 399; \
-	memcpy(tmpStr,(char *) priva->conf->var,tmpLn);\
+	if (nn > 399)\
+		tmpLn = 399;\
+	memcpy(tmpStr, (char *) priva->conf->var, tmpLn);\
 	tmpStr[tmpLn] = 0; \
-	pos += sprintf(arlan_drive_info+pos, "%s\t=\t%s \n",#var,priva->conf->var);\
+	pos += sprintf(arlan_drive_info+pos, "%s\t=\t%s\n",\
+		#var, priva->conf->var);\
 	}
 
-#define SARLUC(var)  	SARLG(u_char, var)
-#define SARLUCN(var,nn) SARLBN(u_char,var, nn)
+#define SARLUC(var) SARLG(u_char, var)
+#define SARLUCN(var, nn) SARLBN(u_char, var, nn)
 #define SARLUS(var)	SARLG(u_short, var)
-#define SARLUSN(var,nn)	SARLBN(u_short,var, nn)
+#define SARLUSN(var, nn)	SARLBN(u_short, var, nn)
 #define SARLUI(var)	SARLG(u_int, var)
 
 #define SARLUSA(var) {\
 	u_short tmpVar;\
-	memcpy(&tmpVar, (short *) priva->conf->var,2); \
-	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x%x\n",#var, tmpVar);\
+	memcpy(&tmpVar, (short *) priva->conf->var, 2); \
+	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x%x\n", #var, tmpVar);\
 }
 
 #define SARLUIA(var) {\
 	u_int tmpVar;\
-	memcpy(&tmpVar, (int* )priva->conf->var,4); \
-	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x%x\n",#var, tmpVar);\
+	memcpy(&tmpVar, (int *)priva->conf->var, 4); \
+	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x%x\n", #var, tmpVar);\
 }
 
 
@@ -63,51 +70,51 @@ static const char *arlan_diagnostic_info_string(struct net_device *dev)
 
 	READSHM(diagnosticInfo, arlan->diagnosticInfo, u_char);
 
-	switch (diagnosticInfo)
-	{
-		case 0xFF:
+	switch (diagnosticInfo) {
+
+	case 0xFF:
 			return "Diagnostic info is OK";
-		case 0xFE:
-			return "ERROR EPROM Checksum error ";
-		case 0xFD:
-			return "ERROR Local Ram Test Failed ";
-		case 0xFC:
-			return "ERROR SCC failure ";
-		case 0xFB:
-			return "ERROR BackBone failure ";
-		case 0xFA:
-			return "ERROR transceiver not found ";
-		case 0xF9:
-			return "ERROR no more address space ";
-		case 0xF8:
-			return "ERROR Checksum error  ";
-		case 0xF7:
-			return "ERROR Missing SS Code";
-		case 0xF6:
-			return "ERROR Invalid config format";
-		case 0xF5:
-			return "ERROR Reserved errorcode F5";
-		case 0xF4:
-			return "ERROR Invalid spreading code/channel number";
-		case 0xF3:
-			return "ERROR Load Code Error";
-		case 0xF2:
-			return "ERROR Reserver errorcode F2 ";
-		case 0xF1:
-			return "ERROR Invalid command receivec by LAN card ";
-		case 0xF0:
-			return "ERROR Invalid parameter found in command ";
-		case 0xEF:
-			return "ERROR On-chip timer failure ";
-		case 0xEE:
-			return "ERROR T410 timer failure ";
-		case 0xED:
-			return "ERROR Too Many TxEnable commands ";
-		case 0xEC:
-			return "ERROR EEPROM error on radio module ";
-		default:
-			return "ERROR unknown Diagnostic info reply code ";
-	  }
+	case 0xFE:
+		return "ERROR EPROM Checksum error ";
+	case 0xFD:
+		return "ERROR Local Ram Test Failed ";
+	case 0xFC:
+		return "ERROR SCC failure ";
+	case 0xFB:
+		return "ERROR BackBone failure ";
+	case 0xFA:
+		return "ERROR transceiver not found ";
+	case 0xF9:
+		return "ERROR no more address space ";
+	case 0xF8:
+		return "ERROR Checksum error  ";
+	case 0xF7:
+		return "ERROR Missing SS Code";
+	case 0xF6:
+		return "ERROR Invalid config format";
+	case 0xF5:
+		return "ERROR Reserved errorcode F5";
+	case 0xF4:
+		return "ERROR Invalid spreading code/channel number";
+	case 0xF3:
+		return "ERROR Load Code Error";
+	case 0xF2:
+		return "ERROR Reserver errorcode F2 ";
+	case 0xF1:
+		return "ERROR Invalid command receivec by LAN card ";
+	case 0xF0:
+		return "ERROR Invalid parameter found in command ";
+	case 0xEF:
+		return "ERROR On-chip timer failure ";
+	case 0xEE:
+		return "ERROR T410 timer failure ";
+	case 0xED:
+		return "ERROR Too Many TxEnable commands ";
+	case 0xEC:
+		return "ERROR EEPROM error on radio module ";
+	default:
+		return "ERROR unknown Diagnostic info reply code ";
+	}
 }
 
 static const char *arlan_hardware_type_string(struct net_device *dev)
@@ -117,70 +124,69 @@ static const char *arlan_hardware_type_string(struct net_device *dev)
 	volatile struct arlan_shmem __iomem *arlan = priv->card;
 
 	READSHM(hardwareType, arlan->hardwareType, u_char);
-	switch (hardwareType)
-	{
-		case 0x00:
-			return "type A450";
-		case 0x01:
-			return "type A650 ";
-		case 0x04:
-			return "type TMA coproc";
-		case 0x0D:
-			return "type A650E ";
-		case 0x18:
-			return "type TMA coproc Australian";
-		case 0x19:
-			return "type A650A ";
-		case 0x26:
-			return "type TMA coproc European";
-		case 0x2E:
-			return "type A655 ";
-		case 0x2F:
-			return "type A655A ";
-		case 0x30:
-			return "type A655E ";
-		case 0x0B:
-			return "type A670 ";
-		case 0x0C:
-			return "type A670E ";
-		case 0x2D:
-			return "type A670A ";
-		case 0x0F:
-			return "type A411T";
-		case 0x16:
-			return "type A411TA";
-		case 0x1B:
-			return "type A440T";
-		case 0x1C:
-			return "type A412T";
-		case 0x1E:
-			return "type A412TA";
-		case 0x22:
-			return "type A411TE";
-		case 0x24:
-			return "type A412TE";
-		case 0x27:
-			return "type A671T ";
-		case 0x29:
-			return "type A671TA ";
-		case 0x2B:
-			return "type A671TE ";
-		case 0x31:
-			return "type A415T ";
-		case 0x33:
-			return "type A415TA ";
-		case 0x35:
-			return "type A415TE ";
-		case 0x37:
-			return "type A672";
-		case 0x39:
-			return "type A672A ";
-		case 0x3B:
-			return "type A672T";
-		case 0x6B:
-			return "type IC2200";
-		default:
-			return "type A672T";
+	switch (hardwareType) {
+	case 0x00:
+		return "type A450";
+	case 0x01:
+		return "type A650 ";
+	case 0x04:
+		return "type TMA coproc";
+	case 0x0D:
+		return "type A650E ";
+	case 0x18:
+		return "type TMA coproc Australian";
+	case 0x19:
+		return "type A650A ";
+	case 0x26:
+		return "type TMA coproc European";
+	case 0x2E:
+		return "type A655 ";
+	case 0x2F:
+		return "type A655A ";
+	case 0x30:
+		return "type A655E ";
+	case 0x0B:
+		return "type A670 ";
+	case 0x0C:
+		return "type A670E ";
+	case 0x2D:
+		return "type A670A ";
+	case 0x0F:
+		return "type A411T";
+	case 0x16:
+		return "type A411TA";
+	case 0x1B:
+		return "type A440T";
+	case 0x1C:
+		return "type A412T";
+	case 0x1E:
+		return "type A412TA";
+	case 0x22:
+		return "type A411TE";
+	case 0x24:
+		return "type A412TE";
+	case 0x27:
+		return "type A671T ";
+	case 0x29:
+		return "type A671TA ";
+	case 0x2B:
+		return "type A671TE ";
+	case 0x31:
+		return "type A415T ";
+	case 0x33:
+		return "type A415TA ";
+	case 0x35:
+		return "type A415TE ";
+	case 0x37:
+		return "type A672";
+	case 0x39:
+		return "type A672A ";
+	case 0x3B:
+		return "type A672T";
+	case 0x6B:
+		return "type IC2200";
+	default:
+		return "type A672T";
 	}
 }
 #ifdef ARLAN_DEBUGGING
@@ -193,12 +199,12 @@ static void arlan_print_diagnostic_info(struct net_device *dev)
 	struct arlan_private *priv = netdev_priv(dev);
 	volatile struct arlan_shmem __iomem *arlan = priv->card;
 
-	//  ARLAN_DEBUG_ENTRY("arlan_print_diagnostic_info");
+	/* ARLAN_DEBUG_ENTRY("arlan_print_diagnostic_info"); */
 
 	if (READSHMB(arlan->configuredStatusFlag) == 0)
-		printk("Arlan: Card NOT configured\n");
+		printk(KERN_WARNING "Arlan: Card NOT configured\n");
 	else
-		printk("Arlan: Card is configured\n");
+		printk(KERN_INFO "Arlan: Card is configured\n");
 
 	READSHM(diagnosticInfo, arlan->diagnosticInfo, u_char);
 	READSHM(diagnosticOffset, arlan->diagnosticOffset, u_short);
@@ -206,14 +212,15 @@ static void arlan_print_diagnostic_info(struct net_device *dev)
 	printk(KERN_INFO "%s\n", arlan_diagnostic_info_string(dev));
 
 	if (diagnosticInfo != 0xff)
-		printk("%s arlan: Diagnostic Offset %d \n", dev->name, diagnosticOffset);
+		printk(KERN_INFO "%s arlan: Diagnostic Offset %d\n",\
+			dev->name, diagnosticOffset);
 
-	printk("arlan: LAN CODE ID = ");
+	printk(KERN_INFO "arlan: LAN CODE ID = ");
 	for (i = 0; i < 6; i++)
 		DEBUGSHM(1, "%03d:", arlan->lanCardNodeId[i], u_char);
 	printk("\n");
 
-	printk("arlan: Arlan BroadCast address  = ");
+	printk(KERN_INFO "arlan: Arlan BroadCast address  = ");
 	for (i = 0; i < 6; i++)
 		DEBUGSHM(1, "%03d:", arlan->broadcastAddress[i], u_char);
 	printk("\n");
@@ -229,13 +236,13 @@ static void arlan_print_diagnostic_info(struct net_device *dev)
 	DEBUGSHM(1, "arlan: SID	=%d\n", arlan->SID, u_short);
 	DEBUGSHM(1, "arlan: rxOffset=%d\n", arlan->rxOffset, u_short);
 
-	DEBUGSHM(1, "arlan: registration mode is %d\n", arlan->registrationMode, u_char);
+	DEBUGSHM(1, "arlan: registration mode is %d\n",\
+		arlan->registrationMode, u_char);
 
-	printk("arlan: name= ");
+	printk(KERN_INFO "arlan: name= ");
 	IFDEBUG(1)
-	
-	for (i = 0; i < 16; i++)
-	{
+
+	for (i = 0; i < 16; i++) {
 		char c;
 		READSHM(c, arlan->name[i], char);
 		if (c)
@@ -243,18 +250,19 @@ static void arlan_print_diagnostic_info(struct net_device *dev)
 	}
 	printk("\n");
 
-//   ARLAN_DEBUG_EXIT("arlan_print_diagnostic_info");
+	/* ARLAN_DEBUG_EXIT("arlan_print_diagnostic_info"); */
 
 }
 
 
-/******************************		TEST 	MEMORY	**************/
+/******************************	TEST MEMORY	**************/
 
 static int arlan_hw_test_memory(struct net_device *dev)
 {
 	u_char *ptr;
 	int i;
-	int memlen = sizeof(struct arlan_shmem) - 0xF;	/* avoid control register */
+	int memlen = sizeof(struct arlan_shmem) - 0xF;	/* avoid
+										control register */
 	volatile char *arlan_mem = (char *) (dev->mem_start);
 	struct arlan_private *priv = netdev_priv(dev);
 	volatile struct arlan_shmem __iomem *arlan = priv->card;
@@ -271,13 +279,11 @@ static int arlan_hw_test_memory(struct net_device *dev)
 		WRITESHM(arlan_mem[i], ((u_char) pattern++), u_char);
 
 	pattern = 0;
-	for (i = 0; i < memlen; i++)
-	{
+	for (i = 0; i < memlen; i++) {
 		char res;
 		READSHM(res, arlan_mem[i], char);
-		if (res != pattern++)
-		{
-			printk(KERN_ERR "Arlan driver memory test 1 failed \n");
+		if (res != pattern++) {
+			printk(KERN_ERR "Arlan driver memory test 1 failed\n");
 			return -1;
 		}
 	}
@@ -287,13 +293,11 @@ static int arlan_hw_test_memory(struct net_device *dev)
 		WRITESHM(arlan_mem[i], ~(pattern++), char);
 
 	pattern = 0;
-	for (i = 0; i < memlen; i++)
-	{
+	for (i = 0; i < memlen; i++) {
 		char res;
 		READSHM(res, arlan_mem[i], char);
-		if (res != ~(pattern++))
-		{
-			printk(KERN_ERR "Arlan driver memory test 2 failed \n");
+		if (res != ~(pattern++)) {
+			printk(KERN_ERR "Arlan driver memory test 2 failed\n");
 			return -1;
 		}
 	}
@@ -311,9 +315,9 @@ static int arlan_hw_test_memory(struct net_device *dev)
 	clearHardwareReset(dev);
 
 	/* wait for reset flag to become zero, we'll wait for two seconds */
-	if (arlan_command(dev, ARLAN_COMMAND_LONG_WAIT_NOW))
-	{
-		printk(KERN_ERR "%s arlan: failed to come back from memory test\n", dev->name);
+	if (arlan_command(dev, ARLAN_COMMAND_LONG_WAIT_NOW)) {
+		printk(KERN_ERR "%s arlan: failed to come\
+			back from memory test\n", dev->name);
 		return -1;
 	}
 	return 0;
@@ -325,29 +329,32 @@ static int arlan_setup_card_by_book(struct net_device *dev)
 	struct arlan_private *priv = netdev_priv(dev);
 	volatile struct arlan_shmem __iomem *arlan = priv->card;
 
-//	ARLAN_DEBUG_ENTRY("arlan_setup_card");
+	/* ARLAN_DEBUG_ENTRY("arlan_setup_card"); */
 
 	READSHM(configuredStatusFlag, arlan->configuredStatusFlag, u_char);
 
 	IFDEBUG(10)
 	if (configuredStatusFlag != 0)
-		IFDEBUG(10) printk("arlan: CARD IS CONFIGURED\n");
+		IFDEBUG(10) printk(KERN_INFO "arlan: CARD IS CONFIGURED\n");
 	else
-		IFDEBUG(10) printk("arlan: card is NOT configured\n");
+		IFDEBUG(10) printk(KERN_WARNING\
+			"arlan: card is NOT configured\n");
 
 	if (testMemory || (READSHMB(arlan->diagnosticInfo) != 0xff))
 		if (arlan_hw_test_memory(dev))
 			return -1;
 
-	DEBUGSHM(4, "arlan configuredStatus = %d \n", arlan->configuredStatusFlag, u_char);
-	DEBUGSHM(4, "arlan driver diagnostic: 0x%2x\n", arlan->diagnosticInfo, u_char);
+	DEBUGSHM(4, "arlan configuredStatus = %d\n",\
+		arlan->configuredStatusFlag, u_char);
+	DEBUGSHM(4, "arlan driver diagnostic: 0x%2x\n",\
+		arlan->diagnosticInfo, u_char);
 
 	/* issue nop command - no interrupt */
 	arlan_command(dev, ARLAN_COMMAND_NOOP);
 	if (arlan_command(dev, ARLAN_COMMAND_WAIT_NOW) != 0)
 		return -1;
 
-	IFDEBUG(50) printk("1st Noop successfully executed !!\n");
+	IFDEBUG(50) printk(KERN_INFO "1st Noop successfully executed !!\n");
 
 	/* try to turn on the arlan interrupts */
 	clearClearInterrupt(dev);
@@ -361,18 +368,18 @@ static int arlan_setup_card_by_book(struct net_device *dev)
 		return -1;
 
 
-	IFDEBUG(50) printk("2nd Noop successfully executed !!\n");
+	IFDEBUG(50) printk(KERN_INFO "2nd Noop successfully executed !!\n");
 
 	READSHM(irqLevel, arlan->irqLevel, u_char)
-	
-	if (irqLevel != dev->irq)
-	{
-		IFDEBUG(1) printk(KERN_WARNING "arlan dip switches set irq to %d\n", irqLevel);
-		printk(KERN_WARNING "device driver irq set to %d - does not match\n", dev->irq);
+
+	if (irqLevel != dev->irq) {
+		IFDEBUG(1) printk(KERN_WARNING "arlan dip switches\
+			set irq to %d\n", irqLevel);
+		printk(KERN_WARNING "device driver irq set to %d-\
+			does not match\n", dev->irq);
 		dev->irq = irqLevel;
-	}
-	else
-		IFDEBUG(2) printk("irq level is OK\n");
+	} else
+		IFDEBUG(2) printk(KERN_INFO "irq level is OK\n");
 
 
 	IFDEBUG(3) arlan_print_diagnostic_info(dev);
@@ -380,8 +387,7 @@ static int arlan_setup_card_by_book(struct net_device *dev)
 	arlan_command(dev, ARLAN_COMMAND_CONF);
 
 	READSHM(configuredStatusFlag, arlan->configuredStatusFlag, u_char);
-	if (configuredStatusFlag == 0)
-	{
+	if (configuredStatusFlag == 0) {
 		printk(KERN_WARNING "arlan configure failed\n");
 		return -1;
 	}
@@ -391,7 +397,7 @@ static int arlan_setup_card_by_book(struct net_device *dev)
 	printk(KERN_NOTICE "%s: arlan driver version %s loaded\n",
 	       dev->name, arlan_version);
 
-//	ARLAN_DEBUG_EXIT("arlan_setup_card");
+	/* ARLAN_DEBUG_EXIT("arlan_setup_card"); */
 
 	return 0;		/* no errors */
 }
@@ -402,7 +408,7 @@ static int arlan_setup_card_by_book(struct net_device *dev)
 
 static char arlan_drive_info[ARLAN_STR_SIZE] = "A655\n\0";
 
-static int arlan_sysctl_info(ctl_table * ctl, int write,
+static int arlan_sysctl_info(ctl_table *ctl, int write,
 		      void __user *buffer, size_t * lenp, loff_t *ppos)
 {
 	int i;
@@ -410,35 +416,30 @@ static int arlan_sysctl_info(ctl_table * ctl, int write,
 	struct arlan_private *priva = NULL;
 	struct net_device *dev;
 	pos = 0;
-	if (write)
-	{
-		printk("wrirte: ");
+	if (write) {
+		printk(KERN_INFO "wrirte: ");
 		for (i = 0; i < 100; i++)
-			printk("adi %x \n", arlan_drive_info[i]);
+			printk("adi %x\n", arlan_drive_info[i]);
 	}
-	if (ctl->procname == NULL || arlan_drive_info == NULL)
-	{
-		printk(KERN_WARNING " procname is NULL in sysctl_table or arlan_drive_info is NULL \n at arlan module\n ");
+	if (ctl->procname == NULL || arlan_drive_info == NULL) {
+		printk(KERN_WARNING " procname is NULL in sysctl_table or arlan_drive_info is NULL\n at arlan module\n ");
 		return -1;
 	}
 	devnum = ctl->procname[5] - '0';
-	if (devnum < 0 || devnum > MAX_ARLANS - 1)
-	{
+	if (devnum < 0 || devnum > MAX_ARLANS - 1) {
 		printk(KERN_WARNING "too strange devnum in procfs parse\n ");
 		return -1;
-	}
-	else if (arlan_device[devnum] == NULL)
-	{
+	} else if (arlan_device[devnum] == NULL) {
 		if (ctl->procname)
-			pos += sprintf(arlan_drive_info + pos, "\t%s\n\n", ctl->procname);
-		pos += sprintf(arlan_drive_info + pos, "No device found here \n");
+			pos += sprintf(arlan_drive_info + pos,\
+				"\t%s\n\n", ctl->procname);
+		pos += sprintf(arlan_drive_info + pos,\
+			"No device found here\n");
 		goto final;
-	}
-	else
+	} else
 		priva = netdev_priv(arlan_device[devnum]);
 
-	if (priva == NULL)
-	{
+	if (priva == NULL) {
 		printk(KERN_WARNING " Could not find the device private in arlan procsys, bad\n ");
 		return -1;
 	}
@@ -446,17 +447,19 @@ static int arlan_sysctl_info(ctl_table * ctl, int write,
 
 	memcpy_fromio(priva->conf, priva->card, sizeof(struct arlan_shmem));
 
-	pos = sprintf(arlan_drive_info, "Arlan  info \n");
+	pos = sprintf(arlan_drive_info, "Arlan  info\n");
 	/* Header Signature */
 	SARLSTR(textRegion, 48);
 	SARLUC(resetFlag);
-	pos += sprintf(arlan_drive_info + pos, "diagnosticInfo\t=\t%s \n", arlan_diagnostic_info_string(dev));
+	pos += sprintf(arlan_drive_info + pos,\
+		"diagnosticInfo\t=\t%s\n", arlan_diagnostic_info_string(dev));
 	SARLUC(diagnosticInfo);
 	SARLUS(diagnosticOffset);
 	SARLUCN(_1, 12);
 	SARLUCN(lanCardNodeId, 6);
 	SARLUCN(broadcastAddress, 6);
-	pos += sprintf(arlan_drive_info + pos, "hardwareType =\t  %s \n", arlan_hardware_type_string(dev));
+	pos += sprintf(arlan_drive_info + pos,\
+		"hardwareType =\t  %s\n", arlan_hardware_type_string(dev));
 	SARLUC(hardwareType);
 	SARLUC(majorHardwareVersion);
 	SARLUC(minorHardwareVersion);
@@ -602,17 +605,18 @@ static int arlan_sysctl_info(ctl_table * ctl, int write,
 	SARLUCN(dumpPtr, 4);
 	SARLUC(dumpVal);
 	SARLUC(wireTest);
-	
+
 	/* next 4 seems too long for procfs, over single page ?
 	SARLUCN( _17, 0x86);
 	SARLUCN( txBuffer, 0x800);
-	SARLUCN( rxBuffer,  0x800); 
+	SARLUCN( rxBuffer,  0x800);
 	SARLUCN( _18, 0x0bff);
 	 */
 
 	pos += sprintf(arlan_drive_info + pos, "rxRing\t=\t0x");
 	for (i = 0; i < 0x50; i++)
-		pos += sprintf(arlan_drive_info + pos, "%02x", ((char *) priva->conf)[priva->conf->rxOffset + i]);
+		pos += sprintf(arlan_drive_info + pos, "%02x",\
+			((char *) priva->conf)[priva->conf->rxOffset + i]);
 	pos += sprintf(arlan_drive_info + pos, "\n");
 
 	SARLUC(configStatus);
@@ -624,14 +628,14 @@ static int arlan_sysctl_info(ctl_table * ctl, int write,
 	pos += sprintf(arlan_drive_info + pos, " total %d chars\n", pos);
 	if (ctl)
 		if (ctl->procname)
-			pos += sprintf(arlan_drive_info + pos, " driver name : %s\n", ctl->procname);
+			pos += sprintf(arlan_drive_info + pos,\
+				" driver name : %s\n", ctl->procname);
 final:
 	*lenp = pos;
 
 	if (!write)
 		retv = proc_dostring(ctl, write, buffer, lenp, ppos);
-	else
-	{
+	else {
 		*lenp = 0;
 		return -1;
 	}
@@ -639,7 +643,7 @@ final:
 }
 
 
-static int arlan_sysctl_info161719(ctl_table * ctl, int write,
+static int arlan_sysctl_info161719(ctl_table *ctl, int write,
 			    void __user *buffer, size_t * lenp, loff_t *ppos)
 {
 	int i;
@@ -648,16 +652,16 @@ static int arlan_sysctl_info161719(ctl_table * ctl, int write,
 
 	pos = 0;
 	devnum = ctl->procname[5] - '0';
-	if (arlan_device[devnum] == NULL)
-	{
-		pos += sprintf(arlan_drive_info + pos, "No device found here \n");
+	if (arlan_device[devnum] == NULL) {
+		pos += sprintf(arlan_drive_info + pos,\
+			"No device found here\n");
 		goto final;
-	}
-	else
+	} else
 		priva = netdev_priv(arlan_device[devnum]);
-	if (priva == NULL)
-	{
-		printk(KERN_WARNING " Could not find the device private in arlan procsys, bad\n ");
+
+	if (priva == NULL) {
+		printk(KERN_WARNING " Could not find the device\
+			private in arlan procsys, bad\n ");
 		return -1;
 	}
 	memcpy_fromio(priva->conf, priva->card, sizeof(struct arlan_shmem));
@@ -673,7 +677,7 @@ final:
 	return retv;
 }
 
-static int arlan_sysctl_infotxRing(ctl_table * ctl, int write,
+static int arlan_sysctl_infotxRing(ctl_table *ctl, int write,
 			    void __user *buffer, size_t * lenp, loff_t *ppos)
 {
 	int i;
@@ -682,15 +686,14 @@ static int arlan_sysctl_infotxRing(ctl_table * ctl, int write,
 
 	pos = 0;
 	devnum = ctl->procname[5] - '0';
-	if (arlan_device[devnum] == NULL)
-	{
-		  pos += sprintf(arlan_drive_info + pos, "No device found here \n");
-		  goto final;
-	}
-	else
+	if (arlan_device[devnum] == NULL) {
+		pos += sprintf(arlan_drive_info + pos,\
+			"No device found here\n");
+		goto final;
+	} else
 		priva = netdev_priv(arlan_device[devnum]);
-	if (priva == NULL)
-	{
+
+	if (priva == NULL) {
 		printk(KERN_WARNING " Could not find the device private in arlan procsys, bad\n ");
 		return -1;
 	}
@@ -702,7 +705,7 @@ final:
 	return retv;
 }
 
-static int arlan_sysctl_inforxRing(ctl_table * ctl, int write,
+static int arlan_sysctl_inforxRing(ctl_table *ctl, int write,
 			    void __user *buffer, size_t * lenp, loff_t *ppos)
 {
 	int i;
@@ -711,14 +714,13 @@ static int arlan_sysctl_inforxRing(ctl_table * ctl, int write,
 
 	pos = 0;
 	devnum = ctl->procname[5] - '0';
-	if (arlan_device[devnum] == NULL)
-	{
-		  pos += sprintf(arlan_drive_info + pos, "No device found here \n");
-		  goto final;
+	if (arlan_device[devnum] == NULL) {
+		pos += sprintf(arlan_drive_info + pos,\
+			"No device found here\n");
+		goto final;
 	} else
 		priva = netdev_priv(arlan_device[devnum]);
-	if (priva == NULL)
-	{
+	if (priva == NULL) {
 		printk(KERN_WARNING " Could not find the device private in arlan procsys, bad\n ");
 		return -1;
 	}
@@ -730,7 +732,7 @@ final:
 	return retv;
 }
 
-static int arlan_sysctl_info18(ctl_table * ctl, int write,
+static int arlan_sysctl_info18(ctl_table *ctl, int write,
 			void __user *buffer, size_t * lenp, loff_t *ppos)
 {
 	int i;
@@ -739,18 +741,18 @@ static int arlan_sysctl_info18(ctl_table * ctl, int write,
 
 	pos = 0;
 	devnum = ctl->procname[5] - '0';
-	if (arlan_device[devnum] == NULL)
-	{
-		pos += sprintf(arlan_drive_info + pos, "No device found here \n");
+	if (arlan_device[devnum] == NULL) {
+		pos += sprintf(arlan_drive_info + pos,\
+			"No device found here\n");
 		goto final;
-	}
-	else
+	} else
 		priva = netdev_priv(arlan_device[devnum]);
-	if (priva == NULL)
-	{
+
+	if (priva == NULL) {
 		printk(KERN_WARNING " Could not find the device private in arlan procsys, bad\n ");
 		return -1;
 	}
+
 	memcpy_fromio(priva->conf, priva->card, sizeof(struct arlan_shmem));
 	SARLBNpln(u_char, _18, 0x800);
 
@@ -766,74 +768,73 @@ final:
 
 static char conf_reset_result[200];
 
-static int arlan_configure(ctl_table * ctl, int write,
+static int arlan_configure(ctl_table *ctl, int write,
 		    void __user *buffer, size_t * lenp, loff_t *ppos)
 {
 	int pos = 0;
 	int devnum = ctl->procname[6] - '0';
 	struct arlan_private *priv;
 
-	if (devnum < 0 || devnum > MAX_ARLANS - 1)
-	{
-		  printk(KERN_WARNING "too strange devnum in procfs parse\n ");
+	if (devnum < 0 || devnum > MAX_ARLANS - 1) {
+		  printk(KERN_WARNING "too strange devnum in procfs parse\n");
 		  return -1;
-	}
-	else if (arlan_device[devnum] != NULL)
-	{
-		  priv = netdev_priv(arlan_device[devnum]);
-
-		  arlan_command(arlan_device[devnum], ARLAN_COMMAND_CLEAN_AND_CONF);
-	}
-	else
+	} else if (arlan_device[devnum] != NULL) {
+		priv = netdev_priv(arlan_device[devnum]);
+		arlan_command(arlan_device[devnum],\
+			ARLAN_COMMAND_CLEAN_AND_CONF);
+	} else
 		return -1;
 
 	*lenp = pos;
 	return proc_dostring(ctl, write, buffer, lenp, ppos);
 }
 
-static int arlan_sysctl_reset(ctl_table * ctl, int write,
+static int arlan_sysctl_reset(ctl_table *ctl, int write,
 		       void __user *buffer, size_t * lenp, loff_t *ppos)
 {
 	int pos = 0;
 	int devnum = ctl->procname[5] - '0';
 	struct arlan_private *priv;
 
-	if (devnum < 0 || devnum > MAX_ARLANS - 1)
-	{
-		  printk(KERN_WARNING "too strange devnum in procfs parse\n ");
+	if (devnum < 0 || devnum > MAX_ARLANS - 1) {
+		  printk(KERN_WARNING "too strange devnum in procfs parse\n");
 		  return -1;
-	}
-	else if (arlan_device[devnum] != NULL)
-	{
+
+	} else if (arlan_device[devnum] != NULL) {
 		priv = netdev_priv(arlan_device[devnum]);
-		arlan_command(arlan_device[devnum], ARLAN_COMMAND_CLEAN_AND_RESET);
+		arlan_command(arlan_device[devnum], \
+			ARLAN_COMMAND_CLEAN_AND_RESET);
 
 	} else
 		return -1;
+
 	*lenp = pos + 3;
 	return proc_dostring(ctl, write, buffer, lenp, ppos);
 }
 
 
 /* Place files in /proc/sys/dev/arlan */
-#define CTBLN(card,nam) \
-        { .procname = #nam,\
-          .data = &(arlan_conf[card].nam),\
-          .maxlen = sizeof(int), .mode = 0600, .proc_handler = proc_dointvec}
+#define CTBLN(card, nam) \
+	{ .procname = #nam,\
+	.data = &(arlan_conf[card].nam),\
+	.maxlen = sizeof(int), .mode = 0600, .proc_handler = proc_dointvec}
 #ifdef ARLAN_DEBUGGING
 
-#define ARLAN_PROC_DEBUG_ENTRIES \
-        { .procname = "entry_exit_debug",\
-          .data = &arlan_entry_and_exit_debug,\
-          .maxlen = sizeof(int), .mode = 0600, .proc_handler = proc_dointvec},\
+#define ARLAN_PROC_DEBUG_ENTRIES do {\
+
+	{ .procname = "entry_exit_debug",\
+		.data = &arlan_entry_and_exit_debug,\
+	.maxlen = sizeof(int), .mode = 0600, .proc_handler = proc_dointvec},\
 	{ .procname = "debug", .data = &arlan_debug,\
-          .maxlen = sizeof(int), .mode = 0600, .proc_handler = proc_dointvec},
-#else 
+	.maxlen = sizeof(int), .mode = 0600, .proc_handler = proc_dointvec},
+
+	} while (0)
+#else
 #define ARLAN_PROC_DEBUG_ENTRIES
 #endif
 
 #define ARLAN_SYSCTL_TABLE_TOTAL(cardNo)\
-	CTBLN(cardNo,spreadingCode),\
+	CTBLN(cardNo, spreadingCode),\
 	CTBLN(cardNo, channelNumber),\
 	CTBLN(cardNo, scramblingDisable),\
 	CTBLN(cardNo, txAttenuation),\
@@ -861,43 +862,40 @@ static int arlan_sysctl_reset(ctl_table * ctl, int write,
 	CTBLN(cardNo, rxParameter),\
 	CTBLN(cardNo, txTimeoutMs),\
 	CTBLN(cardNo, waitCardTimeout),\
-	CTBLN(cardNo, channelSet), \
+	CTBLN(cardNo, channelSet),\
 	{ .procname = "name",\
 	 .data = arlan_conf[cardNo].siteName,\
-	 .maxlen = 16, .mode = 0600, .proc_handler = proc_dostring},\
-	CTBLN(cardNo,waitTime),\
-	CTBLN(cardNo,lParameter),\
-	CTBLN(cardNo,_15),\
-	CTBLN(cardNo,headerSize),\
-	CTBLN(cardNo,tx_delay_ms),\
-	CTBLN(cardNo,retries),\
-	CTBLN(cardNo,ReTransmitPacketMaxSize),\
-	CTBLN(cardNo,waitReTransmitPacketMaxSize),\
-	CTBLN(cardNo,fastReTransCount),\
-	CTBLN(cardNo,driverRetransmissions),\
-	CTBLN(cardNo,txAckTimeoutMs),\
-	CTBLN(cardNo,registrationInterrupts),\
-	CTBLN(cardNo,hardwareType),\
-	CTBLN(cardNo,radioType),\
-	CTBLN(cardNo,writeEEPROM),\
-	CTBLN(cardNo,writeRadioType),\
+	 .maxlen = 16, .mode = 0600, .proc_handler = proc_dostring },\
+	CTBLN(cardNo, waitTime),\
+	CTBLN(cardNo, lParameter),\
+	CTBLN(cardNo, _15),\
+	CTBLN(cardNo, headerSize),\
+	CTBLN(cardNo, tx_delay_ms),\
+	CTBLN(cardNo, retries),\
+	CTBLN(cardNo, ReTransmitPacketMaxSize),\
+	CTBLN(cardNo, waitReTransmitPacketMaxSize),\
+	CTBLN(cardNo, fastReTransCount),\
+	CTBLN(cardNo, driverRetransmissions),\
+	CTBLN(cardNo, txAckTimeoutMs),\
+	CTBLN(cardNo, registrationInterrupts),\
+	CTBLN(cardNo, hardwareType),\
+	CTBLN(cardNo, radioType),\
+	CTBLN(cardNo, writeEEPROM),\
+	CTBLN(cardNo, writeRadioType),\
 	ARLAN_PROC_DEBUG_ENTRIES\
-	CTBLN(cardNo,in_speed),\
-	CTBLN(cardNo,out_speed),\
-	CTBLN(cardNo,in_speed10),\
-	CTBLN(cardNo,out_speed10),\
-	CTBLN(cardNo,in_speed_max),\
-	CTBLN(cardNo,out_speed_max),\
-	CTBLN(cardNo,measure_rate),\
-	CTBLN(cardNo,pre_Command_Wait),\
-	CTBLN(cardNo,rx_tweak1),\
-	CTBLN(cardNo,rx_tweak2),\
-	CTBLN(cardNo,tx_queue_len),\
-
-
-
-static ctl_table arlan_conf_table0[] =
-{
+	CTBLN(cardNo, in_speed),\
+	CTBLN(cardNo, out_speed),\
+	CTBLN(cardNo, in_speed10),\
+	CTBLN(cardNo, out_speed10),\
+	CTBLN(cardNo, in_speed_max),\
+	CTBLN(cardNo, out_speed_max),\
+	CTBLN(cardNo, measure_rate),\
+	CTBLN(cardNo, pre_Command_Wait),\
+	CTBLN(cardNo, rx_tweak1),\
+	CTBLN(cardNo, rx_tweak2),\
+	CTBLN(cardNo, tx_queue_len),\
+
+static ctl_table arlan_conf_table0[] = {
 	ARLAN_SYSCTL_TABLE_TOTAL(0)
 
 #ifdef ARLAN_PROC_SHM_DUMP
@@ -954,8 +952,7 @@ static ctl_table arlan_conf_table0[] =
 	{  }
 };
 
-static ctl_table arlan_conf_table1[] =
-{
+static ctl_table arlan_conf_table1[] = {
 
 	ARLAN_SYSCTL_TABLE_TOTAL(1)
 
@@ -1013,8 +1010,7 @@ static ctl_table arlan_conf_table1[] =
 	{ }
 };
 
-static ctl_table arlan_conf_table2[] =
-{
+static ctl_table arlan_conf_table2[] = {
 
 	ARLAN_SYSCTL_TABLE_TOTAL(2)
 
@@ -1072,8 +1068,7 @@ static ctl_table arlan_conf_table2[] =
 	{ }
 };
 
-static ctl_table arlan_conf_table3[] =
-{
+static ctl_table arlan_conf_table3[] = {
 
 	ARLAN_SYSCTL_TABLE_TOTAL(3)
 
@@ -1133,8 +1128,7 @@ static ctl_table arlan_conf_table3[] =
 
 
 
-static ctl_table arlan_table[] =
-{
+static ctl_table arlan_table[] = {
 	{
 		.procname	= "arlan0",
 		.maxlen		= 0,
@@ -1164,17 +1158,15 @@ static ctl_table arlan_table[] =
 
 #else
 
-static ctl_table arlan_table[] =
-{
+static ctl_table arlan_table[] = {
 	{ }
 };
 #endif
 
 
-// static int mmtu = 1234;
+/* static int mmtu = 1234; */
 
-static ctl_table arlan_root_table[] =
-{
+static ctl_table arlan_root_table[] = {
 	{
 		.procname	= "arlan",
 		.maxlen		= 0,
@@ -1189,8 +1181,6 @@ static struct ctl_table_header *arlan_device_sysctl_header;
 
 int __init init_arlan_proc(void)
 {
-
-	int i = 0;
 	if (arlan_device_sysctl_header)
 		return 0;
 	arlan_device_sysctl_header = register_sysctl_table(arlan_root_table);
@@ -1198,7 +1188,6 @@ int __init init_arlan_proc(void)
 		return -1;
 
 	return 0;
-
 }
 
 void __exit cleanup_arlan_proc(void)
-- 
1.7.0.2

