Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbYJZP1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbYJZP1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 11:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbYJZP05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 11:26:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:24897 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYJZP04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 11:26:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h+bLg+MgcS2Fxtv78bB9DYxRX/0jta6fixIR4ByDgwJw23nba7Ym6Bax+yfGVz/yZL
         1QeWbbutv2CW0XROkoCKkUBdji3vdRgBMQfqxSvb+2C5AKAc1nqnVYP4wZ1t1xVRLokM
         Fo7LMeOOuuM0BwOcyU55eOGW98ohrb+rn9ijI=
Date: Sun, 26 Oct 2008 16:23:10 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Rename DECLARE_MUTEX to DEFINE_SEMAPHORE
Message-ID: <20081026152306.GA29017@joi>
References: <20081026120609.GA10728@joi> <1225028346.32713.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225028346.32713.11.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 02:39:06PM +0100, Peter Zijlstra wrote:
> On Sun, 2008-10-26 at 13:06 +0100, Marcin Slusarz wrote:
> > DECLARE_MUTEX is doubly misleading name (it actually _defines_ struct
> > _semaphore_ initialized to 1) and it can be confused with DEFINE_MUTEX
> > (which defines real struct mutex). Rename it.
> 
> I'd prefer DEFINE_BINARY_SEM or somesuch

Sounds better.

---
Subject: [PATCH] Rename DECLARE_MUTEX to DEFINE_BINARY_SEM

DECLARE_MUTEX is doubly misleading name (it actually _defines_ struct
_semaphore_ initialized to 1) and it can be confused with DEFINE_MUTEX
(which defines real struct mutex). Rename it.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/arm/mach-lh7a40x/clocks.c      |    2 +-
 drivers/macintosh/adb.c             |    2 +-
 drivers/staging/go7007/go7007-i2c.c |    4 ++--
 include/linux/semaphore.h           |    5 +++--
 kernel/printk.c                     |    4 ++--
 lib/dynamic_printk.c                |    2 +-
 scripts/checkpatch.pl               |    2 +-
 sound/soc/s3c24xx/s3c2443-ac97.c    |    2 +-
 8 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-lh7a40x/clocks.c b/arch/arm/mach-lh7a40x/clocks.c
index 4fb23ac..de27e81 100644
--- a/arch/arm/mach-lh7a40x/clocks.c
+++ b/arch/arm/mach-lh7a40x/clocks.c
@@ -80,7 +80,7 @@ unsigned int pclkfreq_get (void)
 /* ----- */
 
 static LIST_HEAD(clocks);
-static DECLARE_MUTEX(clocks_sem);
+static DEFINE_BINARY_SEM(clocks_sem);
 
 struct clk *clk_get (struct device *dev, const char *id)
 {
diff --git a/drivers/macintosh/adb.c b/drivers/macintosh/adb.c
index 23741ce..7cf07c2 100644
--- a/drivers/macintosh/adb.c
+++ b/drivers/macintosh/adb.c
@@ -83,7 +83,7 @@ static struct adb_driver *adb_controller;
 BLOCKING_NOTIFIER_HEAD(adb_client_list);
 static int adb_got_sleep;
 static int adb_inited;
-static DECLARE_MUTEX(adb_probe_mutex);
+static DEFINE_BINARY_SEM(adb_probe_mutex);
 static int sleepy_trackpad;
 static int autopoll_devs;
 int __adb_probe_sync;
diff --git a/drivers/staging/go7007/go7007-i2c.c b/drivers/staging/go7007/go7007-i2c.c
index cd55b76..6f698af 100644
--- a/drivers/staging/go7007/go7007-i2c.c
+++ b/drivers/staging/go7007/go7007-i2c.c
@@ -56,7 +56,7 @@ struct wis_i2c_client_driver {
 };
 
 static LIST_HEAD(i2c_client_drivers);
-static DECLARE_MUTEX(i2c_client_driver_list_lock);
+static DEFINE_BINARY_SEM(i2c_client_driver_list_lock);
 
 /* Client drivers register here by their I2C driver ID */
 int wis_i2c_add_driver(unsigned int id, found_proc found_proc)
@@ -129,7 +129,7 @@ int wis_i2c_probe_device(struct i2c_adapter *adapter,
 
 /* There is only one I2C port on the TW2804 that feeds all four GO7007 VIPs
  * on the Adlink PCI-MPG24, so access is shared between all of them. */
-static DECLARE_MUTEX(adlink_mpg24_i2c_lock);
+static DEFINE_BINARY_SEM(adlink_mpg24_i2c_lock);
 
 static int go7007_i2c_xfer(struct go7007 *go, u16 addr, int read,
 		u16 command, int flags, u8 *data)
diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 7415839..824b423 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -26,8 +26,9 @@ struct semaphore {
 	.wait_list	= LIST_HEAD_INIT((name).wait_list),		\
 }
 
-#define DECLARE_MUTEX(name)	\
-	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
+#define DEFINE_SEMAPHORE(name, init)	\
+	struct semaphore name = __SEMAPHORE_INITIALIZER(name, init)
+#define DEFINE_BINARY_SEM(name) DEFINE_SEMAPHORE(name, 1)
 
 static inline void sema_init(struct semaphore *sem, int val)
 {
diff --git a/kernel/printk.c b/kernel/printk.c
index 6341af7..2a2281b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -72,8 +72,8 @@ EXPORT_SYMBOL(oops_in_progress);
  * provides serialisation for access to the entire console
  * driver system.
  */
-static DECLARE_MUTEX(console_sem);
-static DECLARE_MUTEX(secondary_console_sem);
+static DEFINE_BINARY_SEM(console_sem);
+static DEFINE_BINARY_SEM(secondary_console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
index d640f87..0b3dbdb 100644
--- a/lib/dynamic_printk.c
+++ b/lib/dynamic_printk.c
@@ -34,7 +34,7 @@ static struct hlist_head module_table[DEBUG_HASH_TABLE_SIZE] =
 	{ [0 ... DEBUG_HASH_TABLE_SIZE-1] = HLIST_HEAD_INIT };
 static struct hlist_head module_table2[DEBUG_HASH_TABLE_SIZE] =
 	{ [0 ... DEBUG_HASH_TABLE_SIZE-1] = HLIST_HEAD_INIT };
-static DECLARE_MUTEX(debug_list_mutex);
+static DEFINE_BINARY_SEM(debug_list_mutex);
 
 /* dynamic_printk_enabled, and dynamic_printk_enabled2 are bitmasks in which
  * bit n is set to 1 if any modname hashes into the bucket n, 0 otherwise. They
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f88bb3e..91462b0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2428,7 +2428,7 @@ sub process {
 		}
 
 # check for semaphores used as mutexes
-		if ($line =~ /^.\s*(DECLARE_MUTEX|init_MUTEX)\s*\(/) {
+		if ($line =~ /^.\s*(DEFINE_BINARY_SEM|init_MUTEX)\s*\(/) {
 			WARN("mutexes are preferred for single holder semaphores\n" . $herecurr);
 		}
 # check for semaphores used as mutexes
diff --git a/sound/soc/s3c24xx/s3c2443-ac97.c b/sound/soc/s3c24xx/s3c2443-ac97.c
index 19c5c3c..8980111 100644
--- a/sound/soc/s3c24xx/s3c2443-ac97.c
+++ b/sound/soc/s3c24xx/s3c2443-ac97.c
@@ -46,7 +46,7 @@ static struct s3c24xx_ac97_info s3c24xx_ac97;
 
 static DECLARE_COMPLETION(ac97_completion);
 static u32 codec_ready;
-static DECLARE_MUTEX(ac97_mutex);
+static DEFINE_BINARY_SEM(ac97_mutex);
 
 static unsigned short s3c2443_ac97_read(struct snd_ac97 *ac97,
 	unsigned short reg)
-- 
1.5.6.4

