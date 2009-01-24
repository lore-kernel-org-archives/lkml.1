Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbZAXM6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbZAXM6L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 07:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZAXM54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 07:57:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:49088 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZAXM5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 07:57:55 -0500
Subject: [GIT PULL -tip] fix 22 make headers_check - 200901
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, "H. Peter Anvin" <hpa@zytor.com>,
       jirislaby@gmail.com, gregkh@suse.de, David Miller <davem@davemloft.net>,
       Trent Piepho <xyzzy@speakeasy.org>, Arnd Bergmann <arnd@arndb.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-media <linux-media@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 18:26:57 +0530
Message-Id: <1232801817.3125.21.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit aa52dcf69565512e7d285c1c40dc6e56aab6f789:
  Ingo Molnar (1):
        Merge branch 'x86/urgent'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (11):
      headers_check fix: linux/dvb/audio.h
      headers_check fix: linux/acct.h
      headers_check fix: linux/elf.h
      headers_check fix: linux/flat.h
      headers_check fix: linux/hid.h
      headers_check fix: linux/if_frad.h
      headers_check fix: linux/types.h
      headers_check fix: linux/videodev.h
      headers_check fix: x86, kvm.h
      headers_check fix: x86, swab.h
      headers_check fix: video/edid.h

 arch/x86/include/asm/kvm.h  |    2 +-
 arch/x86/include/asm/swab.h |   12 +++++++++---
 include/linux/acct.h        |    2 +-
 include/linux/dvb/audio.h   |    5 -----
 include/linux/elf.h         |    3 ++-
 include/linux/flat.h        |    6 +++---
 include/linux/hid.h         |    2 ++
 include/linux/if_frad.h     |    9 +--------
 include/linux/types.h       |    2 ++
 include/linux/videodev.h    |   10 ++++++++--
 include/video/edid.h        |    2 +-
 11 files changed, 30 insertions(+), 25 deletions(-)

This patchset solves following 'make headers_check' warnings:

  CHECK   include/linux/dvb (8 files)
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/dvb/audio.h:133: found __[us]{8,16,32,64} type without #include <linux/types.h>
  CHECK   include/linux (348 files)
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/acct.h:62: leaks CONFIG_M68K to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/elf.h:379: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/elf.h:387: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/elf.h:401: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/elf.h:402: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/flat.h:16: leaks CONFIG_BINFMT to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/hid.h:66: leaks CONFIG_HID to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/hid.h:69: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/hid.h:76: extern's make no sense in userspace
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/if_frad.h:29: leaks CONFIG_DLCI to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/if_frad.h:129: leaks CONFIG_DLCI to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/types.h:114: leaks CONFIG_LBD to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/videodev.h:19: leaks CONFIG_VIDEO to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/linux/videodev.h:314: leaks CONFIG_VIDEO to userspace where it is not valid
  CHECK   include/video (3 files)
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/video/edid.h:4: leaks CONFIG_X86 to userspace where it is not valid
  CHECK   include/asm (52 files)
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/kvm.h:9: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/kvm.h:16: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/swab.h:4: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/swab.h:7: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/swab.h:10: leaks CONFIG_X86 to userspace where it is not valid
/home/jaswinder/jaswinder-git/linux-2.6-tip/usr/include/asm/swab.h:40: leaks CONFIG_X86 to userspace where it is not valid

diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
index b95162a..d2e3bf3 100644
--- a/arch/x86/include/asm/kvm.h
+++ b/arch/x86/include/asm/kvm.h
@@ -6,7 +6,7 @@
  *
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/ioctl.h>
 
 /* Architectural interrupt line count. */
diff --git a/arch/x86/include/asm/swab.h b/arch/x86/include/asm/swab.h
index 306d417..292a9d1 100644
--- a/arch/x86/include/asm/swab.h
+++ b/arch/x86/include/asm/swab.h
@@ -1,13 +1,19 @@
 #ifndef _ASM_X86_SWAB_H
 #define _ASM_X86_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 
+#ifdef __KERNEL__
+# ifdef CONFIG_X86_BSWAP
+# define __X86_BSWAP
+# endif /* CONFIG_X86_BSWAP */
+#endif /* __KERNEL__ */
+
 static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
 {
 #ifdef __i386__
-# ifdef CONFIG_X86_BSWAP
+# ifdef __X86_BSWAP
 	asm("bswap %0" : "=r" (val) : "0" (val));
 # else
 	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
@@ -37,7 +43,7 @@ static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
 		__u64 u;
 	} v;
 	v.u = val;
-# ifdef CONFIG_X86_BSWAP
+# ifdef __X86_BSWAP
 	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
 	    : "=r" (v.s.a), "=r" (v.s.b)
 	    : "0" (v.s.a), "1" (v.s.b));
diff --git a/include/linux/acct.h b/include/linux/acct.h
index 882dc72..ad7b5ab 100644
--- a/include/linux/acct.h
+++ b/include/linux/acct.h
@@ -59,7 +59,7 @@ struct acct
 	comp_t		ac_majflt;		/* Major Pagefaults */
 	comp_t		ac_swaps;		/* Number of Swaps */
 /* m68k had no padding here. */
-#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
+#if !defined(__mc68000__) || !defined(__KERNEL__)
 	__u16		ac_ahz;			/* AHZ */
 #endif
 	__u32		ac_exitcode;		/* Exitcode */
diff --git a/include/linux/dvb/audio.h b/include/linux/dvb/audio.h
index 89412e1..bb0df2a 100644
--- a/include/linux/dvb/audio.h
+++ b/include/linux/dvb/audio.h
@@ -24,12 +24,7 @@
 #ifndef _DVBAUDIO_H_
 #define _DVBAUDIO_H_
 
-#ifdef __KERNEL__
 #include <linux/types.h>
-#else
-#include <stdint.h>
-#endif
-
 
 typedef enum {
 	AUDIO_SOURCE_DEMUX, /* Select the demux as the main source */
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 0b61ca4..45a937b 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -377,6 +377,7 @@ typedef struct elf64_note {
   Elf64_Word n_type;	/* Content type */
 } Elf64_Nhdr;
 
+#ifdef __KERNEL__
 #if ELF_CLASS == ELFCLASS32
 
 extern Elf32_Dyn _DYNAMIC [];
@@ -404,5 +405,5 @@ static inline int elf_coredump_extra_notes_write(struct file *file,
 extern int elf_coredump_extra_notes_size(void);
 extern int elf_coredump_extra_notes_write(struct file *file, loff_t *foffset);
 #endif
-
+#endif /* __KERNEL__ */
 #endif /* _LINUX_ELF_H */
diff --git a/include/linux/flat.h b/include/linux/flat.h
index ec56852..076fff7 100644
--- a/include/linux/flat.h
+++ b/include/linux/flat.h
@@ -12,15 +12,15 @@
 
 #ifdef __KERNEL__
 #include <asm/flat.h>
-#endif
-
-#define	FLAT_VERSION			0x00000004L
 
 #ifdef CONFIG_BINFMT_SHARED_FLAT
 #define	MAX_SHARED_LIBS			(4)
 #else
 #define	MAX_SHARED_LIBS			(1)
 #endif
+#endif /* __KERNEL__ */
+
+#define	FLAT_VERSION			0x00000004L
 
 /*
  * To make everything easier to port and manage cross platform
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 81aa84d..fa8ee9c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -791,6 +791,7 @@ dbg_hid(const char *fmt, ...)
 		__FILE__ , ## arg)
 #endif /* HID_FF */
 
+#ifdef __KERNEL__
 #ifdef CONFIG_HID_COMPAT
 #define HID_COMPAT_LOAD_DRIVER(name)	\
 /* prototype to avoid sparse warning */	\
@@ -804,6 +805,7 @@ EXPORT_SYMBOL(hid_compat_##name)
 	extern void hid_compat_##name(void);	\
 	hid_compat_##name();			\
 } while (0)
+#endif /* __KERNEL__ */
 
 #endif
 
diff --git a/include/linux/if_frad.h b/include/linux/if_frad.h
index 5c34240..468a6fc 100644
--- a/include/linux/if_frad.h
+++ b/include/linux/if_frad.h
@@ -26,8 +26,6 @@
 
 #include <linux/if.h>
 
-#if defined(CONFIG_DLCI) || defined(CONFIG_DLCI_MODULE)
-
 /* Structures and constants associated with the DLCI device driver */
 
 struct dlci_add
@@ -190,12 +188,7 @@ struct frad_local
    int               buffer;		/* current buffer for S508 firmware */
 };
 
-#endif /* __KERNEL__ */
-
-#endif /* CONFIG_DLCI || CONFIG_DLCI_MODULE */
-
-#ifdef __KERNEL__
 extern void dlci_ioctl_set(int (*hook)(unsigned int, void __user *));
-#endif
 
+#endif /* __KERNEL__ */
 #endif
diff --git a/include/linux/types.h b/include/linux/types.h
index 712ca53..a6eea14 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -130,6 +130,7 @@ typedef		__s64		int64_t;
 #define aligned_be64 __be64 __attribute__((aligned(8)))
 #define aligned_le64 __le64 __attribute__((aligned(8)))
 
+#ifdef __KERNEL__
 /**
  * The type used for indexing onto a disc or disc partition.
  *
@@ -145,6 +146,7 @@ typedef u64 blkcnt_t;
 typedef unsigned long sector_t;
 typedef unsigned long blkcnt_t;
 #endif
+#endif /* __KERNEL__ */
 
 /*
  * The type of an index into the pagecache.  Use a #define so asm/types.h
diff --git a/include/linux/videodev.h b/include/linux/videodev.h
index 837f392..9faabb2 100644
--- a/include/linux/videodev.h
+++ b/include/linux/videodev.h
@@ -16,7 +16,13 @@
 #include <linux/ioctl.h>
 #include <linux/videodev2.h>
 
-#if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)
+#ifndef __KERNEL__
+# define __V4L1_COMPAT_API	/* Always provide definitions to user space */
+#elif defined(CONFIG_VIDEO_V4L1_COMPAT) /* __KERNEL__ */
+# define __V4L1_COMPAT_API
+#endif /* CONFIG_VIDEO_V4L1_COMPAT */
+
+#ifdef __V4L1_COMPAT_API
 
 #define VID_TYPE_CAPTURE	1	/* Can capture */
 #define VID_TYPE_TUNER		2	/* Can tune */
@@ -311,7 +317,7 @@ struct video_code
 #define VID_PLAY_RESET			13
 #define VID_PLAY_END_MARK		14
 
-#endif /* CONFIG_VIDEO_V4L1_COMPAT */
+#endif /* __V4L1_COMPAT_API */
 
 #endif /* __LINUX_VIDEODEV_H */
 
diff --git a/include/video/edid.h b/include/video/edid.h
index 928c342..02decc5 100644
--- a/include/video/edid.h
+++ b/include/video/edid.h
@@ -1,7 +1,7 @@
 #ifndef __linux_video_edid_h__
 #define __linux_video_edid_h__
 
-#if !defined(__KERNEL__) || defined(CONFIG_X86)
+#if !defined(__KERNEL__) || defined(__i386__) || defined(__x86_64__)
 
 struct edid_info {
 	unsigned char dummy[128];


