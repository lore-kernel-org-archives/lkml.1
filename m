Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZEZMAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZEZMAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbZEZL74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 07:59:56 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:64718 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZEZL7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 07:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DvE7bqRYWCy3oYdnUGbDEW60Nc63fIUUGNUvbxvZ8AZ8F6+Fdf4l+CQCbx262FUdhb
         fiIlQuBcwH4GEnea8XZ0P3nYF9pTCciHpzPsEr8IcPGafZEtS6rZGEpU1zpoq5ENBAM6
         xaGD3P+T0fnjIQ1V4HzVZr911FuD71YN88Q3Q=
Date: Tue, 26 May 2009 15:59:53 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: [PATCH] Remove cred leftovers from sched.h
Message-ID: <20090526115953.GA4958@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct user_struct and functions which work with it do not belong to sched.h
Remove cred.h inclusion from sched.h
Add necessary headers where needed (cred.h, capability.h)

As result sched.h inclusion results in something like -6% stuff after
preprocessing.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/alpha/kernel/asm-offsets.c            |    2 
 arch/ia64/kernel/mca_drv.c                 |    1 
 arch/parisc/kernel/signal.c                |    2 
 arch/powerpc/mm/fault.c                    |    2 
 arch/powerpc/platforms/cell/spufs/inode.c  |    2 
 arch/s390/hypfs/inode.c                    |    1 
 arch/x86/mm/fault.c                        |    1 
 drivers/block/loop.c                       |    2 
 drivers/char/tty_audit.c                   |    1 
 drivers/gpu/drm/drm_fops.c                 |    1 
 drivers/isdn/capi/capifs.c                 |    2 
 drivers/isdn/hysdn/hysdn_procconf.c        |    2 
 drivers/media/video/cpia.c                 |    2 
 drivers/misc/eeprom/eeprom.c               |    2 
 drivers/net/depca.c                        |    2 
 drivers/net/hamradio/baycom_ser_hdx.c      |    1 
 drivers/net/hamradio/hdlcdrv.c             |    1 
 drivers/net/mii.c                          |    2 
 drivers/net/pcmcia/3c574_cs.c              |    2 
 drivers/net/pcmcia/axnet_cs.c              |    1 
 drivers/net/pcmcia/pcnet_cs.c              |    1 
 drivers/net/pcmcia/xirc2ps_cs.c            |    2 
 drivers/net/phy/phy.c                      |    1 
 drivers/net/sis900.c                       |    2 
 drivers/net/skfp/skfddi.c                  |    1 
 drivers/net/sungem.c                       |    2 
 drivers/net/tlan.c                         |    1 
 drivers/net/tulip/de4x5.c                  |    2 
 drivers/net/tulip/tulip_core.c             |    2 
 drivers/net/wan/lmc/lmc_main.c             |    2 
 drivers/net/wan/pc300too.c                 |    2 
 drivers/net/wan/wanxl.c                    |    2 
 drivers/net/wireless/hostap/hostap_ioctl.c |    2 
 drivers/net/wireless/orinoco/wext.c        |    1 
 drivers/net/wireless/prism54/isl_ioctl.c   |    2 
 drivers/rapidio/rio-sysfs.c                |    2 
 drivers/usb/core/inode.c                   |    1 
 fs/9p/fid.c                                |    2 
 fs/9p/vfs_inode.c                          |    2 
 fs/9p/vfs_super.c                          |    2 
 fs/affs/inode.c                            |    1 
 fs/affs/super.c                            |    2 
 fs/anon_inodes.c                           |    2 
 fs/autofs/inode.c                          |    2 
 fs/autofs4/dev-ioctl.c                     |    2 
 fs/autofs4/inode.c                         |    2 
 fs/autofs4/waitq.c                         |    2 
 fs/bfs/dir.c                               |    2 
 fs/btrfs/inode.c                           |    2 
 fs/coda/cache.c                            |    2 
 fs/coda/upcall.c                           |    2 
 fs/configfs/inode.c                        |    1 
 fs/devpts/inode.c                          |    3 -
 fs/ecryptfs/kthread.c                      |    2 
 fs/ecryptfs/main.c                         |    2 
 fs/ecryptfs/messaging.c                    |    1 
 fs/ecryptfs/miscdev.c                      |    2 
 fs/eventpoll.c                             |    2 
 fs/exofs/inode.c                           |    2 
 fs/exportfs/expfs.c                        |    1 
 fs/ext2/acl.c                              |    1 
 fs/ext2/balloc.c                           |    1 
 fs/ext2/ialloc.c                           |    2 
 fs/ext2/ioctl.c                            |    1 
 fs/ext3/acl.c                              |    2 
 fs/ext3/balloc.c                           |    2 
 fs/ext3/ialloc.c                           |    2 
 fs/ext3/ioctl.c                            |    2 
 fs/ext4/acl.c                              |    2 
 fs/ext4/balloc.c                           |    2 
 fs/ext4/ialloc.c                           |    2 
 fs/ext4/ioctl.c                            |    2 
 fs/fat/inode.c                             |    2 
 fs/fuse/dev.c                              |    1 
 fs/fuse/dir.c                              |    1 
 fs/generic_acl.c                           |    2 
 fs/gfs2/acl.c                              |    2 
 fs/hfs/inode.c                             |    2 
 fs/hfs/super.c                             |    2 
 fs/hfsplus/inode.c                         |    2 
 fs/hfsplus/ioctl.c                         |    1 
 fs/hfsplus/options.c                       |    2 
 fs/hpfs/namei.c                            |    1 
 fs/hpfs/super.c                            |    1 
 fs/jffs2/acl.c                             |    2 
 fs/jffs2/fs.c                              |    1 
 fs/jfs/ioctl.c                             |    2 
 fs/jfs/jfs_inode.c                         |    2 
 fs/minix/bitmap.c                          |    1 
 fs/ncpfs/ioctl.c                           |    1 
 fs/nfsd/auth.c                             |    2 
 fs/nfsd/nfs4recover.c                      |    2 
 fs/nfsd/nfs4state.c                        |    2 
 fs/nfsd/nfsfh.c                            |    2 
 fs/nfsd/vfs.c                              |    2 
 fs/nilfs2/inode.c                          |    1 
 fs/notify/inotify/inotify_user.c           |    2 
 fs/ocfs2/acl.c                             |    2 
 fs/ocfs2/ioctl.c                           |    2 
 fs/ocfs2/namei.c                           |    2 
 fs/omfs/inode.c                            |    1 
 fs/pipe.c                                  |    2 
 fs/posix_acl.c                             |    2 
 fs/ramfs/inode.c                           |    2 
 fs/reiserfs/ioctl.c                        |    1 
 fs/reiserfs/namei.c                        |    2 
 fs/reiserfs/xattr_acl.c                    |    1 
 fs/smbfs/dir.c                             |    2 
 fs/smbfs/inode.c                           |    2 
 fs/sysfs/inode.c                           |    2 
 fs/sysv/ialloc.c                           |    2 
 fs/ubifs/budget.c                          |    1 
 fs/ubifs/dir.c                             |    1 
 fs/ubifs/file.c                            |    1 
 fs/ubifs/ioctl.c                           |    1 
 fs/udf/ialloc.c                            |    1 
 fs/udf/namei.c                             |    1 
 fs/ufs/ialloc.c                            |    2 
 fs/utimes.c                                |    1 
 fs/xfs/linux-2.6/xfs_cred.h                |    2 
 include/linux/cred.h                       |   56 +++++++++++++++++++++++++
 include/linux/sched.h                      |   63 -----------------------------
 include/linux/security.h                   |    1 
 kernel/cgroup.c                            |    1 
 kernel/futex.c                             |    1 
 kernel/futex_compat.c                      |    3 -
 kernel/ksysfs.c                            |    3 -
 kernel/timer.c                             |    2 
 kernel/trace/trace.c                       |    1 
 kernel/tsacct.c                            |    2 
 kernel/user.c                              |    2 
 mm/mlock.c                                 |    1 
 net/9p/client.c                            |    2 
 net/sunrpc/auth.c                          |    2 
 net/sunrpc/auth_generic.c                  |    3 -
 net/sunrpc/auth_gss/svcauth_gss.c          |    2 
 net/sunrpc/auth_unix.c                     |    3 -
 security/keys/internal.h                   |    1 
 security/selinux/exports.c                 |    1 
 security/tomoyo/tomoyo.h                   |    2 
 140 files changed, 197 insertions(+), 156 deletions(-)

--- a/arch/alpha/kernel/asm-offsets.c
+++ b/arch/alpha/kernel/asm-offsets.c
@@ -3,7 +3,7 @@
  * This code generates raw asm output which is post-processed to extract
  * and format the required data.
  */
-
+#include <linux/cred.h>
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/sched.h>
--- a/arch/ia64/kernel/mca_drv.c
+++ b/arch/ia64/kernel/mca_drv.c
@@ -8,6 +8,7 @@
  * Copyright (C) 2005 Keith Owens <kaos@sgi.com>
  * Copyright (C) 2006 Russ Anderson <rja@sgi.com>
  */
+#include <linux/cred.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/sched.h>
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -12,7 +12,7 @@
  *  Linux signals.  Therefore we don't.  HP/UX signals will go in
  *  arch/parisc/hpux/signal.c when we figure out how to do them.
  */
-
+#include <linux/cred.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/smp.h>
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -14,7 +14,7 @@
  *  as published by the Free Software Foundation; either version
  *  2 of the License, or (at your option) any later version.
  */
-
+#include <linux/cred.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -20,7 +20,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
-
+#include <linux/cred.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fsnotify.h>
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -9,6 +9,7 @@
 #define KMSG_COMPONENT "hypfs"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/cred.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -22,6 +22,7 @@
 #include <linux/magic.h>
 #include <linux/sched.h>
 #include <linux/types.h>
+#include <linux/cred.h>
 #include <linux/init.h>
 #include <linux/mman.h>
 #include <linux/tty.h>
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -48,7 +48,7 @@
  * - Should use an own CAP_* category instead of CAP_SYS_ADMIN
  *
  */
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/sched.h>
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/audit.h>
+#include <linux/cred.h>
 #include <linux/tty.h>
 
 struct tty_audit_buf {
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -35,6 +35,7 @@
  */
 
 #include "drmP.h"
+#include <linux/cred.h>
 #include <linux/poll.h>
 #include <linux/smp_lock.h>
 
--- a/drivers/isdn/capi/capifs.c
+++ b/drivers/isdn/capi/capifs.c
@@ -8,7 +8,7 @@
  * of the GNU General Public License, incorporated herein by reference.
  *
  */
-
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
--- a/drivers/isdn/hysdn/hysdn_procconf.c
+++ b/drivers/isdn/hysdn/hysdn_procconf.c
@@ -10,7 +10,7 @@
  * of the GNU General Public License, incorporated herein by reference.
  *
  */
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
--- a/drivers/media/video/cpia.c
+++ b/drivers/media/video/cpia.c
@@ -26,7 +26,7 @@
 /* define _CPIA_DEBUG_ for verbose debug output (see cpia.h) */
 /* #define _CPIA_DEBUG_  1 */
 
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
--- a/drivers/misc/eeprom/eeprom.c
+++ b/drivers/misc/eeprom/eeprom.c
@@ -19,7 +19,7 @@
     along with this program; if not, write to the Free Software
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
-
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -234,7 +234,7 @@
 
     =========================================================================
 */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
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
--- a/drivers/net/mii.c
+++ b/drivers/net/mii.c
@@ -26,7 +26,7 @@
 
 
  */
-
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
--- a/drivers/net/pcmcia/3c574_cs.c
+++ b/drivers/net/pcmcia/3c574_cs.c
@@ -68,7 +68,7 @@ Thanks to Terry Murphy of 3Com for providing development information for
 earlier 3Com products.
 
 */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -24,6 +24,7 @@
 
 ======================================================================*/
 
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- a/drivers/net/pcmcia/pcnet_cs.c
+++ b/drivers/net/pcmcia/pcnet_cs.c
@@ -28,6 +28,7 @@
 
 ======================================================================*/
 
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- a/drivers/net/pcmcia/xirc2ps_cs.c
+++ b/drivers/net/pcmcia/xirc2ps_cs.c
@@ -62,7 +62,7 @@
  * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
  * OF THE POSSIBILITY OF SUCH DAMAGE.
  */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
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
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -48,7 +48,7 @@
    Chin-Shan Li (lcs@sis.com.tw) Added AMD Am79c901 HomePNA PHY support
    Rev 1.05 Aug. 7 1999 Jim Huang (cmhuang@sis.com.tw) Initial release
 */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
--- a/drivers/net/skfp/skfddi.c
+++ b/drivers/net/skfp/skfddi.c
@@ -73,6 +73,7 @@ static const char * const boot_msg =
 
 /* Include files */
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -30,7 +30,7 @@
  *    locking in open/resume code path (gem_reinit_chip) by beeing more careful
  *    about when we can start taking interrupts or get xmit() called...
  */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
--- a/drivers/net/tlan.c
+++ b/drivers/net/tlan.c
@@ -170,6 +170,7 @@
  *
  *******************************************************************************/
 
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
--- a/drivers/net/tulip/de4x5.c
+++ b/drivers/net/tulip/de4x5.c
@@ -442,7 +442,7 @@
 			   <maz@wild-wind.fr.eu.org>
     =========================================================================
 */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
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
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -36,7 +36,7 @@
   * we no longer can transmit.
   *
   */
-
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
--- a/drivers/net/wan/pc300too.c
+++ b/drivers/net/wan/pc300too.c
@@ -16,7 +16,7 @@
  * This driver currently supports only PC300/RSV (V.24/V.35) and
  * PC300/X21 cards.
  */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -12,7 +12,7 @@
  *   - Only DTE (external clock) support with NRZ and NRZI encodings
  *   - wanXL100 will require minor driver modifications, no access to hw
  */
-
+#include <linux/capability.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -1,5 +1,5 @@
 /* ioctl() (mostly Linux Wireless Extensions) routines for Host AP driver */
-
+#include <linux/capability.h>
 #include <linux/types.h>
 #include <linux/ethtool.h>
 #include <linux/if_arp.h>
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -2,6 +2,7 @@
  *
  * See copyright notice in main.c
  */
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
 #include <linux/wireless.h>
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
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -9,7 +9,7 @@
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
  */
-
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/rio.h>
 #include <linux/rio_drv.h>
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -27,6 +27,7 @@
 
 /*****************************************************************************/
 
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -20,7 +20,7 @@
  *  Boston, MA  02111-1301  USA
  *
  */
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -22,7 +22,7 @@
  *  Boston, MA  02111-1301  USA
  *
  */
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -23,7 +23,7 @@
  *  Boston, MA  02111-1301  USA
  *
  */
-
+#include <linux/cred.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -9,6 +9,7 @@
  *
  *  (C) 1991  Linus Torvalds - minix filesystem
  */
+#include <linux/cred.h>
 #include <linux/sched.h>
 #include "affs.h"
 
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -9,7 +9,7 @@
  *
  *  (C) 1991  Linus Torvalds - minix filesystem
  */
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/statfs.h>
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -7,7 +7,7 @@
  *  More changes for Thomas Gleixner suggestions.
  *
  */
-
+#include <linux/cred.h>
 #include <linux/file.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -9,7 +9,7 @@
  * option, any later version, incorporated herein by reference.
  *
  * ------------------------------------------------------------------------- */
-
+#include <linux/cred.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -6,7 +6,7 @@
  * the terms of the GNU General Public License, version 2, or at your
  * option, any later version, incorporated herein by reference.
  */
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/miscdevice.h>
--- a/fs/autofs4/inode.c
+++ b/fs/autofs4/inode.c
@@ -10,7 +10,7 @@
  * option, any later version, incorporated herein by reference.
  *
  * ------------------------------------------------------------------------- */
-
+#include <linux/cred.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/file.h>
--- a/fs/autofs4/waitq.c
+++ b/fs/autofs4/waitq.c
@@ -10,7 +10,7 @@
  * option, any later version, incorporated herein by reference.
  *
  * ------------------------------------------------------------------------- */
-
+#include <linux/cred.h>
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/signal.h>
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -4,7 +4,7 @@
  *	Copyright (C) 1999,2000  Tigran Aivazian <tigran@veritas.com>
  *      Made endianness-clean by Andrew Stribblehill <ads@wompom.org> 2005
  */
-
+#include <linux/cred.h>
 #include <linux/time.h>
 #include <linux/string.h>
 #include <linux/fs.h>
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -15,7 +15,7 @@
  * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  * Boston, MA 021110-1307, USA.
  */
-
+#include <linux/cred.h>
 #include <linux/kernel.h>
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -6,7 +6,7 @@
  * Carnegie Mellon encourages users of this code to contribute improvements
  * to the Coda project http://www.coda.cs.cmu.edu/ <coda@cs.cmu.edu>.
  */
-
+#include <linux/cred.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/time.h>
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -13,7 +13,7 @@
  * Carnegie Mellon University encourages users of this code to contribute
  * improvements to the Coda project. Contact Peter Braam <coda@cs.cmu.edu>.
  */
-
+#include <linux/cred.h>
 #include <asm/system.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -28,6 +28,7 @@
 
 #undef DEBUG
 
+#include <linux/cred.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
 #include <linux/backing-dev.h>
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -9,11 +9,10 @@
  * option, any later version, incorporated herein by reference.
  *
  * ------------------------------------------------------------------------- */
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
-#include <linux/sched.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/tty.h>
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -19,7 +19,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
  * 02111-1307, USA.
  */
-
+#include <linux/cred.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/wait.h>
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -23,7 +23,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
  * 02111-1307, USA.
  */
-
+#include <linux/cred.h>
 #include <linux/dcache.h>
 #include <linux/file.h>
 #include <linux/module.h>
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -19,6 +19,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
  * 02111-1307, USA.
  */
+#include <linux/cred.h>
 #include <linux/sched.h>
 #include <linux/user_namespace.h>
 #include <linux/nsproxy.h>
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -18,7 +18,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
  * 02111-1307, USA.
  */
-
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/hash.h>
 #include <linux/random.h>
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -10,7 +10,7 @@
  *  Davide Libenzi <davidel@xmailserver.org>
  *
  */
-
+#include <linux/cred.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -32,7 +32,7 @@
  * along with exofs; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-
+#include <linux/cred.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
 #include <scsi/scsi_device.h>
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -8,6 +8,7 @@
  * For details on why we do all the strange and hairy things in here
  * take a look at Documentation/filesystems/Exporting.
  */
+#include <linux/cred.h>
 #include <linux/exportfs.h>
 #include <linux/fs.h>
 #include <linux/file.h>
--- a/fs/ext2/acl.c
+++ b/fs/ext2/acl.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/capability.h>
+#include <linux/cred.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -12,6 +12,7 @@
  */
 
 #include "ext2.h"
+#include <linux/cred.h>
 #include <linux/quotaops.h>
 #include <linux/sched.h>
 #include <linux/buffer_head.h>
--- a/fs/ext2/ialloc.c
+++ b/fs/ext2/ialloc.c
@@ -11,7 +11,7 @@
  *  Big-endian to little-endian byte-swapping/bitmaps by
  *        David S. Miller (davem@caip.rutgers.edu), 1995
  */
-
+#include <linux/cred.h>
 #include <linux/quotaops.h>
 #include <linux/sched.h>
 #include <linux/backing-dev.h>
--- a/fs/ext2/ioctl.c
+++ b/fs/ext2/ioctl.c
@@ -9,6 +9,7 @@
 
 #include "ext2.h"
 #include <linux/capability.h>
+#include <linux/cred.h>
 #include <linux/time.h>
 #include <linux/sched.h>
 #include <linux/compat.h>
--- a/fs/ext3/acl.c
+++ b/fs/ext3/acl.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2001-2003 Andreas Gruenbacher, <agruen@suse.de>
  */
-
+#include <linux/cred.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -10,7 +10,7 @@
  *  Big-endian to little-endian byte-swapping/bitmaps by
  *        David S. Miller (davem@caip.rutgers.edu), 1995
  */
-
+#include <linux/cred.h>
 #include <linux/time.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -11,7 +11,7 @@
  *  Big-endian to little-endian byte-swapping/bitmaps by
  *        David S. Miller (davem@caip.rutgers.edu), 1995
  */
-
+#include <linux/cred.h>
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/jbd.h>
--- a/fs/ext3/ioctl.c
+++ b/fs/ext3/ioctl.c
@@ -6,7 +6,7 @@
  * Laboratoire MASI - Institut Blaise Pascal
  * Universite Pierre et Marie Curie (Paris VI)
  */
-
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/jbd.h>
 #include <linux/capability.h>
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2001-2003 Andreas Gruenbacher, <agruen@suse.de>
  */
-
+#include <linux/cred.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -10,7 +10,7 @@
  *  Big-endian to little-endian byte-swapping/bitmaps by
  *        David S. Miller (davem@caip.rutgers.edu), 1995
  */
-
+#include <linux/cred.h>
 #include <linux/time.h>
 #include <linux/capability.h>
 #include <linux/fs.h>
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -11,7 +11,7 @@
  *  Big-endian to little-endian byte-swapping/bitmaps by
  *        David S. Miller (davem@caip.rutgers.edu), 1995
  */
-
+#include <linux/cred.h>
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/jbd2.h>
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -6,7 +6,7 @@
  * Laboratoire MASI - Institut Blaise Pascal
  * Universite Pierre et Marie Curie (Paris VI)
  */
-
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/jbd2.h>
 #include <linux/capability.h>
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -9,7 +9,7 @@
  *
  *	Max Cohan: Fixed invalid FSINFO offset when info_sector is 0
  */
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/time.h>
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -8,6 +8,7 @@
 
 #include "fuse_i.h"
 
+#include <linux/cred.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/poll.h>
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -8,6 +8,7 @@
 
 #include "fuse_i.h"
 
+#include <linux/cred.h>
 #include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/gfp.h>
--- a/fs/generic_acl.c
+++ b/fs/generic_acl.c
@@ -5,7 +5,7 @@
  *
  * This file is released under the GPL.
  */
-
+#include <linux/cred.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/generic_acl.h>
--- a/fs/gfs2/acl.c
+++ b/fs/gfs2/acl.c
@@ -6,7 +6,7 @@
  * modify, copy, or redistribute it subject to the terms and conditions
  * of the GNU General Public License version 2.
  */
-
+#include <linux/cred.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -10,7 +10,7 @@
  *
  * Based on the minix file system code, (C) 1991, 1992 by Linus Torvalds
  */
-
+#include <linux/cred.h>
 #include <linux/pagemap.h>
 #include <linux/mpage.h>
 #include <linux/sched.h>
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -11,7 +11,7 @@
  *
  * Based on the minix file system code, (C) 1991, 1992 by Linus Torvalds
  */
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/mount.h>
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -7,7 +7,7 @@
  *
  * Inode handling routines
  */
-
+#include <linux/cred.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/capability.h>
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/sched.h>
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -7,7 +7,7 @@
  *
  * Option parsing
  */
-
+#include <linux/cred.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -5,6 +5,7 @@
  *
  *  adding & removing files & directories
  */
+#include <linux/cred.h>
 #include <linux/sched.h>
 #include "hpfs_fn.h"
 
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -7,6 +7,7 @@
  */
 
 #include "hpfs_fn.h"
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/parser.h>
 #include <linux/init.h>
--- a/fs/jffs2/acl.c
+++ b/fs/jffs2/acl.c
@@ -8,7 +8,7 @@
  * For licensing information, see the file 'LICENCE' in this directory.
  *
  */
-
+#include <linux/cred.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/capability.h>
+#include <linux/cred.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
--- a/fs/jfs/ioctl.c
+++ b/fs/jfs/ioctl.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2006 Herbert Poetzl
  * adapted from Remy Card's ext2/ioctl.c
  */
-
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/ctype.h>
 #include <linux/capability.h>
--- a/fs/jfs/jfs_inode.c
+++ b/fs/jfs/jfs_inode.c
@@ -15,7 +15,7 @@
  *   along with this program;  if not, write to the Free Software
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
-
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/quotaops.h>
 #include "jfs_incore.h"
--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -12,6 +12,7 @@
 /* bitmap.c contains the code that handles the inode and block bitmaps */
 
 #include "minix.h"
+#include <linux/cred.h>
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/bitops.h>
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -9,6 +9,7 @@
 
 #include <linux/capability.h>
 #include <linux/compat.h>
+#include <linux/cred.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 1995, 1996 Olaf Kirch <okir@monad.swb.de>
  */
-
+#include <linux/cred.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/sunrpc/svc.h>
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -32,7 +32,7 @@
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */
-
+#include <linux/cred.h>
 #include <linux/err.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -33,7 +33,7 @@
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */
-
+#include <linux/cred.h>
 #include <linux/param.h>
 #include <linux/major.h>
 #include <linux/slab.h>
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -8,7 +8,7 @@
  * Extensive rewrite by Neil Brown <neilb@cse.unsw.edu.au> Southern-Spring 1999
  * ... and again Southern-Winter 2001 to support export_operations
  */
-
+#include <linux/cred.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/unistd.h>
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -15,7 +15,7 @@
  * Copyright (C) 1995-1999 Olaf Kirch <okir@monad.swb.de>
  * Zerocpy NFS support (C) 2002 Hirokazu Takahashi <taka@valinux.co.jp>
  */
-
+#include <linux/cred.h>
 #include <linux/string.h>
 #include <linux/time.h>
 #include <linux/errno.h>
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/buffer_head.h>
+#include <linux/cred.h>
 #include <linux/mpage.h>
 #include <linux/writeback.h>
 #include <linux/uio.h>
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -18,7 +18,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
-
+#include <linux/cred.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
--- a/fs/ocfs2/acl.c
+++ b/fs/ocfs2/acl.c
@@ -18,7 +18,7 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  */
-
+#include <linux/cred.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/string.h>
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2006 Herbert Poetzl
  * adapted from Remy Card's ext2/ioctl.c
  */
-
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/smp_lock.h>
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -35,7 +35,7 @@
  * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  * Boston, MA 021110-1307, USA.
  */
-
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/types.h>
 #include <linux/slab.h>
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2006 Bob Copeland <me@bobcopeland.com>
  * Released under GPL v2.
  */
+#include <linux/cred.h>
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/sched.h>
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 1991, 1992, 1999  Linus Torvalds
  */
-
+#include <linux/cred.h>
 #include <linux/mm.h>
 #include <linux/file.h>
 #include <linux/poll.h>
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -11,7 +11,7 @@
  *  This file contains generic functions for manipulating
  *  POSIX 1003.1e draft standard 17 ACLs.
  */
-
+#include <linux/cred.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <asm/atomic.h>
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -22,7 +22,7 @@
  * to keep track of the virtual data: using the VFS
  * caches is sufficient.
  */
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -3,6 +3,7 @@
  */
 
 #include <linux/capability.h>
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
 #include <linux/reiserfs_fs.h>
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -10,7 +10,7 @@
  *
  * NO WARRANTY
  */
-
+#include <linux/cred.h>
 #include <linux/time.h>
 #include <linux/bitops.h>
 #include <linux/reiserfs_fs.h>
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -1,4 +1,5 @@
 #include <linux/capability.h>
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/posix_acl.h>
 #include <linux/reiserfs_fs.h>
--- a/fs/smbfs/dir.c
+++ b/fs/smbfs/dir.c
@@ -6,7 +6,7 @@
  *
  *  Please add a note about your changes to smbfs in the ChangeLog file.
  */
-
+#include <linux/cred.h>
 #include <linux/time.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
--- a/fs/smbfs/inode.c
+++ b/fs/smbfs/inode.c
@@ -6,7 +6,7 @@
  *
  *  Please add a note about your changes to smbfs in the ChangeLog file.
  */
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/kernel.h>
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -12,12 +12,12 @@
 
 #undef DEBUG 
 
+#include <linux/cred.h>
 #include <linux/pagemap.h>
 #include <linux/namei.h>
 #include <linux/backing-dev.h>
 #include <linux/capability.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include "sysfs.h"
 
 extern struct super_block * sysfs_sb;
--- a/fs/sysv/ialloc.c
+++ b/fs/sysv/ialloc.c
@@ -18,7 +18,7 @@
  *
  *  This file contains code for allocating/freeing inodes.
  */
-
+#include <linux/cred.h>
 #include <linux/kernel.h>
 #include <linux/stddef.h>
 #include <linux/sched.h>
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -31,6 +31,7 @@
  */
 
 #include "ubifs.h"
+#include <linux/cred.h>
 #include <linux/writeback.h>
 #include <linux/math64.h>
 
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -41,6 +41,7 @@
  */
 
 #include "ubifs.h"
+#include <linux/cred.h>
 
 /**
  * inherit_flags - inherit flags of the parent inode.
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -52,6 +52,7 @@
  */
 
 #include "ubifs.h"
+#include <linux/cred.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
 
--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -25,6 +25,7 @@
 /* This file implements EXT2-compatible extended attribute ioctl() calls */
 
 #include <linux/compat.h>
+#include <linux/cred.h>
 #include <linux/smp_lock.h>
 #include <linux/mount.h>
 #include "ubifs.h"
--- a/fs/udf/ialloc.c
+++ b/fs/udf/ialloc.c
@@ -19,6 +19,7 @@
  */
 
 #include "udfdecl.h"
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/quotaops.h>
 #include <linux/sched.h>
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -23,6 +23,7 @@
 
 #include "udf_i.h"
 #include "udf_sb.h"
+#include <linux/cred.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
--- a/fs/ufs/ialloc.c
+++ b/fs/ufs/ialloc.c
@@ -22,7 +22,7 @@
  * UFS2 write support added by
  * Evgeniy Dushistov <dushistov@mail.ru>, 2007
  */
-
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/time.h>
 #include <linux/stat.h>
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -1,4 +1,5 @@
 #include <linux/compiler.h>
+#include <linux/cred.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/linkage.h>
--- a/fs/xfs/linux-2.6/xfs_cred.h
+++ b/fs/xfs/linux-2.6/xfs_cred.h
@@ -18,7 +18,7 @@
 #ifndef __XFS_CRED_H__
 #define __XFS_CRED_H__
 
-#include <linux/capability.h>
+#include <linux/cred.h>
 
 /*
  * Credentials
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -15,9 +15,10 @@
 #include <linux/capability.h>
 #include <linux/init.h>
 #include <linux/key.h>
+#include <linux/kobject.h>
+#include <linux/workqueue.h>
 #include <asm/atomic.h>
 
-struct user_struct;
 struct cred;
 struct inode;
 
@@ -75,6 +76,59 @@ extern int in_group_p(gid_t);
 extern int in_egroup_p(gid_t);
 
 /*
+ * Some day this will be a full-fledged user tracking system..
+ */
+struct user_struct {
+	atomic_t __count;	/* reference count */
+	atomic_t processes;	/* How many processes does this user have? */
+	atomic_t files;		/* How many open files does this user have? */
+	atomic_t sigpending;	/* How many pending signals does this user have? */
+#ifdef CONFIG_INOTIFY_USER
+	atomic_t inotify_watches; /* How many inotify watches does this user have? */
+	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
+#endif
+#ifdef CONFIG_EPOLL
+	atomic_t epoll_watches;	/* The number of file descriptors currently watched */
+#endif
+#ifdef CONFIG_POSIX_MQUEUE
+	/* protected by mq_lock	*/
+	unsigned long mq_bytes;	/* How many bytes can be allocated to mqueue? */
+#endif
+	unsigned long locked_shm; /* How many pages of mlocked shm ? */
+
+#ifdef CONFIG_KEYS
+	struct key *uid_keyring;	/* UID specific keyring */
+	struct key *session_keyring;	/* UID's default session keyring */
+#endif
+
+	/* Hash table maintenance information */
+	struct hlist_node uidhash_node;
+	uid_t uid;
+	struct user_namespace *user_ns;
+
+#ifdef CONFIG_USER_SCHED
+	struct task_group *tg;
+#ifdef CONFIG_SYSFS
+	struct kobject kobj;
+	struct work_struct work;
+#endif
+#endif
+};
+
+int uids_sysfs_init(void);
+struct user_struct *find_user(uid_t);
+extern struct user_struct root_user;
+#define INIT_USER (&root_user)
+/* per-UID process charging. */
+struct user_struct *alloc_uid(struct user_namespace *, uid_t);
+static inline struct user_struct *get_uid(struct user_struct *u)
+{
+	atomic_inc(&u->__count);
+	return u;
+}
+void free_uid(struct user_struct *);
+
+/*
  * The common credentials for a thread group
  * - shared by CLONE_THREAD
  */
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -47,7 +47,6 @@ struct sched_param {
 
 #include <asm/param.h>	/* for HZ */
 
-#include <linux/capability.h>
 #include <linux/threads.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -85,12 +84,11 @@ struct sched_param {
 #include <linux/timer.h>
 #include <linux/hrtimer.h>
 #include <linux/task_io_accounting.h>
-#include <linux/kobject.h>
 #include <linux/latencytop.h>
-#include <linux/cred.h>
 
 #include <asm/processor.h>
 
+struct cred;
 struct mem_cgroup;
 struct exec_domain;
 struct futex_pi_state;
@@ -98,6 +96,7 @@ struct robust_list_head;
 struct bio;
 struct bts_tracer;
 struct fs_struct;
+struct user_struct;
 
 /*
  * List of flags we want to share for kernel threads,
@@ -634,54 +633,6 @@ static inline int signal_group_exit(const struct signal_struct *sig)
 		(sig->group_exit_task != NULL);
 }
 
-/*
- * Some day this will be a full-fledged user tracking system..
- */
-struct user_struct {
-	atomic_t __count;	/* reference count */
-	atomic_t processes;	/* How many processes does this user have? */
-	atomic_t files;		/* How many open files does this user have? */
-	atomic_t sigpending;	/* How many pending signals does this user have? */
-#ifdef CONFIG_INOTIFY_USER
-	atomic_t inotify_watches; /* How many inotify watches does this user have? */
-	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
-#endif
-#ifdef CONFIG_EPOLL
-	atomic_t epoll_watches;	/* The number of file descriptors currently watched */
-#endif
-#ifdef CONFIG_POSIX_MQUEUE
-	/* protected by mq_lock	*/
-	unsigned long mq_bytes;	/* How many bytes can be allocated to mqueue? */
-#endif
-	unsigned long locked_shm; /* How many pages of mlocked shm ? */
-
-#ifdef CONFIG_KEYS
-	struct key *uid_keyring;	/* UID specific keyring */
-	struct key *session_keyring;	/* UID's default session keyring */
-#endif
-
-	/* Hash table maintenance information */
-	struct hlist_node uidhash_node;
-	uid_t uid;
-	struct user_namespace *user_ns;
-
-#ifdef CONFIG_USER_SCHED
-	struct task_group *tg;
-#ifdef CONFIG_SYSFS
-	struct kobject kobj;
-	struct work_struct work;
-#endif
-#endif
-};
-
-extern int uids_sysfs_init(void);
-
-extern struct user_struct *find_user(uid_t);
-
-extern struct user_struct root_user;
-#define INIT_USER (&root_user)
-
-
 struct backing_dev_info;
 struct reclaim_state;
 
@@ -1857,16 +1808,6 @@ extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 
 extern void __set_special_pids(struct pid *pid);
 
-/* per-UID process charging. */
-extern struct user_struct * alloc_uid(struct user_namespace *, uid_t);
-static inline struct user_struct *get_uid(struct user_struct *u)
-{
-	atomic_inc(&u->__count);
-	return u;
-}
-extern void free_uid(struct user_struct *);
-extern void release_uids(struct user_namespace *ns);
-
 #include <asm/current.h>
 
 extern void do_timer(unsigned long ticks);
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -22,6 +22,7 @@
 #ifndef __LINUX_SECURITY_H
 #define __LINUX_SECURITY_H
 
+#include <linux/cred.h>
 #include <linux/fs.h>
 #include <linux/binfmts.h>
 #include <linux/signal.h>
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/cgroup.h>
+#include <linux/cred.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -40,6 +40,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#include <linux/cred.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/fs.h>
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -5,7 +5,8 @@
  *
  * Copyright 2006, Red Hat, Inc., Ingo Molnar
  */
-
+#include <linux/capability.h>
+#include <linux/cred.h>
 #include <linux/linkage.h>
 #include <linux/compat.h>
 #include <linux/nsproxy.h>
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -7,7 +7,7 @@
  * This file is release under the GPLv2
  *
  */
-
+#include <linux/cred.h>
 #include <linux/kobject.h>
 #include <linux/string.h>
 #include <linux/sysfs.h>
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/kexec.h>
 #include <linux/profile.h>
-#include <linux/sched.h>
 
 #define KERNEL_ATTR_RO(_name) \
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -18,7 +18,7 @@
  *                              Copyright (C) 2000, 2001, 2002  Ingo Molnar
  *              Designed by David S. Miller, Alexey Kuznetsov and Ingo Molnar
  */
-
+#include <linux/cred.h>
 #include <linux/kernel_stat.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -32,6 +32,7 @@
 #include <linux/kdebug.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
+#include <linux/cred.h>
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/gfp.h>
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -15,7 +15,7 @@
  * GNU General Public License for more details.
  *
  */
-
+#include <linux/cred.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/tsacct_kern.h>
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -7,7 +7,7 @@
  * processes, files etc the user has claimed, in order to be
  * able to have per-user limits for system resources. 
  */
-
+#include <linux/cred.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/capability.h>
+#include <linux/cred.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -22,7 +22,7 @@
  *  Boston, MA  02111-1301  USA
  *
  */
-
+#include <linux/cred.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -5,7 +5,7 @@
  *
  * Copyright (C) 1996, Olaf Kirch <okir@monad.swb.de>
  */
-
+#include <linux/cred.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/module.h>
--- a/net/sunrpc/auth_generic.c
+++ b/net/sunrpc/auth_generic.c
@@ -3,11 +3,10 @@
  *
  * Copyright (C) 2008, Trond Myklebust <Trond.Myklebust@netapp.com>
  */
-
+#include <linux/cred.h>
 #include <linux/err.h>
 #include <linux/types.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/sunrpc/auth.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/debug.h>
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -36,7 +36,7 @@
  *   mechanism specific information, such as a key
  *
  */
-
+#include <linux/cred.h>
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -5,9 +5,8 @@
  *
  * Copyright (C) 1996, Olaf Kirch <okir@monad.swb.de>
  */
-
+#include <linux/cred.h>
 #include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/sunrpc/auth.h>
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -12,6 +12,7 @@
 #ifndef _INTERNAL_H
 #define _INTERNAL_H
 
+#include <linux/cred.h>
 #include <linux/sched.h>
 #include <linux/key-type.h>
 
--- a/security/selinux/exports.c
+++ b/security/selinux/exports.c
@@ -11,6 +11,7 @@
  * it under the terms of the GNU General Public License version 2,
  * as published by the Free Software Foundation.
  */
+#include <linux/cred.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
--- a/security/tomoyo/tomoyo.h
+++ b/security/tomoyo/tomoyo.h
@@ -12,6 +12,8 @@
 #ifndef _SECURITY_TOMOYO_TOMOYO_H
 #define _SECURITY_TOMOYO_TOMOYO_H
 
+#include <linux/cred.h>
+
 struct tomoyo_path_info;
 struct path;
 struct inode;
