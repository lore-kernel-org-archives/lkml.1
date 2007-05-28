Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbXE1VAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbXE1VAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932376AbXE1VAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:00:23 -0400
Received: from mail.zelnet.ru ([80.92.97.13]:38755 "EHLO mail.zelnet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246AbXE1VAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:00:22 -0400
Message-ID: <465B42D8.1020102@namesys.com>
Date: Tue, 29 May 2007 01:00:08 +0400
From: Edward Shishkin <edward@namesys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060411
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>
CC: akpm <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       vs@namesys.com
Subject: Re: [PATCH -mm] reiser4: remove lzo compression security hole
References: <1180047240.12821.48.camel@localhost.localdomain>
In-Reply-To: <1180047240.12821.48.camel@localhost.localdomain>
X-Enigmail-Version: 0.86.0.0
X-Enigmail-Supports: pgp-inline, pgp-mime
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:

>Switch reiser4 to use lzo1x_decompress_safe instead of lzo1x_decompress
>as otherwise it presents a security hole (lzo1x_decompress doesn't
>perform bounds checking on the decompressed data).
>
>Signed-off-by: Richard Purdie <rpurdie@rpsys.net>
>
>---
> fs/reiser4/plugin/compress/compress.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>Index: linux-2.6.21/fs/reiser4/plugin/compress/compress.c
>===================================================================
>--- linux-2.6.21.orig/fs/reiser4/plugin/compress/compress.c	2007-05-16 20:47:45.000000000 +0100
>+++ linux-2.6.21/fs/reiser4/plugin/compress/compress.c	2007-05-24 23:43:28.000000000 +0100
>@@ -319,7 +319,7 @@ lzo1_decompress(coa_t coa, __u8 * src_fi
> 	assert("edward-851", coa == NULL);
> 	assert("edward-852", src_len != 0);
> 
>-	result = lzo1x_decompress(src_first, src_len, dst_first, &dstlen, NULL);
>+	result = lzo1x_decompress_safe(src_first, src_len, dst_first, &dstlen, NULL);
> 	if (result != LZO_E_OK)
> 		warning("edward-853", "lzo1x_1_decompress failed\n");
> 	*dst_len = dstlen;
>
>  
>

Signed-off-by: Edward Shishkin <edward@namesys.com>
