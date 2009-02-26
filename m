Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZBZAdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZBZAdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZBZAcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:32:55 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:43967 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZBZAcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:32:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bFpE8pkPltNGXru2/8MOWbaXbIHQf37Dq0mC2PXGFBpiaxTqgGsi0XLuPRuxYznFlm
         qG/b18IwfhxB5HnpvWqd88mNJWrEcVSqAf/BwW2qtTN3Kj722BbPcj/W4/d4ADQKocEZ
         j4q5falv12rDrnVfLRbEWNFjcDnFWfpw2genI=
MIME-Version: 1.0
In-Reply-To: <20090225235515.357247809@arndb.de>
References: <20090225235138.062045835@arndb.de>
	 <20090225235515.357247809@arndb.de>
Date: Wed, 25 Feb 2009 21:32:50 -0300
Message-ID: <82ecf08e0902251632k550156e5k471fc2cab5e9a0fd@mail.gmail.com>
Subject: Re: [patch 3/7] make MTD headers use strict integer types
From: Thiago Galesi <thiagogalesi@gmail.com>
To: arnd@arndb.de
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Kyle McMartin <kyle@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know if the idea is to do all at once, but MTD has a lot of
things like u_char as well

-- 
-
Thiago Galesi


On Wed, Feb 25, 2009 at 8:51 PM,  <arnd@arndb.de> wrote:
> The MTD headers traditionally use stdint types rather than
> the kernel integer types. This converts them to do the
> same as all the others.
>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  include/linux/jffs2.h    |   26 ++++++++--------
>  include/mtd/inftl-user.h |   36 ++++++++++++------------
>  include/mtd/jffs2-user.h |    4 +-
>  include/mtd/mtd-abi.h    |   64 +++++++++++++++++++++---------------------
>  include/mtd/nftl-user.h  |   30 ++++++++++----------
>  include/mtd/ubi-user.h   |   70 +++++++++++++++++++++++-----------------------
>  6 files changed, 115 insertions(+), 115 deletions(-)
>
> Index: linux-2.6/include/linux/jffs2.h
> ===================================================================
> --- linux-2.6.orig/include/linux/jffs2.h
> +++ linux-2.6/include/linux/jffs2.h
> @@ -12,6 +12,7 @@
>  #ifndef __LINUX_JFFS2_H__
>  #define __LINUX_JFFS2_H__
>
> +#include <linux/types.h>
>  #include <linux/magic.h>
>
>  /* You must include something which defines the C99 uintXX_t types.
> @@ -91,15 +92,15 @@
>    byteswapping */
>
>  typedef struct {
> -       uint32_t v32;
> +       __u32 v32;
>  } __attribute__((packed)) jint32_t;
>
>  typedef struct {
> -       uint32_t m;
> +       __u32 m;
>  } __attribute__((packed)) jmode_t;
>
>  typedef struct {
> -       uint16_t v16;
> +       __u16 v16;
>  } __attribute__((packed)) jint16_t;
>
>  struct jffs2_unknown_node
> @@ -121,12 +122,12 @@ struct jffs2_raw_dirent
>        jint32_t version;
>        jint32_t ino; /* == zero for unlink */
>        jint32_t mctime;
> -       uint8_t nsize;
> -       uint8_t type;
> -       uint8_t unused[2];
> +       __u8 nsize;
> +       __u8 type;
> +       __u8 unused[2];
>        jint32_t node_crc;
>        jint32_t name_crc;
> -       uint8_t name[0];
> +       __u8 name[0];
>  };
>
>  /* The JFFS2 raw inode structure: Used for storage on physical media.  */
> @@ -153,12 +154,12 @@ struct jffs2_raw_inode
>        jint32_t offset;     /* Where to begin to write.  */
>        jint32_t csize;      /* (Compressed) data size */
>        jint32_t dsize;      /* Size of the node's data. (after decompression) */
> -       uint8_t compr;       /* Compression algorithm used */
> -       uint8_t usercompr;   /* Compression algorithm requested by the user */
> +       __u8 compr;       /* Compression algorithm used */
> +       __u8 usercompr;   /* Compression algorithm requested by the user */
>        jint16_t flags;      /* See JFFS2_INO_FLAG_* */
>        jint32_t data_crc;   /* CRC for the (compressed) data.  */
>        jint32_t node_crc;   /* CRC for the raw inode (excluding data)  */
> -       uint8_t data[0];
> +       __u8 data[0];
>  };
>
>  struct jffs2_raw_xattr {
> @@ -168,12 +169,12 @@ struct jffs2_raw_xattr {
>        jint32_t hdr_crc;
>        jint32_t xid;           /* XATTR identifier number */
>        jint32_t version;
> -       uint8_t xprefix;
> -       uint8_t name_len;
> +       __u8 xprefix;
> +       __u8 name_len;
>        jint16_t value_len;
>        jint32_t data_crc;
>        jint32_t node_crc;
> -       uint8_t data[0];
> +       __u8 data[0];
>  } __attribute__((packed));
>
>  struct jffs2_raw_xref
> Index: linux-2.6/include/mtd/inftl-user.h
> ===================================================================
> --- linux-2.6.orig/include/mtd/inftl-user.h
> +++ linux-2.6/include/mtd/inftl-user.h
> @@ -16,33 +16,33 @@
>  /* Block Control Information */
>
>  struct inftl_bci {
> -       uint8_t ECCsig[6];
> -       uint8_t Status;
> -       uint8_t Status1;
> +       __u8 ECCsig[6];
> +       __u8 Status;
> +       __u8 Status1;
>  } __attribute__((packed));
>
>  struct inftl_unithead1 {
> -       uint16_t virtualUnitNo;
> -       uint16_t prevUnitNo;
> -       uint8_t ANAC;
> -       uint8_t NACs;
> -       uint8_t parityPerField;
> -       uint8_t discarded;
> +       __u16 virtualUnitNo;
> +       __u16 prevUnitNo;
> +       __u8 ANAC;
> +       __u8 NACs;
> +       __u8 parityPerField;
> +       __u8 discarded;
>  } __attribute__((packed));
>
>  struct inftl_unithead2 {
> -       uint8_t parityPerField;
> -       uint8_t ANAC;
> -       uint16_t prevUnitNo;
> -       uint16_t virtualUnitNo;
> -       uint8_t NACs;
> -       uint8_t discarded;
> +       __u8 parityPerField;
> +       __u8 ANAC;
> +       __u16 prevUnitNo;
> +       __u16 virtualUnitNo;
> +       __u8 NACs;
> +       __u8 discarded;
>  } __attribute__((packed));
>
>  struct inftl_unittail {
> -       uint8_t Reserved[4];
> -       uint16_t EraseMark;
> -       uint16_t EraseMark1;
> +       __u8 Reserved[4];
> +       __u16 EraseMark;
> +       __u16 EraseMark1;
>  } __attribute__((packed));
>
>  union inftl_uci {
> Index: linux-2.6/include/mtd/jffs2-user.h
> ===================================================================
> --- linux-2.6.orig/include/mtd/jffs2-user.h
> +++ linux-2.6/include/mtd/jffs2-user.h
> @@ -7,6 +7,7 @@
>
>  /* This file is blessed for inclusion by userspace */
>  #include <linux/jffs2.h>
> +#include <linux/types.h>
>  #include <endian.h>
>  #include <byteswap.h>
>
> @@ -19,8 +20,8 @@
>
>  extern int target_endian;
>
> -#define t16(x) ({ uint16_t __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_16(__b); })
> -#define t32(x) ({ uint32_t __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_32(__b); })
> +#define t16(x) ({ __u16 __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_16(__b); })
> +#define t32(x) ({ __u32 __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_32(__b); })
>
>  #define cpu_to_je16(x) ((jint16_t){t16(x)})
>  #define cpu_to_je32(x) ((jint32_t){t32(x)})
> Index: linux-2.6/include/mtd/mtd-abi.h
> ===================================================================
> --- linux-2.6.orig/include/mtd/mtd-abi.h
> +++ linux-2.6/include/mtd/mtd-abi.h
> @@ -5,14 +5,16 @@
>  #ifndef __MTD_ABI_H__
>  #define __MTD_ABI_H__
>
> +#include <linux/types.h>
> +
>  struct erase_info_user {
> -       uint32_t start;
> -       uint32_t length;
> +       __u32 start;
> +       __u32 length;
>  };
>
>  struct mtd_oob_buf {
> -       uint32_t start;
> -       uint32_t length;
> +       __u32 start;
> +       __u32 length;
>        unsigned char __user *ptr;
>  };
>
> @@ -48,30 +50,30 @@ struct mtd_oob_buf {
>  #define MTD_OTP_USER           2
>
>  struct mtd_info_user {
> -       uint8_t type;
> -       uint32_t flags;
> -       uint32_t size;   // Total size of the MTD
> -       uint32_t erasesize;
> -       uint32_t writesize;
> -       uint32_t oobsize;   // Amount of OOB data per block (e.g. 16)
> +       __u8 type;
> +       __u32 flags;
> +       __u32 size;      // Total size of the MTD
> +       __u32 erasesize;
> +       __u32 writesize;
> +       __u32 oobsize;   // Amount of OOB data per block (e.g. 16)
>        /* The below two fields are obsolete and broken, do not use them
>         * (TODO: remove at some point) */
> -       uint32_t ecctype;
> -       uint32_t eccsize;
> +       __u32 ecctype;
> +       __u32 eccsize;
>  };
>
>  struct region_info_user {
> -       uint32_t offset;                /* At which this region starts,
> +       __u32 offset;           /* At which this region starts,
>                                         * from the beginning of the MTD */
> -       uint32_t erasesize;             /* For this region */
> -       uint32_t numblocks;             /* Number of blocks in this region */
> -       uint32_t regionindex;
> +       __u32 erasesize;                /* For this region */
> +       __u32 numblocks;                /* Number of blocks in this region */
> +       __u32 regionindex;
>  };
>
>  struct otp_info {
> -       uint32_t start;
> -       uint32_t length;
> -       uint32_t locked;
> +       __u32 start;
> +       __u32 length;
> +       __u32 locked;
>  };
>
>  #define MEMGETINFO             _IOR('M', 1, struct mtd_info_user)
> @@ -99,15 +101,15 @@ struct otp_info {
>  * interfaces
>  */
>  struct nand_oobinfo {
> -       uint32_t useecc;
> -       uint32_t eccbytes;
> -       uint32_t oobfree[8][2];
> -       uint32_t eccpos[32];
> +       __u32 useecc;
> +       __u32 eccbytes;
> +       __u32 oobfree[8][2];
> +       __u32 eccpos[32];
>  };
>
>  struct nand_oobfree {
> -       uint32_t offset;
> -       uint32_t length;
> +       __u32 offset;
> +       __u32 length;
>  };
>
>  #define MTD_MAX_OOBFREE_ENTRIES        8
> @@ -116,9 +118,9 @@ struct nand_oobfree {
>  * diagnosis and to allow creation of raw images
>  */
>  struct nand_ecclayout {
> -       uint32_t eccbytes;
> -       uint32_t eccpos[64];
> -       uint32_t oobavail;
> +       __u32 eccbytes;
> +       __u32 eccpos[64];
> +       __u32 oobavail;
>        struct nand_oobfree oobfree[MTD_MAX_OOBFREE_ENTRIES];
>  };
>
> @@ -131,10 +133,10 @@ struct nand_ecclayout {
>  * @bbtblocks: number of blocks reserved for bad block tables
>  */
>  struct mtd_ecc_stats {
> -       uint32_t corrected;
> -       uint32_t failed;
> -       uint32_t badblocks;
> -       uint32_t bbtblocks;
> +       __u32 corrected;
> +       __u32 failed;
> +       __u32 badblocks;
> +       __u32 bbtblocks;
>  };
>
>  /*
> Index: linux-2.6/include/mtd/nftl-user.h
> ===================================================================
> --- linux-2.6.orig/include/mtd/nftl-user.h
> +++ linux-2.6/include/mtd/nftl-user.h
> @@ -6,33 +6,35 @@
>  #ifndef __MTD_NFTL_USER_H__
>  #define __MTD_NFTL_USER_H__
>
> +#include <linux/types.h>
> +
>  /* Block Control Information */
>
>  struct nftl_bci {
>        unsigned char ECCSig[6];
> -       uint8_t Status;
> -       uint8_t Status1;
> +       __u8 Status;
> +       __u8 Status1;
>  }__attribute__((packed));
>
>  /* Unit Control Information */
>
>  struct nftl_uci0 {
> -       uint16_t VirtUnitNum;
> -       uint16_t ReplUnitNum;
> -       uint16_t SpareVirtUnitNum;
> -       uint16_t SpareReplUnitNum;
> +       __u16 VirtUnitNum;
> +       __u16 ReplUnitNum;
> +       __u16 SpareVirtUnitNum;
> +       __u16 SpareReplUnitNum;
>  } __attribute__((packed));
>
>  struct nftl_uci1 {
> -       uint32_t WearInfo;
> -       uint16_t EraseMark;
> -       uint16_t EraseMark1;
> +       __u32 WearInfo;
> +       __u16 EraseMark;
> +       __u16 EraseMark1;
>  } __attribute__((packed));
>
>  struct nftl_uci2 {
> -        uint16_t FoldMark;
> -        uint16_t FoldMark1;
> -       uint32_t unused;
> +        __u16 FoldMark;
> +        __u16 FoldMark1;
> +       __u32 unused;
>  } __attribute__((packed));
>
>  union nftl_uci {
> @@ -50,9 +52,9 @@ struct nftl_oob {
>
>  struct NFTLMediaHeader {
>        char DataOrgID[6];
> -       uint16_t NumEraseUnits;
> -       uint16_t FirstPhysicalEUN;
> -       uint32_t FormattedSize;
> +       __u16 NumEraseUnits;
> +       __u16 FirstPhysicalEUN;
> +       __u32 FormattedSize;
>        unsigned char UnitSizeFactor;
>  } __attribute__((packed));
>
> Index: linux-2.6/include/mtd/ubi-user.h
> ===================================================================
> --- linux-2.6.orig/include/mtd/ubi-user.h
> +++ linux-2.6/include/mtd/ubi-user.h
> @@ -21,6 +21,8 @@
>  #ifndef __UBI_USER_H__
>  #define __UBI_USER_H__
>
> +#include <linux/types.h>
> +
>  /*
>  * UBI device creation (the same as MTD device attachment)
>  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> @@ -152,7 +154,7 @@
>  /* Create an UBI volume */
>  #define UBI_IOCMKVOL _IOW(UBI_IOC_MAGIC, 0, struct ubi_mkvol_req)
>  /* Remove an UBI volume */
> -#define UBI_IOCRMVOL _IOW(UBI_IOC_MAGIC, 1, int32_t)
> +#define UBI_IOCRMVOL _IOW(UBI_IOC_MAGIC, 1, __s32)
>  /* Re-size an UBI volume */
>  #define UBI_IOCRSVOL _IOW(UBI_IOC_MAGIC, 2, struct ubi_rsvol_req)
>  /* Re-name volumes */
> @@ -165,24 +167,24 @@
>  /* Attach an MTD device */
>  #define UBI_IOCATT _IOW(UBI_CTRL_IOC_MAGIC, 64, struct ubi_attach_req)
>  /* Detach an MTD device */
> -#define UBI_IOCDET _IOW(UBI_CTRL_IOC_MAGIC, 65, int32_t)
> +#define UBI_IOCDET _IOW(UBI_CTRL_IOC_MAGIC, 65, __s32)
>
>  /* ioctl commands of UBI volume character devices */
>
>  #define UBI_VOL_IOC_MAGIC 'O'
>
>  /* Start UBI volume update */
> -#define UBI_IOCVOLUP _IOW(UBI_VOL_IOC_MAGIC, 0, int64_t)
> +#define UBI_IOCVOLUP _IOW(UBI_VOL_IOC_MAGIC, 0, __s64)
>  /* LEB erasure command, used for debugging, disabled by default */
> -#define UBI_IOCEBER _IOW(UBI_VOL_IOC_MAGIC, 1, int32_t)
> +#define UBI_IOCEBER _IOW(UBI_VOL_IOC_MAGIC, 1, __s32)
>  /* Atomic LEB change command */
> -#define UBI_IOCEBCH _IOW(UBI_VOL_IOC_MAGIC, 2, int32_t)
> +#define UBI_IOCEBCH _IOW(UBI_VOL_IOC_MAGIC, 2, __s32)
>  /* Map LEB command */
>  #define UBI_IOCEBMAP _IOW(UBI_VOL_IOC_MAGIC, 3, struct ubi_map_req)
>  /* Unmap LEB command */
> -#define UBI_IOCEBUNMAP _IOW(UBI_VOL_IOC_MAGIC, 4, int32_t)
> +#define UBI_IOCEBUNMAP _IOW(UBI_VOL_IOC_MAGIC, 4, __s32)
>  /* Check if LEB is mapped command */
> -#define UBI_IOCEBISMAP _IOR(UBI_VOL_IOC_MAGIC, 5, int32_t)
> +#define UBI_IOCEBISMAP _IOR(UBI_VOL_IOC_MAGIC, 5, __s32)
>  /* Set an UBI volume property */
>  #define UBI_IOCSETPROP _IOW(UBI_VOL_IOC_MAGIC, 6, struct ubi_set_prop_req)
>
> @@ -260,10 +262,10 @@ enum {
>  * sub-page of the first page and add needed padding.
>  */
>  struct ubi_attach_req {
> -       int32_t ubi_num;
> -       int32_t mtd_num;
> -       int32_t vid_hdr_offset;
> -       int8_t padding[12];
> +       __s32 ubi_num;
> +       __s32 mtd_num;
> +       __s32 vid_hdr_offset;
> +       __s8 padding[12];
>  };
>
>  /**
> @@ -298,13 +300,13 @@ struct ubi_attach_req {
>  * BLOBs, without caring about how to properly align them.
>  */
>  struct ubi_mkvol_req {
> -       int32_t vol_id;
> -       int32_t alignment;
> -       int64_t bytes;
> -       int8_t vol_type;
> -       int8_t padding1;
> -       int16_t name_len;
> -       int8_t padding2[4];
> +       __s32 vol_id;
> +       __s32 alignment;
> +       __s64 bytes;
> +       __s8 vol_type;
> +       __s8 padding1;
> +       __s16 name_len;
> +       __s8 padding2[4];
>        char name[UBI_MAX_VOLUME_NAME + 1];
>  } __attribute__ ((packed));
>
> @@ -320,8 +322,8 @@ struct ubi_mkvol_req {
>  * zero number of bytes).
>  */
>  struct ubi_rsvol_req {
> -       int64_t bytes;
> -       int32_t vol_id;
> +       __s64 bytes;
> +       __s32 vol_id;
>  } __attribute__ ((packed));
>
>  /**
> @@ -356,12 +358,12 @@ struct ubi_rsvol_req {
>  * re-name request.
>  */
>  struct ubi_rnvol_req {
> -       int32_t count;
> -       int8_t padding1[12];
> +       __s32 count;
> +       __s8 padding1[12];
>        struct {
> -               int32_t vol_id;
> -               int16_t name_len;
> -               int8_t  padding2[2];
> +               __s32 vol_id;
> +               __s16 name_len;
> +               __s8  padding2[2];
>                char    name[UBI_MAX_VOLUME_NAME + 1];
>        } ents[UBI_MAX_RNVOL];
>  } __attribute__ ((packed));
> @@ -375,10 +377,10 @@ struct ubi_rnvol_req {
>  * @padding: reserved for future, not used, has to be zeroed
>  */
>  struct ubi_leb_change_req {
> -       int32_t lnum;
> -       int32_t bytes;
> -       int8_t  dtype;
> -       int8_t  padding[7];
> +       __s32 lnum;
> +       __s32 bytes;
> +       __s8  dtype;
> +       __s8  padding[7];
>  } __attribute__ ((packed));
>
>  /**
> @@ -388,9 +390,9 @@ struct ubi_leb_change_req {
>  * @padding: reserved for future, not used, has to be zeroed
>  */
>  struct ubi_map_req {
> -       int32_t lnum;
> -       int8_t  dtype;
> -       int8_t  padding[3];
> +       __s32 lnum;
> +       __s8  dtype;
> +       __s8  padding[3];
>  } __attribute__ ((packed));
>
>
> @@ -402,9 +404,9 @@ struct ubi_map_req {
>  * @value: value to set
>  */
>  struct ubi_set_prop_req {
> -       uint8_t  property;
> -       uint8_t  padding[7];
> -       uint64_t value;
> +       __u8  property;
> +       __u8  padding[7];
> +       __u64 value;
>  }  __attribute__ ((packed));
>
>  #endif /* __UBI_USER_H__ */
>
> --
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
