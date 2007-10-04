Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbXJDADb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbXJDADb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 20:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbXJDADX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 20:03:23 -0400
Received: from ozlabs.org ([203.10.76.45]:50914 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbXJDADV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 20:03:21 -0400
Subject: Re: [PATCH 5/5] lguest: loading bzImage directly
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chris Malley <mail@chrismalley.co.uk>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, lguest <lguest@ozlabs.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <1191404221.17247.15.camel@feisty>
References: <1191368052.17826.40.camel@localhost.localdomain>
	 <1191368106.17826.43.camel@localhost.localdomain>
	 <1191368154.17826.44.camel@localhost.localdomain>
	 <1191368217.17826.47.camel@localhost.localdomain>
	 <1191368399.17826.51.camel@localhost.localdomain>
	 <1191368457.17826.53.camel@localhost.localdomain>
	 <1191404221.17247.15.camel@feisty>
Content-Type: text/plain
Date: Thu, 04 Oct 2007 10:02:55 +1000
Message-Id: <1191456175.8268.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-03 at 10:37 +0100, Chris Malley wrote:
> Hi guys
> 
> Would it not be clearer to #include <asm/bootparam.h> and use 
> the relevant named members of struct setup_header / struct boot_params
> rather than the hard-coded values 0x202, 0x1F1, 0x214 ?

Yes, but unfortunately bootparam.h wasn't designed to be included from
userspace.

The patch would look like this, but it makes me wonder if it'd be better
to put all these user-exposed types in bootparam.h and have the other
headers include them.  hpa?

diff -r 6bb527d113a8 include/asm-i386/Kbuild
--- a/include/asm-i386/Kbuild	Wed Oct 03 13:49:31 2007 +1000
+++ b/include/asm-i386/Kbuild	Thu Oct 04 09:53:08 2007 +1000
@@ -6,7 +6,10 @@ header-y += msr-index.h
 header-y += msr-index.h
 header-y += ptrace-abi.h
 header-y += ucontext.h
+header-y += bootparam.h
 
+unifdef-y += e820.h
+unifdef-y += ist.h
 unifdef-y += msr.h
 unifdef-y += mtrr.h
 unifdef-y += vm86.h
diff -r 6bb527d113a8 include/asm-i386/bootparam.h
--- a/include/asm-i386/bootparam.h	Wed Oct 03 13:49:31 2007 +1000
+++ b/include/asm-i386/bootparam.h	Thu Oct 04 09:45:12 2007 +1000
@@ -10,82 +10,82 @@
 #include <video/edid.h>
 
 struct setup_header {
-	u8	setup_sects;
-	u16	root_flags;
-	u32	syssize;
-	u16	ram_size;
-	u16	vid_mode;
-	u16	root_dev;
-	u16	boot_flag;
-	u16	jump;
-	u32	header;
-	u16	version;
-	u32	realmode_swtch;
-	u16	start_sys;
-	u16	kernel_version;
-	u8	type_of_loader;
-	u8	loadflags;
+	__u8	setup_sects;
+	__u16	root_flags;
+	__u32	syssize;
+	__u16	ram_size;
+	__u16	vid_mode;
+	__u16	root_dev;
+	__u16	boot_flag;
+	__u16	jump;
+	__u32	header;
+	__u16	version;
+	__u32	realmode_swtch;
+	__u16	start_sys;
+	__u16	kernel_version;
+	__u8	type_of_loader;
+	__u8	loadflags;
 #define LOADED_HIGH	(1<<0)
 #define KEEP_SEGMENTS	(1<<6)
 #define CAN_USE_HEAP	(1<<7)
-	u16	setup_move_size;
-	u32	code32_start;
-	u32	ramdisk_image;
-	u32	ramdisk_size;
-	u32	bootsect_kludge;
-	u16	heap_end_ptr;
-	u16	_pad1;
-	u32	cmd_line_ptr;
-	u32	initrd_addr_max;
-	u32	kernel_alignment;
-	u8	relocatable_kernel;
-	u8	_pad2[3];
-	u32	cmdline_size;
-	u32	hardware_subarch;
-	u64	hardware_subarch_data;
+	__u16	setup_move_size;
+	__u32	code32_start;
+	__u32	ramdisk_image;
+	__u32	ramdisk_size;
+	__u32	bootsect_kludge;
+	__u16	heap_end_ptr;
+	__u16	_pad1;
+	__u32	cmd_line_ptr;
+	__u32	initrd_addr_max;
+	__u32	kernel_alignment;
+	__u8	relocatable_kernel;
+	__u8	_pad2[3];
+	__u32	cmdline_size;
+	__u32	hardware_subarch;
+	__u64	hardware_subarch_data;
 } __attribute__((packed));
 
 struct sys_desc_table {
-	u16 length;
-	u8  table[14];
+	__u16 length;
+	__u8  table[14];
 };
 
 struct efi_info {
-	u32 _pad1;
-	u32 efi_systab;
-	u32 efi_memdesc_size;
-	u32 efi_memdesc_version;
-	u32 efi_memmap;
-	u32 efi_memmap_size;
-	u32 _pad2[2];
+	__u32 _pad1;
+	__u32 efi_systab;
+	__u32 efi_memdesc_size;
+	__u32 efi_memdesc_version;
+	__u32 efi_memmap;
+	__u32 efi_memmap_size;
+	__u32 _pad2[2];
 };
 
 /* The so-called "zeropage" */
 struct boot_params {
 	struct screen_info screen_info;			/* 0x000 */
 	struct apm_bios_info apm_bios_info;		/* 0x040 */
-	u8  _pad2[12];					/* 0x054 */
+	__u8  _pad2[12];				/* 0x054 */
 	struct ist_info ist_info;			/* 0x060 */
-	u8  _pad3[16];					/* 0x070 */
-	u8  hd0_info[16];	/* obsolete! */		/* 0x080 */
-	u8  hd1_info[16];	/* obsolete! */		/* 0x090 */
+	__u8  _pad3[16];				/* 0x070 */
+	__u8  hd0_info[16];	/* obsolete! */		/* 0x080 */
+	__u8  hd1_info[16];	/* obsolete! */		/* 0x090 */
 	struct sys_desc_table sys_desc_table;		/* 0x0a0 */
-	u8  _pad4[144];					/* 0x0b0 */
+	__u8  _pad4[144];				/* 0x0b0 */
 	struct edid_info edid_info;			/* 0x140 */
 	struct efi_info efi_info;			/* 0x1c0 */
-	u32 alt_mem_k;					/* 0x1e0 */
-	u32 scratch;		/* Scratch field! */	/* 0x1e4 */
-	u8  e820_entries;				/* 0x1e8 */
-	u8  eddbuf_entries;				/* 0x1e9 */
-	u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
-	u8  _pad6[6];					/* 0x1eb */
+	__u32 alt_mem_k;				/* 0x1e0 */
+	__u32 scratch;		/* Scratch field! */	/* 0x1e4 */
+	__u8  e820_entries;				/* 0x1e8 */
+	__u8  eddbuf_entries;				/* 0x1e9 */
+	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
+	__u8  _pad6[6];					/* 0x1eb */
 	struct setup_header hdr;    /* setup header */	/* 0x1f1 */
-	u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
-	u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];	/* 0x290 */
+	__u8  _pad7[0x290-0x1f1-sizeof(struct setup_header)];
+	__u32 edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];	/* 0x290 */
 	struct e820entry e820_map[E820MAX];		/* 0x2d0 */
-	u8  _pad8[48];					/* 0xcd0 */
+	__u8  _pad8[48];				/* 0xcd0 */
 	struct edd_info eddbuf[EDDMAXNR];		/* 0xd00 */
-	u8  _pad9[276];					/* 0xeec */
+	__u8  _pad9[276];				/* 0xeec */
 } __attribute__((packed));
 
 #endif /* _ASM_BOOTPARAM_H */
diff -r 6bb527d113a8 include/asm-i386/e820.h
--- a/include/asm-i386/e820.h	Wed Oct 03 13:49:31 2007 +1000
+++ b/include/asm-i386/e820.h	Thu Oct 04 09:44:56 2007 +1000
@@ -26,16 +26,17 @@
 #ifndef __ASSEMBLY__
 
 struct e820entry {
-	u64 addr;	/* start of memory segment */
-	u64 size;	/* size of memory segment */
-	u32 type;	/* type of memory segment */
+	__u64 addr;	/* start of memory segment */
+	__u64 size;	/* size of memory segment */
+	__u32 type;	/* type of memory segment */
 } __attribute__((packed));
 
 struct e820map {
-	u32 nr_map;
+	__u32 nr_map;
 	struct e820entry map[E820MAX];
 };
 
+#ifdef __KERNEL__
 extern struct e820map e820;
 
 extern int e820_all_mapped(unsigned long start, unsigned long end,
@@ -56,5 +57,5 @@ static inline void e820_mark_nosave_regi
 #endif
 
 #endif/*!__ASSEMBLY__*/
-
+#endif/*__KERNEL__*/
 #endif/*__E820_HEADER*/
diff -r 6bb527d113a8 include/asm-i386/ist.h
--- a/include/asm-i386/ist.h	Wed Oct 03 13:49:31 2007 +1000
+++ b/include/asm-i386/ist.h	Thu Oct 04 09:45:39 2007 +1000
@@ -17,16 +17,16 @@
  */
 
 
-#ifdef __KERNEL__
-
 #include <linux/types.h>
 
 struct ist_info {
-	u32 signature;
-	u32 command;
-	u32 event;
-	u32 perf_level;
+	__u32 signature;
+	__u32 command;
+	__u32 event;
+	__u32 perf_level;
 };
+
+#ifdef __KERNEL__
 
 extern struct ist_info ist_info;
 
diff -r 6bb527d113a8 include/linux/Kbuild
--- a/include/linux/Kbuild	Wed Oct 03 13:49:31 2007 +1000
+++ b/include/linux/Kbuild	Thu Oct 04 09:51:30 2007 +1000
@@ -189,6 +189,7 @@ unifdef-y += dccp.h
 unifdef-y += dccp.h
 unifdef-y += dirent.h
 unifdef-y += dlm.h
+unifdef-y += edd.h
 unifdef-y += elfcore.h
 unifdef-y += errno.h
 unifdef-y += errqueue.h
@@ -308,6 +309,7 @@ unifdef-y += rtnetlink.h
 unifdef-y += rtnetlink.h
 unifdef-y += scc.h
 unifdef-y += sched.h
+unifdef-y += screen_info.h
 unifdef-y += sdla.h
 unifdef-y += selinux_netlink.h
 unifdef-y += sem.h
diff -r 6bb527d113a8 include/linux/apm_bios.h
--- a/include/linux/apm_bios.h	Wed Oct 03 13:49:31 2007 +1000
+++ b/include/linux/apm_bios.h	Thu Oct 04 09:37:28 2007 +1000
@@ -16,28 +16,28 @@
  * General Public License for more details.
  */
 
+#include <linux/types.h>
+
+struct apm_bios_info {
+	__u16	version;
+	__u16	cseg;
+	__u32	offset;
+	__u16	cseg_16;
+	__u16	dseg;
+	__u16	flags;
+	__u16	cseg_len;
+	__u16	cseg_16_len;
+	__u16	dseg_len;
+};
+
+#ifdef __KERNEL__
+
 typedef unsigned short	apm_event_t;
 typedef unsigned short	apm_eventinfo_t;
-
-#ifdef __KERNEL__
-
-#include <linux/types.h>
 
 #define APM_CS		(GDT_ENTRY_APMBIOS_BASE * 8)
 #define APM_CS_16	(APM_CS + 8)
 #define APM_DS		(APM_CS_16 + 8)
-
-struct apm_bios_info {
-	u16	version;
-	u16	cseg;
-	u32	offset;
-	u16	cseg_16;
-	u16	dseg;
-	u16	flags;
-	u16	cseg_len;
-	u16	cseg_16_len;
-	u16	dseg_len;
-};
 
 /* Results of APM Installation Check */
 #define APM_16_BIT_SUPPORT	0x0001
diff -r 6bb527d113a8 include/linux/edd.h
--- a/include/linux/edd.h	Wed Oct 03 13:49:31 2007 +1000
+++ b/include/linux/edd.h	Thu Oct 04 09:43:22 2007 +1000
@@ -67,113 +67,113 @@
 #define EDD_INFO_USE_INT13_FN50                (1 << 7)
 
 struct edd_device_params {
-	u16 length;
-	u16 info_flags;
-	u32 num_default_cylinders;
-	u32 num_default_heads;
-	u32 sectors_per_track;
-	u64 number_of_sectors;
-	u16 bytes_per_sector;
-	u32 dpte_ptr;		/* 0xFFFFFFFF for our purposes */
-	u16 key;		/* = 0xBEDD */
-	u8 device_path_info_length;	/* = 44 */
-	u8 reserved2;
-	u16 reserved3;
-	u8 host_bus_type[4];
-	u8 interface_type[8];
+	__u16 length;
+	__u16 info_flags;
+	__u32 num_default_cylinders;
+	__u32 num_default_heads;
+	__u32 sectors_per_track;
+	__u64 number_of_sectors;
+	__u16 bytes_per_sector;
+	__u32 dpte_ptr;		/* 0xFFFFFFFF for our purposes */
+	__u16 key;		/* = 0xBEDD */
+	__u8 device_path_info_length;	/* = 44 */
+	__u8 reserved2;
+	__u16 reserved3;
+	__u8 host_bus_type[4];
+	__u8 interface_type[8];
 	union {
 		struct {
-			u16 base_address;
-			u16 reserved1;
-			u32 reserved2;
+			__u16 base_address;
+			__u16 reserved1;
+			__u32 reserved2;
 		} __attribute__ ((packed)) isa;
 		struct {
-			u8 bus;
-			u8 slot;
-			u8 function;
-			u8 channel;
-			u32 reserved;
+			__u8 bus;
+			__u8 slot;
+			__u8 function;
+			__u8 channel;
+			__u32 reserved;
 		} __attribute__ ((packed)) pci;
 		/* pcix is same as pci */
 		struct {
-			u64 reserved;
+			__u64 reserved;
 		} __attribute__ ((packed)) ibnd;
 		struct {
-			u64 reserved;
+			__u64 reserved;
 		} __attribute__ ((packed)) xprs;
 		struct {
-			u64 reserved;
+			__u64 reserved;
 		} __attribute__ ((packed)) htpt;
 		struct {
-			u64 reserved;
+			__u64 reserved;
 		} __attribute__ ((packed)) unknown;
 	} interface_path;
 	union {
 		struct {
-			u8 device;
-			u8 reserved1;
-			u16 reserved2;
-			u32 reserved3;
-			u64 reserved4;
+			__u8 device;
+			__u8 reserved1;
+			__u16 reserved2;
+			__u32 reserved3;
+			__u64 reserved4;
 		} __attribute__ ((packed)) ata;
 		struct {
-			u8 device;
-			u8 lun;
-			u8 reserved1;
-			u8 reserved2;
-			u32 reserved3;
-			u64 reserved4;
+			__u8 device;
+			__u8 lun;
+			__u8 reserved1;
+			__u8 reserved2;
+			__u32 reserved3;
+			__u64 reserved4;
 		} __attribute__ ((packed)) atapi;
 		struct {
-			u16 id;
-			u64 lun;
-			u16 reserved1;
-			u32 reserved2;
+			__u16 id;
+			__u64 lun;
+			__u16 reserved1;
+			__u32 reserved2;
 		} __attribute__ ((packed)) scsi;
 		struct {
-			u64 serial_number;
-			u64 reserved;
+			__u64 serial_number;
+			__u64 reserved;
 		} __attribute__ ((packed)) usb;
 		struct {
-			u64 eui;
-			u64 reserved;
+			__u64 eui;
+			__u64 reserved;
 		} __attribute__ ((packed)) i1394;
 		struct {
-			u64 wwid;
-			u64 lun;
+			__u64 wwid;
+			__u64 lun;
 		} __attribute__ ((packed)) fibre;
 		struct {
-			u64 identity_tag;
-			u64 reserved;
+			__u64 identity_tag;
+			__u64 reserved;
 		} __attribute__ ((packed)) i2o;
 		struct {
-			u32 array_number;
-			u32 reserved1;
-			u64 reserved2;
+			__u32 array_number;
+			__u32 reserved1;
+			__u64 reserved2;
 		} __attribute__ ((packed)) raid;
 		struct {
-			u8 device;
-			u8 reserved1;
-			u16 reserved2;
-			u32 reserved3;
-			u64 reserved4;
+			__u8 device;
+			__u8 reserved1;
+			__u16 reserved2;
+			__u32 reserved3;
+			__u64 reserved4;
 		} __attribute__ ((packed)) sata;
 		struct {
-			u64 reserved1;
-			u64 reserved2;
+			__u64 reserved1;
+			__u64 reserved2;
 		} __attribute__ ((packed)) unknown;
 	} device_path;
-	u8 reserved4;
-	u8 checksum;
+	__u8 reserved4;
+	__u8 checksum;
 } __attribute__ ((packed));
 
 struct edd_info {
-	u8 device;
-	u8 version;
-	u16 interface_support;
-	u16 legacy_max_cylinder;
-	u8 legacy_max_head;
-	u8 legacy_sectors_per_track;
+	__u8 device;
+	__u8 version;
+	__u16 interface_support;
+	__u16 legacy_max_cylinder;
+	__u8 legacy_max_head;
+	__u8 legacy_sectors_per_track;
 	struct edd_device_params params;
 } __attribute__ ((packed));
 
@@ -184,8 +184,9 @@ struct edd {
 	unsigned char edd_info_nr;
 };
 
+#ifdef __KERNEL__
 extern struct edd edd;
-
+#endif /* __KERNEL__ */
 #endif				/*!__ASSEMBLY__ */
 
 #endif				/* _LINUX_EDD_H */
diff -r 6bb527d113a8 include/linux/screen_info.h
--- a/include/linux/screen_info.h	Wed Oct 03 13:49:31 2007 +1000
+++ b/include/linux/screen_info.h	Thu Oct 04 09:40:29 2007 +1000
@@ -8,53 +8,42 @@
  */
 
 struct screen_info {
-	u8  orig_x;		/* 0x00 */
-	u8  orig_y;		/* 0x01 */
-	u16 ext_mem_k;		/* 0x02 */
-	u16 orig_video_page;	/* 0x04 */
-	u8  orig_video_mode;	/* 0x06 */
-	u8  orig_video_cols;	/* 0x07 */
-	u16 unused2;		/* 0x08 */
-	u16 orig_video_ega_bx;	/* 0x0a */
-	u16 unused3;		/* 0x0c */
-	u8  orig_video_lines;	/* 0x0e */
-	u8  orig_video_isVGA;	/* 0x0f */
-	u16 orig_video_points;	/* 0x10 */
+	__u8  orig_x;		/* 0x00 */
+	__u8  orig_y;		/* 0x01 */
+	__u16 ext_mem_k;	/* 0x02 */
+	__u16 orig_video_page;	/* 0x04 */
+	__u8  orig_video_mode;	/* 0x06 */
+	__u8  orig_video_cols;	/* 0x07 */
+	__u16 unused2;		/* 0x08 */
+	__u16 orig_video_ega_bx;/* 0x0a */
+	__u16 unused3;		/* 0x0c */
+	__u8  orig_video_lines;	/* 0x0e */
+	__u8  orig_video_isVGA;	/* 0x0f */
+	__u16 orig_video_points;/* 0x10 */
 
 	/* VESA graphic mode -- linear frame buffer */
-	u16 lfb_width;		/* 0x12 */
-	u16 lfb_height;		/* 0x14 */
-	u16 lfb_depth;		/* 0x16 */
-	u32 lfb_base;		/* 0x18 */
-	u32 lfb_size;		/* 0x1c */
-	u16 cl_magic, cl_offset; /* 0x20 */
-	u16 lfb_linelength;	/* 0x24 */
-	u8  red_size;		/* 0x26 */
-	u8  red_pos;		/* 0x27 */
-	u8  green_size;		/* 0x28 */
-	u8  green_pos;		/* 0x29 */
-	u8  blue_size;		/* 0x2a */
-	u8  blue_pos;		/* 0x2b */
-	u8  rsvd_size;		/* 0x2c */
-	u8  rsvd_pos;		/* 0x2d */
-	u16 vesapm_seg;		/* 0x2e */
-	u16 vesapm_off;		/* 0x30 */
-	u16 pages;		/* 0x32 */
-	u16 vesa_attributes;	/* 0x34 */
-	u32 capabilities;       /* 0x36 */
-	u8  _reserved[6];	/* 0x3a */
+	__u16 lfb_width;	/* 0x12 */
+	__u16 lfb_height;	/* 0x14 */
+	__u16 lfb_depth;	/* 0x16 */
+	__u32 lfb_base;		/* 0x18 */
+	__u32 lfb_size;		/* 0x1c */
+	__u16 cl_magic, cl_offset; /* 0x20 */
+	__u16 lfb_linelength;	/* 0x24 */
+	__u8  red_size;		/* 0x26 */
+	__u8  red_pos;		/* 0x27 */
+	__u8  green_size;	/* 0x28 */
+	__u8  green_pos;	/* 0x29 */
+	__u8  blue_size;	/* 0x2a */
+	__u8  blue_pos;		/* 0x2b */
+	__u8  rsvd_size;	/* 0x2c */
+	__u8  rsvd_pos;		/* 0x2d */
+	__u16 vesapm_seg;	/* 0x2e */
+	__u16 vesapm_off;	/* 0x30 */
+	__u16 pages;		/* 0x32 */
+	__u16 vesa_attributes;	/* 0x34 */
+	__u32 capabilities;     /* 0x36 */
+	__u8  _reserved[6];	/* 0x3a */
 } __attribute__((packed));
-
-extern struct screen_info screen_info;
-
-#define ORIG_X			(screen_info.orig_x)
-#define ORIG_Y			(screen_info.orig_y)
-#define ORIG_VIDEO_MODE		(screen_info.orig_video_mode)
-#define ORIG_VIDEO_COLS 	(screen_info.orig_video_cols)
-#define ORIG_VIDEO_EGA_BX	(screen_info.orig_video_ega_bx)
-#define ORIG_VIDEO_LINES	(screen_info.orig_video_lines)
-#define ORIG_VIDEO_ISVGA	(screen_info.orig_video_isVGA)
-#define ORIG_VIDEO_POINTS       (screen_info.orig_video_points)
 
 #define VIDEO_TYPE_MDA		0x10	/* Monochrome Text Display	*/
 #define VIDEO_TYPE_CGA		0x11	/* CGA Display 			*/
@@ -74,4 +63,17 @@ extern struct screen_info screen_info;
 
 #define VIDEO_TYPE_PMAC		0x60	/* PowerMacintosh frame buffer. */
 
+#ifdef __KERNEL__
+extern struct screen_info screen_info;
+
+#define ORIG_X			(screen_info.orig_x)
+#define ORIG_Y			(screen_info.orig_y)
+#define ORIG_VIDEO_MODE		(screen_info.orig_video_mode)
+#define ORIG_VIDEO_COLS 	(screen_info.orig_video_cols)
+#define ORIG_VIDEO_EGA_BX	(screen_info.orig_video_ega_bx)
+#define ORIG_VIDEO_LINES	(screen_info.orig_video_lines)
+#define ORIG_VIDEO_ISVGA	(screen_info.orig_video_isVGA)
+#define ORIG_VIDEO_POINTS       (screen_info.orig_video_points)
+#endif /* __KERNEL__ */
+
 #endif /* _SCREEN_INFO_H */
diff -r 6bb527d113a8 include/video/Kbuild
--- a/include/video/Kbuild	Wed Oct 03 13:49:31 2007 +1000
+++ b/include/video/Kbuild	Thu Oct 04 09:50:15 2007 +1000
@@ -1,1 +1,2 @@ unifdef-y += sisfb.h
 unifdef-y += sisfb.h
+unifdef-y += edid.h
diff -r 6bb527d113a8 include/video/edid.h
--- a/include/video/edid.h	Wed Oct 03 13:49:31 2007 +1000
+++ b/include/video/edid.h	Thu Oct 04 09:48:14 2007 +1000
@@ -1,17 +1,16 @@
 #ifndef __linux_video_edid_h__
 #define __linux_video_edid_h__
 
-#ifdef __KERNEL__
+#if !defined(__KERNEL__) || defined(CONFIG_X86)
 
-
-#ifdef CONFIG_X86
 struct edid_info {
 	unsigned char dummy[128];
 };
 
+#ifdef __KERNEL__
 extern struct edid_info edid_info;
-#endif /* CONFIG_X86 */
-
 #endif /* __KERNEL__ */
 
+#endif
+
 #endif /* __linux_video_edid_h__ */


