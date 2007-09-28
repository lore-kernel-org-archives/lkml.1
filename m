Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbXI1KsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbXI1KsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 06:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXI1KsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 06:48:14 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:54431 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbXI1KsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 06:48:12 -0400
Message-ID: <46FCDBE9.8030406@tiscali.nl>
Date: Fri, 28 Sep 2007 12:48:09 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] use array_size macro
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes code to use the ARRAY_SIZE macro. This patch is the result of:
find -name *.[chsS] | xargs sed -i "s/sizeof(\(\w*\))[ \t]*\/[ \t]*sizeof(\1\[0\])/ARRAY_SIZE(\1)/g"

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/arm/kernel/dma-isa.c b/arch/arm/kernel/dma-isa.c
index 0a3e9ad..2f080a3 100644
--- a/arch/arm/kernel/dma-isa.c
+++ b/arch/arm/kernel/dma-isa.c
@@ -216,7 +216,7 @@ void __init isa_init_dma(dma_t *dma)
 
 		request_dma(DMA_ISA_CASCADE, "cascade");
 
-		for (i = 0; i < sizeof(dma_resources) / sizeof(dma_resources[0]); i++)
+		for (i = 0; i < ARRAY_SIZE(dma_resources); i++)
 			request_resource(&ioport_resource, dma_resources + i);
 	}
 }
diff --git a/arch/powerpc/platforms/celleb/scc_sio.c b/arch/powerpc/platforms/celleb/scc_sio.c
index bcd25f5..457651d 100644
--- a/arch/powerpc/platforms/celleb/scc_sio.c
+++ b/arch/powerpc/platforms/celleb/scc_sio.c
@@ -52,7 +52,7 @@ static int txx9_serial_init(void)
 	if (!node)
 		return 0;
 
-	for(i = 0; i < sizeof(txx9_scc_tab)/sizeof(txx9_scc_tab[0]); i++) {
+	for(i = 0; i < ARRAY_SIZE(txx9_scc_tab); i++) {
 		if (!(txx9_serial_bitmap & (1<<i)))
 			continue;
 
diff --git a/arch/um/kernel/tt/ptproxy/ptrace.c b/arch/um/kernel/tt/ptproxy/ptrace.c
index 4b4f617..5b526c4 100644
--- a/arch/um/kernel/tt/ptproxy/ptrace.c
+++ b/arch/um/kernel/tt/ptproxy/ptrace.c
@@ -77,7 +77,7 @@ long proxy_ptrace(struct debugger *debugger, int arg1, pid_t arg2,
 		result = ptrace(PTRACE_GETFPREGS, child, 0, regs);
 		if(result == -1) return(-errno);
 		
-		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
+		for (i = 0; i < ARRAY_SIZE(regs); i++)
 			ptrace(PTRACE_POKEDATA, debugger->pid, arg4 + 4 * i,
 			       regs[i]);
 		return(result);
@@ -93,7 +93,7 @@ long proxy_ptrace(struct debugger *debugger, int arg1, pid_t arg2,
 		result = ptrace(PTRACE_GETFPXREGS, child, 0, regs);
 		if(result == -1) return(-errno);
 		
-		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
+		for (i = 0; i < ARRAY_SIZE(regs); i++)
 			ptrace(PTRACE_POKEDATA, debugger->pid, arg4 + 4 * i,
 			       regs[i]);
 		return(result);
@@ -109,7 +109,7 @@ long proxy_ptrace(struct debugger *debugger, int arg1, pid_t arg2,
 		result = ptrace(PTRACE_GETREGS, child, 0, regs);
 		if(result == -1) return(-errno);
 
-		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
+		for (i = 0; i < ARRAY_SIZE(regs); i++)
 			ptrace (PTRACE_POKEDATA, debugger->pid,
 				arg4 + 4 * i, regs[i]);
 		return(result);
@@ -155,7 +155,7 @@ long proxy_ptrace(struct debugger *debugger, int arg1, pid_t arg2,
 		long regs[FP_FRAME_SIZE];
 		int i;
 
-		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
+		for (i = 0; i < ARRAY_SIZE(regs); i++)
 			regs[i] = ptrace (PTRACE_PEEKDATA, debugger->pid,
 					  arg4 + 4 * i, 0);
 		result = ptrace(PTRACE_SETFPREGS, child, 0, regs);
@@ -171,7 +171,7 @@ long proxy_ptrace(struct debugger *debugger, int arg1, pid_t arg2,
 		long regs[FPX_FRAME_SIZE];
 		int i;
 
-		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
+		for (i = 0; i < ARRAY_SIZE(regs); i++)
 			regs[i] = ptrace (PTRACE_PEEKDATA, debugger->pid,
 					  arg4 + 4 * i, 0);
 		result = ptrace(PTRACE_SETFPXREGS, child, 0, regs);
@@ -187,7 +187,7 @@ long proxy_ptrace(struct debugger *debugger, int arg1, pid_t arg2,
 		long regs[FRAME_SIZE];
 		int i;
 
-		for (i = 0; i < sizeof(regs)/sizeof(regs[0]); i++)
+		for (i = 0; i < ARRAY_SIZE(regs); i++)
 			regs[i] = ptrace(PTRACE_PEEKDATA, debugger->pid,
 					 arg4 + 4 * i, 0);
 		result = ptrace(PTRACE_SETREGS, child, 0, regs);
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 2f97d2f..d27001a 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -4717,7 +4717,7 @@ static int register_test(struct slgt_info *info)
 {
 	static unsigned short patterns[] =
 		{0x0000, 0xffff, 0xaaaa, 0x5555, 0x6969, 0x9696};
-	static unsigned int count = sizeof(patterns)/sizeof(patterns[0]);
+	static unsigned int count = ARRAY_SIZE(patterns);
 	unsigned int i;
 	int rc = 0;
 
diff --git a/drivers/net/apne.c b/drivers/net/apne.c
index 9541911..8806151 100644
--- a/drivers/net/apne.c
+++ b/drivers/net/apne.c
@@ -247,7 +247,7 @@ static int __init apne_probe1(struct net_device *dev, int ioaddr)
 	    {0x00,	NE_EN0_RSARHI},
 	    {E8390_RREAD+E8390_START, NE_CMD},
 	};
-	for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(program_seq); i++) {
 	    outb(program_seq[i].value, ioaddr + program_seq[i].offset);
 	}
 
diff --git a/drivers/net/arm/am79c961a.c b/drivers/net/arm/am79c961a.c
index 2143eeb..7796455 100644
--- a/drivers/net/arm/am79c961a.c
+++ b/drivers/net/arm/am79c961a.c
@@ -414,7 +414,7 @@ static void am79c961_setmulticastlist (struct net_device *dev)
 	/*
 	 * Update the multicast hash table
 	 */
-	for (i = 0; i < sizeof(multi_hash) / sizeof(multi_hash[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(multi_hash); i++)
 		write_rreg(dev->base_addr, i + LADRL, multi_hash[i]);
 
 	/*
diff --git a/drivers/net/atl1/atl1_hw.c b/drivers/net/atl1/atl1_hw.c
index ef886bd..9d3bd22 100644
--- a/drivers/net/atl1/atl1_hw.c
+++ b/drivers/net/atl1/atl1_hw.c
@@ -603,7 +603,7 @@ static struct atl1_spi_flash_dev flash_table[] = {
 
 static void atl1_init_flash_opcode(struct atl1_hw *hw)
 {
-	if (hw->flash_vendor >= sizeof(flash_table) / sizeof(flash_table[0]))
+	if (hw->flash_vendor >= ARRAY_SIZE(flash_table))
 		hw->flash_vendor = 0;	/* ATMEL */
 
 	/* Init OP table */
diff --git a/drivers/net/cs89x0.c b/drivers/net/cs89x0.c
index 9774bb1..d0f4a1a 100644
--- a/drivers/net/cs89x0.c
+++ b/drivers/net/cs89x0.c
@@ -806,7 +806,7 @@ cs89x0_probe1(struct net_device *dev, int ioaddr, int modular)
 		        i = cs8900_irq_map[0];
 #else
 			/* Translate the IRQ using the IRQ mapping table. */
-			if (i >= sizeof(cs8900_irq_map)/sizeof(cs8900_irq_map[0]))
+			if (i >= ARRAY_SIZE(cs8900_irq_map))
 				printk("\ncs89x0: invalid ISA interrupt number %d\n", i);
 			else
 				i = cs8900_irq_map[i];
@@ -1247,11 +1247,11 @@ write_irq(struct net_device *dev, int chip_type, int irq)
 
 	if (chip_type == CS8900) {
 		/* Search the mapping table for the corresponding IRQ pin. */
-		for (i = 0; i != sizeof(cs8900_irq_map)/sizeof(cs8900_irq_map[0]); i++)
+		for (i = 0; i != ARRAY_SIZE(cs8900_irq_map); i++)
 			if (cs8900_irq_map[i] == irq)
 				break;
 		/* Not found */
-		if (i == sizeof(cs8900_irq_map)/sizeof(cs8900_irq_map[0]))
+		if (i == ARRAY_SIZE(cs8900_irq_map))
 			i = 3;
 		writereg(dev, PP_CS8900_ISAINT, i);
 	} else {
diff --git a/drivers/net/fec_8xx/fec_mii.c b/drivers/net/fec_8xx/fec_mii.c
index b3fa0d6..d290611 100644
--- a/drivers/net/fec_8xx/fec_mii.c
+++ b/drivers/net/fec_8xx/fec_mii.c
@@ -308,12 +308,12 @@ int fec_mii_phy_id_detect(struct net_device *dev)
 		return -1;
 	}
 
-	for (i = 0, phy = phy_info; i < sizeof(phy_info) / sizeof(phy_info[0]);
+	for (i = 0, phy = phy_info; i < ARRAY_SIZE(phy_info);
 	     i++, phy++)
 		if (phy->id == (phy_hwid >> 4) || phy->id == 0)
 			break;
 
-	if (i >= sizeof(phy_info) / sizeof(phy_info[0])) {
+	if (i >= ARRAY_SIZE(phy_info)) {
 		printk(KERN_ERR DRV_MODULE_NAME
 		       ": %s PHY id 0x%08x is not supported!\n",
 		       dev->name, phy_hwid);
diff --git a/drivers/net/ibm_emac/ibm_emac_debug.c b/drivers/net/ibm_emac/ibm_emac_debug.c
index 92f970d..1f70906 100644
--- a/drivers/net/ibm_emac/ibm_emac_debug.c
+++ b/drivers/net/ibm_emac/ibm_emac_debug.c
@@ -132,7 +132,7 @@ void emac_dbg_register(int idx, struct ocp_enet_private *dev)
 {
 	unsigned long flags;
 
-	if (idx >= sizeof(__emacs) / sizeof(__emacs[0])) {
+	if (idx >= ARRAY_SIZE(__emacs)) {
 		printk(KERN_WARNING
 		       "invalid index %d when registering EMAC for debugging\n",
 		       idx);
@@ -148,7 +148,7 @@ void mal_dbg_register(int idx, struct ibm_ocp_mal *mal)
 {
 	unsigned long flags;
 
-	if (idx >= sizeof(__mals) / sizeof(__mals[0])) {
+	if (idx >= ARRAY_SIZE(__mals)) {
 		printk(KERN_WARNING
 		       "invalid index %d when registering MAL for debugging\n",
 		       idx);
@@ -167,11 +167,11 @@ void emac_dbg_dump_all(void)
 
 	local_irq_save(flags);
 
-	for (i = 0; i < sizeof(__mals) / sizeof(__mals[0]); ++i)
+	for (i = 0; i < ARRAY_SIZE(__mals); ++i)
 		if (__mals[i])
 			emac_mal_dump(__mals[i]);
 
-	for (i = 0; i < sizeof(__emacs) / sizeof(__emacs[0]); ++i)
+	for (i = 0; i < ARRAY_SIZE(__emacs); ++i)
 		if (__emacs[i])
 			emac_mac_dump(i, __emacs[i]);
 
diff --git a/drivers/net/ne-h8300.c b/drivers/net/ne-h8300.c
index 38fd525..7599d77 100644
--- a/drivers/net/ne-h8300.c
+++ b/drivers/net/ne-h8300.c
@@ -259,7 +259,7 @@ static int __init ne_probe1(struct net_device *dev, int ioaddr)
 			{E8390_RREAD+E8390_START, E8390_CMD},
 		};
 
-		for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++)
+		for (i = 0; i < ARRAY_SIZE(program_seq); i++)
 			outb_p(program_seq[i].value, ioaddr + program_seq[i].offset);
 
 	}
diff --git a/drivers/net/ne.c b/drivers/net/ne.c
index c9f74bf..eac2fa6 100644
--- a/drivers/net/ne.c
+++ b/drivers/net/ne.c
@@ -377,7 +377,7 @@ static int __init ne_probe1(struct net_device *dev, unsigned long ioaddr)
 			{E8390_RREAD+E8390_START, E8390_CMD},
 		};
 
-		for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++)
+		for (i = 0; i < ARRAY_SIZE(program_seq); i++)
 			outb_p(program_seq[i].value, ioaddr + program_seq[i].offset);
 
 	}
diff --git a/drivers/net/ne2.c b/drivers/net/ne2.c
index 089b5bb..c6c2a91 100644
--- a/drivers/net/ne2.c
+++ b/drivers/net/ne2.c
@@ -432,7 +432,7 @@ static int __init ne2_probe1(struct net_device *dev, int slot)
 			{E8390_RREAD+E8390_START, E8390_CMD},
 		};
 
-		for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++)
+		for (i = 0; i < ARRAY_SIZE(program_seq); i++)
 			outb_p(program_seq[i].value, base_addr +
 				program_seq[i].offset);
 
diff --git a/drivers/net/ne2k-pci.c b/drivers/net/ne2k-pci.c
index f81d939..9c2abcc 100644
--- a/drivers/net/ne2k-pci.c
+++ b/drivers/net/ne2k-pci.c
@@ -308,7 +308,7 @@ static int __devinit ne2k_pci_init_one (struct pci_dev *pdev,
 			{0x00,	EN0_RSARHI},
 			{E8390_RREAD+E8390_START, E8390_CMD},
 		};
-		for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++)
+		for (i = 0; i < ARRAY_SIZE(program_seq); i++)
 			outb(program_seq[i].value, ioaddr + program_seq[i].offset);
 
 	}
diff --git a/drivers/net/netxen/netxen_nic_hw.c b/drivers/net/netxen/netxen_nic_hw.c
index a7b8d7f..edc2b93 100644
--- a/drivers/net/netxen/netxen_nic_hw.c
+++ b/drivers/net/netxen/netxen_nic_hw.c
@@ -569,7 +569,7 @@ int netxen_is_flash_supported(struct netxen_adapter *adapter)
 	/* if the flash size less than 4Mb, make huge war cry and die */
 	for (j = 1; j < 4; j++) {
 		addr = j * NETXEN_NIC_WINDOW_MARGIN;
-		for (i = 0; i < (sizeof(locs) / sizeof(locs[0])); i++) {
+		for (i = 0; i < (ARRAY_SIZE(locs)); i++) {
 			if (netxen_rom_fast_read(adapter, locs[i], &val01) == 0
 			    && netxen_rom_fast_read(adapter, (addr + locs[i]),
 						    &val02) == 0) {
diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index 50dff1b..2f3c4dc 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -232,7 +232,7 @@ static int get_prom(struct pcmcia_device *link)
     axnet_reset_8390(dev);
     mdelay(10);
 
-    for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++)
+    for (i = 0; i < ARRAY_SIZE(program_seq); i++)
 	outb_p(program_seq[i].value, ioaddr + program_seq[i].offset);
 
     for (i = 0; i < 6; i += 2) {
diff --git a/drivers/net/pcmcia/pcnet_cs.c b/drivers/net/pcmcia/pcnet_cs.c
index 63de89e..a28eb6a 100644
--- a/drivers/net/pcmcia/pcnet_cs.c
+++ b/drivers/net/pcmcia/pcnet_cs.c
@@ -375,7 +375,7 @@ static hw_info_t *get_prom(struct pcmcia_device *link)
     pcnet_reset_8390(dev);
     mdelay(10);
 
-    for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++)
+    for (i = 0; i < ARRAY_SIZE(program_seq); i++)
 	outb_p(program_seq[i].value, ioaddr + program_seq[i].offset);
 
     for (i = 0; i < 32; i++)
diff --git a/drivers/net/sk98lin/skgesirq.c b/drivers/net/sk98lin/skgesirq.c
index 3e7aa49..e5ee6d6 100644
--- a/drivers/net/sk98lin/skgesirq.c
+++ b/drivers/net/sk98lin/skgesirq.c
@@ -892,7 +892,7 @@ int		Port)		/* Which port should be checked */
 	 */
 	RxCts = 0;
 
-	for (i = 0; i < sizeof(SkGeRxRegs)/sizeof(SkGeRxRegs[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(SkGeRxRegs); i++) {
 		
 		(void)SkXmMacStatistic(pAC, IoC, Port, SkGeRxRegs[i], &RxTmp);
 		
diff --git a/drivers/net/zorro8390.c b/drivers/net/zorro8390.c
index d85e2ea..29f9750 100644
--- a/drivers/net/zorro8390.c
+++ b/drivers/net/zorro8390.c
@@ -191,7 +191,7 @@ static int __devinit zorro8390_init(struct net_device *dev,
 	    {0x00,	NE_EN0_RSARHI},
 	    {E8390_RREAD+E8390_START, NE_CMD},
 	};
-	for (i = 0; i < sizeof(program_seq)/sizeof(program_seq[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(program_seq); i++) {
 	    z_writeb(program_seq[i].value, ioaddr + program_seq[i].offset);
 	}
     }
diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
index 52f8c79..69db8b2 100644
--- a/drivers/serial/68328serial.c
+++ b/drivers/serial/68328serial.c
@@ -1429,10 +1429,10 @@ static void m68328_set_baud(void)
 	USTCNT = ustcnt & ~USTCNT_TXEN;
 
 again:
-	for (i = 0; i < sizeof(baud_table) / sizeof(baud_table[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(baud_table); i++)
 		if (baud_table[i] == m68328_console_baud)
 			break;
-	if (i >= sizeof(baud_table) / sizeof(baud_table[0])) {
+	if (i >= ARRAY_SIZE(baud_table)) {
 		m68328_console_baud = 9600;
 		goto again;
 	}
diff --git a/drivers/serial/mcfserial.c b/drivers/serial/mcfserial.c
index 99af084..bd8d4b6 100644
--- a/drivers/serial/mcfserial.c
+++ b/drivers/serial/mcfserial.c
@@ -147,7 +147,7 @@ static int mcfrs_baud_table[] = {
 	9600, 19200, 38400, 57600, 115200, 230400, 460800, 0
 };
 #define MCFRS_BAUD_TABLE_SIZE \
-			(sizeof(mcfrs_baud_table)/sizeof(mcfrs_baud_table[0]))
+			(ARRAY_SIZE(mcfrs_baud_table))
 
 
 #ifdef CONFIG_MAGIC_SYSRQ
diff --git a/include/asm-parisc/mmzone.h b/include/asm-parisc/mmzone.h
index 9608d2c..b0077a5 100644
--- a/include/asm-parisc/mmzone.h
+++ b/include/asm-parisc/mmzone.h
@@ -51,7 +51,7 @@ static inline int pfn_to_nid(unsigned long pfn)
 		return 0;
 
 	i = pfn >> PFNNID_SHIFT;
-	BUG_ON(i >= sizeof(pfnnid_map) / sizeof(pfnnid_map[0]));
+	BUG_ON(i >= ARRAY_SIZE(pfnnid_map));
 	r = pfnnid_map[i];
 	BUG_ON(r == 0xff);
 
diff --git a/net/atm/proc.c b/net/atm/proc.c
index 99fc1fe..a3e52ff 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -175,7 +175,7 @@ static void pvc_info(struct seq_file *seq, struct atm_vcc *vcc)
 
 	seq_printf(seq, "%3d %3d %5d %-3s %7d %-5s %7d %-6s",
 	    vcc->dev->number,vcc->vpi,vcc->vci,
-	    vcc->qos.aal >= sizeof(aal_name)/sizeof(aal_name[0]) ? "err" :
+	    vcc->qos.aal >= ARRAY_SIZE(aal_name) ? "err" :
 	    aal_name[vcc->qos.aal],vcc->qos.rxtp.min_pcr,
 	    class_name[vcc->qos.rxtp.traffic_class],vcc->qos.txtp.min_pcr,
 	    class_name[vcc->qos.txtp.traffic_class]);
