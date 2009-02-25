Return-Path: <linux-kernel-owner+w=401wt.eu-S1764044AbZBZADy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764044AbZBZADy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759183AbZBZAC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:02:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58428 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbZBZACY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:02:24 -0500
Message-Id: <20090225235515.519731431@arndb.de>
References: <20090225235138.062045835@arndb.de>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 00:51:42 +0100
From: arnd@arndb.de
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, David Airlie <airlied@linux.ie>
Subject: [patch 4/7] make drm headers use strict integer types
Content-Disposition: inline; filename=0005-make-drm-headers-use-strict-integer-types.patch
X-Provags-ID: V01U2FsdGVkX1/ON4SCgD/Cf38G+l08lxu4DJlOgLHpiw142z9
 ktsArLvgL6KPNO7Ddg+ol+OMucCyOlOwow64nQfEB6NsIIhm7f
 t3eFt+uHm3zraEY/k7yAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drm headers are traditionally shared with BSD and
could not use the strict linux integer types. This is
over now, so we can use our own types now.

Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/drm/drm.h        |   21 +++---
 include/drm/drm_mode.h   |  153 ++++++++++++++++++++++-----------------------
 include/drm/i915_drm.h   |  140 +++++++++++++++++++++---------------------
 include/drm/mga_drm.h    |   18 +++---
 include/drm/radeon_drm.h |    4 +-
 include/drm/via_drm.h    |   42 +++++++------
 6 files changed, 190 insertions(+), 188 deletions(-)

diff --git a/include/drm/drm.h b/include/drm/drm.h
index 8e77357..7cb50bd 100644
--- a/include/drm/drm.h
+++ b/include/drm/drm.h
@@ -36,8 +36,7 @@
 #ifndef _DRM_H_
 #define _DRM_H_
 
-#if defined(__KERNEL__)
-#endif
+#include <linux/types.h>
 #include <asm/ioctl.h>		/* For _IO* macros */
 #define DRM_IOCTL_NR(n)		_IOC_NR(n)
 #define DRM_IOC_VOID		_IOC_NONE
@@ -497,8 +496,8 @@ union drm_wait_vblank {
  * \sa drmModesetCtl().
  */
 struct drm_modeset_ctl {
-	uint32_t crtc;
-	uint32_t cmd;
+	__u32 crtc;
+	__u32 cmd;
 };
 
 /**
@@ -574,29 +573,29 @@ struct drm_set_version {
 /** DRM_IOCTL_GEM_CLOSE ioctl argument type */
 struct drm_gem_close {
 	/** Handle of the object to be closed. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 };
 
 /** DRM_IOCTL_GEM_FLINK ioctl argument type */
 struct drm_gem_flink {
 	/** Handle for the object being named */
-	uint32_t handle;
+	__u32 handle;
 
 	/** Returned global name */
-	uint32_t name;
+	__u32 name;
 };
 
 /** DRM_IOCTL_GEM_OPEN ioctl argument type */
 struct drm_gem_open {
 	/** Name of object being opened */
-	uint32_t name;
+	__u32 name;
 
 	/** Returned handle for the object */
-	uint32_t handle;
+	__u32 handle;
 
 	/** Returned size of the object */
-	uint64_t size;
+	__u64 size;
 };
 
 #include "drm_mode.h"
diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
index 601d2bd..ae304cc 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -27,11 +27,8 @@
 #ifndef _DRM_MODE_H
 #define _DRM_MODE_H
 
-#if !defined(__KERNEL__) && !defined(_KERNEL)
-#include <stdint.h>
-#else
 #include <linux/kernel.h>
-#endif
+#include <linux/types.h>
 
 #define DRM_DISPLAY_INFO_LEN	32
 #define DRM_CONNECTOR_NAME_LEN	32
@@ -81,41 +78,41 @@
 #define DRM_MODE_DITHERING_ON	1
 
 struct drm_mode_modeinfo {
-	uint32_t clock;
-	uint16_t hdisplay, hsync_start, hsync_end, htotal, hskew;
-	uint16_t vdisplay, vsync_start, vsync_end, vtotal, vscan;
+	__u32 clock;
+	__u16 hdisplay, hsync_start, hsync_end, htotal, hskew;
+	__u16 vdisplay, vsync_start, vsync_end, vtotal, vscan;
 
-	uint32_t vrefresh; /* vertical refresh * 1000 */
+	__u32 vrefresh; /* vertical refresh * 1000 */
 
-	uint32_t flags;
-	uint32_t type;
+	__u32 flags;
+	__u32 type;
 	char name[DRM_DISPLAY_MODE_LEN];
 };
 
 struct drm_mode_card_res {
-	uint64_t fb_id_ptr;
-	uint64_t crtc_id_ptr;
-	uint64_t connector_id_ptr;
-	uint64_t encoder_id_ptr;
-	uint32_t count_fbs;
-	uint32_t count_crtcs;
-	uint32_t count_connectors;
-	uint32_t count_encoders;
-	uint32_t min_width, max_width;
-	uint32_t min_height, max_height;
+	__u64 fb_id_ptr;
+	__u64 crtc_id_ptr;
+	__u64 connector_id_ptr;
+	__u64 encoder_id_ptr;
+	__u32 count_fbs;
+	__u32 count_crtcs;
+	__u32 count_connectors;
+	__u32 count_encoders;
+	__u32 min_width, max_width;
+	__u32 min_height, max_height;
 };
 
 struct drm_mode_crtc {
-	uint64_t set_connectors_ptr;
-	uint32_t count_connectors;
+	__u64 set_connectors_ptr;
+	__u32 count_connectors;
 
-	uint32_t crtc_id; /**< Id */
-	uint32_t fb_id; /**< Id of framebuffer */
+	__u32 crtc_id; /**< Id */
+	__u32 fb_id; /**< Id of framebuffer */
 
-	uint32_t x, y; /**< Position on the frameuffer */
+	__u32 x, y; /**< Position on the frameuffer */
 
-	uint32_t gamma_size;
-	uint32_t mode_valid;
+	__u32 gamma_size;
+	__u32 mode_valid;
 	struct drm_mode_modeinfo mode;
 };
 
@@ -126,13 +123,13 @@ struct drm_mode_crtc {
 #define DRM_MODE_ENCODER_TVDAC	4
 
 struct drm_mode_get_encoder {
-	uint32_t encoder_id;
-	uint32_t encoder_type;
+	__u32 encoder_id;
+	__u32 encoder_type;
 
-	uint32_t crtc_id; /**< Id of crtc */
+	__u32 crtc_id; /**< Id of crtc */
 
-	uint32_t possible_crtcs;
-	uint32_t possible_clones;
+	__u32 possible_crtcs;
+	__u32 possible_clones;
 };
 
 /* This is for connectors with multiple signal types. */
@@ -161,23 +158,23 @@ struct drm_mode_get_encoder {
 
 struct drm_mode_get_connector {
 
-	uint64_t encoders_ptr;
-	uint64_t modes_ptr;
-	uint64_t props_ptr;
-	uint64_t prop_values_ptr;
+	__u64 encoders_ptr;
+	__u64 modes_ptr;
+	__u64 props_ptr;
+	__u64 prop_values_ptr;
 
-	uint32_t count_modes;
-	uint32_t count_props;
-	uint32_t count_encoders;
+	__u32 count_modes;
+	__u32 count_props;
+	__u32 count_encoders;
 
-	uint32_t encoder_id; /**< Current Encoder */
-	uint32_t connector_id; /**< Id */
-	uint32_t connector_type;
-	uint32_t connector_type_id;
+	__u32 encoder_id; /**< Current Encoder */
+	__u32 connector_id; /**< Id */
+	__u32 connector_type;
+	__u32 connector_type_id;
 
-	uint32_t connection;
-	uint32_t mm_width, mm_height; /**< HxW in millimeters */
-	uint32_t subpixel;
+	__u32 connection;
+	__u32 mm_width, mm_height; /**< HxW in millimeters */
+	__u32 subpixel;
 };
 
 #define DRM_MODE_PROP_PENDING	(1<<0)
@@ -187,46 +184,46 @@ struct drm_mode_get_connector {
 #define DRM_MODE_PROP_BLOB	(1<<4)
 
 struct drm_mode_property_enum {
-	uint64_t value;
+	__u64 value;
 	char name[DRM_PROP_NAME_LEN];
 };
 
 struct drm_mode_get_property {
-	uint64_t values_ptr; /* values and blob lengths */
-	uint64_t enum_blob_ptr; /* enum and blob id ptrs */
+	__u64 values_ptr; /* values and blob lengths */
+	__u64 enum_blob_ptr; /* enum and blob id ptrs */
 
-	uint32_t prop_id;
-	uint32_t flags;
+	__u32 prop_id;
+	__u32 flags;
 	char name[DRM_PROP_NAME_LEN];
 
-	uint32_t count_values;
-	uint32_t count_enum_blobs;
+	__u32 count_values;
+	__u32 count_enum_blobs;
 };
 
 struct drm_mode_connector_set_property {
-	uint64_t value;
-	uint32_t prop_id;
-	uint32_t connector_id;
+	__u64 value;
+	__u32 prop_id;
+	__u32 connector_id;
 };
 
 struct drm_mode_get_blob {
-	uint32_t blob_id;
-	uint32_t length;
-	uint64_t data;
+	__u32 blob_id;
+	__u32 length;
+	__u64 data;
 };
 
 struct drm_mode_fb_cmd {
-	uint32_t fb_id;
-	uint32_t width, height;
-	uint32_t pitch;
-	uint32_t bpp;
-	uint32_t depth;
+	__u32 fb_id;
+	__u32 width, height;
+	__u32 pitch;
+	__u32 bpp;
+	__u32 depth;
 	/* driver specific handle */
-	uint32_t handle;
+	__u32 handle;
 };
 
 struct drm_mode_mode_cmd {
-	uint32_t connector_id;
+	__u32 connector_id;
 	struct drm_mode_modeinfo mode;
 };
 
@@ -248,24 +245,24 @@ struct drm_mode_mode_cmd {
  *    y
  */
 struct drm_mode_cursor {
-	uint32_t flags;
-	uint32_t crtc_id;
-	int32_t x;
-	int32_t y;
-	uint32_t width;
-	uint32_t height;
+	__u32 flags;
+	__u32 crtc_id;
+	__s32 x;
+	__s32 y;
+	__u32 width;
+	__u32 height;
 	/* driver specific handle */
-	uint32_t handle;
+	__u32 handle;
 };
 
 struct drm_mode_crtc_lut {
-	uint32_t crtc_id;
-	uint32_t gamma_size;
+	__u32 crtc_id;
+	__u32 gamma_size;
 
 	/* pointers to arrays */
-	uint64_t red;
-	uint64_t green;
-	uint64_t blue;
+	__u64 red;
+	__u64 green;
+	__u64 blue;
 };
 
 #endif
diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index 912cd52..67e3353 100644
--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -30,7 +30,7 @@
 /* Please note that modifications to all structs defined here are
  * subject to backwards-compatibility constraints.
  */
-
+#include <linux/types.h>
 #include "drm.h"
 
 /* Each region is a minimum of 16k, and there are at most 255 of them.
@@ -116,15 +116,15 @@ typedef struct _drm_i915_sarea {
 
 	/* fill out some space for old userspace triple buffer */
 	drm_handle_t unused_handle;
-	uint32_t unused1, unused2, unused3;
+	__u32 unused1, unused2, unused3;
 
 	/* buffer object handles for static buffers. May change
 	 * over the lifetime of the client.
 	 */
-	uint32_t front_bo_handle;
-	uint32_t back_bo_handle;
-	uint32_t unused_bo_handle;
-	uint32_t depth_bo_handle;
+	__u32 front_bo_handle;
+	__u32 back_bo_handle;
+	__u32 unused_bo_handle;
+	__u32 depth_bo_handle;
 
 } drm_i915_sarea_t;
 
@@ -327,7 +327,7 @@ typedef struct drm_i915_vblank_swap {
 } drm_i915_vblank_swap_t;
 
 typedef struct drm_i915_hws_addr {
-	uint64_t addr;
+	__u64 addr;
 } drm_i915_hws_addr_t;
 
 struct drm_i915_gem_init {
@@ -335,12 +335,12 @@ struct drm_i915_gem_init {
 	 * Beginning offset in the GTT to be managed by the DRM memory
 	 * manager.
 	 */
-	uint64_t gtt_start;
+	__u64 gtt_start;
 	/**
 	 * Ending offset in the GTT to be managed by the DRM memory
 	 * manager.
 	 */
-	uint64_t gtt_end;
+	__u64 gtt_end;
 };
 
 struct drm_i915_gem_create {
@@ -349,94 +349,94 @@ struct drm_i915_gem_create {
 	 *
 	 * The (page-aligned) allocated size for the object will be returned.
 	 */
-	uint64_t size;
+	__u64 size;
 	/**
 	 * Returned handle for the object.
 	 *
 	 * Object handles are nonzero.
 	 */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 };
 
 struct drm_i915_gem_pread {
 	/** Handle for the object being read. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 	/** Offset into the object to read from */
-	uint64_t offset;
+	__u64 offset;
 	/** Length of data to read */
-	uint64_t size;
+	__u64 size;
 	/**
 	 * Pointer to write the data into.
 	 *
 	 * This is a fixed-size type for 32/64 compatibility.
 	 */
-	uint64_t data_ptr;
+	__u64 data_ptr;
 };
 
 struct drm_i915_gem_pwrite {
 	/** Handle for the object being written to. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 	/** Offset into the object to write to */
-	uint64_t offset;
+	__u64 offset;
 	/** Length of data to write */
-	uint64_t size;
+	__u64 size;
 	/**
 	 * Pointer to read the data from.
 	 *
 	 * This is a fixed-size type for 32/64 compatibility.
 	 */
-	uint64_t data_ptr;
+	__u64 data_ptr;
 };
 
 struct drm_i915_gem_mmap {
 	/** Handle for the object being mapped. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 	/** Offset in the object to map. */
-	uint64_t offset;
+	__u64 offset;
 	/**
 	 * Length of data to map.
 	 *
 	 * The value will be page-aligned.
 	 */
-	uint64_t size;
+	__u64 size;
 	/**
 	 * Returned pointer the data was mapped at.
 	 *
 	 * This is a fixed-size type for 32/64 compatibility.
 	 */
-	uint64_t addr_ptr;
+	__u64 addr_ptr;
 };
 
 struct drm_i915_gem_mmap_gtt {
 	/** Handle for the object being mapped. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 	/**
 	 * Fake offset to use for subsequent mmap call
 	 *
 	 * This is a fixed-size type for 32/64 compatibility.
 	 */
-	uint64_t offset;
+	__u64 offset;
 };
 
 struct drm_i915_gem_set_domain {
 	/** Handle for the object */
-	uint32_t handle;
+	__u32 handle;
 
 	/** New read domains */
-	uint32_t read_domains;
+	__u32 read_domains;
 
 	/** New write domain */
-	uint32_t write_domain;
+	__u32 write_domain;
 };
 
 struct drm_i915_gem_sw_finish {
 	/** Handle for the object */
-	uint32_t handle;
+	__u32 handle;
 };
 
 struct drm_i915_gem_relocation_entry {
@@ -448,16 +448,16 @@ struct drm_i915_gem_relocation_entry {
 	 * a relocation list for state buffers and not re-write it per
 	 * exec using the buffer.
 	 */
-	uint32_t target_handle;
+	__u32 target_handle;
 
 	/**
 	 * Value to be added to the offset of the target buffer to make up
 	 * the relocation entry.
 	 */
-	uint32_t delta;
+	__u32 delta;
 
 	/** Offset in the buffer the relocation entry will be written into */
-	uint64_t offset;
+	__u64 offset;
 
 	/**
 	 * Offset value of the target buffer that the relocation entry was last
@@ -467,12 +467,12 @@ struct drm_i915_gem_relocation_entry {
 	 * and writing the relocation.  This value is written back out by
 	 * the execbuffer ioctl when the relocation is written.
 	 */
-	uint64_t presumed_offset;
+	__u64 presumed_offset;
 
 	/**
 	 * Target memory domains read by this operation.
 	 */
-	uint32_t read_domains;
+	__u32 read_domains;
 
 	/**
 	 * Target memory domains written by this operation.
@@ -481,7 +481,7 @@ struct drm_i915_gem_relocation_entry {
 	 * execbuffer operation, so that where there are conflicts,
 	 * the application will get -EINVAL back.
 	 */
-	uint32_t write_domain;
+	__u32 write_domain;
 };
 
 /** @{
@@ -512,24 +512,24 @@ struct drm_i915_gem_exec_object {
 	 * User's handle for a buffer to be bound into the GTT for this
 	 * operation.
 	 */
-	uint32_t handle;
+	__u32 handle;
 
 	/** Number of relocations to be performed on this buffer */
-	uint32_t relocation_count;
+	__u32 relocation_count;
 	/**
 	 * Pointer to array of struct drm_i915_gem_relocation_entry containing
 	 * the relocations to be performed in this buffer.
 	 */
-	uint64_t relocs_ptr;
+	__u64 relocs_ptr;
 
 	/** Required alignment in graphics aperture */
-	uint64_t alignment;
+	__u64 alignment;
 
 	/**
 	 * Returned value of the updated offset of the object, for future
 	 * presumed_offset writes.
 	 */
-	uint64_t offset;
+	__u64 offset;
 };
 
 struct drm_i915_gem_execbuffer {
@@ -543,44 +543,44 @@ struct drm_i915_gem_execbuffer {
 	 * a buffer is performing refer to buffers that have already appeared
 	 * in the validate list.
 	 */
-	uint64_t buffers_ptr;
-	uint32_t buffer_count;
+	__u64 buffers_ptr;
+	__u32 buffer_count;
 
 	/** Offset in the batchbuffer to start execution from. */
-	uint32_t batch_start_offset;
+	__u32 batch_start_offset;
 	/** Bytes used in batchbuffer from batch_start_offset */
-	uint32_t batch_len;
-	uint32_t DR1;
-	uint32_t DR4;
-	uint32_t num_cliprects;
+	__u32 batch_len;
+	__u32 DR1;
+	__u32 DR4;
+	__u32 num_cliprects;
 	/** This is a struct drm_clip_rect *cliprects */
-	uint64_t cliprects_ptr;
+	__u64 cliprects_ptr;
 };
 
 struct drm_i915_gem_pin {
 	/** Handle of the buffer to be pinned. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 
 	/** alignment required within the aperture */
-	uint64_t alignment;
+	__u64 alignment;
 
 	/** Returned GTT offset of the buffer. */
-	uint64_t offset;
+	__u64 offset;
 };
 
 struct drm_i915_gem_unpin {
 	/** Handle of the buffer to be unpinned. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 };
 
 struct drm_i915_gem_busy {
 	/** Handle of the buffer to check for busy */
-	uint32_t handle;
+	__u32 handle;
 
 	/** Return busy status (1 if busy, 0 if idle) */
-	uint32_t busy;
+	__u32 busy;
 };
 
 #define I915_TILING_NONE	0
@@ -597,7 +597,7 @@ struct drm_i915_gem_busy {
 
 struct drm_i915_gem_set_tiling {
 	/** Handle of the buffer to have its tiling state updated */
-	uint32_t handle;
+	__u32 handle;
 
 	/**
 	 * Tiling mode for the object (I915_TILING_NONE, I915_TILING_X,
@@ -611,47 +611,47 @@ struct drm_i915_gem_set_tiling {
 	 *
 	 * Buffer contents become undefined when changing tiling_mode.
 	 */
-	uint32_t tiling_mode;
+	__u32 tiling_mode;
 
 	/**
 	 * Stride in bytes for the object when in I915_TILING_X or
 	 * I915_TILING_Y.
 	 */
-	uint32_t stride;
+	__u32 stride;
 
 	/**
 	 * Returned address bit 6 swizzling required for CPU access through
 	 * mmap mapping.
 	 */
-	uint32_t swizzle_mode;
+	__u32 swizzle_mode;
 };
 
 struct drm_i915_gem_get_tiling {
 	/** Handle of the buffer to get tiling state for. */
-	uint32_t handle;
+	__u32 handle;
 
 	/**
 	 * Current tiling mode for the object (I915_TILING_NONE, I915_TILING_X,
 	 * I915_TILING_Y).
 	 */
-	uint32_t tiling_mode;
+	__u32 tiling_mode;
 
 	/**
 	 * Returned address bit 6 swizzling required for CPU access through
 	 * mmap mapping.
 	 */
-	uint32_t swizzle_mode;
+	__u32 swizzle_mode;
 };
 
 struct drm_i915_gem_get_aperture {
 	/** Total size of the aperture used by i915_gem_execbuffer, in bytes */
-	uint64_t aper_size;
+	__u64 aper_size;
 
 	/**
 	 * Available space in the aperture used by i915_gem_execbuffer, in
 	 * bytes
 	 */
-	uint64_t aper_available_size;
+	__u64 aper_available_size;
 };
 
 #endif				/* _I915_DRM_H_ */
diff --git a/include/drm/mga_drm.h b/include/drm/mga_drm.h
index 944b50a..325fd6f 100644
--- a/include/drm/mga_drm.h
+++ b/include/drm/mga_drm.h
@@ -35,6 +35,8 @@
 #ifndef __MGA_DRM_H__
 #define __MGA_DRM_H__
 
+#include <linux/types.h>
+
 /* WARNING: If you change any of these defines, make sure to change the
  * defines in the Xserver file (mga_sarea.h)
  */
@@ -255,8 +257,8 @@ typedef struct _drm_mga_sarea {
 #define DRM_IOCTL_MGA_ILOAD    DRM_IOW( DRM_COMMAND_BASE + DRM_MGA_ILOAD, drm_mga_iload_t)
 #define DRM_IOCTL_MGA_BLIT     DRM_IOW( DRM_COMMAND_BASE + DRM_MGA_BLIT, drm_mga_blit_t)
 #define DRM_IOCTL_MGA_GETPARAM DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_GETPARAM, drm_mga_getparam_t)
-#define DRM_IOCTL_MGA_SET_FENCE     DRM_IOW( DRM_COMMAND_BASE + DRM_MGA_SET_FENCE, uint32_t)
-#define DRM_IOCTL_MGA_WAIT_FENCE    DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_WAIT_FENCE, uint32_t)
+#define DRM_IOCTL_MGA_SET_FENCE     DRM_IOW( DRM_COMMAND_BASE + DRM_MGA_SET_FENCE, __u32)
+#define DRM_IOCTL_MGA_WAIT_FENCE    DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_WAIT_FENCE, __u32)
 #define DRM_IOCTL_MGA_DMA_BOOTSTRAP DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_DMA_BOOTSTRAP, drm_mga_dma_bootstrap_t)
 
 typedef struct _drm_mga_warp_index {
@@ -310,7 +312,7 @@ typedef struct drm_mga_dma_bootstrap {
 	 */
 	/*@{ */
 	unsigned long texture_handle; /**< Handle used to map AGP textures. */
-	uint32_t texture_size;	      /**< Size of the AGP texture region. */
+	__u32 texture_size;	      /**< Size of the AGP texture region. */
 	/*@} */
 
 	/**
@@ -319,7 +321,7 @@ typedef struct drm_mga_dma_bootstrap {
 	 * On return from the DRM_MGA_DMA_BOOTSTRAP ioctl, this field will be
 	 * filled in with the actual AGP mode.  If AGP was not available
 	 */
-	uint32_t primary_size;
+	__u32 primary_size;
 
 	/**
 	 * Requested number of secondary DMA buffers.
@@ -329,7 +331,7 @@ typedef struct drm_mga_dma_bootstrap {
 	 * allocated.  Particularly when PCI DMA is used, this may be
 	 * (subtantially) less than the number requested.
 	 */
-	uint32_t secondary_bin_count;
+	__u32 secondary_bin_count;
 
 	/**
 	 * Requested size of each secondary DMA buffer.
@@ -338,7 +340,7 @@ typedef struct drm_mga_dma_bootstrap {
 	 * dma_mga_dma_bootstrap::secondary_bin_count, it is \b not allowed
 	 * to reduce dma_mga_dma_bootstrap::secondary_bin_size.
 	 */
-	uint32_t secondary_bin_size;
+	__u32 secondary_bin_size;
 
 	/**
 	 * Bit-wise mask of AGPSTAT2_* values.  Currently only \c AGPSTAT2_1X,
@@ -350,12 +352,12 @@ typedef struct drm_mga_dma_bootstrap {
 	 * filled in with the actual AGP mode.  If AGP was not available
 	 * (i.e., PCI DMA was used), this value will be zero.
 	 */
-	uint32_t agp_mode;
+	__u32 agp_mode;
 
 	/**
 	 * Desired AGP GART size, measured in megabytes.
 	 */
-	uint8_t agp_size;
+	__u8 agp_size;
 } drm_mga_dma_bootstrap_t;
 
 typedef struct drm_mga_clear {
diff --git a/include/drm/radeon_drm.h b/include/drm/radeon_drm.h
index 73ff51f..72ecf67 100644
--- a/include/drm/radeon_drm.h
+++ b/include/drm/radeon_drm.h
@@ -33,6 +33,8 @@
 #ifndef __RADEON_DRM_H__
 #define __RADEON_DRM_H__
 
+#include <linux/types.h>
+
 /* WARNING: If you change any of these defines, make sure to change the
  * defines in the X server file (radeon_sarea.h)
  */
@@ -722,7 +724,7 @@ typedef struct drm_radeon_irq_wait {
 
 typedef struct drm_radeon_setparam {
 	unsigned int param;
-	int64_t value;
+	__s64 value;
 } drm_radeon_setparam_t;
 
 #define RADEON_SETPARAM_FB_LOCATION    1	/* determined framebuffer location */
diff --git a/include/drm/via_drm.h b/include/drm/via_drm.h
index a3b5c10..170786e 100644
--- a/include/drm/via_drm.h
+++ b/include/drm/via_drm.h
@@ -24,6 +24,8 @@
 #ifndef _VIA_DRM_H_
 #define _VIA_DRM_H_
 
+#include <linux/types.h>
+
 /* WARNING: These defines must be the same as what the Xserver uses.
  * if you change them, you must change the defines in the Xserver.
  */
@@ -114,19 +116,19 @@
 #define VIA_MEM_UNKNOWN 4
 
 typedef struct {
-	uint32_t offset;
-	uint32_t size;
+	__u32 offset;
+	__u32 size;
 } drm_via_agp_t;
 
 typedef struct {
-	uint32_t offset;
-	uint32_t size;
+	__u32 offset;
+	__u32 size;
 } drm_via_fb_t;
 
 typedef struct {
-	uint32_t context;
-	uint32_t type;
-	uint32_t size;
+	__u32 context;
+	__u32 type;
+	__u32 size;
 	unsigned long index;
 	unsigned long offset;
 } drm_via_mem_t;
@@ -148,9 +150,9 @@ typedef struct _drm_via_futex {
 		VIA_FUTEX_WAIT = 0x00,
 		VIA_FUTEX_WAKE = 0X01
 	} func;
-	uint32_t ms;
-	uint32_t lock;
-	uint32_t val;
+	__u32 ms;
+	__u32 lock;
+	__u32 val;
 } drm_via_futex_t;
 
 typedef struct _drm_via_dma_init {
@@ -211,7 +213,7 @@ typedef struct _drm_via_cmdbuf_size {
 		VIA_CMDBUF_LAG = 0x02
 	} func;
 	int wait;
-	uint32_t size;
+	__u32 size;
 } drm_via_cmdbuf_size_t;
 
 typedef enum {
@@ -236,8 +238,8 @@ enum drm_via_irqs {
 struct drm_via_wait_irq_request {
 	unsigned irq;
 	via_irq_seq_type_t type;
-	uint32_t sequence;
-	uint32_t signal;
+	__u32 sequence;
+	__u32 signal;
 };
 
 typedef union drm_via_irqwait {
@@ -246,7 +248,7 @@ typedef union drm_via_irqwait {
 } drm_via_irqwait_t;
 
 typedef struct drm_via_blitsync {
-	uint32_t sync_handle;
+	__u32 sync_handle;
 	unsigned engine;
 } drm_via_blitsync_t;
 
@@ -257,16 +259,16 @@ typedef struct drm_via_blitsync {
  */
 
 typedef struct drm_via_dmablit {
-	uint32_t num_lines;
-	uint32_t line_length;
+	__u32 num_lines;
+	__u32 line_length;
 
-	uint32_t fb_addr;
-	uint32_t fb_stride;
+	__u32 fb_addr;
+	__u32 fb_stride;
 
 	unsigned char *mem_addr;
-	uint32_t mem_stride;
+	__u32 mem_stride;
 
-	uint32_t flags;
+	__u32 flags;
 	int to_fb;
 
 	drm_via_blitsync_t sync;
-- 
1.5.6.3

-- 

