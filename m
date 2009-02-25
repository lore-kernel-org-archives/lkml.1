Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbZBZAEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbZBZAEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762823AbZBZACe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:02:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:63209 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762655AbZBZACc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:02:32 -0500
Message-Id: <20090225235515.036025408@arndb.de>
References: <20090225235138.062045835@arndb.de>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 00:51:39 +0100
From: arnd@arndb.de
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [patch 1/7] make exported headers use strict posix types
Content-Disposition: inline; filename=0001-A-number-of-standard-posix-types-are-used-in-exporte.patch
X-Provags-ID: V01U2FsdGVkX18bA/txEGu8wvZpqVdpi3VwgVdw48ngG9Disvn
 rJHa1wrT89Ka90pooDPscUTlYqWfVHLlgu2ozJwsM+FVqmfkSg
 WecwpDFJ6hvFsOe0esBNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of standard posix types are used in exported headers, which
is not allowed if __STRICT_KERNEL_NAMES is defined. In order to
get rid of the non-__STRICT_KERNEL_NAMES part and to make sane headers
the default, we have to change them all to safe types.

There are also still some leftovers in reiserfs_fs.h, elfcore.h
and coda.h, but these files have not compiled in user space for
a long time.

This leaves out the various integer types ({u_,u,}int{8,16,32,64}_t),
which we take care of separately.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/fcntl.h               |   12 ++++++------
 include/asm-generic/siginfo.h             |   14 +++++++-------
 include/linux/agpgart.h                   |   14 +++++++-------
 include/linux/cn_proc.h                   |   20 ++++++++++----------
 include/linux/cyclades.h                  |    6 +++---
 include/linux/dvb/video.h                 |    2 +-
 include/linux/if_pppol2tp.h               |    2 +-
 include/linux/mroute6.h                   |    2 +-
 include/linux/netfilter_ipv4/ipt_owner.h  |    8 ++++----
 include/linux/netfilter_ipv6/ip6t_owner.h |    8 ++++----
 include/linux/ppp_defs.h                  |    4 ++--
 include/linux/suspend_ioctls.h            |   10 +++++-----
 include/linux/time.h                      |    8 ++++----
 include/linux/times.h                     |    8 ++++----
 include/linux/utime.h                     |    4 ++--
 include/linux/xfrm.h                      |    2 +-
 include/mtd/mtd-abi.h                     |    4 ++--
 include/sound/asound.h                    |    4 ++--
 18 files changed, 66 insertions(+), 66 deletions(-)

Index: linux-2.6/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.orig/include/asm-generic/fcntl.h
+++ linux-2.6/include/asm-generic/fcntl.h
@@ -117,9 +117,9 @@
 struct flock {
 	short	l_type;
 	short	l_whence;
-	off_t	l_start;
-	off_t	l_len;
-	pid_t	l_pid;
+	__kernel_off_t	l_start;
+	__kernel_off_t	l_len;
+	__kernel_pid_t	l_pid;
 	__ARCH_FLOCK_PAD
 };
 #endif
@@ -140,9 +140,9 @@ struct flock {
 struct flock64 {
 	short  l_type;
 	short  l_whence;
-	loff_t l_start;
-	loff_t l_len;
-	pid_t  l_pid;
+	__kernel_loff_t l_start;
+	__kernel_loff_t l_len;
+	__kernel_pid_t  l_pid;
 	__ARCH_FLOCK64_PAD
 };
 #endif
Index: linux-2.6/include/asm-generic/siginfo.h
===================================================================
--- linux-2.6.orig/include/asm-generic/siginfo.h
+++ linux-2.6/include/asm-generic/siginfo.h
@@ -23,7 +23,7 @@ typedef union sigval {
 #endif
 
 #ifndef __ARCH_SI_UID_T
-#define __ARCH_SI_UID_T	uid_t
+#define __ARCH_SI_UID_T	__kernel_uid32_t
 #endif
 
 /*
@@ -47,13 +47,13 @@ typedef struct siginfo {
 
 		/* kill() */
 		struct {
-			pid_t _pid;		/* sender's pid */
+			__kernel_pid_t _pid;	/* sender's pid */
 			__ARCH_SI_UID_T _uid;	/* sender's uid */
 		} _kill;
 
 		/* POSIX.1b timers */
 		struct {
-			timer_t _tid;		/* timer id */
+			__kernel_timer_t _tid;	/* timer id */
 			int _overrun;		/* overrun count */
 			char _pad[sizeof( __ARCH_SI_UID_T) - sizeof(int)];
 			sigval_t _sigval;	/* same as below */
@@ -62,18 +62,18 @@ typedef struct siginfo {
 
 		/* POSIX.1b signals */
 		struct {
-			pid_t _pid;		/* sender's pid */
+			__kernel_pid_t _pid;	/* sender's pid */
 			__ARCH_SI_UID_T _uid;	/* sender's uid */
 			sigval_t _sigval;
 		} _rt;
 
 		/* SIGCHLD */
 		struct {
-			pid_t _pid;		/* which child */
+			__kernel_pid_t _pid;	/* which child */
 			__ARCH_SI_UID_T _uid;	/* sender's uid */
 			int _status;		/* exit code */
-			clock_t _utime;
-			clock_t _stime;
+			__kernel_clock_t _utime;
+			__kernel_clock_t _stime;
 		} _sigchld;
 
 		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
Index: linux-2.6/include/linux/agpgart.h
===================================================================
--- linux-2.6.orig/include/linux/agpgart.h
+++ linux-2.6/include/linux/agpgart.h
@@ -77,20 +77,20 @@ typedef struct _agp_setup {
  * The "prot" down below needs still a "sleep" flag somehow ...
  */
 typedef struct _agp_segment {
-	off_t pg_start;		/* starting page to populate    */
-	size_t pg_count;	/* number of pages              */
-	int prot;		/* prot flags for mmap          */
+	__kernel_off_t pg_start;	/* starting page to populate    */
+	__kernel_size_t pg_count;	/* number of pages              */
+	int prot;			/* prot flags for mmap          */
 } agp_segment;
 
 typedef struct _agp_region {
-	pid_t pid;		/* pid of process               */
-	size_t seg_count;	/* number of segments           */
+	__kernel_pid_t pid;		/* pid of process       */
+	__kernel_size_t seg_count;	/* number of segments   */
 	struct _agp_segment *seg_list;
 } agp_region;
 
 typedef struct _agp_allocate {
 	int key;		/* tag of allocation            */
-	size_t pg_count;	/* number of pages              */
+	__kernel_size_t pg_count;/* number of pages             */
 	__u32 type;		/* 0 == normal, other devspec   */
    	__u32 physical;         /* device specific (some devices  
 				 * need a phys address of the     
@@ -100,7 +100,7 @@ typedef struct _agp_allocate {
 
 typedef struct _agp_bind {
 	int key;		/* tag of allocation            */
-	off_t pg_start;		/* starting page to populate    */
+	__kernel_off_t pg_start;/* starting page to populate    */
 } agp_bind;
 
 typedef struct _agp_unbind {
Index: linux-2.6/include/linux/cn_proc.h
===================================================================
--- linux-2.6.orig/include/linux/cn_proc.h
+++ linux-2.6/include/linux/cn_proc.h
@@ -65,20 +65,20 @@ struct proc_event {
 		} ack;
 
 		struct fork_proc_event {
-			pid_t parent_pid;
-			pid_t parent_tgid;
-			pid_t child_pid;
-			pid_t child_tgid;
+			__kernel_pid_t parent_pid;
+			__kernel_pid_t parent_tgid;
+			__kernel_pid_t child_pid;
+			__kernel_pid_t child_tgid;
 		} fork;
 
 		struct exec_proc_event {
-			pid_t process_pid;
-			pid_t process_tgid;
+			__kernel_pid_t process_pid;
+			__kernel_pid_t process_tgid;
 		} exec;
 
 		struct id_proc_event {
-			pid_t process_pid;
-			pid_t process_tgid;
+			__kernel_pid_t process_pid;
+			__kernel_pid_t process_tgid;
 			union {
 				__u32 ruid; /* task uid */
 				__u32 rgid; /* task gid */
@@ -90,8 +90,8 @@ struct proc_event {
 		} id;
 
 		struct exit_proc_event {
-			pid_t process_pid;
-			pid_t process_tgid;
+			__kernel_pid_t process_pid;
+			__kernel_pid_t process_tgid;
 			__u32 exit_code, exit_signal;
 		} exit;
 	} event_data;
Index: linux-2.6/include/linux/cyclades.h
===================================================================
--- linux-2.6.orig/include/linux/cyclades.h
+++ linux-2.6/include/linux/cyclades.h
@@ -82,9 +82,9 @@ struct cyclades_monitor {
  * open)
  */
 struct cyclades_idle_stats {
-    time_t	   in_use;	/* Time device has been in use (secs) */
-    time_t	   recv_idle;	/* Time since last char received (secs) */
-    time_t	   xmit_idle;	/* Time since last char transmitted (secs) */
+    __kernel_time_t in_use;	/* Time device has been in use (secs) */
+    __kernel_time_t recv_idle;	/* Time since last char received (secs) */
+    __kernel_time_t xmit_idle;	/* Time since last char transmitted (secs) */
     unsigned long  recv_bytes;	/* Bytes received */
     unsigned long  xmit_bytes;	/* Bytes transmitted */
     unsigned long  overruns;	/* Input overruns */
Index: linux-2.6/include/linux/dvb/video.h
===================================================================
--- linux-2.6.orig/include/linux/dvb/video.h
+++ linux-2.6/include/linux/dvb/video.h
@@ -137,7 +137,7 @@ struct video_event {
 #define VIDEO_EVENT_FRAME_RATE_CHANGED	2
 #define VIDEO_EVENT_DECODER_STOPPED 	3
 #define VIDEO_EVENT_VSYNC 		4
-	time_t timestamp;
+	__kernel_time_t timestamp;
 	union {
 		video_size_t size;
 		unsigned int frame_rate;	/* in frames per 1000sec */
Index: linux-2.6/include/linux/if_pppol2tp.h
===================================================================
--- linux-2.6.orig/include/linux/if_pppol2tp.h
+++ linux-2.6/include/linux/if_pppol2tp.h
@@ -26,7 +26,7 @@
  */
 struct pppol2tp_addr
 {
-	pid_t	pid;			/* pid that owns the fd.
+	__kernel_pid_t	pid;		/* pid that owns the fd.
 					 * 0 => current */
 	int	fd;			/* FD of UDP socket to use */
 
Index: linux-2.6/include/linux/mroute6.h
===================================================================
--- linux-2.6.orig/include/linux/mroute6.h
+++ linux-2.6/include/linux/mroute6.h
@@ -65,7 +65,7 @@ struct mif6ctl {
 	mifi_t	mif6c_mifi;		/* Index of MIF */
 	unsigned char mif6c_flags;	/* MIFF_ flags */
 	unsigned char vifc_threshold;	/* ttl limit */
-	u_short	 mif6c_pifi;		/* the index of the physical IF */
+	__u16	 mif6c_pifi;		/* the index of the physical IF */
 	unsigned int vifc_rate_limit;	/* Rate limiter values (NI) */
 };
 
Index: linux-2.6/include/linux/netfilter_ipv4/ipt_owner.h
===================================================================
--- linux-2.6.orig/include/linux/netfilter_ipv4/ipt_owner.h
+++ linux-2.6/include/linux/netfilter_ipv4/ipt_owner.h
@@ -9,10 +9,10 @@
 #define IPT_OWNER_COMM	0x10
 
 struct ipt_owner_info {
-    uid_t uid;
-    gid_t gid;
-    pid_t pid;
-    pid_t sid;
+    __kernel_uid32_t uid;
+    __kernel_gid32_t gid;
+    __kernel_pid_t pid;
+    __kernel_pid_t sid;
     char comm[16];
     u_int8_t match, invert;	/* flags */
 };
Index: linux-2.6/include/linux/netfilter_ipv6/ip6t_owner.h
===================================================================
--- linux-2.6.orig/include/linux/netfilter_ipv6/ip6t_owner.h
+++ linux-2.6/include/linux/netfilter_ipv6/ip6t_owner.h
@@ -8,10 +8,10 @@
 #define IP6T_OWNER_SID	0x08
 
 struct ip6t_owner_info {
-    uid_t uid;
-    gid_t gid;
-    pid_t pid;
-    pid_t sid;
+    __kernel_uid32_t uid;
+    __kernel_gid32_t gid;
+    __kernel_pid_t pid;
+    __kernel_pid_t sid;
     u_int8_t match, invert;	/* flags */
 };
 
Index: linux-2.6/include/linux/ppp_defs.h
===================================================================
--- linux-2.6.orig/include/linux/ppp_defs.h
+++ linux-2.6/include/linux/ppp_defs.h
@@ -177,8 +177,8 @@ struct ppp_comp_stats {
  * the last NP packet was sent or received.
  */
 struct ppp_idle {
-    time_t xmit_idle;		/* time since last NP packet sent */
-    time_t recv_idle;		/* time since last NP packet received */
+    __kernel_time_t xmit_idle;	/* time since last NP packet sent */
+    __kernel_time_t recv_idle;	/* time since last NP packet received */
 };
 
 #endif /* _PPP_DEFS_H_ */
Index: linux-2.6/include/linux/suspend_ioctls.h
===================================================================
--- linux-2.6.orig/include/linux/suspend_ioctls.h
+++ linux-2.6/include/linux/suspend_ioctls.h
@@ -1,14 +1,15 @@
 #ifndef _LINUX_SUSPEND_IOCTLS_H
 #define _LINUX_SUSPEND_IOCTLS_H
 
+#include <linux/types.h>
 /*
  * This structure is used to pass the values needed for the identification
  * of the resume swap area from a user space to the kernel via the
  * SNAPSHOT_SET_SWAP_AREA ioctl
  */
 struct resume_swap_area {
-	loff_t offset;
-	u_int32_t dev;
+	__kernel_loff_t offset;
+	__u32 dev;
 } __attribute__((packed));
 
 #define SNAPSHOT_IOC_MAGIC	'3'
@@ -20,13 +21,13 @@ struct resume_swap_area {
 #define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
 #define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
 							struct resume_swap_area)
-#define SNAPSHOT_GET_IMAGE_SIZE		_IOR(SNAPSHOT_IOC_MAGIC, 14, loff_t)
+#define SNAPSHOT_GET_IMAGE_SIZE		_IOR(SNAPSHOT_IOC_MAGIC, 14, __kernel_loff_t)
 #define SNAPSHOT_PLATFORM_SUPPORT	_IO(SNAPSHOT_IOC_MAGIC, 15)
 #define SNAPSHOT_POWER_OFF		_IO(SNAPSHOT_IOC_MAGIC, 16)
 #define SNAPSHOT_CREATE_IMAGE		_IOW(SNAPSHOT_IOC_MAGIC, 17, int)
 #define SNAPSHOT_PREF_IMAGE_SIZE	_IO(SNAPSHOT_IOC_MAGIC, 18)
-#define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, loff_t)
-#define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, loff_t)
+#define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, __kernel_loff_t)
+#define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, __kernel_loff_t)
 #define SNAPSHOT_IOC_MAXNR	20
 
 #endif /* _LINUX_SUSPEND_IOCTLS_H */
Index: linux-2.6/include/linux/time.h
===================================================================
--- linux-2.6.orig/include/linux/time.h
+++ linux-2.6/include/linux/time.h
@@ -12,14 +12,14 @@
 #ifndef _STRUCT_TIMESPEC
 #define _STRUCT_TIMESPEC
 struct timespec {
-	time_t	tv_sec;		/* seconds */
-	long	tv_nsec;	/* nanoseconds */
+	__kernel_time_t	tv_sec;			/* seconds */
+	long		tv_nsec;		/* nanoseconds */
 };
 #endif
 
 struct timeval {
-	time_t		tv_sec;		/* seconds */
-	suseconds_t	tv_usec;	/* microseconds */
+	__kernel_time_t		tv_sec;		/* seconds */
+	__kernel_suseconds_t	tv_usec;	/* microseconds */
 };
 
 struct timezone {
Index: linux-2.6/include/linux/times.h
===================================================================
--- linux-2.6.orig/include/linux/times.h
+++ linux-2.6/include/linux/times.h
@@ -4,10 +4,10 @@
 #include <linux/types.h>
 
 struct tms {
-	clock_t tms_utime;
-	clock_t tms_stime;
-	clock_t tms_cutime;
-	clock_t tms_cstime;
+	__kernel_clock_t tms_utime;
+	__kernel_clock_t tms_stime;
+	__kernel_clock_t tms_cutime;
+	__kernel_clock_t tms_cstime;
 };
 
 #endif
Index: linux-2.6/include/linux/utime.h
===================================================================
--- linux-2.6.orig/include/linux/utime.h
+++ linux-2.6/include/linux/utime.h
@@ -4,8 +4,8 @@
 #include <linux/types.h>
 
 struct utimbuf {
-	time_t actime;
-	time_t modtime;
+	__kernel_time_t actime;
+	__kernel_time_t modtime;
 };
 
 #endif
Index: linux-2.6/include/linux/xfrm.h
===================================================================
--- linux-2.6.orig/include/linux/xfrm.h
+++ linux-2.6/include/linux/xfrm.h
@@ -58,7 +58,7 @@ struct xfrm_selector
 	__u8	prefixlen_s;
 	__u8	proto;
 	int	ifindex;
-	uid_t	user;
+	__kernel_uid32_t	user;
 };
 
 #define XFRM_INF (~(__u64)0)
Index: linux-2.6/include/mtd/mtd-abi.h
===================================================================
--- linux-2.6.orig/include/mtd/mtd-abi.h
+++ linux-2.6/include/mtd/mtd-abi.h
@@ -84,8 +84,8 @@ struct otp_info {
 #define MEMGETREGIONINFO	_IOWR('M', 8, struct region_info_user)
 #define MEMSETOOBSEL		_IOW('M', 9, struct nand_oobinfo)
 #define MEMGETOOBSEL		_IOR('M', 10, struct nand_oobinfo)
-#define MEMGETBADBLOCK		_IOW('M', 11, loff_t)
-#define MEMSETBADBLOCK		_IOW('M', 12, loff_t)
+#define MEMGETBADBLOCK		_IOW('M', 11, __kernel_loff_t)
+#define MEMSETBADBLOCK		_IOW('M', 12, __kernel_loff_t)
 #define OTPSELECT		_IOR('M', 13, int)
 #define OTPGETREGIONCOUNT	_IOW('M', 14, int)
 #define OTPGETREGIONINFO	_IOW('M', 15, struct otp_info)
Index: linux-2.6/include/sound/asound.h
===================================================================
--- linux-2.6.orig/include/sound/asound.h
+++ linux-2.6/include/sound/asound.h
@@ -385,7 +385,7 @@ struct snd_pcm_sw_params {
 
 struct snd_pcm_channel_info {
 	unsigned int channel;
-	off_t offset;			/* mmap offset */
+	__kernel_off_t offset;		/* mmap offset */
 	unsigned int first;		/* offset to first sample in bits */
 	unsigned int step;		/* samples distance in bits */
 };
@@ -789,7 +789,7 @@ struct snd_ctl_elem_info {
 	snd_ctl_elem_type_t type;	/* R: value type - SNDRV_CTL_ELEM_TYPE_* */
 	unsigned int access;		/* R: value access (bitmask) - SNDRV_CTL_ELEM_ACCESS_* */
 	unsigned int count;		/* count of values */
-	pid_t owner;			/* owner's PID of this control */
+	__kernel_pid_t owner;		/* owner's PID of this control */
 	union {
 		struct {
 			long min;		/* R: minimum value */

-- 

