Return-Path: <linux-kernel-owner+w=401wt.eu-S1752678AbYJNPnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbYJNPnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 11:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYJNPn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:43:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:16348 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbYJNPnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=F1z+i1volzFFM9OM07zuBOqIdFIiJLQ4H9wOMxlFKFyaGORyB74S37u9n/xgWKw2qX
         yJ0rMDGRD0O32GnkcolALnzXnlqPRzWvT+xuRTMeCSTeKq5BSCfOrdwsCxZFJ13HSU1n
         39Zp6EX1knzZWvu6x29rhqN0ipixxuO7lh1cs=
Date: Tue, 14 Oct 2008 19:45:10 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: viro@zeniv.linux.org.uk, acme@ghostprotocols.net
Subject: [PATCH v0] header redux: remove sched.h from interrupt.h
Message-ID: <20081014154510.GA14588@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm going to send this slightly before -rc1 or right after -rc1.

It lives at

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/headers.git headers

Further reduction ideas are welcome.


1) remove sched.h from interrupt.h
2) remove sched.h from smp_lock.h (interrupt.h => hardirq.h => smp_lock.h)
3) for (2) move release_kernel_lock(), reacquire_kernel_lock() to
   kernel/sched.c -- they're only used by scheduler and low-level enough
   to now allow in drivers.
4) insert sched.h and less-bloated headers where needed.

[insert recompile redux here]
[insert *.i bloat redux here]
[insert cross-compile status here]

---

 arch/arm/mach-integrator/pci_v3.c           |    1 +
 arch/arm/mach-msm/dma.c                     |    3 ++-
 arch/arm/plat-mxc/dma-mx1-mx2.c             |    1 +
 arch/arm/plat-omap/include/mach/irda.h      |    2 ++
 arch/blackfin/kernel/time.c                 |    1 +
 arch/x86/xen/time.c                         |    1 +
 crypto/aead.c                               |    1 +
 drivers/acpi/ec.c                           |    1 +
 drivers/acpi/sbshc.c                        |    1 +
 drivers/char/applicom.c                     |    1 +
 drivers/char/epca.c                         |    1 +
 drivers/char/generic_serial.c               |    1 +
 drivers/char/istallion.c                    |    1 +
 drivers/char/nozomi.c                       |    1 +
 drivers/char/pty.c                          |    1 +
 drivers/char/rio/riocmd.c                   |    1 +
 drivers/char/rio/rioctrl.c                  |    1 +
 drivers/char/rio/riotty.c                   |    1 +
 drivers/char/stallion.c                     |    1 +
 drivers/char/tlclk.c                        |    1 +
 drivers/crypto/hifn_795x.c                  |    1 +
 drivers/dma/mv_xor.h                        |    1 +
 drivers/infiniband/core/iwcm.c              |    1 +
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |    1 +
 drivers/input/keyboard/sunkbd.c             |    1 +
 drivers/input/mouse/psmouse.h               |    2 ++
 drivers/input/serio/libps2.c                |    1 +
 drivers/input/serio/serport.c               |    1 +
 drivers/input/touchscreen/ads7846.c         |    1 +
 drivers/isdn/capi/kcapi.c                   |    1 +
 drivers/isdn/hisax/arcofi.c                 |    2 +-
 drivers/isdn/hisax/hfc_2bds0.c              |    1 +
 drivers/isdn/hisax/hfc_pci.c                |    1 +
 drivers/isdn/pcbit/drv.c                    |    2 +-
 drivers/isdn/pcbit/layer2.c                 |    1 +
 drivers/isdn/sc/init.c                      |    1 +
 drivers/lguest/interrupts_and_traps.c       |    1 +
 drivers/message/fusion/mptlan.c             |    1 +
 drivers/mfd/ucb1x00-core.c                  |    1 +
 drivers/misc/ibmasm/command.c               |    2 +-
 drivers/misc/ibmasm/event.c                 |    2 +-
 drivers/misc/ibmasm/r_heartbeat.c           |    2 +-
 drivers/net/amd8111e.c                      |    2 +-
 drivers/net/chelsio/cxgb2.c                 |    1 +
 drivers/net/depca.c                         |    1 +
 drivers/net/e100.c                          |    1 +
 drivers/net/e1000e/ich8lan.c                |    1 +
 drivers/net/eql.c                           |    2 +-
 drivers/net/ewrk3.c                         |    1 +
 drivers/net/hamachi.c                       |    1 +
 drivers/net/hamradio/baycom_epp.c           |    1 +
 drivers/net/hamradio/baycom_ser_fdx.c       |    1 +
 drivers/net/hamradio/baycom_ser_hdx.c       |    1 +
 drivers/net/hamradio/hdlcdrv.c              |    1 +
 drivers/net/hp100.c                         |    1 +
 drivers/net/igb/igb_ethtool.c               |    1 +
 drivers/net/irda/toim3232-sir.c             |    2 +-
 drivers/net/mii.c                           |    2 +-
 drivers/net/ns83820.c                       |    1 +
 drivers/net/pcnet32.c                       |    1 +
 drivers/net/phy/phy.c                       |    1 +
 drivers/net/sb1000.c                        |    1 +
 drivers/net/sis900.c                        |    1 +
 drivers/net/skfp/skfddi.c                   |    1 +
 drivers/net/skge.c                          |    1 +
 drivers/net/slip.c                          |    1 +
 drivers/net/sungem.c                        |    1 +
 drivers/net/tlan.c                          |    2 +-
 drivers/net/tokenring/ibmtr.c               |    1 +
 drivers/net/tulip/tulip_core.c              |    2 +-
 drivers/net/typhoon.c                       |    1 +
 drivers/net/wan/c101.c                      |    2 +-
 drivers/net/wan/cycx_x25.c                  |    1 +
 drivers/net/wan/dscc4.c                     |    1 +
 drivers/net/wan/farsync.c                   |    1 +
 drivers/net/wan/n2.c                        |    2 +-
 drivers/net/wan/pci200syn.c                 |    2 +-
 drivers/net/wan/syncppp.c                   |    1 +
 drivers/net/wireless/b43/main.c             |    1 +
 drivers/net/wireless/b43/pio.c              |    2 +-
 drivers/net/wireless/b43legacy/main.c       |    1 +
 drivers/net/wireless/b43legacy/phy.c        |    1 +
 drivers/net/wireless/hostap/hostap_info.c   |    2 +-
 drivers/net/wireless/hostap/hostap_ioctl.c  |    1 +
 drivers/net/wireless/ipw2200.c              |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    1 +
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 drivers/net/wireless/libertas/cmd.c         |    1 +
 drivers/net/wireless/libertas/tx.c          |    1 +
 drivers/net/wireless/orinoco.c              |    1 +
 drivers/net/wireless/prism54/isl_ioctl.c    |    2 +-
 drivers/net/wireless/prism54/islpci_dev.c   |    2 +-
 drivers/net/wireless/prism54/islpci_mgt.c   |    1 +
 drivers/net/yellowfin.c                     |    1 +
 drivers/pci/hotplug/cpqphp.h                |    1 +
 drivers/pci/pcie/aer/aerdrv.c               |    1 +
 drivers/spi/omap2_mcspi.c                   |    1 +
 drivers/spi/orion_spi.c                     |    1 +
 drivers/usb/gadget/m66592-udc.h             |    2 ++
 drivers/usb/gadget/u_serial.c               |    1 +
 fs/file.c                                   |    1 +
 include/linux/interrupt.h                   |    3 ++-
 include/linux/mmc/host.h                    |    2 +-
 include/linux/smp_lock.h                    |   20 +-------------------
 include/linux/tick.h                        |    1 +
 kernel/hrtimer.c                            |    1 +
 kernel/irq/proc.c                           |    1 +
 kernel/mutex-debug.c                        |    1 +
 kernel/sched.c                              |   20 ++++++++++++++++++++
 kernel/time/timekeeping.c                   |    1 +
 lib/debugobjects.c                          |    1 +
 lib/fault-inject.c                          |    1 +
 lib/kernel_lock.c                           |    1 +
 net/irda/ircomm/ircomm_tty_attach.c         |    1 +
 net/irda/irlan/irlan_common.c               |    1 +
 net/irda/irlan/irlan_eth.c                  |    1 +
 net/netfilter/ipvs/ip_vs_conn.c             |    1 +
 net/netfilter/nf_conntrack_core.c           |    1 +
 net/sunrpc/xprtrdma/rpc_rdma.c              |    1 +
 net/sunrpc/xprtrdma/svc_rdma_transport.c    |    1 +
 net/sunrpc/xprtrdma/transport.c             |    1 +
 net/sunrpc/xprtrdma/verbs.c                 |    2 +-
 127 files changed, 151 insertions(+), 42 deletions(-)

--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -31,6 +31,7 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
+#include <asm/signal.h>
 #include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <asm/irq_regs.h>
--- a/arch/arm/mach-msm/dma.c
+++ b/arch/arm/mach-msm/dma.c
@@ -12,8 +12,9 @@
  * GNU General Public License for more details.
  *
  */
-
+#include <linux/completion.h>
 #include <linux/io.h>
+#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <mach/dma.h>
 
--- a/arch/arm/plat-mxc/dma-mx1-mx2.c
+++ b/arch/arm/plat-mxc/dma-mx1-mx2.c
@@ -29,6 +29,7 @@
 #include <linux/errno.h>
 #include <linux/clk.h>
 #include <linux/scatterlist.h>
+#include <linux/timer.h>
 #include <linux/io.h>
 
 #include <asm/system.h>
--- a/arch/arm/plat-omap/include/mach/irda.h
+++ b/arch/arm/plat-omap/include/mach/irda.h
@@ -10,6 +10,8 @@
 #ifndef ASMARM_ARCH_IRDA_H
 #define ASMARM_ARCH_IRDA_H
 
+#include <linux/workqueue.h>
+
 /* board specific transceiver capabilities */
 
 #define IR_SEL		1	/* Selects IrDA */
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/irq.h>
 
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -13,6 +13,7 @@
 #include <linux/clockchips.h>
 #include <linux/kernel_stat.h>
 #include <linux/math64.h>
+#include <linux/sched.h>
 
 #include <asm/pvclock.h>
 #include <asm/xen/hypervisor.h>
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/rtnetlink.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -35,6 +35,7 @@
 #include <linux/types.h>
 #include <linux/delay.h>
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
--- a/drivers/acpi/sbshc.c
+++ b/drivers/acpi/sbshc.c
@@ -11,6 +11,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/actypes.h>
+#include <linux/sched.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/miscdevice.h>
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -30,6 +30,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/serial.h>
 #include <linux/delay.h>
 #include <linux/ctype.h>
--- a/drivers/char/generic_serial.c
+++ b/drivers/char/generic_serial.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/tty.h>
+#include <linux/sched.h>
 #include <linux/serial.h>
 #include <linux/mm.h>
 #include <linux/generic_serial.h>
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -19,6 +19,7 @@
 /*****************************************************************************/
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -45,6 +45,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/ioport.h>
+#include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -20,6 +20,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/fcntl.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/major.h>
 #include <linux/mm.h>
--- a/drivers/char/rio/riocmd.c
+++ b/drivers/char/rio/riocmd.c
@@ -32,6 +32,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/tty.h>
--- a/drivers/char/rio/rioctrl.c
+++ b/drivers/char/rio/rioctrl.c
@@ -31,6 +31,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <asm/io.h>
--- a/drivers/char/rio/riotty.c
+++ b/drivers/char/rio/riotty.c
@@ -33,6 +33,7 @@
 #define __EXPLICIT_DEF_H__
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/tty.h>
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -27,6 +27,7 @@
 /*****************************************************************************/
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
--- a/drivers/char/tlclk.c
+++ b/drivers/char/tlclk.c
@@ -32,6 +32,7 @@
 #include <linux/kernel.h>	/* printk() */
 #include <linux/fs.h>		/* everything... */
 #include <linux/errno.h>	/* error codes */
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/interrupt.h>
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/mod_devicetable.h>
+#include <linux/hrtimer.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
--- a/drivers/dma/mv_xor.h
+++ b/drivers/dma/mv_xor.h
@@ -18,6 +18,7 @@
 #ifndef MV_XOR_H
 #define MV_XOR_H
 
+#include <linux/timer.h>
 #include <linux/types.h>
 #include <linux/io.h>
 #include <linux/dmaengine.h>
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -40,6 +40,7 @@
 #include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/rbtree.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/completion.h>
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -29,6 +29,7 @@
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  */
+#include <linux/sched.h>
 #include "iwch_provider.h"
 #include "iwch.h"
 #include "iwch_cm.h"
--- a/drivers/input/keyboard/sunkbd.c
+++ b/drivers/input/keyboard/sunkbd.c
@@ -27,6 +27,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -1,6 +1,8 @@
 #ifndef _PSMOUSE_H
 #define _PSMOUSE_H
 
+#include <linux/workqueue.h>
+
 #define PSMOUSE_CMD_SETSCALE11	0x00e6
 #define PSMOUSE_CMD_SETSCALE21	0x00e7
 #define PSMOUSE_CMD_SETRES	0x10e8
--- a/drivers/input/serio/libps2.c
+++ b/drivers/input/serio/libps2.c
@@ -13,6 +13,7 @@
 
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -15,6 +15,7 @@
 
 #include <asm/uaccess.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -17,6 +17,7 @@
  *  it under the terms of the GNU General Public License version 2 as
  *  published by the Free Software Foundation.
  */
+#include <linux/hrtimer.h>
 #include <linux/hwmon.h>
 #include <linux/init.h>
 #include <linux/err.h>
--- a/drivers/isdn/capi/kcapi.c
+++ b/drivers/isdn/capi/kcapi.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/skbuff.h>
 #include <linux/workqueue.h>
--- a/drivers/isdn/hisax/arcofi.c
+++ b/drivers/isdn/hisax/arcofi.c
@@ -9,7 +9,7 @@
  * of the GNU General Public License, incorporated herein by reference.
  *
  */
- 
+#include <linux/sched.h>
 #include "hisax.h"
 #include "isdnl1.h"
 #include "isac.h"
--- a/drivers/isdn/hisax/hfc_2bds0.c
+++ b/drivers/isdn/hisax/hfc_2bds0.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/sched.h>
 #include "hisax.h"
 #include "hfc_2bds0.h"
 #include "isdnl1.h"
--- a/drivers/isdn/hisax/hfc_pci.c
+++ b/drivers/isdn/hisax/hfc_pci.c
@@ -20,6 +20,7 @@
 #include "hfc_pci.h"
 #include "isdnl1.h"
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/interrupt.h>
 
 static const char *hfcpci_revision = "$Revision: 1.48.2.4 $";
--- a/drivers/isdn/pcbit/drv.c
+++ b/drivers/isdn/pcbit/drv.c
@@ -21,7 +21,7 @@
 
 
 #include <linux/kernel.h>
-
+#include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
--- a/drivers/isdn/pcbit/layer2.c
+++ b/drivers/isdn/pcbit/layer2.c
@@ -27,6 +27,7 @@
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -8,6 +8,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include "includes.h"
 #include "hardware.h"
 #include "card.h"
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -14,6 +14,7 @@
 #include <linux/uaccess.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include "lg.h"
 
 /* Allow Guests to use a non-128 (ie. non-Linux) syscall trap. */
--- a/drivers/message/fusion/mptlan.c
+++ b/drivers/message/fusion/mptlan.c
@@ -56,6 +56,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/sched.h>
 
 #define my_VERSION	MPT_LINUX_VERSION_COMMON
 #define MYNAM		"mptlan"
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -18,6 +18,7 @@
  */
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/errno.h>
--- a/drivers/misc/ibmasm/command.c
+++ b/drivers/misc/ibmasm/command.c
@@ -21,7 +21,7 @@
  * Author: Max Asböck <amax@us.ibm.com>
  *
  */
-
+#include <linux/sched.h>
 #include "ibmasm.h"
 #include "lowlevel.h"
 
--- a/drivers/misc/ibmasm/event.c
+++ b/drivers/misc/ibmasm/event.c
@@ -21,7 +21,7 @@
  * Author: Max Asböck <amax@us.ibm.com>
  *
  */
-
+#include <linux/sched.h>
 #include "ibmasm.h"
 #include "lowlevel.h"
 
--- a/drivers/misc/ibmasm/r_heartbeat.c
+++ b/drivers/misc/ibmasm/r_heartbeat.c
@@ -19,7 +19,7 @@
  * Author: Max Asböck <amax@us.ibm.com>
  *
  */
-
+#include <linux/sched.h>
 #include "ibmasm.h"
 #include "dot_command.h"
 
--- a/drivers/net/amd8111e.c
+++ b/drivers/net/amd8111e.c
@@ -68,7 +68,7 @@ Revision History:
 
 */
 
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
--- a/drivers/net/chelsio/cxgb2.c
+++ b/drivers/net/chelsio/cxgb2.c
@@ -37,6 +37,7 @@
  ****************************************************************************/
 
 #include "common.h"
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/pci.h>
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -240,6 +240,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -149,6 +149,7 @@
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/init.h>
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -52,6 +52,7 @@
 #include <linux/ethtool.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 
 #include "e1000.h"
 
--- a/drivers/net/eql.c
+++ b/drivers/net/eql.c
@@ -110,7 +110,7 @@
  *
  * Sorry, I had to rewrite most of this for 2.5.x -DaveM
  */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
--- a/drivers/net/ewrk3.c
+++ b/drivers/net/ewrk3.c
@@ -148,6 +148,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
--- a/drivers/net/hamachi.c
+++ b/drivers/net/hamachi.c
@@ -145,6 +145,7 @@ static int tx_params[MAX_UNITS] = {-1, -1, -1, -1, -1, -1, -1, -1};
 /* Time in jiffies before concluding the transmitter is hung. */
 #define TX_TIMEOUT  (5*HZ)
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -44,6 +44,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/workqueue.h>
 #include <linux/fs.h>
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -71,6 +71,7 @@
 
 /*****************************************************************************/
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/string.h>
--- a/drivers/net/hamradio/baycom_ser_hdx.c
+++ b/drivers/net/hamradio/baycom_ser_hdx.c
@@ -61,6 +61,7 @@
 
 /*****************************************************************************/
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/string.h>
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -42,6 +42,7 @@
 
 /*****************************************************************************/
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/net.h>
--- a/drivers/net/hp100.c
+++ b/drivers/net/hp100.c
@@ -98,6 +98,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
--- a/drivers/net/igb/igb_ethtool.c
+++ b/drivers/net/igb/igb_ethtool.c
@@ -32,6 +32,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/if_ether.h>
 #include <linux/ethtool.h>
 
--- a/drivers/net/irda/toim3232-sir.c
+++ b/drivers/net/irda/toim3232-sir.c
@@ -116,7 +116,7 @@
  * 	- Vishay/Temic TFDS4500	SIR IRDA front-end transceiver
  *
  */
-
+#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/init.h>
--- a/drivers/net/mii.c
+++ b/drivers/net/mii.c
@@ -26,7 +26,7 @@
 
 
  */
-
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
--- a/drivers/net/ns83820.c
+++ b/drivers/net/ns83820.c
@@ -110,6 +110,7 @@
 #include <linux/in.h>	/* for IPPROTO_... */
 #include <linux/compiler.h>
 #include <linux/prefetch.h>
+#include <linux/sched.h>
 #include <linux/ethtool.h>
 #include <linux/timer.h>
 #include <linux/if_vlan.h>
--- a/drivers/net/pcnet32.c
+++ b/drivers/net/pcnet32.c
@@ -31,6 +31,7 @@ static const char *const version =
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -15,6 +15,7 @@
  * option) any later version.
  *
  */
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/errno.h>
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -36,6 +36,7 @@ static char version[] = "sb1000.c:v1.1.2 6/01/98 (fventuri@mediaone.net)\n";
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -52,6 +52,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/errno.h>
--- a/drivers/net/skfp/skfddi.c
+++ b/drivers/net/skfp/skfddi.c
@@ -73,6 +73,7 @@ static const char * const boot_msg =
 
 /* Include files */
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
--- a/drivers/net/skge.c
+++ b/drivers/net/skge.c
@@ -37,6 +37,7 @@
 #include <linux/crc32.h>
 #include <linux/dma-mapping.h>
 #include <linux/debugfs.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/mii.h>
 #include <asm/irq.h>
--- a/drivers/net/slip.c
+++ b/drivers/net/slip.c
@@ -71,6 +71,7 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/in.h>
+#include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/errno.h>
 #include <linux/netdevice.h>
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -38,6 +38,7 @@
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/in.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/delay.h>
--- a/drivers/net/tlan.c
+++ b/drivers/net/tlan.c
@@ -163,7 +163,7 @@
  *	                       10T half duplex no loopback
  *	                       Thanks to Gunnar Eikman
  *******************************************************************************/
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
--- a/drivers/net/tokenring/ibmtr.c
+++ b/drivers/net/tokenring/ibmtr.c
@@ -108,6 +108,7 @@ in the event that chatty debug messages are desired - jjs 12/30/98 */
 #define IBMTR_DEBUG_MESSAGES 0
 
 #include <linux/module.h>
+#include <linux/sched.h>
 
 #ifdef PCMCIA		/* required for ibmtr_cs.c to build */
 #undef MODULE		/* yes, really */
--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -21,7 +21,7 @@
 #endif
 #define DRV_RELDATE	"Feb 27, 2007"
 
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include "tulip.h"
--- a/drivers/net/typhoon.c
+++ b/drivers/net/typhoon.c
@@ -107,6 +107,7 @@ static const int multicast_filter_limit = 32;
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/errno.h>
--- a/drivers/net/wan/c101.c
+++ b/drivers/net/wan/c101.c
@@ -13,7 +13,7 @@
  *    Hitachi HD64570 SCA User's Manual
  *    Moxa C101 User's Manual
  */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
--- a/drivers/net/wan/cycx_x25.c
+++ b/drivers/net/wan/cycx_x25.c
@@ -83,6 +83,7 @@
 #include <linux/if_arp.h>       /* ARPHRD_HWX25 */
 #include <linux/kernel.h>	/* printk(), and other useful stuff */
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/string.h>	/* inline memset(), etc. */
 #include <linux/slab.h>		/* kmalloc(), kfree() */
 #include <linux/stddef.h>	/* offsetof(), etc. */
--- a/drivers/net/wan/dscc4.c
+++ b/drivers/net/wan/dscc4.c
@@ -88,6 +88,7 @@
 #include <linux/pci.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 
 #include <asm/system.h>
 #include <asm/cache.h>
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/if.h>
 #include <linux/hdlc.h>
+#include <linux/sched.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
--- a/drivers/net/wan/n2.c
+++ b/drivers/net/wan/n2.c
@@ -15,7 +15,7 @@
  *    Hitachi HD64570 SCA User's Manual
  *    SDL Inc. PPP/HDLC/CISCO driver
  */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
--- a/drivers/net/wan/pci200syn.c
+++ b/drivers/net/wan/pci200syn.c
@@ -13,7 +13,7 @@
  *    Hitachi HD64572 SCA-II User's Manual
  *    PLX Technology Inc. PCI9052 Data Book
  */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
--- a/drivers/net/wan/syncppp.c
+++ b/drivers/net/wan/syncppp.c
@@ -37,6 +37,7 @@
  */
 #undef DEBUG
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -36,6 +36,7 @@
 #include <linux/firmware.h>
 #include <linux/wireless.h>
 #include <linux/workqueue.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -30,7 +30,7 @@
 #include "xmit.h"
 
 #include <linux/delay.h>
-
+#include <linux/sched.h>
 
 static void b43_pio_rx_work(struct work_struct *work);
 
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -37,6 +37,7 @@
 #include <linux/firmware.h>
 #include <linux/wireless.h>
 #include <linux/workqueue.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/dma-mapping.h>
 #include <net/dst.h>
--- a/drivers/net/wireless/b43legacy/phy.c
+++ b/drivers/net/wireless/b43legacy/phy.c
@@ -31,6 +31,7 @@
 
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 #include <linux/types.h>
 
 #include "b43legacy.h"
--- a/drivers/net/wireless/hostap/hostap_info.c
+++ b/drivers/net/wireless/hostap/hostap_info.c
@@ -1,5 +1,5 @@
 /* Host AP driver Info Frame processing (part of hostap.o module) */
-
+#include <linux/sched.h>
 #include "hostap_wlan.h"
 #include "hostap.h"
 #include "hostap_ap.h"
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -2,6 +2,7 @@
 
 #include <linux/types.h>
 #include <linux/ethtool.h>
+#include <linux/sched.h>
 #include <net/ieee80211_crypt.h>
 
 #include "hostap_wlan.h"
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -29,7 +29,7 @@
   Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
 
 ******************************************************************************/
-
+#include <linux/sched.h>
 #include "ipw2200.h"
 
 
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -30,6 +30,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -30,6 +30,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -29,6 +29,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -33,6 +33,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -28,6 +28,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <net/mac80211.h>
 
 #include "iwl-dev.h" /* FIXME: remove */
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -28,6 +28,7 @@
  *****************************************************************************/
 
 #include <linux/etherdevice.h>
+#include <linux/sched.h>
 #include <net/mac80211.h>
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -33,6 +33,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -6,6 +6,7 @@
 #include <net/iw_handler.h>
 #include <net/ieee80211.h>
 #include <linux/kfifo.h>
+#include <linux/sched.h>
 #include "host.h"
 #include "hostcmd.h"
 #include "decl.h"
--- a/drivers/net/wireless/libertas/tx.c
+++ b/drivers/net/wireless/libertas/tx.c
@@ -3,6 +3,7 @@
   */
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/sched.h>
 
 #include "hostcmd.h"
 #include "radiotap.h"
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -76,6 +76,7 @@
 
 #define DRIVER_NAME "orinoco"
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
  */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -19,7 +19,7 @@
  */
 
 #include <linux/module.h>
-
+#include <linux/sched.h>
 #include <linux/netdevice.h>
 #include <linux/ethtool.h>
 #include <linux/pci.h>
--- a/drivers/net/wireless/prism54/islpci_mgt.c
+++ b/drivers/net/wireless/prism54/islpci_mgt.c
@@ -20,6 +20,7 @@
 #include <linux/netdevice.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/sched.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
--- a/drivers/net/yellowfin.c
+++ b/drivers/net/yellowfin.c
@@ -84,6 +84,7 @@ static int gx_fix;
 
 #define yellowfin_debug debug
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -32,6 +32,7 @@
 #include <asm/io.h>		/* for read? and write? functions */
 #include <linux/delay.h>	/* for delays */
 #include <linux/mutex.h>
+#include <linux/sched.h>
 
 #define MY_NAME	"cpqphp"
 
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/pm.h>
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
--- a/drivers/spi/omap2_mcspi.c
+++ b/drivers/spi/omap2_mcspi.c
@@ -32,6 +32,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/workqueue.h>
 
 #include <linux/spi/spi.h>
 
--- a/drivers/spi/orion_spi.c
+++ b/drivers/spi/orion_spi.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/workqueue.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/orion_spi.h>
 #include <asm/unaligned.h>
--- a/drivers/usb/gadget/m66592-udc.h
+++ b/drivers/usb/gadget/m66592-udc.h
@@ -23,6 +23,8 @@
 #ifndef __M66592_UDC_H__
 #define __M66592_UDC_H__
 
+#include <linux/timer.h>
+
 #define M66592_SYSCFG		0x00
 #define M66592_XTAL		0xC000	/* b15-14: Crystal selection */
 #define   M66592_XTAL48		 0x8000		/* 48MHz */
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/delay.h>
+#include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 
--- a/fs/file.c
+++ b/fs/file.c
@@ -10,6 +10,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/time.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/file.h>
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -9,7 +9,7 @@
 #include <linux/cpumask.h>
 #include <linux/irqreturn.h>
 #include <linux/hardirq.h>
-#include <linux/sched.h>
+#include <linux/errno.h>
 #include <linux/irqflags.h>
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
@@ -439,6 +439,7 @@ static inline void init_irq_proc(void)
 }
 #endif
 
+struct seq_file;
 int show_interrupts(struct seq_file *p, void *v);
 
 #endif
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -11,7 +11,7 @@
 #define LINUX_MMC_HOST_H
 
 #include <linux/leds.h>
-
+#include <linux/sched.h>
 #include <linux/mmc/core.h>
 
 struct mmc_ios {
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -2,28 +2,12 @@
 #define __LINUX_SMPLOCK_H
 
 #ifdef CONFIG_LOCK_KERNEL
-#include <linux/sched.h>
+#include <linux/spinlock.h>
 
 #define kernel_locked()		(current->lock_depth >= 0)
 
 extern int __lockfunc __reacquire_kernel_lock(void);
 extern void __lockfunc __release_kernel_lock(void);
-
-/*
- * Release/re-acquire global kernel lock for the scheduler
- */
-#define release_kernel_lock(tsk) do { 		\
-	if (unlikely((tsk)->lock_depth >= 0))	\
-		__release_kernel_lock();	\
-} while (0)
-
-static inline int reacquire_kernel_lock(struct task_struct *task)
-{
-	if (unlikely(task->lock_depth >= 0))
-		return __reacquire_kernel_lock();
-	return 0;
-}
-
 extern void __lockfunc lock_kernel(void)	__acquires(kernel_lock);
 extern void __lockfunc unlock_kernel(void)	__releases(kernel_lock);
 
@@ -43,9 +27,7 @@ static inline void cycle_kernel_lock(void)
 
 #define lock_kernel()				do { } while(0)
 #define unlock_kernel()				do { } while(0)
-#define release_kernel_lock(task)		do { } while(0)
 #define cycle_kernel_lock()			do { } while(0)
-#define reacquire_kernel_lock(task)		0
 #define kernel_locked()				1
 
 #endif /* CONFIG_LOCK_KERNEL */
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -7,6 +7,7 @@
 #define _LINUX_TICK_H
 
 #include <linux/clockchips.h>
+#include <linux/hrtimer.h>
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -37,6 +37,7 @@
 #include <linux/percpu.h>
 #include <linux/hrtimer.h>
 #include <linux/notifier.h>
+#include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/irq.h>
+#include <linux/jiffies.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
--- a/kernel/mutex-debug.c
+++ b/kernel/mutex-debug.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/poison.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/kallsyms.h>
 #include <linux/interrupt.h>
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -77,6 +77,26 @@
 
 #include "sched_cpupri.h"
 
+#ifdef CONFIG_LOCK_KERNEL
+/*
+ * Release/re-acquire global kernel lock for the scheduler
+ */
+#define release_kernel_lock(tsk) do { 		\
+	if (unlikely((tsk)->lock_depth >= 0))	\
+		__release_kernel_lock();	\
+} while (0)
+
+static inline int reacquire_kernel_lock(struct task_struct *task)
+{
+	if (unlikely(task->lock_depth >= 0))
+		return __reacquire_kernel_lock();
+	return 0;
+}
+#else
+#define release_kernel_lock(task)		do { } while(0)
+#define reacquire_kernel_lock(task)		0
+#endif
+
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -13,6 +13,7 @@
 #include <linux/percpu.h>
 #include <linux/init.h>
 #include <linux/mm.h>
+#include <linux/sched.h>
 #include <linux/sysdev.h>
 #include <linux/clocksource.h>
 #include <linux/jiffies.h>
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -9,6 +9,7 @@
  */
 #include <linux/debugobjects.h>
 #include <linux/interrupt.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/hash.h>
--- a/lib/fault-inject.c
+++ b/lib/fault-inject.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/random.h>
+#include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/types.h>
 #include <linux/fs.h>
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -5,6 +5,7 @@
  * relegated to obsolescence, but used by various less
  * important (or lazy) subsystems.
  */
+#include <linux/sched.h>
 #include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
--- a/net/irda/ircomm/ircomm_tty_attach.c
+++ b/net/irda/ircomm/ircomm_tty_attach.c
@@ -30,6 +30,7 @@
  ********************************************************************/
 
 #include <linux/init.h>
+#include <linux/sched.h>
 
 #include <net/irda/irda.h>
 #include <net/irda/irlmp.h>
--- a/net/irda/irlan/irlan_common.c
+++ b/net/irda/irlan/irlan_common.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/errno.h>
--- a/net/irda/irlan/irlan_eth.c
+++ b/net/irda/irlan/irlan_eth.c
@@ -30,6 +30,7 @@
 #include <linux/inetdevice.h>
 #include <linux/if_arp.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <net/arp.h>
 
 #include <net/irda/irda.h>
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/proc_fs.h>		/* for proc_net_* */
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/jhash.h>
 #include <linux/random.h>
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/netfilter.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -47,6 +47,7 @@
 
 #include "xprt_rdma.h"
 
+#include <linux/sched.h>
 #include <linux/highmem.h>
 
 #ifdef RPC_DEBUG
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -42,6 +42,7 @@
 #include <linux/sunrpc/svc_xprt.h>
 #include <linux/sunrpc/debug.h>
 #include <linux/sunrpc/rpc_rdma.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -49,6 +49,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 
 #include "xprt_rdma.h"
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -48,7 +48,7 @@
  */
 
 #include <linux/pci.h>	/* for Tavor hack below */
-
+#include <linux/sched.h>
 #include "xprt_rdma.h"
 
 /*
