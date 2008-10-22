Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbYJVQfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbYJVQfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYJVQfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:35:21 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62421 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753736AbYJVQfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:35:20 -0400
Date: Wed, 22 Oct 2008 18:35:18 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 04/16] Squashfs: regular file operations
In-Reply-To: <E1KqrTW-0001xQ-Kx@dylan>
Message-ID: <Pine.LNX.4.64.0810221833360.5634@vixen.sonytel.be>
References: <E1KqrTW-0001xQ-Kx@dylan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-429055810-1224693318=:5634"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-429055810-1224693318=:5634
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 17 Oct 2008, Phillip Lougher wrote:
> --- /dev/null
> +++ b/fs/squashfs/file.c
> +static long long read_blocklist(struct inode *inode, int index,
> +				unsigned int *bsize)
> +{
> +	long long start, block, blks;
> +	int offset;
> +	__le32 size;
> +	int res = fill_meta_index(inode, index, &start, &offset, &block);
> +
> +	TRACE("read_blocklist: res %d, index %d, start 0x%llx, offset"
> +		       " 0x%x, block 0x%llx\n", res, index, start, offset,
> +			block);
> +
> +	if (res == -1)
> +		goto failure;
                ^^^^^^^^^^^^^

> +		if (blks == -1)
> +			goto failure;
			^^^^^^^^^^^^^

> +	if (res == 0)
> +		goto failure;
                ^^^^^^^^^^^^^

> +failure:
> +	return -1;
> +}

As there's nothing to clean up, you can just use `return -1' instead of `goto
failure', and save a few lines.

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
---584349381-429055810-1224693318=:5634--
