Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbZASKhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbZASKhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 05:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758303AbZASKhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 05:37:04 -0500
Received: from smtp.nokia.com ([192.100.122.230]:24935 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585AbZASKhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 05:37:00 -0500
Date: Mon, 19 Jan 2009 12:36:12 +0200 (EET)
Message-Id: <20090119.123612.153133347.Hiroshi.DOYU@nokia.com>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 07/10] omap mailbox: add save_/restore_ctx() for PM
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <20090117172037.GF12341@n2100.arm.linux.org.uk>
References: <20090116082737.17571.53738.stgit@oreo.research.nokia.com>
	<20090117171044.GE12341@n2100.arm.linux.org.uk>
	<20090117172037.GF12341@n2100.arm.linux.org.uk>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Mon_Jan_19_12_36_12_2009_231)--"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jan 2009 10:36:15.0062 (UTC) FILETIME=[C132EF60:01C97A21]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----Next_Part(Mon_Jan_19_12_36_12_2009_231)--
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Russell, Thank you for your review.

From: "ext Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 07/10] omap mailbox: add save_/restore_ctx() for PM=

Date: Sat, 17 Jan 2009 17:20:37 +0000

> On Sat, Jan 17, 2009 at 05:10:44PM +0000, Russell King - ARM Linux wr=
ote:
> > On Fri, Jan 16, 2009 at 10:27:37AM +0200, Hiroshi DOYU wrote:
> > > diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/=
mailbox.c
> > > index a877305..544dde9 100644
> > > --- a/arch/arm/mach-omap2/mailbox.c
> > > +++ b/arch/arm/mach-omap2/mailbox.c

[...]

> Hmm, don't forget 'i' is an offset not an index, so...
> =

> =A3define MBOX_NR_REGS (MBOX_REG_SIZE / sizeof(u32))
> =

> 	for (i =3D 0; i < MBOX_NR_REGS; i++) {
> 		p->ctx[i] =3D mbox_read_reg(i * sizeof(u32));

The updated one is attached.

> (you'll have to excuse the '=A3' there - my keyboard currently does n=
ot have
> a 'hash' key for some Fedora 9 post upgrade silly reason.)

No problem, just sorry for you inconvenience;)


Just for convenience, I provided a branch for the latest "mailbox"
patchset as below:

The following changes since commit 1de9e8e70f5acc441550ca75433563d91b26=
9bbe:
  Linus Torvalds (1):
        Linux 2.6.29-rc2

are available in the git repository at:

  http://git.gitorious.org/lk/mainline.git mailbox

Hiroshi DOYU (10):
      omap mailbox: cleanup omap2 register definition with macro
      omap mailbox: add initial omap3 support
      omap mailbox: print hardware revision at startup
      omap mailbox: fix empty struct device for omap_mbox
      omap mailbox: fix empty struct device for omap1
      omap mailbox: fix empty struct device for omap2
      omap mailbox: add save_/restore_ctx() for PM
      omap mailbox: move mailbox.h into mailbox.c
      omap mailbox: convert sequence bit checking to module paramter
      omap mailbox: remove unnecessary header file inclusion

 arch/arm/mach-omap1/devices.c              |    2 +-
 arch/arm/mach-omap1/mailbox.c              |   31 +++--
 arch/arm/mach-omap2/devices.c              |   39 ++++--
 arch/arm/mach-omap2/mailbox.c              |  197 ++++++++++++++++----=
--------
 arch/arm/plat-omap/Kconfig                 |    8 +
 arch/arm/plat-omap/include/mach/mailbox.h  |   27 ++++-
 arch/arm/plat-omap/include/mach/omap34xx.h |    1 +
 arch/arm/plat-omap/mailbox.c               |  152 ++++++++++++++++----=
--
 arch/arm/plat-omap/mailbox.h               |  100 --------------
 9 files changed, 311 insertions(+), 246 deletions(-)
 delete mode 100644 arch/arm/plat-omap/mailbox.h

----Next_Part(Mon_Jan_19_12_36_12_2009_231)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="omap-mailbox-add-save_-restore"

omap mailbox: add save_/restore_ctx() for PM

From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

To preserve the registers during off-mode

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/mach-omap2/mailbox.c             |   32 +++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/mach/mailbox.h |   23 +++++++++++++++++++++
 2 files changed, 55 insertions(+), 0 deletions(-)


diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 5751013..0a88243 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -32,6 +32,9 @@
 #define MAILBOX_IRQ_NEWMSG(u)		(1 << (2 * (u)))
 #define MAILBOX_IRQ_NOTFULL(u)		(1 << (2 * (u) + 1))
 
+#define MBOX_REG_SIZE			0x120
+#define MBOX_NR_REGS			(MBOX_REG_SIZE / sizeof(u32))
+
 static void __iomem *mbox_base;
 
 struct omap_mbox2_fifo {
@@ -47,6 +50,7 @@ struct omap_mbox2_priv {
 	unsigned long irqstatus;
 	u32 newmsg_bit;
 	u32 notfull_bit;
+	u32 ctx[MBOX_NR_REGS];
 };
 
 static struct clk *mbox_ick_handle;
@@ -167,6 +171,32 @@ static int omap2_mbox_is_irq(struct omap_mbox *mbox,
 	return (enable & status & bit);
 }
 
+static void omap2_mbox_save_ctx(struct omap_mbox *mbox)
+{
+	int i;
+	struct omap_mbox2_priv *p = mbox->priv;
+
+	for (i = 0; i < MBOX_NR_REGS; i++) {
+		p->ctx[i] = mbox_read_reg(i * sizeof(u32));
+
+		dev_dbg(mbox->dev, "%s: [%02x] %08x\n", __func__,
+			i, p->ctx[i]);
+	}
+}
+
+static void omap2_mbox_restore_ctx(struct omap_mbox *mbox)
+{
+	int i;
+	struct omap_mbox2_priv *p = mbox->priv;
+
+	for (i = 0; i < MBOX_NR_REGS; i++) {
+		mbox_write_reg(p->ctx[i], i * sizeof(u32));
+
+		dev_dbg(mbox->dev, "%s: [%02x] %08x\n", __func__,
+			i, p->ctx[i]);
+	}
+}
+
 static struct omap_mbox_ops omap2_mbox_ops = {
 	.type		= OMAP_MBOX_TYPE2,
 	.startup	= omap2_mbox_startup,
@@ -179,6 +209,8 @@ static struct omap_mbox_ops omap2_mbox_ops = {
 	.disable_irq	= omap2_mbox_disable_irq,
 	.ack_irq	= omap2_mbox_ack_irq,
 	.is_irq		= omap2_mbox_is_irq,
+	.save_ctx	= omap2_mbox_save_ctx,
+	.restore_ctx	= omap2_mbox_restore_ctx,
 };
 
 /*
diff --git a/arch/arm/plat-omap/include/mach/mailbox.h b/arch/arm/plat-omap/include/mach/mailbox.h
index 577db68..b7a6991 100644
--- a/arch/arm/plat-omap/include/mach/mailbox.h
+++ b/arch/arm/plat-omap/include/mach/mailbox.h
@@ -33,6 +33,9 @@ struct omap_mbox_ops {
 	void		(*disable_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
 	void		(*ack_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
 	int		(*is_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+	/* ctx */
+	void		(*save_ctx)(struct omap_mbox *mbox);
+	void		(*restore_ctx)(struct omap_mbox *mbox);
 };
 
 struct omap_mbox_queue {
@@ -70,4 +73,24 @@ void omap_mbox_put(struct omap_mbox *);
 int omap_mbox_register(struct device *parent, struct omap_mbox *);
 int omap_mbox_unregister(struct omap_mbox *);
 
+static inline void omap_mbox_save_ctx(struct omap_mbox *mbox)
+{
+	if (!mbox->ops->save_ctx) {
+		dev_err(mbox->dev, "%s:\tno save\n", __func__);
+		return;
+	}
+
+	mbox->ops->save_ctx(mbox);
+}
+
+static inline void omap_mbox_restore_ctx(struct omap_mbox *mbox)
+{
+	if (!mbox->ops->restore_ctx) {
+		dev_err(mbox->dev, "%s:\tno restore\n", __func__);
+		return;
+	}
+
+	mbox->ops->restore_ctx(mbox);
+}
+
 #endif /* MAILBOX_H */

----Next_Part(Mon_Jan_19_12_36_12_2009_231)----
