Return-Path: <linux-kernel-owner+w=401wt.eu-S1763560AbXJNSgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763560AbXJNSgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762534AbXJNSfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:35:25 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47924 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761404AbXJNSfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:35:21 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] long vs. unsigned long - low-hanging fruits in drivers
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1Ih8J6-00042n-6l@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:35:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


deal with signedness of the stuff passed to set_bit() et.al.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/kernel/scx200_32.c               |    2 +-
 drivers/atm/ambassador.h                  |    2 +-
 drivers/atm/horizon.h                     |    2 +-
 drivers/char/dsp56k.c                     |    2 +-
 drivers/char/rio/host.h                   |    2 +-
 drivers/char/riscom8.h                    |    2 +-
 drivers/char/sx.h                         |    4 ++--
 drivers/fc4/fcp_impl.h                    |    2 +-
 drivers/isdn/hisax/hisax.h                |    2 +-
 drivers/isdn/hisax/hisax_if.h             |    2 +-
 drivers/net/ni65.c                        |    2 +-
 drivers/net/wan/cosa.c                    |    4 ++--
 drivers/net/wireless/hostap/hostap_wlan.h |    2 +-
 drivers/net/wireless/ray_cs.h             |    4 ++--
 include/linux/agpgart.h                   |    2 +-
 include/linux/hdlcdrv.h                   |    2 +-
 include/linux/scx200_gpio.h               |    8 ++++----
 include/linux/stallion.h                  |    2 +-
 sound/pci/bt87x.c                         |    2 +-
 19 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/scx200_32.c b/arch/x86/kernel/scx200_32.c
index 4875977..87bc159 100644
--- a/arch/x86/kernel/scx200_32.c
+++ b/arch/x86/kernel/scx200_32.c
@@ -24,7 +24,7 @@ MODULE_DESCRIPTION("NatSemi SCx200 Driver");
 MODULE_LICENSE("GPL");
 
 unsigned scx200_gpio_base = 0;
-long scx200_gpio_shadow[2];
+unsigned long scx200_gpio_shadow[2];
 
 unsigned scx200_cb_base = 0;
 
diff --git a/drivers/atm/ambassador.h b/drivers/atm/ambassador.h
index 8296420..ff2a303 100644
--- a/drivers/atm/ambassador.h
+++ b/drivers/atm/ambassador.h
@@ -626,7 +626,7 @@ typedef struct {
 
 struct amb_dev {
   u8               irq;
-  long		   flags;
+  unsigned long	   flags;
   u32              iobase;
   u32 *            membase;
 
diff --git a/drivers/atm/horizon.h b/drivers/atm/horizon.h
index 4461229..b48859d 100644
--- a/drivers/atm/horizon.h
+++ b/drivers/atm/horizon.h
@@ -423,7 +423,7 @@ struct hrz_dev {
   wait_queue_head_t   tx_queue;
 
   u8                  irq;
-  long		      flags;
+  unsigned long	      flags;
   u8                  tx_last;
   u8                  tx_idle;
 
diff --git a/drivers/char/dsp56k.c b/drivers/char/dsp56k.c
index acbfe1c..a69c652 100644
--- a/drivers/char/dsp56k.c
+++ b/drivers/char/dsp56k.c
@@ -136,7 +136,7 @@ static int sizeof_bootstrap = 375;
 
 
 static struct dsp56k_device {
-	long in_use;
+	unsigned long in_use;
 	long maxio, timeout;
 	int tx_wsize, rx_wsize;
 } dsp56k;
diff --git a/drivers/char/rio/host.h b/drivers/char/rio/host.h
index 23d0681..78f2454 100644
--- a/drivers/char/rio/host.h
+++ b/drivers/char/rio/host.h
@@ -99,7 +99,7 @@ struct Host {
 	struct UnixRup UnixRups[MAX_RUP + LINKS_PER_UNIT];
 	int timeout_id;				/* For calling 100 ms delays */
 	int timeout_sem;			/* For calling 100 ms delays */
-	long locks;				/* long req'd for set_bit --RR */
+	unsigned long locks;			/* long req'd for set_bit --RR */
 	char ____end_marker____;
 };
 #define Control      CardP->DpControl
diff --git a/drivers/char/riscom8.h b/drivers/char/riscom8.h
index 6317aad..9cc1313 100644
--- a/drivers/char/riscom8.h
+++ b/drivers/char/riscom8.h
@@ -71,7 +71,7 @@ struct riscom_port {
 	struct tty_struct 	* tty;
 	int			count;
 	int			blocked_open;
-	long			event; /* long req'd for set_bit --RR */
+	unsigned long		event; /* long req'd for set_bit --RR */
 	int			timeout;
 	int			close_delay;
 	unsigned char 		* xmit_buf;
diff --git a/drivers/char/sx.h b/drivers/char/sx.h
index 432aad0..70d9783 100644
--- a/drivers/char/sx.h
+++ b/drivers/char/sx.h
@@ -27,7 +27,7 @@ struct sx_port {
   int                     c_dcd;
   struct sx_board         *board;
   int                     line;
-  long                    locks;
+  unsigned long           locks;
 };
 
 struct sx_board {
@@ -45,7 +45,7 @@ struct sx_board {
   int poll;
   int ta_type;
   struct timer_list       timer;
-  long                    locks;
+  unsigned long           locks;
 };
 
 struct vpd_prom {
diff --git a/drivers/fc4/fcp_impl.h b/drivers/fc4/fcp_impl.h
index 1ac6133..506338a 100644
--- a/drivers/fc4/fcp_impl.h
+++ b/drivers/fc4/fcp_impl.h
@@ -91,7 +91,7 @@ typedef struct _fc_channel {
 	fcp_cmd			*scsi_cmd_pool;
 	char			*scsi_rsp_pool;
 	dma_addr_t		dma_scsi_cmd, dma_scsi_rsp;
-	long			*scsi_bitmap;
+	unsigned long		*scsi_bitmap;
 	long			scsi_bitmap_end;
 	int			scsi_free;
 	int			(*encode_addr)(struct scsi_cmnd *, u16 *, struct _fc_channel *, fcp_cmnd *);
diff --git a/drivers/isdn/hisax/hisax.h b/drivers/isdn/hisax/hisax.h
index 3cd8d5b..34733c9 100644
--- a/drivers/isdn/hisax/hisax.h
+++ b/drivers/isdn/hisax/hisax.h
@@ -202,7 +202,7 @@ struct Layer1 {
 	void *hardware;
 	struct BCState *bcs;
 	struct PStack **stlistp;
-	long Flags;
+	unsigned long Flags;
 	struct FsmInst l1m;
 	struct FsmTimer	timer;
 	void (*l1l2) (struct PStack *, int, void *);
diff --git a/drivers/isdn/hisax/hisax_if.h b/drivers/isdn/hisax/hisax_if.h
index 4898fce..aa7c940 100644
--- a/drivers/isdn/hisax/hisax_if.h
+++ b/drivers/isdn/hisax/hisax_if.h
@@ -56,7 +56,7 @@ struct hisax_d_if {
 	struct IsdnCardState *cs;
 	struct hisax_b_if *b_if[2];
 	struct sk_buff_head erq;
-	long ph_state;
+	unsigned long ph_state;
 };
 
 int hisax_register(struct hisax_d_if *hisax_if, struct hisax_b_if *b_if[],
diff --git a/drivers/net/ni65.c b/drivers/net/ni65.c
index 0976852..3edc971 100644
--- a/drivers/net/ni65.c
+++ b/drivers/net/ni65.c
@@ -183,7 +183,7 @@ static struct card {
 	short addr_offset;
 	unsigned char *vendor_id;
 	char *cardname;
-	long config;
+	unsigned long config;
 } cards[] = {
 	{
 		.id0	     = NI65_ID0,
diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 26058b4..ff37bf4 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -154,8 +154,8 @@ struct cosa_data {
 	int nchannels;			/* # of channels on this card */
 	int driver_status;		/* For communicating with firmware */
 	int firmware_status;		/* Downloaded, reseted, etc. */
-	long int rxbitmap, txbitmap;	/* Bitmap of channels who are willing to send/receive data */
-	long int rxtx;			/* RX or TX in progress? */
+	unsigned long rxbitmap, txbitmap;/* Bitmap of channels who are willing to send/receive data */
+	unsigned long rxtx;		/* RX or TX in progress? */
 	int enabled;
 	int usage;				/* usage count */
 	int txchan, txsize, rxsize;
diff --git a/drivers/net/wireless/hostap/hostap_wlan.h b/drivers/net/wireless/hostap/hostap_wlan.h
index c27b2c1..e6516a1 100644
--- a/drivers/net/wireless/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/hostap/hostap_wlan.h
@@ -661,7 +661,7 @@ struct local_info {
 #define HOSTAP_BITS_TRANSMIT 0
 #define HOSTAP_BITS_BAP_TASKLET 1
 #define HOSTAP_BITS_BAP_TASKLET2 2
-	long bits;
+	unsigned long bits;
 
 	struct ap_data *ap;
 
diff --git a/drivers/net/wireless/ray_cs.h b/drivers/net/wireless/ray_cs.h
index bd73ebf..1e23b7f 100644
--- a/drivers/net/wireless/ray_cs.h
+++ b/drivers/net/wireless/ray_cs.h
@@ -33,8 +33,8 @@ typedef struct ray_dev_t {
     void __iomem *rmem;            /* pointer to receive buffer window       */
     struct pcmcia_device *finder;            /* pointer back to struct pcmcia_device for card    */
     struct timer_list timer;
-    long tx_ccs_lock;
-    long ccs_lock;
+    unsigned long tx_ccs_lock;
+    unsigned long ccs_lock;
     int   dl_param_ccs;
     union {
         struct b4_startup_params b4;
diff --git a/include/linux/agpgart.h b/include/linux/agpgart.h
index bfb8ec7..09fbf7e 100644
--- a/include/linux/agpgart.h
+++ b/include/linux/agpgart.h
@@ -197,7 +197,7 @@ struct agp_file_private {
 	struct agp_file_private *next;
 	struct agp_file_private *prev;
 	pid_t my_pid;
-	long access_flags;	/* long req'd for set_bit --RR */
+	unsigned long access_flags;	/* long req'd for set_bit --RR */
 };
 
 struct agp_front_data {
diff --git a/include/linux/hdlcdrv.h b/include/linux/hdlcdrv.h
index 4f6ee3b..bf6302f 100644
--- a/include/linux/hdlcdrv.h
+++ b/include/linux/hdlcdrv.h
@@ -200,7 +200,7 @@ struct hdlcdrv_state {
 
 	struct hdlcdrv_hdlcrx {
 		struct hdlcdrv_hdlcbuffer hbuf;
-		long in_hdlc_rx;
+		unsigned long in_hdlc_rx;
 		/* 0 = sync hunt, != 0 receiving */
 		int rx_state;	
 		unsigned int bitstream;
diff --git a/include/linux/scx200_gpio.h b/include/linux/scx200_gpio.h
index d2b0581..ece4e55 100644
--- a/include/linux/scx200_gpio.h
+++ b/include/linux/scx200_gpio.h
@@ -1,7 +1,7 @@
 u32 scx200_gpio_configure(unsigned index, u32 set, u32 clear);
 
 extern unsigned scx200_gpio_base;
-extern long scx200_gpio_shadow[2];
+extern unsigned long scx200_gpio_shadow[2];
 extern struct nsc_gpio_ops scx200_gpio_ops;
 
 #define scx200_gpio_present() (scx200_gpio_base!=0)
@@ -9,7 +9,7 @@ extern struct nsc_gpio_ops scx200_gpio_ops;
 /* Definitions to make sure I do the same thing in all functions */
 #define __SCx200_GPIO_BANK unsigned bank = index>>5
 #define __SCx200_GPIO_IOADDR unsigned short ioaddr = scx200_gpio_base+0x10*bank
-#define __SCx200_GPIO_SHADOW long *shadow = scx200_gpio_shadow+bank
+#define __SCx200_GPIO_SHADOW unsigned long *shadow = scx200_gpio_shadow+bank
 #define __SCx200_GPIO_INDEX index &= 31
 
 #define __SCx200_GPIO_OUT __asm__ __volatile__("outsl":"=mS" (shadow):"d" (ioaddr), "0" (shadow))
@@ -42,7 +42,7 @@ static inline void scx200_gpio_set_high(unsigned index) {
 	__SCx200_GPIO_IOADDR;
 	__SCx200_GPIO_SHADOW;
 	__SCx200_GPIO_INDEX;
-	set_bit(index, shadow);
+	set_bit(index, shadow);	/* __set_bit()? */
 	__SCx200_GPIO_OUT;
 }
 
@@ -53,7 +53,7 @@ static inline void scx200_gpio_set_low(unsigned index) {
 	__SCx200_GPIO_IOADDR;
 	__SCx200_GPIO_SHADOW;
 	__SCx200_GPIO_INDEX;
-	clear_bit(index, shadow);
+	clear_bit(index, shadow); /* __clear_bit()? */
 	__SCx200_GPIO_OUT;
 }
 
diff --git a/include/linux/stallion.h b/include/linux/stallion.h
index 4a0a329..94b4a10 100644
--- a/include/linux/stallion.h
+++ b/include/linux/stallion.h
@@ -75,7 +75,7 @@ struct stlport {
 	int			ioaddr;
 	int			uartaddr;
 	unsigned int		pagenr;
-	long			istate;
+	unsigned long		istate;
 	int			flags;
 	int			baud_base;
 	int			custom_divisor;
diff --git a/sound/pci/bt87x.c b/sound/pci/bt87x.c
index 188c7cf..131952f 100644
--- a/sound/pci/bt87x.c
+++ b/sound/pci/bt87x.c
@@ -157,7 +157,7 @@ struct snd_bt87x {
 	int dig_rate;
 
 	spinlock_t reg_lock;
-	long opened;
+	unsigned long opened;
 	struct snd_pcm_substream *substream;
 
 	struct snd_dma_buffer dma_risc;
-- 
1.5.3.GIT


