Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbZAGQRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbZAGQRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZAGQRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:17:30 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62503 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751134AbZAGQR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:17:29 -0500
Date: Wed, 7 Jan 2009 17:17:20 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com, sfr@canb.auug.org.au
Subject: Re: [PATCH V3 10/17] Squashfs: cache operations
In-Reply-To: <E1LJnJn-0002Lm-Va@dylan.lougher.demon.co.uk>
Message-ID: <Pine.LNX.4.64.0901071713570.16480@vixen.sonytel.be>
References: <E1LJnJn-0002Lm-Va@dylan.lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Phillip Lougher wrote:
> diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
> new file mode 100644
> index 0000000..f29eda1
> --- /dev/null
> +++ b/fs/squashfs/cache.c

> +/*
> + * Copy upto length bytes from cache entry to buffer starting at offset bytes
> + * into the cache entry.  If there's not length bytes then copy the number of
> + * bytes available.  In all cases return the number of bytes copied.
> + */
> +int squashfs_copy_data(void *buffer, struct squashfs_cache_entry *entry,
                                        ^
					const?

It also makes it clear from the prototype in which direction is copied.
> +		int offset, int length)
                ^^^         ^^^
> +{
> +	int remaining = length;
        ^^^
Shouldn't all of these be unsigned int?

> +
> +	if (length == 0)
> +		return 0;
> +	else if (buffer == NULL)
> +		return min(length, entry->length - offset);
> +
> +	while (offset < entry->length) {
> +		void *buff = entry->data[offset / PAGE_CACHE_SIZE]
> +				+ (offset % PAGE_CACHE_SIZE);
> +		int bytes = min_t(int, entry->length - offset,
> +				PAGE_CACHE_SIZE - (offset % PAGE_CACHE_SIZE));
> +
> +		if (bytes >= remaining) {
> +			memcpy(buffer, buff, remaining);
> +			remaining = 0;
> +			break;
> +		}
> +
> +		memcpy(buffer, buff, bytes);
> +		buffer += bytes;
> +		remaining -= bytes;
> +		offset += bytes;
> +	}
> +
> +	return length - remaining;
> +}

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
