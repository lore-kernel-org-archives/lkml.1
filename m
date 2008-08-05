Return-Path: <linux-kernel-owner+w=401wt.eu-S1764734AbYHEUVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764734AbYHEUVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764354AbYHEUR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:17:27 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:50089 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764340AbYHEURY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:17:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IQ9YK+2UtLMRSOEjeFivdgzHuWoJqrWvqkGrbBtRz3Jk2853i91um6wkWFNKrswO2K
         b8B393Zt2fNid3LhjqDBAxfSRagcnwc4bI2QbFq7yzNC2gQYsbu1kUl6euoEJtWS1y71
         6DRxcx6jGKZ842qLZ2JoUBmy8YtFwZIGiosfg=
Message-ID: <87f94c370808051310g4186034dnbd711ed3b4db752e@mail.gmail.com>
Date: Tue, 5 Aug 2008 16:10:36 -0400
From: "Greg Freemyer" <greg.freemyer@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: [PATCH] ata: Define new commands from ATA8
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Matt_Domsch@dell.com, "Matthew Wilcox" <willy@linux.intel.com>
In-Reply-To: <1217957207-23116-2-git-send-email-matthew@wil.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217957207-23116-1-git-send-email-matthew@wil.cx>
	 <1217957207-23116-2-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated comment below.

On Tue, Aug 5, 2008 at 1:26 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
>
> Later patches require knowledge of some commands which aren't currently
> defined.  While I'm at it, add all the commands that are in ATA8 and
> reorder the existing commands to be in the same order as ATA8.
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  include/linux/ata.h |   97 ++++++++++++++++++++++++++++++++++----------------
>  1 files changed, 66 insertions(+), 31 deletions(-)
>
> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index 1c622e2..3815431 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -149,58 +149,93 @@ enum {
>        ATA_REG_IRQ             = ATA_REG_NSECT,
>
>        /* ATA device commands */
> -       ATA_CMD_DEV_RESET       = 0x08, /* ATAPI device reset */
> +       ATA_CMD_CFA_ERASE_SECTORS = 0xC0,
> +       ATA_CMD_CFA_REQUEST_EXT_ERROR = 0x03,
> +       ATA_CMD_CFA_TRANSLATE_SECTOR = 0x87,
> +       ATA_CMD_CFA_WRITE_MULTI_WITHOUT_ERASE = 0xCD,
> +       ATA_CMD_CFA_WRITE_SECTORS_WITHOUT_ERASE = 0x38,
> +       ATA_CMD_CHK_MEDIA_CARD_TYPE = 0xD1,
>        ATA_CMD_CHK_POWER       = 0xE5, /* check power mode */
> -       ATA_CMD_STANDBY         = 0xE2, /* place in standby power mode */
> -       ATA_CMD_IDLE            = 0xE3, /* place in idle power mode */
> +       ATA_CMD_CONFIG_STREAM   = 0x51,
> +       ATA_CMD_CONF_OVERLAY    = 0xB1,
> +       ATA_CMD_DEV_RESET       = 0x08, /* ATAPI device reset */
> +       ATA_CMD_DLOAD_MCODE     = 0x92,
>        ATA_CMD_EDD             = 0x90, /* execute device diagnostic */
>        ATA_CMD_FLUSH           = 0xE7,
>        ATA_CMD_FLUSH_EXT       = 0xEA,
>        ATA_CMD_ID_ATA          = 0xEC,
>        ATA_CMD_ID_ATAPI        = 0xA1,
> -       ATA_CMD_READ            = 0xC8,
> -       ATA_CMD_READ_EXT        = 0x25,
> -       ATA_CMD_WRITE           = 0xCA,
> -       ATA_CMD_WRITE_EXT       = 0x35,
> -       ATA_CMD_WRITE_FUA_EXT   = 0x3D,
> +       ATA_CMD_IDLE            = 0xE3, /* place in idle power mode */
> +       ATA_CMD_IDLEIMMEDIATE   = 0xE1,
> +       ATA_CMD_NVCACHE         = 0xB6,
> +       ATA_CMD_NOP             = 0x00,
> +       ATA_CMD_PACKET          = 0xA0,
> +       ATA_CMD_PMP_READ        = 0xE4, /* aka READ BUFFER */
> +       ATA_CMD_READ            = 0xC8, /* aka READ DMA */
> +       ATA_CMD_READ_EXT        = 0x25, /* aka READ DMA EXT */
> +       ATA_CMD_READ_QUEUED     = 0xC7,
> +       ATA_CMD_READ_QUEUED_EXT = 0x26,
>        ATA_CMD_FPDMA_READ      = 0x60,
> -       ATA_CMD_FPDMA_WRITE     = 0x61,
> -       ATA_CMD_PIO_READ        = 0x20,
> -       ATA_CMD_PIO_READ_EXT    = 0x24,
> -       ATA_CMD_PIO_WRITE       = 0x30,
> -       ATA_CMD_PIO_WRITE_EXT   = 0x34,
> +       ATA_CMD_READ_LOG_EXT    = 0x2F,
> +       ATA_CMD_READ_LOG_DMA_EXT= 0x47,
>        ATA_CMD_READ_MULTI      = 0xC4,
>        ATA_CMD_READ_MULTI_EXT  = 0x29,
> -       ATA_CMD_WRITE_MULTI     = 0xC5,
> -       ATA_CMD_WRITE_MULTI_EXT = 0x39,
> -       ATA_CMD_WRITE_MULTI_FUA_EXT = 0xCE,
> -       ATA_CMD_SET_FEATURES    = 0xEF,
> -       ATA_CMD_SET_MULTI       = 0xC6,
> -       ATA_CMD_PACKET          = 0xA0,
> -       ATA_CMD_VERIFY          = 0x40,
> -       ATA_CMD_VERIFY_EXT      = 0x42,
> -       ATA_CMD_STANDBYNOW1     = 0xE0,
> -       ATA_CMD_IDLEIMMEDIATE   = 0xE1,
> -       ATA_CMD_SLEEP           = 0xE6,
> -       ATA_CMD_INIT_DEV_PARAMS = 0x91,
>        ATA_CMD_READ_NATIVE_MAX = 0xF8,
>        ATA_CMD_READ_NATIVE_MAX_EXT = 0x27,
> +       ATA_CMD_PIO_READ        = 0x20, /* aka READ SECTOR(S) */
> +       ATA_CMD_PIO_READ_EXT    = 0x24, /* aka READ SECTOR(S) EXT */
> +       ATA_CMD_READ_STREAM_DMA_EXT = 0x2A,
> +       ATA_CMD_READ_STREAM_EXT = 0x2B,
> +       ATA_CMD_VERIFY          = 0x40, /* aka READ VERIFY SECTOR(S) */
> +       ATA_CMD_VERIFY_EXT      = 0x42, /* aka READ VERIFY SECTOR(S) EXT */
> +       ATA_CMD_SEC_DISABLE_PASSWORD = 0xF6,
> +       ATA_CMD_SEC_ERASE_PREPARE = 0xF3,
> +       ATA_CMD_SEC_ERASE_UNIT  = 0xF4,
> +       ATA_CMD_SEC_FREEZE_LOCK = 0xF5,
> +       ATA_CMD_SEC_SET_PASSWORD = 0xF1,
> +       ATA_CMD_SEC_UNLOCK      = 0xF2,
> +       ATA_CMD_SERVICE         = 0xA2,
> +       ATA_CMD_SET_FEATURES    = 0xEF,
>        ATA_CMD_SET_MAX         = 0xF9,
>        ATA_CMD_SET_MAX_EXT     = 0x37,
> -       ATA_CMD_READ_LOG_EXT    = 0x2f,
> -       ATA_CMD_PMP_READ        = 0xE4,
> -       ATA_CMD_PMP_WRITE       = 0xE8,
> -       ATA_CMD_CONF_OVERLAY    = 0xB1,
> -       ATA_CMD_SEC_FREEZE_LOCK = 0xF5,
> +       ATA_CMD_SET_MULTI       = 0xC6,
> +       ATA_CMD_SLEEP           = 0xE6,
> +       ATA_CMD_SMART           = 0xB0,
> +       ATA_CMD_STANDBY         = 0xE2, /* place in standby power mode */
> +       ATA_CMD_STANDBYNOW1     = 0xE0,
> +       ATA_CMD_TRUSTED_NON_DATA = 0x5B,
> +       ATA_CMD_TRUSTED_RECEIVE = 0x5C,
> +       ATA_CMD_TRUSTED_RECEIVE_DMA = 0x5D,
> +       ATA_CMD_TRUSTED_SEND    = 0x5E,
> +       ATA_CMD_TRUSTED_SEND_DMA = 0x5F,
> +       ATA_CMD_PMP_WRITE       = 0xE8, /* aka WRITE BUFFER */
> +       ATA_CMD_WRITE           = 0xCA, /* aka WRITE DMA */
> +       ATA_CMD_WRITE_EXT       = 0x35, /* aka WRITE DMA EXT */
> +       ATA_CMD_WRITE_FUA_EXT   = 0x3D, /* aka WRITE DMA FUA EXT */
> +       ATA_CMD_WRITE_DMA_QUEUED = 0xCC,
> +       ATA_CMD_WRITE_DMA_QUEUED_EXT = 0x36,
> +       ATA_CMD_WRITE_DMA_QUEUED_FUA_EXT = 0x3E,
> +       ATA_CMD_FPDMA_WRITE     = 0x61, /* aka WRITE FPDMA QUEUED */
> +       ATA_CMD_WRITE_LOG_EXT   = 0x3F,
> +       ATA_CMD_WRITE_LOG_DMA_EXT = 0x57,
> +       ATA_CMD_WRITE_MULTI     = 0xC5,
> +       ATA_CMD_WRITE_MULTI_EXT = 0x39,
> +       ATA_CMD_WRITE_MULTI_FUA_EXT = 0xCE,
> +       ATA_CMD_PIO_WRITE       = 0x30, /* aka WRITE SECTOR(S) */
> +       ATA_CMD_PIO_WRITE_EXT   = 0x34, /* aka WRITE SECTOR(S) EXT */
> +       ATA_CMD_WRITE_STREAM_DMA_EXT = 0x3A,
> +       ATA_CMD_WRITE_STREAM_EXT = 0x3B,
> +       ATA_CMD_WRITE_UNCORRECTABLE_EXT = 0x45,
>
>        /* READ_LOG_EXT pages */
>        ATA_LOG_SATA_NCQ        = 0x10,
>
> -       /* READ/WRITE LONG (obsolete) */
> +       /* Obsolete */

Since these diagnostic commands could be confused with the new "long
sector" commands, should the comment say:

/* Obsolete LBA28 diagnostic commands, in LBA48 replaced by
ATA_WRITE_UNC_EXT, etc. */

>        ATA_CMD_READ_LONG       = 0x22,
>        ATA_CMD_READ_LONG_ONCE  = 0x23,
>        ATA_CMD_WRITE_LONG      = 0x32,
>        ATA_CMD_WRITE_LONG_ONCE = 0x33,
> +       ATA_CMD_INIT_DEV_PARAMS = 0x91,
>
>        /* SETFEATURES stuff */
>        SETFEATURES_XFER        = 0x03,
> --
> 1.5.6.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
