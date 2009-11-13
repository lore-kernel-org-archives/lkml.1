Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZKMKMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZKMKMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbZKMKMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:12:14 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:58908 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbZKMKMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:12:14 -0500
Date: Fri, 13 Nov 2009 11:11:53 +0100
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH v2] qnx4: Use hweight8
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <1258104305l.9440l.0l@i-dmzi_al.realan.de>
	<1258106265-18181-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1258106265-18181-1-git-send-email-akinobu.mita@gmail.com>
	(from akinobu.mita@gmail.com on Fri Nov 13 10:57:45 2009)
X-Mailer: Balsa 2.3.14
Message-Id: <1258107113l.9440l.1l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-11-13 10:57:45, Akinobu Mita wrote:
> Oops,
> 
> Subject: [PATCH v2] qnx4: Use hweight8
> 
> Use hweight8 instead of counting for each bit
> 
> [ v2: count_bit() counts zero bits in the bitmap]
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Anders Larsen <al@alarsen.net>
> Cc: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Anders Larsen <al@alarsen.net>

> ---
>  fs/qnx4/bitmap.c |   17 +----------------
>  1 files changed, 1 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/qnx4/bitmap.c b/fs/qnx4/bitmap.c
> index 0afba06..cbaae72 100644
> --- a/fs/qnx4/bitmap.c
> +++ b/fs/qnx4/bitmap.c
> @@ -35,22 +35,7 @@ static void count_bits(register const char *bmPart, register int size,
>  	}
>  	do {
>  		b = *bmPart++;
> -		if ((b & 1) == 0)
> -			tot++;
> -		if ((b & 2) == 0)
> -			tot++;
> -		if ((b & 4) == 0)
> -			tot++;
> -		if ((b & 8) == 0)
> -			tot++;
> -		if ((b & 16) == 0)
> -			tot++;
> -		if ((b & 32) == 0)
> -			tot++;
> -		if ((b & 64) == 0)
> -			tot++;
> -		if ((b & 128) == 0)
> -			tot++;
> +		tot += 8 - hweight8(b);
>  		size--;
>  	} while (size != 0);
>  	*tf = tot;
> -- 
> 1.6.5.1

