Return-Path: <linux-kernel-owner+w=401wt.eu-S1760899AbZBZACG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760899AbZBZACG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZBZABt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:01:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:57321 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZBZABq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:01:46 -0500
Message-Id: <20090225235515.196697126@arndb.de>
References: <20090225235138.062045835@arndb.de>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 00:51:40 +0100
From: arnd@arndb.de
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: [patch 2/7] make most exported headers use strict integer types
Content-Disposition: inline; filename=0003-make-exported-headers-use-strict-integer-types.patch
X-Provags-ID: V01U2FsdGVkX19myzXx0/vAzzF6UDmiH74DWKkMW+y4tNu4qch
 d+oVDv8WSdMujRsS5JaneG7Bkx7HTCd/+k3XxGx8Yx3ew/mDBF
 4vwsvdwz85Oethefk7alg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This takes care of all files that have only a small number
of non-strict integer type uses.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/atmlec.h          |    5 +-
 include/linux/atmmpc.h          |   44 ++++----
 include/linux/cm4000_cs.h       |   10 +-
 include/linux/dlm_netlink.h     |   18 ++--
 include/linux/dm-ioctl.h        |   42 ++++----
 include/linux/dvb/audio.h       |    2 +-
 include/linux/dvb/video.h       |   22 ++--
 include/linux/if_arcnet.h       |   27 +++--
 include/linux/ip_vs.h           |   26 ++--
 include/linux/ivtvfb.h          |    2 +-
 include/linux/matroxfb.h        |    2 +-
 include/linux/pfkeyv2.h         |  242 +++++++++++++++++++-------------------
 include/linux/pkt_sched.h       |    2 +-
 include/linux/selinux_netlink.h |    6 +-
 include/sound/asound.h          |    2 +-
 include/sound/emu10k1.h         |   10 +-
 16 files changed, 236 insertions(+), 226 deletions(-)

Index: linux-2.6/include/linux/atmlec.h
===================================================================
--- linux-2.6.orig/include/linux/atmlec.h
+++ linux-2.6/include/linux/atmlec.h
@@ -11,6 +11,7 @@
 #include <linux/atmioc.h>
 #include <linux/atm.h>
 #include <linux/if_ether.h>
+#include <linux/types.h>
 
 /* ATM lec daemon control socket */
 #define ATMLEC_CTRL	_IO('a', ATMIOC_LANE)
@@ -78,8 +79,8 @@ struct atmlec_msg {
 		} normal;
 		struct atmlec_config_msg config;
 		struct {
-			uint16_t lec_id;			/* requestor lec_id  */
-			uint32_t tran_id;			/* transaction id    */
+			__u16 lec_id;				/* requestor lec_id  */
+			__u32 tran_id;				/* transaction id    */
 			unsigned char mac_addr[ETH_ALEN];	/* dst mac addr      */
 			unsigned char atm_addr[ATM_ESA_LEN];	/* reqestor ATM addr */
 		} proxy;	/*
Index: linux-2.6/include/linux/atmmpc.h
===================================================================
--- linux-2.6.orig/include/linux/atmmpc.h
+++ linux-2.6/include/linux/atmmpc.h
@@ -4,6 +4,7 @@
 #include <linux/atmapi.h>
 #include <linux/atmioc.h>
 #include <linux/atm.h>
+#include <linux/types.h>
 
 #define ATMMPC_CTRL _IO('a', ATMIOC_MPOA)
 #define ATMMPC_DATA _IO('a', ATMIOC_MPOA+1)
@@ -18,39 +19,39 @@ struct atmmpc_ioc {
 };
 
 typedef struct in_ctrl_info {
-        uint8_t   Last_NHRP_CIE_code;
-        uint8_t   Last_Q2931_cause_value;     
-        uint8_t   eg_MPC_ATM_addr[ATM_ESA_LEN];
+        __u8   Last_NHRP_CIE_code;
+        __u8   Last_Q2931_cause_value;
+        __u8   eg_MPC_ATM_addr[ATM_ESA_LEN];
         __be32  tag;
         __be32  in_dst_ip;      /* IP address this ingress MPC sends packets to */
-        uint16_t  holding_time;
-        uint32_t  request_id;
+        __u16  holding_time;
+        __u32  request_id;
 } in_ctrl_info;
 
 typedef struct eg_ctrl_info {
-        uint8_t   DLL_header[256];
-        uint8_t   DH_length;
+        __u8   DLL_header[256];
+        __u8   DH_length;
         __be32  cache_id;
         __be32  tag;
         __be32  mps_ip;
         __be32  eg_dst_ip;      /* IP address to which ingress MPC sends packets */
-        uint8_t   in_MPC_data_ATM_addr[ATM_ESA_LEN];
-        uint16_t  holding_time;
+        __u8   in_MPC_data_ATM_addr[ATM_ESA_LEN];
+        __u16  holding_time;
 } eg_ctrl_info;
 
 struct mpc_parameters {
-        uint16_t mpc_p1;   /* Shortcut-Setup Frame Count    */
-        uint16_t mpc_p2;   /* Shortcut-Setup Frame Time     */
-        uint8_t mpc_p3[8]; /* Flow-detection Protocols      */
-        uint16_t mpc_p4;   /* MPC Initial Retry Time        */
-        uint16_t mpc_p5;   /* MPC Retry Time Maximum        */
-        uint16_t mpc_p6;   /* Hold Down Time                */      
+        __u16 mpc_p1;   /* Shortcut-Setup Frame Count    */
+        __u16 mpc_p2;   /* Shortcut-Setup Frame Time     */
+        __u8 mpc_p3[8]; /* Flow-detection Protocols      */
+        __u16 mpc_p4;   /* MPC Initial Retry Time        */
+        __u16 mpc_p5;   /* MPC Retry Time Maximum        */
+        __u16 mpc_p6;   /* Hold Down Time                */
 } ;
 
 struct k_message {
-        uint16_t type;
+        __u16 type;
         __be32 ip_mask;
-        uint8_t  MPS_ctrl[ATM_ESA_LEN];
+        __u8  MPS_ctrl[ATM_ESA_LEN];
         union {
                 in_ctrl_info in_info;
                 eg_ctrl_info eg_info;
@@ -61,11 +62,11 @@ struct k_message {
 
 struct llc_snap_hdr {
 	/* RFC 1483 LLC/SNAP encapsulation for routed IP PDUs */
-        uint8_t  dsap;    /* Destination Service Access Point (0xAA)     */
-        uint8_t  ssap;    /* Source Service Access Point      (0xAA)     */
-        uint8_t  ui;      /* Unnumbered Information           (0x03)     */
-        uint8_t  org[3];  /* Organizational identification    (0x000000) */
-        uint8_t  type[2]; /* Ether type (for IP)              (0x0800)   */
+        __u8  dsap;    /* Destination Service Access Point (0xAA)     */
+        __u8  ssap;    /* Source Service Access Point      (0xAA)     */
+        __u8  ui;      /* Unnumbered Information           (0x03)     */
+        __u8  org[3];  /* Organizational identification    (0x000000) */
+        __u8  type[2]; /* Ether type (for IP)              (0x0800)   */
 };
 
 /* TLVs this MPC recognizes */
Index: linux-2.6/include/linux/cm4000_cs.h
===================================================================
--- linux-2.6.orig/include/linux/cm4000_cs.h
+++ linux-2.6/include/linux/cm4000_cs.h
@@ -1,6 +1,8 @@
 #ifndef	_CM4000_H_
 #define	_CM4000_H_
 
+#include <linux/types.h>
+
 #define	MAX_ATR			33
 
 #define	CM4000_MAX_DEV		4
@@ -10,9 +12,9 @@
  * not to break compilation of userspace apps. -HW */
 
 typedef struct atreq {
-	int32_t atr_len;
+	__s32 atr_len;
 	unsigned char atr[64];
-	int32_t power_act;
+	__s32 power_act;
 	unsigned char bIFSD;
 	unsigned char bIFSC;
 } atreq_t;
@@ -22,13 +24,13 @@ typedef struct atreq {
  * member sizes. This leads to CONFIG_COMPAT breakage, since 32bit userspace
  * will lay out the structure members differently than the 64bit kernel.
  *
- * I've changed "ptsreq.protocol" from "unsigned long" to "u_int32_t".
+ * I've changed "ptsreq.protocol" from "unsigned long" to "__u32".
  * On 32bit this will make no difference.  With 64bit kernels, it will make
  * 32bit apps work, too.
  */
 
 typedef struct ptsreq {
-	u_int32_t protocol; /*T=0: 2^0, T=1:  2^1*/
+	__u32 protocol; /*T=0: 2^0, T=1:  2^1*/
  	unsigned char flags;
  	unsigned char pts1;
  	unsigned char pts2;
Index: linux-2.6/include/linux/dlm_netlink.h
===================================================================
--- linux-2.6.orig/include/linux/dlm_netlink.h
+++ linux-2.6/include/linux/dlm_netlink.h
@@ -9,6 +9,8 @@
 #ifndef _DLM_NETLINK_H
 #define _DLM_NETLINK_H
 
+#include <linux/types.h>
+
 enum {
 	DLM_STATUS_WAITING = 1,
 	DLM_STATUS_GRANTED = 2,
@@ -18,16 +20,16 @@ enum {
 #define DLM_LOCK_DATA_VERSION 1
 
 struct dlm_lock_data {
-	uint16_t version;
-	uint32_t lockspace_id;
+	__u16 version;
+	__u32 lockspace_id;
 	int nodeid;
 	int ownpid;
-	uint32_t id;
-	uint32_t remid;
-	uint64_t xid;
-	int8_t status;
-	int8_t grmode;
-	int8_t rqmode;
+	__u32 id;
+	__u32 remid;
+	__u64 xid;
+	__s8 status;
+	__s8 grmode;
+	__s8 rqmode;
 	unsigned long timestamp;
 	int resource_namelen;
 	char resource_name[DLM_RESNAME_MAXLEN];
Index: linux-2.6/include/linux/dm-ioctl.h
===================================================================
--- linux-2.6.orig/include/linux/dm-ioctl.h
+++ linux-2.6/include/linux/dm-ioctl.h
@@ -113,20 +113,20 @@ struct dm_ioctl {
 	 * return -ENOTTY) fill out this field, even if the
 	 * command failed.
 	 */
-	uint32_t version[3];	/* in/out */
-	uint32_t data_size;	/* total size of data passed in
+	__u32 version[3];	/* in/out */
+	__u32 data_size;	/* total size of data passed in
 				 * including this struct */
 
-	uint32_t data_start;	/* offset to start of data
+	__u32 data_start;	/* offset to start of data
 				 * relative to start of this struct */
 
-	uint32_t target_count;	/* in/out */
-	int32_t open_count;	/* out */
-	uint32_t flags;		/* in/out */
-	uint32_t event_nr;      	/* in/out */
-	uint32_t padding;
+	__u32 target_count;	/* in/out */
+	__s32 open_count;	/* out */
+	__u32 flags;		/* in/out */
+	__u32 event_nr;      	/* in/out */
+	__u32 padding;
 
-	uint64_t dev;		/* in/out */
+	__u64 dev;		/* in/out */
 
 	char name[DM_NAME_LEN];	/* device name */
 	char uuid[DM_UUID_LEN];	/* unique identifier for
@@ -139,9 +139,9 @@ struct dm_ioctl {
  * dm_ioctl.
  */
 struct dm_target_spec {
-	uint64_t sector_start;
-	uint64_t length;
-	int32_t status;		/* used when reading from kernel only */
+	__u64 sector_start;
+	__u64 length;
+	__s32 status;		/* used when reading from kernel only */
 
 	/*
 	 * Location of the next dm_target_spec.
@@ -153,7 +153,7 @@ struct dm_target_spec {
 	 *   (that follows the dm_ioctl struct) to the start of the "next"
 	 *   dm_target_spec.
 	 */
-	uint32_t next;
+	__u32 next;
 
 	char target_type[DM_MAX_TYPE_NAME];
 
@@ -168,17 +168,17 @@ struct dm_target_spec {
  * Used to retrieve the target dependencies.
  */
 struct dm_target_deps {
-	uint32_t count;	/* Array size */
-	uint32_t padding;	/* unused */
-	uint64_t dev[0];	/* out */
+	__u32 count;	/* Array size */
+	__u32 padding;	/* unused */
+	__u64 dev[0];	/* out */
 };
 
 /*
  * Used to get a list of all dm devices.
  */
 struct dm_name_list {
-	uint64_t dev;
-	uint32_t next;		/* offset to the next record from
+	__u64 dev;
+	__u32 next;		/* offset to the next record from
 				   the _start_ of this */
 	char name[0];
 };
@@ -187,8 +187,8 @@ struct dm_name_list {
  * Used to retrieve the target versions
  */
 struct dm_target_versions {
-        uint32_t next;
-        uint32_t version[3];
+        __u32 next;
+        __u32 version[3];
 
         char name[0];
 };
@@ -197,7 +197,7 @@ struct dm_target_versions {
  * Used to pass message to a target
  */
 struct dm_target_msg {
-	uint64_t sector;	/* Device sector */
+	__u64 sector;	/* Device sector */
 
 	char message[0];
 };
Index: linux-2.6/include/linux/dvb/audio.h
===================================================================
--- linux-2.6.orig/include/linux/dvb/audio.h
+++ linux-2.6/include/linux/dvb/audio.h
@@ -76,7 +76,7 @@ struct audio_karaoke{  /* if Vocal1 or V
 } audio_karaoke_t;     /* into left and right  */
 
 
-typedef uint16_t audio_attributes_t;
+typedef __u16 audio_attributes_t;
 /*   bits: descr. */
 /*   15-13 audio coding mode (0=ac3, 2=mpeg1, 3=mpeg2ext, 4=LPCM, 6=DTS, */
 /*   12    multichannel extension */
Index: linux-2.6/include/linux/dvb/video.h
===================================================================
--- linux-2.6.orig/include/linux/dvb/video.h
+++ linux-2.6/include/linux/dvb/video.h
@@ -132,7 +132,7 @@ struct video_command {
 #define VIDEO_VSYNC_FIELD_PROGRESSIVE	(3)
 
 struct video_event {
-	int32_t type;
+	__s32 type;
 #define VIDEO_EVENT_SIZE_CHANGED	1
 #define VIDEO_EVENT_FRAME_RATE_CHANGED	2
 #define VIDEO_EVENT_DECODER_STOPPED 	3
@@ -157,25 +157,25 @@ struct video_status {
 
 struct video_still_picture {
 	char __user *iFrame;        /* pointer to a single iframe in memory */
-	int32_t size;
+	__s32 size;
 };
 
 
 typedef
 struct video_highlight {
 	int     active;      /*    1=show highlight, 0=hide highlight */
-	uint8_t contrast1;   /*    7- 4  Pattern pixel contrast */
+	__u8    contrast1;   /*    7- 4  Pattern pixel contrast */
 			     /*    3- 0  Background pixel contrast */
-	uint8_t contrast2;   /*    7- 4  Emphasis pixel-2 contrast */
+	__u8    contrast2;   /*    7- 4  Emphasis pixel-2 contrast */
 			     /*    3- 0  Emphasis pixel-1 contrast */
-	uint8_t color1;      /*    7- 4  Pattern pixel color */
+	__u8    color1;      /*    7- 4  Pattern pixel color */
 			     /*    3- 0  Background pixel color */
-	uint8_t color2;      /*    7- 4  Emphasis pixel-2 color */
+	__u8    color2;      /*    7- 4  Emphasis pixel-2 color */
 			     /*    3- 0  Emphasis pixel-1 color */
-	uint32_t ypos;       /*   23-22  auto action mode */
+	__u32    ypos;       /*   23-22  auto action mode */
 			     /*   21-12  start y */
 			     /*    9- 0  end y */
-	uint32_t xpos;       /*   23-22  button color number */
+	__u32    xpos;       /*   23-22  button color number */
 			     /*   21-12  start x */
 			     /*    9- 0  end x */
 } video_highlight_t;
@@ -189,17 +189,17 @@ typedef struct video_spu {
 
 typedef struct video_spu_palette {      /* SPU Palette information */
 	int length;
-	uint8_t __user *palette;
+	__u8 __user *palette;
 } video_spu_palette_t;
 
 
 typedef struct video_navi_pack {
 	int length;          /* 0 ... 1024 */
-	uint8_t data[1024];
+	__u8 data[1024];
 } video_navi_pack_t;
 
 
-typedef uint16_t video_attributes_t;
+typedef __u16 video_attributes_t;
 /*   bits: descr. */
 /*   15-14 Video compression mode (0=MPEG-1, 1=MPEG-2) */
 /*   13-12 TV system (0=525/60, 1=625/50) */
Index: linux-2.6/include/linux/if_arcnet.h
===================================================================
--- linux-2.6.orig/include/linux/if_arcnet.h
+++ linux-2.6/include/linux/if_arcnet.h
@@ -16,6 +16,7 @@
 #ifndef _LINUX_IF_ARCNET_H
 #define _LINUX_IF_ARCNET_H
 
+#include <linux/types.h>
 #include <linux/if_ether.h>
 
 
@@ -57,10 +58,10 @@
  */
 struct arc_rfc1201
 {
-    uint8_t  proto;		/* protocol ID field - varies		*/
-    uint8_t  split_flag;	/* for use with split packets		*/
+    __u8  proto;		/* protocol ID field - varies		*/
+    __u8  split_flag;	/* for use with split packets		*/
     __be16   sequence;		/* sequence number			*/
-    uint8_t  payload[0];	/* space remaining in packet (504 bytes)*/
+    __u8  payload[0];	/* space remaining in packet (504 bytes)*/
 };
 #define RFC1201_HDR_SIZE 4
 
@@ -70,8 +71,8 @@ struct arc_rfc1201
  */
 struct arc_rfc1051
 {
-    uint8_t proto;		/* ARC_P_RFC1051_ARP/RFC1051_IP	*/
-    uint8_t payload[0];		/* 507 bytes			*/
+    __u8 proto;		/* ARC_P_RFC1051_ARP/RFC1051_IP	*/
+    __u8 payload[0];		/* 507 bytes			*/
 };
 #define RFC1051_HDR_SIZE 1
 
@@ -82,20 +83,20 @@ struct arc_rfc1051
  */
 struct arc_eth_encap
 {
-    uint8_t proto;		/* Always ARC_P_ETHER			*/
+    __u8 proto;		/* Always ARC_P_ETHER			*/
     struct ethhdr eth;		/* standard ethernet header (yuck!)	*/
-    uint8_t payload[0];		/* 493 bytes				*/
+    __u8 payload[0];		/* 493 bytes				*/
 };
 #define ETH_ENCAP_HDR_SIZE 14
 
 
 struct arc_cap
 {
-	uint8_t proto;
-	uint8_t cookie[sizeof(int)];   /* Actually NOT sent over the network */
+	__u8 proto;
+	__u8 cookie[sizeof(int)];   /* Actually NOT sent over the network */
 	union {
-		uint8_t ack;
-		uint8_t raw[0];		/* 507 bytes */
+		__u8 ack;
+		__u8 raw[0];		/* 507 bytes */
 	} mes;
 };
 
@@ -109,7 +110,7 @@ struct arc_cap
  */
 struct arc_hardware
 {
-    uint8_t  source,		/* source ARCnet - filled in automagically */
+    __u8  source,		/* source ARCnet - filled in automagically */
              dest,		/* destination ARCnet - 0 for broadcast    */
     	     offset[2];		/* offset bytes (some weird semantics)     */
 };
@@ -130,7 +131,7 @@ struct archdr
 	struct arc_rfc1051   rfc1051;
 	struct arc_eth_encap eth_encap;
 	struct arc_cap       cap;
-	uint8_t raw[0];		/* 508 bytes				*/
+	__u8 raw[0];		/* 508 bytes				*/
     } soft;
 };
 
Index: linux-2.6/include/linux/ip_vs.h
===================================================================
--- linux-2.6.orig/include/linux/ip_vs.h
+++ linux-2.6/include/linux/ip_vs.h
@@ -96,10 +96,10 @@
  */
 struct ip_vs_service_user {
 	/* virtual service addresses */
-	u_int16_t		protocol;
+	__u16		protocol;
 	__be32			addr;		/* virtual ip address */
 	__be16			port;
-	u_int32_t		fwmark;		/* firwall mark of service */
+	__u32		fwmark;		/* firwall mark of service */
 
 	/* virtual service options */
 	char			sched_name[IP_VS_SCHEDNAME_MAXLEN];
@@ -119,8 +119,8 @@ struct ip_vs_dest_user {
 	int			weight;		/* destination weight */
 
 	/* thresholds for active connections */
-	u_int32_t		u_threshold;	/* upper threshold */
-	u_int32_t		l_threshold;	/* lower threshold */
+	__u32		u_threshold;	/* upper threshold */
+	__u32		l_threshold;	/* lower threshold */
 };
 
 
@@ -159,10 +159,10 @@ struct ip_vs_getinfo {
 /* The argument to IP_VS_SO_GET_SERVICE */
 struct ip_vs_service_entry {
 	/* which service: user fills in these */
-	u_int16_t		protocol;
+	__u16		protocol;
 	__be32			addr;		/* virtual address */
 	__be16			port;
-	u_int32_t		fwmark;		/* firwall mark of service */
+	__u32		fwmark;		/* firwall mark of service */
 
 	/* service options */
 	char			sched_name[IP_VS_SCHEDNAME_MAXLEN];
@@ -184,12 +184,12 @@ struct ip_vs_dest_entry {
 	unsigned		conn_flags;	/* connection flags */
 	int			weight;		/* destination weight */
 
-	u_int32_t		u_threshold;	/* upper threshold */
-	u_int32_t		l_threshold;	/* lower threshold */
+	__u32		u_threshold;	/* upper threshold */
+	__u32		l_threshold;	/* lower threshold */
 
-	u_int32_t		activeconns;	/* active connections */
-	u_int32_t		inactconns;	/* inactive connections */
-	u_int32_t		persistconns;	/* persistent connections */
+	__u32		activeconns;	/* active connections */
+	__u32		inactconns;	/* inactive connections */
+	__u32		persistconns;	/* persistent connections */
 
 	/* statistics */
 	struct ip_vs_stats_user stats;
@@ -199,10 +199,10 @@ struct ip_vs_dest_entry {
 /* The argument to IP_VS_SO_GET_DESTS */
 struct ip_vs_get_dests {
 	/* which service: user fills in these */
-	u_int16_t		protocol;
+	__u16		protocol;
 	__be32			addr;		/* virtual address */
 	__be16			port;
-	u_int32_t		fwmark;		/* firwall mark of service */
+	__u32		fwmark;		/* firwall mark of service */
 
 	/* number of real servers */
 	unsigned int		num_dests;
Index: linux-2.6/include/linux/ivtvfb.h
===================================================================
--- linux-2.6.orig/include/linux/ivtvfb.h
+++ linux-2.6/include/linux/ivtvfb.h
@@ -33,6 +33,6 @@ struct ivtvfb_dma_frame {
 };
 
 #define IVTVFB_IOC_DMA_FRAME 	_IOW('V', BASE_VIDIOC_PRIVATE+0, struct ivtvfb_dma_frame)
-#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, u_int32_t)
+#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
 
 #endif
Index: linux-2.6/include/linux/matroxfb.h
===================================================================
--- linux-2.6.orig/include/linux/matroxfb.h
+++ linux-2.6/include/linux/matroxfb.h
@@ -37,7 +37,7 @@ enum matroxfb_ctrl_id {
   MATROXFB_CID_LAST
 };
 
-#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, u_int32_t)
+#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
 
 #endif
 
Index: linux-2.6/include/linux/pfkeyv2.h
===================================================================
--- linux-2.6.orig/include/linux/pfkeyv2.h
+++ linux-2.6/include/linux/pfkeyv2.h
@@ -12,187 +12,187 @@
 #define PFKEYV2_REVISION	199806L
 
 struct sadb_msg {
-	uint8_t		sadb_msg_version;
-	uint8_t		sadb_msg_type;
-	uint8_t		sadb_msg_errno;
-	uint8_t		sadb_msg_satype;
-	uint16_t	sadb_msg_len;
-	uint16_t	sadb_msg_reserved;
-	uint32_t	sadb_msg_seq;
-	uint32_t	sadb_msg_pid;
+	__u8		sadb_msg_version;
+	__u8		sadb_msg_type;
+	__u8		sadb_msg_errno;
+	__u8		sadb_msg_satype;
+	__u16	sadb_msg_len;
+	__u16	sadb_msg_reserved;
+	__u32	sadb_msg_seq;
+	__u32	sadb_msg_pid;
 } __attribute__((packed));
 /* sizeof(struct sadb_msg) == 16 */
 
 struct sadb_ext {
-	uint16_t	sadb_ext_len;
-	uint16_t	sadb_ext_type;
+	__u16	sadb_ext_len;
+	__u16	sadb_ext_type;
 } __attribute__((packed));
 /* sizeof(struct sadb_ext) == 4 */
 
 struct sadb_sa {
-	uint16_t	sadb_sa_len;
-	uint16_t	sadb_sa_exttype;
+	__u16	sadb_sa_len;
+	__u16	sadb_sa_exttype;
 	__be32		sadb_sa_spi;
-	uint8_t		sadb_sa_replay;
-	uint8_t		sadb_sa_state;
-	uint8_t		sadb_sa_auth;
-	uint8_t		sadb_sa_encrypt;
-	uint32_t	sadb_sa_flags;
+	__u8		sadb_sa_replay;
+	__u8		sadb_sa_state;
+	__u8		sadb_sa_auth;
+	__u8		sadb_sa_encrypt;
+	__u32	sadb_sa_flags;
 } __attribute__((packed));
 /* sizeof(struct sadb_sa) == 16 */
 
 struct sadb_lifetime {
-	uint16_t	sadb_lifetime_len;
-	uint16_t	sadb_lifetime_exttype;
-	uint32_t	sadb_lifetime_allocations;
-	uint64_t	sadb_lifetime_bytes;
-	uint64_t	sadb_lifetime_addtime;
-	uint64_t	sadb_lifetime_usetime;
+	__u16	sadb_lifetime_len;
+	__u16	sadb_lifetime_exttype;
+	__u32	sadb_lifetime_allocations;
+	__u64	sadb_lifetime_bytes;
+	__u64	sadb_lifetime_addtime;
+	__u64	sadb_lifetime_usetime;
 } __attribute__((packed));
 /* sizeof(struct sadb_lifetime) == 32 */
 
 struct sadb_address {
-	uint16_t	sadb_address_len;
-	uint16_t	sadb_address_exttype;
-	uint8_t		sadb_address_proto;
-	uint8_t		sadb_address_prefixlen;
-	uint16_t	sadb_address_reserved;
+	__u16	sadb_address_len;
+	__u16	sadb_address_exttype;
+	__u8		sadb_address_proto;
+	__u8		sadb_address_prefixlen;
+	__u16	sadb_address_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_address) == 8 */
 
 struct sadb_key {
-	uint16_t	sadb_key_len;
-	uint16_t	sadb_key_exttype;
-	uint16_t	sadb_key_bits;
-	uint16_t	sadb_key_reserved;
+	__u16	sadb_key_len;
+	__u16	sadb_key_exttype;
+	__u16	sadb_key_bits;
+	__u16	sadb_key_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_key) == 8 */
 
 struct sadb_ident {
-	uint16_t	sadb_ident_len;
-	uint16_t	sadb_ident_exttype;
-	uint16_t	sadb_ident_type;
-	uint16_t	sadb_ident_reserved;
-	uint64_t	sadb_ident_id;
+	__u16	sadb_ident_len;
+	__u16	sadb_ident_exttype;
+	__u16	sadb_ident_type;
+	__u16	sadb_ident_reserved;
+	__u64	sadb_ident_id;
 } __attribute__((packed));
 /* sizeof(struct sadb_ident) == 16 */
 
 struct sadb_sens {
-	uint16_t	sadb_sens_len;
-	uint16_t	sadb_sens_exttype;
-	uint32_t	sadb_sens_dpd;
-	uint8_t		sadb_sens_sens_level;
-	uint8_t		sadb_sens_sens_len;
-	uint8_t		sadb_sens_integ_level;
-	uint8_t		sadb_sens_integ_len;
-	uint32_t	sadb_sens_reserved;
+	__u16	sadb_sens_len;
+	__u16	sadb_sens_exttype;
+	__u32	sadb_sens_dpd;
+	__u8		sadb_sens_sens_level;
+	__u8		sadb_sens_sens_len;
+	__u8		sadb_sens_integ_level;
+	__u8		sadb_sens_integ_len;
+	__u32	sadb_sens_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_sens) == 16 */
 
 /* followed by:
-	uint64_t	sadb_sens_bitmap[sens_len];
-	uint64_t	sadb_integ_bitmap[integ_len];  */
+	__u64	sadb_sens_bitmap[sens_len];
+	__u64	sadb_integ_bitmap[integ_len];  */
 
 struct sadb_prop {
-	uint16_t	sadb_prop_len;
-	uint16_t	sadb_prop_exttype;
-	uint8_t		sadb_prop_replay;
-	uint8_t		sadb_prop_reserved[3];
+	__u16	sadb_prop_len;
+	__u16	sadb_prop_exttype;
+	__u8		sadb_prop_replay;
+	__u8		sadb_prop_reserved[3];
 } __attribute__((packed));
 /* sizeof(struct sadb_prop) == 8 */
 
 /* followed by:
 	struct sadb_comb sadb_combs[(sadb_prop_len +
-		sizeof(uint64_t) - sizeof(struct sadb_prop)) /
+		sizeof(__u64) - sizeof(struct sadb_prop)) /
 		sizeof(struct sadb_comb)]; */
 
 struct sadb_comb {
-	uint8_t		sadb_comb_auth;
-	uint8_t		sadb_comb_encrypt;
-	uint16_t	sadb_comb_flags;
-	uint16_t	sadb_comb_auth_minbits;
-	uint16_t	sadb_comb_auth_maxbits;
-	uint16_t	sadb_comb_encrypt_minbits;
-	uint16_t	sadb_comb_encrypt_maxbits;
-	uint32_t	sadb_comb_reserved;
-	uint32_t	sadb_comb_soft_allocations;
-	uint32_t	sadb_comb_hard_allocations;
-	uint64_t	sadb_comb_soft_bytes;
-	uint64_t	sadb_comb_hard_bytes;
-	uint64_t	sadb_comb_soft_addtime;
-	uint64_t	sadb_comb_hard_addtime;
-	uint64_t	sadb_comb_soft_usetime;
-	uint64_t	sadb_comb_hard_usetime;
+	__u8		sadb_comb_auth;
+	__u8		sadb_comb_encrypt;
+	__u16	sadb_comb_flags;
+	__u16	sadb_comb_auth_minbits;
+	__u16	sadb_comb_auth_maxbits;
+	__u16	sadb_comb_encrypt_minbits;
+	__u16	sadb_comb_encrypt_maxbits;
+	__u32	sadb_comb_reserved;
+	__u32	sadb_comb_soft_allocations;
+	__u32	sadb_comb_hard_allocations;
+	__u64	sadb_comb_soft_bytes;
+	__u64	sadb_comb_hard_bytes;
+	__u64	sadb_comb_soft_addtime;
+	__u64	sadb_comb_hard_addtime;
+	__u64	sadb_comb_soft_usetime;
+	__u64	sadb_comb_hard_usetime;
 } __attribute__((packed));
 /* sizeof(struct sadb_comb) == 72 */
 
 struct sadb_supported {
-	uint16_t	sadb_supported_len;
-	uint16_t	sadb_supported_exttype;
-	uint32_t	sadb_supported_reserved;
+	__u16	sadb_supported_len;
+	__u16	sadb_supported_exttype;
+	__u32	sadb_supported_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_supported) == 8 */
 
 /* followed by:
 	struct sadb_alg sadb_algs[(sadb_supported_len +
-		sizeof(uint64_t) - sizeof(struct sadb_supported)) /
+		sizeof(__u64) - sizeof(struct sadb_supported)) /
 		sizeof(struct sadb_alg)]; */
 
 struct sadb_alg {
-	uint8_t		sadb_alg_id;
-	uint8_t		sadb_alg_ivlen;
-	uint16_t	sadb_alg_minbits;
-	uint16_t	sadb_alg_maxbits;
-	uint16_t	sadb_alg_reserved;
+	__u8		sadb_alg_id;
+	__u8		sadb_alg_ivlen;
+	__u16	sadb_alg_minbits;
+	__u16	sadb_alg_maxbits;
+	__u16	sadb_alg_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_alg) == 8 */
 
 struct sadb_spirange {
-	uint16_t	sadb_spirange_len;
-	uint16_t	sadb_spirange_exttype;
-	uint32_t	sadb_spirange_min;
-	uint32_t	sadb_spirange_max;
-	uint32_t	sadb_spirange_reserved;
+	__u16	sadb_spirange_len;
+	__u16	sadb_spirange_exttype;
+	__u32	sadb_spirange_min;
+	__u32	sadb_spirange_max;
+	__u32	sadb_spirange_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_spirange) == 16 */
 
 struct sadb_x_kmprivate {
-	uint16_t	sadb_x_kmprivate_len;
-	uint16_t	sadb_x_kmprivate_exttype;
-	uint32_t	sadb_x_kmprivate_reserved;
+	__u16	sadb_x_kmprivate_len;
+	__u16	sadb_x_kmprivate_exttype;
+	__u32	sadb_x_kmprivate_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_x_kmprivate) == 8 */
 
 struct sadb_x_sa2 {
-	uint16_t	sadb_x_sa2_len;
-	uint16_t	sadb_x_sa2_exttype;
-	uint8_t		sadb_x_sa2_mode;
-	uint8_t		sadb_x_sa2_reserved1;
-	uint16_t	sadb_x_sa2_reserved2;
-	uint32_t	sadb_x_sa2_sequence;
-	uint32_t	sadb_x_sa2_reqid;
+	__u16	sadb_x_sa2_len;
+	__u16	sadb_x_sa2_exttype;
+	__u8		sadb_x_sa2_mode;
+	__u8		sadb_x_sa2_reserved1;
+	__u16	sadb_x_sa2_reserved2;
+	__u32	sadb_x_sa2_sequence;
+	__u32	sadb_x_sa2_reqid;
 } __attribute__((packed));
 /* sizeof(struct sadb_x_sa2) == 16 */
 
 struct sadb_x_policy {
-	uint16_t	sadb_x_policy_len;
-	uint16_t	sadb_x_policy_exttype;
-	uint16_t	sadb_x_policy_type;
-	uint8_t		sadb_x_policy_dir;
-	uint8_t		sadb_x_policy_reserved;
-	uint32_t	sadb_x_policy_id;
-	uint32_t	sadb_x_policy_priority;
+	__u16	sadb_x_policy_len;
+	__u16	sadb_x_policy_exttype;
+	__u16	sadb_x_policy_type;
+	__u8		sadb_x_policy_dir;
+	__u8		sadb_x_policy_reserved;
+	__u32	sadb_x_policy_id;
+	__u32	sadb_x_policy_priority;
 } __attribute__((packed));
 /* sizeof(struct sadb_x_policy) == 16 */
 
 struct sadb_x_ipsecrequest {
-	uint16_t	sadb_x_ipsecrequest_len;
-	uint16_t	sadb_x_ipsecrequest_proto;
-	uint8_t		sadb_x_ipsecrequest_mode;
-	uint8_t		sadb_x_ipsecrequest_level;
-	uint16_t	sadb_x_ipsecrequest_reserved1;
-	uint32_t	sadb_x_ipsecrequest_reqid;
-	uint32_t	sadb_x_ipsecrequest_reserved2;
+	__u16	sadb_x_ipsecrequest_len;
+	__u16	sadb_x_ipsecrequest_proto;
+	__u8		sadb_x_ipsecrequest_mode;
+	__u8		sadb_x_ipsecrequest_level;
+	__u16	sadb_x_ipsecrequest_reserved1;
+	__u32	sadb_x_ipsecrequest_reqid;
+	__u32	sadb_x_ipsecrequest_reserved2;
 } __attribute__((packed));
 /* sizeof(struct sadb_x_ipsecrequest) == 16 */
 
@@ -200,38 +200,38 @@ struct sadb_x_ipsecrequest {
  * type of NAT-T is supported, draft-ietf-ipsec-udp-encaps-06
  */
 struct sadb_x_nat_t_type {
-	uint16_t	sadb_x_nat_t_type_len;
-	uint16_t	sadb_x_nat_t_type_exttype;
-	uint8_t		sadb_x_nat_t_type_type;
-	uint8_t		sadb_x_nat_t_type_reserved[3];
+	__u16	sadb_x_nat_t_type_len;
+	__u16	sadb_x_nat_t_type_exttype;
+	__u8		sadb_x_nat_t_type_type;
+	__u8		sadb_x_nat_t_type_reserved[3];
 } __attribute__((packed));
 /* sizeof(struct sadb_x_nat_t_type) == 8 */
 
 /* Pass a NAT Traversal port (Source or Dest port) */
 struct sadb_x_nat_t_port {
-	uint16_t	sadb_x_nat_t_port_len;
-	uint16_t	sadb_x_nat_t_port_exttype;
+	__u16	sadb_x_nat_t_port_len;
+	__u16	sadb_x_nat_t_port_exttype;
 	__be16		sadb_x_nat_t_port_port;
-	uint16_t	sadb_x_nat_t_port_reserved;
+	__u16	sadb_x_nat_t_port_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_x_nat_t_port) == 8 */
 
 /* Generic LSM security context */
 struct sadb_x_sec_ctx {
-	uint16_t	sadb_x_sec_len;
-	uint16_t	sadb_x_sec_exttype;
-	uint8_t		sadb_x_ctx_alg;  /* LSMs: e.g., selinux == 1 */
-	uint8_t		sadb_x_ctx_doi;
-	uint16_t	sadb_x_ctx_len;
+	__u16	sadb_x_sec_len;
+	__u16	sadb_x_sec_exttype;
+	__u8		sadb_x_ctx_alg;  /* LSMs: e.g., selinux == 1 */
+	__u8		sadb_x_ctx_doi;
+	__u16	sadb_x_ctx_len;
 } __attribute__((packed));
 /* sizeof(struct sadb_sec_ctx) = 8 */
 
 /* Used by MIGRATE to pass addresses IKE will use to perform
  * negotiation with the peer */
 struct sadb_x_kmaddress {
-	uint16_t	sadb_x_kmaddress_len;
-	uint16_t	sadb_x_kmaddress_exttype;
-	uint32_t	sadb_x_kmaddress_reserved;
+	__u16	sadb_x_kmaddress_len;
+	__u16	sadb_x_kmaddress_exttype;
+	__u32	sadb_x_kmaddress_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_x_kmaddress) == 8 */
 
Index: linux-2.6/include/linux/pkt_sched.h
===================================================================
--- linux-2.6.orig/include/linux/pkt_sched.h
+++ linux-2.6/include/linux/pkt_sched.h
@@ -515,7 +515,7 @@ enum
 
 struct tc_drr_stats
 {
-	__u32	deficit;
+	u32	deficit;
 };
 
 #endif
Index: linux-2.6/include/linux/selinux_netlink.h
===================================================================
--- linux-2.6.orig/include/linux/selinux_netlink.h
+++ linux-2.6/include/linux/selinux_netlink.h
@@ -12,6 +12,8 @@
 #ifndef _LINUX_SELINUX_NETLINK_H
 #define _LINUX_SELINUX_NETLINK_H
 
+#include <linux/types.h>
+
 /* Message types. */
 #define SELNL_MSG_BASE 0x10
 enum {
@@ -38,11 +40,11 @@ enum selinux_nlgroups {
 
 /* Message structures */
 struct selnl_msg_setenforce {
-	int32_t		val;
+	__s32		val;
 };
 
 struct selnl_msg_policyload {
-	u_int32_t	seqno;
+	__u32	seqno;
 };
 
 #endif /* _LINUX_SELINUX_NETLINK_H */
Index: linux-2.6/include/sound/asound.h
===================================================================
--- linux-2.6.orig/include/sound/asound.h
+++ linux-2.6/include/sound/asound.h
@@ -23,9 +23,10 @@
 #ifndef __SOUND_ASOUND_H
 #define __SOUND_ASOUND_H
 
+#include <linux/types.h>
+
 #ifdef __KERNEL__
 #include <linux/ioctl.h>
-#include <linux/types.h>
 #include <linux/time.h>
 #include <asm/byteorder.h>
 
@@ -342,7 +343,7 @@ struct snd_interval {
 #define SNDRV_MASK_MAX	256
 
 struct snd_mask {
-	u_int32_t bits[(SNDRV_MASK_MAX+31)/32];
+	__u32 bits[(SNDRV_MASK_MAX+31)/32];
 };
 
 struct snd_pcm_hw_params {
Index: linux-2.6/include/sound/emu10k1.h
===================================================================
--- linux-2.6.orig/include/sound/emu10k1.h
+++ linux-2.6/include/sound/emu10k1.h
@@ -1,6 +1,8 @@
 #ifndef __SOUND_EMU10K1_H
 #define __SOUND_EMU10K1_H
 
+#include <linux/types.h>
+
 /*
  *  Copyright (c) by Jaroslav Kysela <perex@perex.cz>,
  *		     Creative Labs, Inc.
@@ -34,6 +36,8 @@
 #include <sound/timer.h>
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
+#include <linux/types.h>
+
 #include <asm/io.h>
 
 /* ------------------- DEFINES -------------------- */
@@ -2171,7 +2175,7 @@ struct snd_emu10k1_fx8010_code {
 	char name[128];
 
 	DECLARE_BITMAP(gpr_valid, 0x200); /* bitmask of valid initializers */
-	u_int32_t __user *gpr_map;	  /* initializers */
+	__u32 __user *gpr_map;		/* initializers */
 
 	unsigned int gpr_add_control_count; /* count of GPR controls to add/replace */
 	struct snd_emu10k1_fx8010_control_gpr __user *gpr_add_controls; /* GPR controls to add/replace */
@@ -2184,11 +2188,11 @@ struct snd_emu10k1_fx8010_code {
 	struct snd_emu10k1_fx8010_control_gpr __user *gpr_list_controls; /* listed GPR controls */
 
 	DECLARE_BITMAP(tram_valid, 0x100); /* bitmask of valid initializers */
-	u_int32_t __user *tram_data_map;  /* data initializers */
-	u_int32_t __user *tram_addr_map;  /* map initializers */
+	__u32 __user *tram_data_map;	  /* data initializers */
+	__u32 __user *tram_addr_map;	  /* map initializers */
 
 	DECLARE_BITMAP(code_valid, 1024); /* bitmask of valid instructions */
-	u_int32_t __user *code;		  /* one instruction - 64 bits */
+	__u32 __user *code;		  /* one instruction - 64 bits */
 };
 
 struct snd_emu10k1_fx8010_tram {

-- 

