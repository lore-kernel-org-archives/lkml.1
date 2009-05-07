Return-Path: <linux-kernel-owner+w=401wt.eu-S1762859AbZEHAOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859AbZEHAOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757468AbZEHAKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:08 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52710
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754116AbZEHAJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:09:56 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 16/16] xen: checkpatch cleanups
Date: Thu,  7 May 2009 14:10:53 -0700
Message-Id: <1241730653-4688-17-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241730653-4688-1-git-send-email-jeremy@goop.org>
References: <1241730653-4688-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

General whitespacery.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/paravirt.h  |    4 +-
 arch/x86/include/asm/processor.h |    2 +-
 arch/x86/kernel/cpu/mtrr/xen.c   |    3 -
 arch/x86/kernel/ioport.c         |    2 +-
 arch/x86/kernel/process.c        |    4 +-
 arch/x86/xen/enlighten.c         |   11 ++-
 arch/x86/xen/vga.c               |   15 ++--
 drivers/char/hvc_xen.c           |    2 +-
 include/xen/interface/platform.h |  166 ++++++++++++++++++--------------------
 include/xen/interface/xen.h      |   66 ++++++++--------
 10 files changed, 132 insertions(+), 143 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 56acbe8..5b74269 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -157,7 +157,7 @@ struct pv_cpu_ops {
 
 	void (*set_iopl_mask)(unsigned mask);
 	void (*set_io_bitmap)(struct thread_struct *thread,
-	                      unsigned long bytes_updated);
+			      unsigned long bytes_updated);
 
 	void (*wbinvd)(void);
 	void (*io_delay)(void);
@@ -1005,7 +1005,7 @@ static inline void set_iopl_mask(unsigned mask)
 }
 
 static inline void set_io_bitmap(struct thread_struct *thread,
-                                 unsigned long bytes_updated)
+				 unsigned long bytes_updated)
 {
 	PVOP_VCALL2(pv_cpu_ops.set_io_bitmap, thread, bytes_updated);
 }
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 15d0769..4a8d13b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -539,7 +539,7 @@ static inline void native_set_iopl_mask(unsigned mask)
 }
 
 extern void native_set_io_bitmap(struct thread_struct *thread,
-                                 unsigned long updated_bytes);
+				 unsigned long updated_bytes);
 
 static inline void
 native_load_sp0(struct tss_struct *tss, struct thread_struct *thread)
diff --git a/arch/x86/kernel/cpu/mtrr/xen.c b/arch/x86/kernel/cpu/mtrr/xen.c
index db3ef39..6760907 100644
--- a/arch/x86/kernel/cpu/mtrr/xen.c
+++ b/arch/x86/kernel/cpu/mtrr/xen.c
@@ -19,10 +19,7 @@ static int __init xen_num_var_ranges(void);
  * working userland mtrr support. */
 static struct mtrr_ops xen_mtrr_ops = {
 	.vendor            = X86_VENDOR_UNKNOWN,
-//	.set               = xen_set_mtrr,
-//	.get               = xen_get_mtrr,
 	.get_free_region   = generic_get_free_region,
-//	.validate_add_page = xen_validate_add_page,
 	.have_wrcomb       = positive_have_wrcomb,
 	.use_intel_if	   = 0,
 	.num_var_ranges	   = xen_num_var_ranges,
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index 642660f..0a421d3 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -31,7 +31,7 @@ static void set_bitmap(unsigned long *bitmap, unsigned int base,
 }
 
 void native_set_io_bitmap(struct thread_struct *t,
-                          unsigned long bytes_updated)
+			  unsigned long bytes_updated)
 {
 	struct tss_struct *tss;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ef9b919..0934c09 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -209,8 +209,8 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 
 	if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP) ||
 	    test_tsk_thread_flag(prev_p, TIF_IO_BITMAP))
-		set_io_bitmap(next,
-		              max(prev->io_bitmap_max, next->io_bitmap_max));
+		set_io_bitmap(next, max(prev->io_bitmap_max,
+					next->io_bitmap_max));
 }
 
 int sys_fork(struct pt_regs *regs)
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e231cb7..2d0341f 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -172,7 +172,8 @@ static void __init xen_banner(void)
 	       pv_info.name);
 	printk(KERN_INFO "Xen version: %d.%d%s%s%s\n",
 	       version >> 16, version & 0xffff, extra.extraversion,
-	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "",
+	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ?
+			" (preserve-AD)" : "",
 	       xen_initial_domain() ? " (dom0)" : "");
 }
 
@@ -570,15 +571,15 @@ static void xen_set_iopl_mask(unsigned mask)
 }
 
 static void xen_set_io_bitmap(struct thread_struct *thread,
-                              unsigned long bytes_updated)
+			      unsigned long bytes_updated)
 {
 	struct physdev_set_iobitmap set_iobitmap;
 
 	set_xen_guest_handle(set_iobitmap.bitmap,
-	                     (char *)thread->io_bitmap_ptr);
+			     (char *)thread->io_bitmap_ptr);
 	set_iobitmap.nr_ports = thread->io_bitmap_ptr ? IO_BITMAP_BITS : 0;
 	WARN_ON(HYPERVISOR_physdev_op(PHYSDEVOP_set_iobitmap,
-	                              &set_iobitmap));
+				      &set_iobitmap));
 }
 
 static void xen_io_delay(void)
@@ -1061,7 +1062,7 @@ asmlinkage void __init xen_start_kernel(void)
 	} else {
 		const struct dom0_vga_console_info *info =
 			(void *)((char *)xen_start_info +
-			         xen_start_info->console.dom0.info_off);
+				 xen_start_info->console.dom0.info_off);
 
 		xen_init_vga(info, xen_start_info->console.dom0.info_size);
 		xen_start_info->console.domU.mfn = 0;
diff --git a/arch/x86/xen/vga.c b/arch/x86/xen/vga.c
index f2fca2c..ab3b39e 100644
--- a/arch/x86/xen/vga.c
+++ b/arch/x86/xen/vga.c
@@ -25,7 +25,7 @@ void __init xen_init_vga(const struct dom0_vga_console_info *info, size_t size)
 	switch (info->video_type) {
 	case XEN_VGATYPE_TEXT_MODE_3:
 		if (size < offsetof(struct dom0_vga_console_info, u.text_mode_3)
-		           + sizeof(info->u.text_mode_3))
+		    + sizeof(info->u.text_mode_3))
 			break;
 		screen_info->orig_video_lines = info->u.text_mode_3.rows;
 		screen_info->orig_video_cols = info->u.text_mode_3.columns;
@@ -37,7 +37,7 @@ void __init xen_init_vga(const struct dom0_vga_console_info *info, size_t size)
 
 	case XEN_VGATYPE_VESA_LFB:
 		if (size < offsetof(struct dom0_vga_console_info,
-		                    u.vesa_lfb.gbl_caps))
+				    u.vesa_lfb.gbl_caps))
 			break;
 		screen_info->orig_video_isVGA = VIDEO_TYPE_VLFB;
 		screen_info->lfb_width = info->u.vesa_lfb.width;
@@ -55,13 +55,14 @@ void __init xen_init_vga(const struct dom0_vga_console_info *info, size_t size)
 		screen_info->rsvd_size = info->u.vesa_lfb.rsvd_size;
 		screen_info->rsvd_pos = info->u.vesa_lfb.rsvd_pos;
 		if (size >= offsetof(struct dom0_vga_console_info,
-		                     u.vesa_lfb.gbl_caps)
-		            + sizeof(info->u.vesa_lfb.gbl_caps))
+				     u.vesa_lfb.gbl_caps)
+				+ sizeof(info->u.vesa_lfb.gbl_caps))
 			screen_info->capabilities = info->u.vesa_lfb.gbl_caps;
 		if (size >= offsetof(struct dom0_vga_console_info,
-		                     u.vesa_lfb.mode_attrs)
-		            + sizeof(info->u.vesa_lfb.mode_attrs))
-			screen_info->vesa_attributes = info->u.vesa_lfb.mode_attrs;
+				     u.vesa_lfb.mode_attrs)
+				+ sizeof(info->u.vesa_lfb.mode_attrs))
+			screen_info->vesa_attributes =
+				info->u.vesa_lfb.mode_attrs;
 		break;
 	}
 }
diff --git a/drivers/char/hvc_xen.c b/drivers/char/hvc_xen.c
index 81d9186..11071ed 100644
--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -137,7 +137,7 @@ static int __init xen_hvc_init(void)
 	struct hv_ops *ops;
 
 	if (!xen_pv_domain())
- 		return -ENODEV;
+		return -ENODEV;
 
 	if (xen_initial_domain()) {
 		ops = &dom0_hvc_ops;
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
index da548f3..2307b0f 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -54,13 +54,13 @@ DEFINE_GUEST_HANDLE_STRUCT(xenpf_settime_t);
  */
 #define XENPF_add_memtype         31
 struct xenpf_add_memtype {
-    /* IN variables. */
-    unsigned long mfn;
-    uint64_t nr_mfns;
-    uint32_t type;
-    /* OUT variables. */
-    uint32_t handle;
-    uint32_t reg;
+	/* IN variables. */
+	unsigned long mfn;
+	uint64_t nr_mfns;
+	uint32_t type;
+	/* OUT variables. */
+	uint32_t handle;
+	uint32_t reg;
 };
 typedef struct xenpf_add_memtype xenpf_add_memtype_t;
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_add_memtype_t);
@@ -74,9 +74,9 @@ DEFINE_GUEST_HANDLE_STRUCT(xenpf_add_memtype_t);
  */
 #define XENPF_del_memtype         32
 struct xenpf_del_memtype {
-    /* IN variables. */
-    uint32_t handle;
-    uint32_t reg;
+	/* IN variables. */
+	uint32_t handle;
+	uint32_t reg;
 };
 typedef struct xenpf_del_memtype xenpf_del_memtype_t;
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_del_memtype_t);
@@ -84,21 +84,21 @@ DEFINE_GUEST_HANDLE_STRUCT(xenpf_del_memtype_t);
 /* Read current type of an MTRR (x86-specific). */
 #define XENPF_read_memtype        33
 struct xenpf_read_memtype {
-    /* IN variables. */
-    uint32_t reg;
-    /* OUT variables. */
-    unsigned long mfn;
-    uint64_t nr_mfns;
-    uint32_t type;
+	/* IN variables. */
+	uint32_t reg;
+	/* OUT variables. */
+	unsigned long mfn;
+	uint64_t nr_mfns;
+	uint32_t type;
 };
 typedef struct xenpf_read_memtype xenpf_read_memtype_t;
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_read_memtype_t);
 
 #define XENPF_microcode_update    35
 struct xenpf_microcode_update {
-    /* IN variables. */
-    GUEST_HANDLE(void) data;          /* Pointer to microcode data */
-    uint32_t length;                  /* Length of microcode data. */
+	/* IN variables. */
+	GUEST_HANDLE(void) data;          /* Pointer to microcode data */
+	uint32_t length;                  /* Length of microcode data. */
 };
 typedef struct xenpf_microcode_update xenpf_microcode_update_t;
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_microcode_update_t);
@@ -124,30 +124,30 @@ struct xenpf_firmware_info {
     uint32_t index;
     /* OUT variables. */
     union {
-        struct {
-            /* Int13, Fn48: Check Extensions Present. */
-            uint8_t device;                   /* %dl: bios device number */
-            uint8_t version;                  /* %ah: major version      */
-            uint16_t interface_support;       /* %cx: support bitmap     */
-            /* Int13, Fn08: Legacy Get Device Parameters. */
-            uint16_t legacy_max_cylinder;     /* %cl[7:6]:%ch: max cyl # */
-            uint8_t legacy_max_head;          /* %dh: max head #         */
-            uint8_t legacy_sectors_per_track; /* %cl[5:0]: max sector #  */
-            /* Int13, Fn41: Get Device Parameters (as filled into %ds:%esi). */
-            /* NB. First uint16_t of buffer must be set to buffer size.      */
-            GUEST_HANDLE(void) edd_params;
-        } disk_info; /* XEN_FW_DISK_INFO */
-        struct {
-            uint8_t device;                   /* bios device number  */
-            uint32_t mbr_signature;           /* offset 0x1b8 in mbr */
-        } disk_mbr_signature; /* XEN_FW_DISK_MBR_SIGNATURE */
-        struct {
-            /* Int10, AX=4F15: Get EDID info. */
-            uint8_t capabilities;
-            uint8_t edid_transfer_time;
-            /* must refer to 128-byte buffer */
-            GUEST_HANDLE(uchar) edid;
-        } vbeddc_info; /* XEN_FW_VBEDDC_INFO */
+	struct {
+	    /* Int13, Fn48: Check Extensions Present. */
+	    uint8_t device;		      /* %dl: bios device number */
+	    uint8_t version;		      /* %ah: major version	 */
+	    uint16_t interface_support;	      /* %cx: support bitmap	 */
+	    /* Int13, Fn08: Legacy Get Device Parameters. */
+	    uint16_t legacy_max_cylinder;     /* %cl[7:6]:%ch: max cyl # */
+	    uint8_t legacy_max_head;	      /* %dh: max head #	 */
+	    uint8_t legacy_sectors_per_track; /* %cl[5:0]: max sector #	 */
+	    /* Int13, Fn41: Get Device Parameters (as filled into %ds:%esi). */
+	    /* NB. First uint16_t of buffer must be set to buffer size.	     */
+	    GUEST_HANDLE(void) edd_params;
+	} disk_info; /* XEN_FW_DISK_INFO */
+	struct {
+	    uint8_t device;		      /* bios device number  */
+	    uint32_t mbr_signature;	      /* offset 0x1b8 in mbr */
+	} disk_mbr_signature; /* XEN_FW_DISK_MBR_SIGNATURE */
+	struct {
+	    /* Int10, AX=4F15: Get EDID info. */
+	    uint8_t capabilities;
+	    uint8_t edid_transfer_time;
+	    /* must refer to 128-byte buffer */
+	    GUEST_HANDLE(uchar) edid;
+	} vbeddc_info; /* XEN_FW_VBEDDC_INFO */
     } u;
 };
 typedef struct xenpf_firmware_info xenpf_firmware_info_t;
@@ -155,21 +155,21 @@ DEFINE_GUEST_HANDLE_STRUCT(xenpf_firmware_info_t);
 
 #define XENPF_enter_acpi_sleep    51
 struct xenpf_enter_acpi_sleep {
-    /* IN variables */
-    uint16_t pm1a_cnt_val;      /* PM1a control value. */
-    uint16_t pm1b_cnt_val;      /* PM1b control value. */
-    uint32_t sleep_state;       /* Which state to enter (Sn). */
-    uint32_t flags;             /* Must be zero. */
+	/* IN variables */
+	uint16_t pm1a_cnt_val;      /* PM1a control value. */
+	uint16_t pm1b_cnt_val;      /* PM1b control value. */
+	uint32_t sleep_state;       /* Which state to enter (Sn). */
+	uint32_t flags;             /* Must be zero. */
 };
 typedef struct xenpf_enter_acpi_sleep xenpf_enter_acpi_sleep_t;
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_enter_acpi_sleep_t);
 
 #define XENPF_change_freq         52
 struct xenpf_change_freq {
-    /* IN variables */
-    uint32_t flags; /* Must be zero. */
-    uint32_t cpu;   /* Physical cpu. */
-    uint64_t freq;  /* New frequency (Hz). */
+	/* IN variables */
+	uint32_t flags; /* Must be zero. */
+	uint32_t cpu;   /* Physical cpu. */
+	uint64_t freq;  /* New frequency (Hz). */
 };
 typedef struct xenpf_change_freq xenpf_change_freq_t;
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_change_freq_t);
@@ -184,49 +184,39 @@ DEFINE_GUEST_HANDLE_STRUCT(xenpf_change_freq_t);
  */
 #define XENPF_getidletime         53
 struct xenpf_getidletime {
-    /* IN/OUT variables */
-    /* IN: CPUs to interrogate; OUT: subset of IN which are present */
-    GUEST_HANDLE(uchar) cpumap_bitmap;
-    /* IN variables */
-    /* Size of cpumap bitmap. */
-    uint32_t cpumap_nr_cpus;
-    /* Must be indexable for every cpu in cpumap_bitmap. */
-    GUEST_HANDLE(uint64_t) idletime;
-    /* OUT variables */
-    /* System time when the idletime snapshots were taken. */
-    uint64_t now;
+	/* IN/OUT variables */
+	/* IN: CPUs to interrogate; OUT: subset of IN which are present */
+	GUEST_HANDLE(uchar) cpumap_bitmap;
+	/* IN variables */
+	/* Size of cpumap bitmap. */
+	uint32_t cpumap_nr_cpus;
+	/* Must be indexable for every cpu in cpumap_bitmap. */
+	GUEST_HANDLE(uint64_t) idletime;
+	/* OUT variables */
+	/* System time when the idletime snapshots were taken. */
+	uint64_t now;
 };
 typedef struct xenpf_getidletime xenpf_getidletime_t;
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_getidletime_t);
 
 struct xen_platform_op {
-    uint32_t cmd;
-    uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
-    union {
-        struct xenpf_settime           settime;
-        struct xenpf_add_memtype       add_memtype;
-        struct xenpf_del_memtype       del_memtype;
-        struct xenpf_read_memtype      read_memtype;
-        struct xenpf_microcode_update  microcode;
-        struct xenpf_platform_quirk    platform_quirk;
-        struct xenpf_firmware_info     firmware_info;
-        struct xenpf_enter_acpi_sleep  enter_acpi_sleep;
-        struct xenpf_change_freq       change_freq;
-        struct xenpf_getidletime       getidletime;
-        uint8_t                        pad[128];
-    } u;
+	uint32_t cmd;
+	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
+	union {
+		struct xenpf_settime           settime;
+		struct xenpf_add_memtype       add_memtype;
+		struct xenpf_del_memtype       del_memtype;
+		struct xenpf_read_memtype      read_memtype;
+		struct xenpf_microcode_update  microcode;
+		struct xenpf_platform_quirk    platform_quirk;
+		struct xenpf_firmware_info     firmware_info;
+		struct xenpf_enter_acpi_sleep  enter_acpi_sleep;
+		struct xenpf_change_freq       change_freq;
+		struct xenpf_getidletime       getidletime;
+		uint8_t                        pad[128];
+	} u;
 };
 typedef struct xen_platform_op xen_platform_op_t;
 DEFINE_GUEST_HANDLE_STRUCT(xen_platform_op_t);
 
 #endif /* __XEN_PUBLIC_PLATFORM_H__ */
-
-/*
- * Local variables:
- * mode: C
- * c-set-style: "BSD"
- * c-basic-offset: 4
- * tab-width: 4
- * indent-tabs-mode: nil
- * End:
- */
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index 6c0af21..412326d 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -450,42 +450,42 @@ struct start_info {
 };
 
 struct dom0_vga_console_info {
-    uint8_t video_type; /* DOM0_VGA_CONSOLE_??? */
+	uint8_t video_type; /* DOM0_VGA_CONSOLE_??? */
 #define XEN_VGATYPE_TEXT_MODE_3 0x03
 #define XEN_VGATYPE_VESA_LFB    0x23
 
-    union {
-        struct {
-            /* Font height, in pixels. */
-            uint16_t font_height;
-            /* Cursor location (column, row). */
-            uint16_t cursor_x, cursor_y;
-            /* Number of rows and columns (dimensions in characters). */
-            uint16_t rows, columns;
-        } text_mode_3;
-
-        struct {
-            /* Width and height, in pixels. */
-            uint16_t width, height;
-            /* Bytes per scan line. */
-            uint16_t bytes_per_line;
-            /* Bits per pixel. */
-            uint16_t bits_per_pixel;
-            /* LFB physical address, and size (in units of 64kB). */
-            uint32_t lfb_base;
-            uint32_t lfb_size;
-            /* RGB mask offsets and sizes, as defined by VBE 1.2+ */
-            uint8_t  red_pos, red_size;
-            uint8_t  green_pos, green_size;
-            uint8_t  blue_pos, blue_size;
-            uint8_t  rsvd_pos, rsvd_size;
-
-            /* VESA capabilities (offset 0xa, VESA command 0x4f00). */
-            uint32_t gbl_caps;
-            /* Mode attributes (offset 0x0, VESA command 0x4f01). */
-            uint16_t mode_attrs;
-        } vesa_lfb;
-    } u;
+	union {
+		struct {
+			/* Font height, in pixels. */
+			uint16_t font_height;
+			/* Cursor location (column, row). */
+			uint16_t cursor_x, cursor_y;
+			/* Number of rows and columns (dimensions in characters). */
+			uint16_t rows, columns;
+		} text_mode_3;
+
+		struct {
+			/* Width and height, in pixels. */
+			uint16_t width, height;
+			/* Bytes per scan line. */
+			uint16_t bytes_per_line;
+			/* Bits per pixel. */
+			uint16_t bits_per_pixel;
+			/* LFB physical address, and size (in units of 64kB). */
+			uint32_t lfb_base;
+			uint32_t lfb_size;
+			/* RGB mask offsets and sizes, as defined by VBE 1.2+ */
+			uint8_t  red_pos, red_size;
+			uint8_t  green_pos, green_size;
+			uint8_t  blue_pos, blue_size;
+			uint8_t  rsvd_pos, rsvd_size;
+
+			/* VESA capabilities (offset 0xa, VESA command 0x4f00). */
+			uint32_t gbl_caps;
+			/* Mode attributes (offset 0x0, VESA command 0x4f01). */
+			uint16_t mode_attrs;
+		} vesa_lfb;
+	} u;
 };
 
 /* These flags are passed in the 'flags' field of start_info_t. */
-- 
1.6.0.6

