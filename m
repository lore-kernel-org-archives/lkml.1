Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYARChG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYARChG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 21:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758222AbYARCgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 21:36:40 -0500
Received: from waste.org ([66.93.16.53]:40542 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757883AbYARCgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 21:36:39 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 01 of 12] random: clean up checkpatch complaints
X-Mercurial-Node: 905475c480bd26613cd9514df279a3ee8c986d55
Message-Id: <905475c480bd26613cd9.1200623623@cinder.waste.org>
In-Reply-To: <patchbomb.1200623622@cinder.waste.org>
Date: Thu, 17 Jan 2008 20:33:43 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 5595adaea70f -r 905475c480bd drivers/char/random.c
--- a/drivers/char/random.c	Thu Jan 17 13:26:54 2008 -0600
+++ b/drivers/char/random.c	Thu Jan 17 20:25:23 2008 -0600
@@ -272,7 +272,7 @@
 
 static int trickle_thresh __read_mostly = INPUT_POOL_WORDS * 28;
 
-static DEFINE_PER_CPU(int, trickle_count) = 0;
+static DEFINE_PER_CPU(int, trickle_count);
 
 /*
  * A pool of size .poolwords is stirred with a primitive polynomial
@@ -372,15 +372,16 @@
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
 
 #if 0
-static int debug = 0;
+static int debug;
 module_param(debug, bool, 0644);
-#define DEBUG_ENT(fmt, arg...) do { if (debug) \
-	printk(KERN_DEBUG "random %04d %04d %04d: " \
-	fmt,\
-	input_pool.entropy_count,\
-	blocking_pool.entropy_count,\
-	nonblocking_pool.entropy_count,\
-	## arg); } while (0)
+#define DEBUG_ENT(fmt, arg...) do { \
+	if (debug) \
+		printk(KERN_DEBUG "random %04d %04d %04d: " \
+		fmt,\
+		input_pool.entropy_count,\
+		blocking_pool.entropy_count,\
+		nonblocking_pool.entropy_count,\
+		## arg); } while (0)
 #else
 #define DEBUG_ENT(fmt, arg...) do {} while (0)
 #endif
@@ -551,7 +552,7 @@
 /* There is one of these per entropy source */
 struct timer_rand_state {
 	cycles_t last_time;
-	long last_delta,last_delta2;
+	long last_delta, last_delta2;
 	unsigned dont_count_entropy:1;
 };
 
@@ -624,7 +625,7 @@
 				     min_t(int, fls(delta>>1), 11));
 	}
 
-	if(input_pool.entropy_count >= random_read_wakeup_thresh)
+	if (input_pool.entropy_count >= random_read_wakeup_thresh)
 		wake_up_interruptible(&random_read_wait);
 
 out:
@@ -667,7 +668,6 @@
 	add_timer_randomness(disk->random,
 			     0x100 + MKDEV(disk->major, disk->first_minor));
 }
-
 EXPORT_SYMBOL(add_disk_randomness);
 #endif
 
@@ -679,7 +679,7 @@
  *
  *********************************************************************/
 
-static ssize_t extract_entropy(struct entropy_store *r, void * buf,
+static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 			       size_t nbytes, int min, int rsvd);
 
 /*
@@ -706,8 +706,8 @@
 			  "(%d of %d requested)\n",
 			  r->name, bytes * 8, nbytes * 8, r->entropy_count);
 
-		bytes=extract_entropy(r->pull, tmp, bytes,
-				      random_read_wakeup_thresh / 8, rsvd);
+		bytes = extract_entropy(r->pull, tmp, bytes,
+					random_read_wakeup_thresh / 8, rsvd);
 		add_entropy_words(r, tmp, (bytes + 3) / 4);
 		credit_entropy_store(r, bytes*8);
 	}
@@ -746,7 +746,7 @@
 		if (r->limit && nbytes + reserved >= r->entropy_count / 8)
 			nbytes = r->entropy_count/8 - reserved;
 
-		if(r->entropy_count / 8 >= nbytes + reserved)
+		if (r->entropy_count / 8 >= nbytes + reserved)
 			r->entropy_count -= nbytes*8;
 		else
 			r->entropy_count = reserved;
@@ -804,7 +804,7 @@
 	memset(buf, 0, sizeof(buf));
 }
 
-static ssize_t extract_entropy(struct entropy_store *r, void * buf,
+static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 			       size_t nbytes, int min, int reserved)
 {
 	ssize_t ret = 0, i;
@@ -874,7 +874,6 @@
 {
 	extract_entropy(&nonblocking_pool, buf, nbytes, 0, 0);
 }
-
 EXPORT_SYMBOL(get_random_bytes);
 
 /*
@@ -942,7 +941,7 @@
 #endif
 
 static ssize_t
-random_read(struct file * file, char __user * buf, size_t nbytes, loff_t *ppos)
+random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	ssize_t n, retval = 0, count = 0;
 
@@ -1004,8 +1003,7 @@
 }
 
 static ssize_t
-urandom_read(struct file * file, char __user * buf,
-		      size_t nbytes, loff_t *ppos)
+urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	return extract_entropy_user(&nonblocking_pool, buf, nbytes);
 }
@@ -1047,9 +1045,8 @@
 	return 0;
 }
 
-static ssize_t
-random_write(struct file * file, const char __user * buffer,
-	     size_t count, loff_t *ppos)
+static ssize_t random_write(struct file *file, const char __user *buffer,
+			    size_t count, loff_t *ppos)
 {
 	size_t ret;
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -1066,9 +1063,8 @@
 	return (ssize_t)count;
 }
 
-static int
-random_ioctl(struct inode * inode, struct file * file,
-	     unsigned int cmd, unsigned long arg)
+static int random_ioctl(struct inode *inode, struct file *file,
+			unsigned int cmd, unsigned long arg)
 {
 	int size, ent_count;
 	int __user *p = (int __user *)arg;
@@ -1159,7 +1155,6 @@
 	/* Set the UUID variant to DCE */
 	uuid_out[8] = (uuid_out[8] & 0x3F) | 0x80;
 }
-
 EXPORT_SYMBOL(generate_random_uuid);
 
 /********************************************************************
@@ -1334,14 +1329,14 @@
  * Rotation is separate from addition to prevent recomputation
  */
 #define ROUND(f, a, b, c, d, x, s)	\
-	(a += f(b, c, d) + x, a = (a << s) | (a >> (32 - s)))
+	(a += f(b, c, d) + in[x], a = (a << s) | (a >> (32 - s)))
 #define K1 0
 #define K2 013240474631UL
 #define K3 015666365641UL
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 
-static __u32 twothirdsMD4Transform (__u32 const buf[4], __u32 const in[12])
+static __u32 twothirdsMD4Transform(__u32 const buf[4], __u32 const in[12])
 {
 	__u32 a = buf[0], b = buf[1], c = buf[2], d = buf[3];
 
@@ -1489,8 +1484,8 @@
 	 */
 
 	memcpy(hash, saddr, 16);
-	hash[4]=((__force u16)sport << 16) + (__force u16)dport;
-	memcpy(&hash[5],keyptr->secret,sizeof(__u32) * 7);
+	hash[4] = ((__force u16)sport << 16) + (__force u16)dport;
+	memcpy(&hash[5], keyptr->secret, sizeof(__u32) * 7);
 
 	seq = twothirdsMD4Transform((const __u32 *)daddr, hash) & HASH_MASK;
 	seq += keyptr->count;
@@ -1540,10 +1535,10 @@
 	 *  Note that the words are placed into the starting vector, which is
 	 *  then mixed with a partial MD4 over random data.
 	 */
-	hash[0]=(__force u32)saddr;
-	hash[1]=(__force u32)daddr;
-	hash[2]=((__force u16)sport << 16) + (__force u16)dport;
-	hash[3]=keyptr->secret[11];
+	hash[0] = (__force u32)saddr;
+	hash[1] = (__force u32)daddr;
+	hash[2] = ((__force u16)sport << 16) + (__force u16)dport;
+	hash[3] = keyptr->secret[11];
 
 	seq = half_md4_transform(hash, keyptr->secret) & HASH_MASK;
 	seq += keyptr->count;
@@ -1558,10 +1553,7 @@
 	 *	Choosing a clock of 64 ns period is OK. (period of 274 s)
 	 */
 	seq += ktime_to_ns(ktime_get_real()) >> 6;
-#if 0
-	printk("init_seq(%lx, %lx, %d, %d) = %d\n",
-	       saddr, daddr, sport, dport, seq);
-#endif
+
 	return seq;
 }
 
@@ -1584,14 +1576,15 @@
 }
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr, __be16 dport)
+u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+			       __be16 dport)
 {
 	struct keydata *keyptr = get_keyptr();
 	u32 hash[12];
 
 	memcpy(hash, saddr, 16);
 	hash[4] = (__force u32)dport;
-	memcpy(&hash[5],keyptr->secret,sizeof(__u32) * 7);
+	memcpy(&hash[5], keyptr->secret, sizeof(__u32) * 7);
 
 	return twothirdsMD4Transform((const __u32 *)daddr, hash);
 }
@@ -1619,13 +1612,9 @@
 
 	seq += ktime_to_ns(ktime_get_real());
 	seq &= (1ull << 48) - 1;
-#if 0
-	printk("dccp init_seq(%lx, %lx, %d, %d) = %d\n",
-	       saddr, daddr, sport, dport, seq);
-#endif
+
 	return seq;
 }
-
 EXPORT_SYMBOL(secure_dccp_sequence_number);
 #endif
 
