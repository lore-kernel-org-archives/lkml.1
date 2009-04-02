Return-Path: <linux-kernel-owner+w=401wt.eu-S1762887AbZDBPz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762887AbZDBPz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZDBPzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 11:55:13 -0400
Received: from h155.mvista.com ([63.81.120.155]:9468 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751527AbZDBPzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 11:55:11 -0400
Message-ID: <49D4DFFB.8070201@ru.mvista.com>
Date: Thu, 02 Apr 2009 19:55:39 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 3/5] ata: Add TRIM infrastructure
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com>
In-Reply-To: <1238683047-13588-3-git-send-email-willy@linux.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:

> This is common code shared between the IDE and libata implementations

> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

[...]

> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index 6617c9f..cb79b7a 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -29,6 +29,8 @@
>  #ifndef __LINUX_ATA_H__
>  #define __LINUX_ATA_H__
>  
> +#include <linux/kernel.h>
> +#include <linux/string.h>
>  #include <linux/types.h>
>  #include <asm/byteorder.h>
>  
> @@ -91,6 +93,7 @@ enum {
>  	ATA_ID_CFA_POWER	= 160,
>  	ATA_ID_CFA_KEY_MGMT	= 162,
>  	ATA_ID_CFA_MODES	= 163,
> +	ATA_ID_DATA_SET_MGMT	= 169,
>  	ATA_ID_ROT_SPEED	= 217,
>  	ATA_ID_PIO4		= (1 << 1),
>  
> @@ -248,6 +251,7 @@ enum {
>  	ATA_CMD_SMART		= 0xB0,
>  	ATA_CMD_MEDIA_LOCK	= 0xDE,
>  	ATA_CMD_MEDIA_UNLOCK	= 0xDF,
> +	ATA_CMD_DSM		= 0x06,
>  	/* marked obsolete in the ATA/ATAPI-7 spec */
>  	ATA_CMD_RESTORE		= 0x10,
>  
> @@ -321,6 +325,9 @@ enum {
>  	ATA_SMART_READ_VALUES	= 0xD0,
>  	ATA_SMART_READ_THRESHOLDS = 0xD1,
>  
> +	/* feature values for Data Set Management */
> +	ATA_DSM_TRIM		= 0x01,
> +
>  	/* password used in LBA Mid / LBA High for executing SMART commands */
>  	ATA_SMART_LBAM_PASS	= 0x4F,
>  	ATA_SMART_LBAH_PASS	= 0xC2,

    I wonder where to read about the word 169 and commnand 0x06... what's it 
all about?

WBR, Sergei
