Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYJTTWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYJTTWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 15:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYJTTWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 15:22:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59221 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYJTTWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 15:22:00 -0400
Date: Mon, 20 Oct 2008 21:21:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland Dreier <rdreier@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>
Subject: Re: [announce] new tree: "fix all build warnings, on all configs"
Message-ID: <20081020192110.GA28736@elte.hu>
References: <20081017171139.GA1792@elte.hu> <ada3aiv9k6j.fsf@cisco.com> <20081017180523.GA11590@elte.hu> <adatzbbrrcf.fsf@cisco.com> <20081017191202.GA5396@elte.hu> <adaiqrrrp2h.fsf@cisco.com> <20081018082209.GA24220@elte.hu> <alpine.LFD.2.00.0810200933470.3518@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0810200933470.3518@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> That thing is supposed to be a 5-byte memcpy. Not a "take a random 
> byte from a random location and move it to another random location". 
> That would be "randcpy()", not "memcpy()".
> 
> I don't want to see obvious and shitty crap like this. I don't want to 
> pull from people who write code with some "random walk" algorithm.

yes, the patch is worse than crap, so i:

 1) signalled that it's crap in its branch name (warnings/ugly)
 2) named it a hack in the subject line: "hack, workaround for warning"
 3) explained it in the commit log that GCC is crap
 4) added a NOT-Signed-off

but i guess i should not even have created it, because it shows a broken 
"symptom driven" thought process when it was created.

So i zapped the 'ugly' branch completely and removed all those commits. 
Will filter out bogus warnings via different technical means. Have no 
ideas at the moment of how to do it technically though - filtering the 
compiler output does not work reliably.

Below are the kind of commits i want to end up with eventually and 
reliably.

	Ingo

------------------>

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git warnings/simple

Ingo Molnar (10):
      x86: fix default_spin_lock_flags() prototype
      drivers/ide/pci/hpt366.c: remove unused variable
      drivers/net/wireless/b43/phy_g.c: type check debug printouts
      drivers/video/cirrusfb.c: remove unused variables
      fs/afs/dir.c: fix uninitialized variable use
      net/netlabel/netlabel_addrlist.c: add type checking to audit_log_format()
      include/linux/fs.h: improve type checking of __mandatory_lock()
      [vfs] fs.h: fops_get()/fops_put(): use pointer comparison
      net/mac80211/rc80211_minstrel_debugfs.c: fix return type
      sound/soc/codecs/tlv320aic23.c: remove unused variable


 arch/x86/kernel/paravirt-spinlocks.c    |    3 ++-
 drivers/ide/pci/hpt366.c                |    1 -
 drivers/net/wireless/b43/b43.h          |    3 ++-
 drivers/video/cirrusfb.c                |    3 +--
 fs/afs/dir.c                            |    2 +-
 include/linux/audit.h                   |    3 ++-
 include/linux/fs.h                      |    6 +++---
 net/mac80211/rc80211_minstrel_debugfs.c |    2 +-
 sound/soc/codecs/tlv320aic23.c          |    2 --
 9 files changed, 12 insertions(+), 13 deletions(-)

commit 54b1d646d442289d8d49e04bc2f10ba122ff6aa4
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 12:07:47 2008 +0200

    sound/soc/codecs/tlv320aic23.c: remove unused variable
    
    this warning:
    
      sound/soc/codecs/tlv320aic23.c: In function ‘tlv320aic23_set_dai_sysclk’:
      sound/soc/codecs/tlv320aic23.c:424: warning: unused variable ‘codec’
    
    triggers because this variable is not used in any form.
    
    Remove it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index 44308da..45395d0 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -421,8 +421,6 @@ static int tlv320aic23_set_dai_fmt(struct snd_soc_dai *codec_dai,
 static int tlv320aic23_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 				      int clk_id, unsigned int freq, int dir)
 {
-	struct snd_soc_codec *codec = codec_dai->codec;
-
 	switch (freq) {
 	case 12000000:
 		return 0;

commit 0be735b3ff71e13e24b82420f23a1b3b0a207ffb
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 12:56:23 2008 +0200

    net/mac80211/rc80211_minstrel_debugfs.c: fix return type
    
    this warning:
    
      net/mac80211/rc80211_minstrel_debugfs.c:145: warning: initialization from incompatible pointer type
    
    triggers because the proper return type for file_operations::read
    is ssize_t, not int.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 0b024cd..26f8ffc 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -106,7 +106,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int
+static ssize_t
 minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *o)
 {
 	struct minstrel_stats_info *ms;

commit 04271505e03535e1fd085c96085fcee41e7c415f
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Aug 18 15:31:58 2008 +0200

    [vfs] fs.h: fops_get()/fops_put(): use pointer comparison
    
    this warning:
    
      drivers/infiniband/core/uverbs_main.c: In function ‘ib_uverbs_alloc_event_file’:
      drivers/infiniband/core/uverbs_main.c:526: warning: the address of ‘uverbs_event_fops’ will always evaluate as ‘true’
      drivers/infiniband/core/uverbs_main.c:526: warning: assignment discards qualifiers from pointer target type
    
    triggers because we use an arithmetic comparison. Use a pointer
    comparison instead.
    
    No code changed:
       91bef63ad2e661e7adb4456b944cec7d  uverbs_main.o.before.asm
       91bef63ad2e661e7adb4456b944cec7d  uverbs_main.o.after.asm
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 686d46c..114f469 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1597,9 +1597,9 @@ void unnamed_dev_init(void);
 
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
-	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
+	(((fops != NULL) && try_module_get((fops)->owner) ? (fops) : NULL))
 #define fops_put(fops) \
-	do { if (fops) module_put((fops)->owner); } while(0)
+	do { if (fops != NULL) module_put((fops)->owner); } while(0)
 
 extern int register_filesystem(struct file_system_type *);
 extern int unregister_filesystem(struct file_system_type *);

commit f81ee5ca545020daf0ddfff3744199b87bbd8c70
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 14:54:48 2008 +0200

    include/linux/fs.h: improve type checking of __mandatory_lock()
    
    this warning:
    
      fs/gfs2/ops_file.c: In function ‘gfs2_flock’:
      fs/gfs2/ops_file.c:722: warning: unused variable ‘ip’
    
    triggers because __mandatory_lock() should not be a macro in the
    !CONFIG_FILE_LOCKING case but an inline. This improves the type
    checking and also does not trigger a warning.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a6a625b..686d46c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1675,7 +1675,7 @@ static inline int break_lease(struct inode *inode, unsigned int mode)
 #else /* !CONFIG_FILE_LOCKING */
 #define locks_mandatory_locked(a) ({ 0; })
 #define locks_mandatory_area(a, b, c, d, e) ({ 0; })
-#define __mandatory_lock(a) ({ 0; })
+static inline int __mandatory_lock(struct inode *ino) { return 0; }
 #define mandatory_lock(a) ({ 0; })
 #define locks_verify_locked(a) ({ 0; })
 #define locks_verify_truncate(a, b, c) ({ 0; })

commit 5baf34fc63c31ef676e0a764415b10e5cc1c7a4b
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 14:25:36 2008 +0200

    net/netlabel/netlabel_addrlist.c: add type checking to audit_log_format()
    
    this warning:
    
      net/netlabel/netlabel_addrlist.c: In function ‘netlbl_af4list_audit_addr’:
      net/netlabel/netlabel_addrlist.c:335: warning: unused variable ‘dir’
      net/netlabel/netlabel_addrlist.c: In function ‘netlbl_af6list_audit_addr’:
      net/netlabel/netlabel_addrlist.c:369: warning: unused variable ‘dir’
    
    is caused because audit_log_format() is a macro, hence in the
    !CONFIG_AUDIT case the compiler does not know that the variables are
    used.
    
    Convert it to a proper inline instead. This improves type checking
    in the !CONFIG_AUDIT case.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 6272a39..a3f78d0 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -580,7 +580,8 @@ extern int audit_enabled;
 #define audit_log(c,g,t,f,...) do { ; } while (0)
 #define audit_log_start(c,g,t) ({ NULL; })
 #define audit_log_vformat(b,f,a) do { ; } while (0)
-#define audit_log_format(b,f,...) do { ; } while (0)
+static inline void __attribute__ ((format(printf, 2, 3)))
+audit_log_format(struct audit_buffer *ab, const char *fmt, ...) { }
 #define audit_log_end(b) do { ; } while (0)
 #define audit_log_n_hex(a,b,l) do { ; } while (0)
 #define audit_log_n_string(a,c,l) do { ; } while (0)

commit d58cbf52cb25e215c0e34048bda8ec481bdce4af
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 14:18:31 2008 +0200

    fs/afs/dir.c: fix uninitialized variable use
    
    this warning:
    
      fs/afs/dir.c: In function ‘afs_d_revalidate’:
      fs/afs/dir.c:566: warning: ‘fid.vnode’ may be used uninitialized in this function
      fs/afs/dir.c:566: warning: ‘fid.unique’ may be used uninitialized in this function
    
    shows us a real bug: afs_dir_get_page() could use the uninitialized
    fid variable if CONFIG_AFS_DEBUG=y to print messages, and leak kernel
    stack data to the console.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index dfda03d..254c567 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -563,7 +563,7 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct afs_vnode *vnode, *dir;
-	struct afs_fid fid;
+	struct afs_fid fid = { 0, };
 	struct dentry *parent;
 	struct key *key;
 	void *dir_version;

commit 19be5d76a014ce0e743848a42cbb3b579c0ad8d7
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 13:40:00 2008 +0200

    drivers/video/cirrusfb.c: remove unused variables
    
    fix these warnings:
    
      drivers/video/cirrusfb.c: In function ‘cirrusfb_setup’:
      drivers/video/cirrusfb.c:2466: warning: unused variable ‘i’
      drivers/video/cirrusfb.c:2465: warning: unused variable ‘s’
    
    These two parameters are not used anymore, their use got removed
    in this commit:
    
      a1d35a7: cirrusfb: use modedb and add mode_option parameter
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 048b139..ace4001 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -2462,8 +2462,7 @@ static int __init cirrusfb_init(void)
 
 #ifndef MODULE
 static int __init cirrusfb_setup(char *options) {
-	char *this_opt, s[32];
-	int i;
+	char *this_opt;
 
 	DPRINTK("ENTER\n");
 

commit d138e44e2f8d0f26e04b0386d328d9cc7e33d82e
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 14:30:37 2008 +0200

    drivers/net/wireless/b43/phy_g.c: type check debug printouts
    
    this warning:
    
      drivers/net/wireless/b43/phy_g.c: In function ‘b43_gphy_op_recalc_txpower’:
      drivers/net/wireless/b43/phy_g.c:3191: warning: unused variable ‘dbm’
    
    is caused because b43dbg() is a macro, hence in the !B43_DEBUG
    case the compiler does not know that the variables are used.
    
    Convert it to a proper inline instead. This also improves type checking
    in the !B43_DEBUG case.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 427b820..ac55b62 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -853,7 +853,8 @@ void b43warn(struct b43_wl *wl, const char *fmt, ...)
 void b43dbg(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
 #else /* DEBUG */
-# define b43dbg(wl, fmt...) do { /* nothing */ } while (0)
+static inline void __attribute__ ((format(printf, 2, 3)))
+b43dbg(struct b43_wl *wl, const char *fmt, ...) { }
 #endif /* DEBUG */
 
 /* A WARN_ON variant that vanishes when b43 debugging is disabled.

commit f11adf3c65aff25074d5d3a90d72cdfc40d66b50
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 12:54:56 2008 +0200

    drivers/ide/pci/hpt366.c: remove unused variable
    
    this warning:
    
      drivers/ide/pci/hpt366.c: In function ‘init_hwif_hpt366’:
      drivers/ide/pci/hpt366.c:1292: warning: unused variable ‘dev’
    
    triggers because this variable is not used in this function at all.
    
    Remov it.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index 9cf171c..ca0acb5 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1289,7 +1289,6 @@ static u8 hpt3xx_cable_detect(ide_hwif_t *hwif)
 
 static void __devinit init_hwif_hpt366(ide_hwif_t *hwif)
 {
-	struct pci_dev *dev	= to_pci_dev(hwif->dev);
 	struct hpt_info *info	= hpt3xx_get_info(hwif->dev);
 	int serialize		= HPT_SERIALIZE_IO;
 	u8  chip_type		= info->chip_type;

commit ecd05381e26b9a61e49fa485baea1595bd3d1b40
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Oct 17 16:09:57 2008 +0200

    x86: fix default_spin_lock_flags() prototype
    
    these warnings:
    
      arch/x86/kernel/paravirt-spinlocks.c: In function ‘default_spin_lock_flags’:
      arch/x86/kernel/paravirt-spinlocks.c:12: warning: passing argument 1 of ‘__raw_spin_lock’ from incompatible pointer type
      arch/x86/kernel/paravirt-spinlocks.c: At top level:
      arch/x86/kernel/paravirt-spinlocks.c:11: warning: ‘default_spin_lock_flags’ defined but not used
    
    showed that the prototype of default_spin_lock_flags() was confused about
    what type spinlocks have.
    
    the proper type on UP is raw_spinlock_t.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 0e9f198..95777b0 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -7,7 +7,8 @@
 
 #include <asm/paravirt.h>
 
-static void default_spin_lock_flags(struct raw_spinlock *lock, unsigned long flags)
+static inline void
+default_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
 {
 	__raw_spin_lock(lock);
 }
