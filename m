Return-Path: <linux-kernel-owner+w=401wt.eu-S932084AbZKMJZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbZKMJZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZKMJZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:25:21 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:58400 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbZKMJZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:25:19 -0500
Date: Fri, 13 Nov 2009 10:25:05 +0100
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH] qnx4: Use hweight8
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <1258095978-13380-1-git-send-email-akinobu.mita@gmail.com>
	(from akinobu.mita@gmail.com on Fri Nov 13 08:06:18 2009)
X-Mailer: Balsa 2.3.14
Message-Id: <1258104305l.9440l.0l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
References: <1258095978-13380-1-git-send-email-akinobu.mita@gmail.com>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-11-13 08:06:18, Akinobu Mita wrote:
> Use hweight8 instead of counting for each bit
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Anders Larsen <al@alarsen.net>
> Cc: Al Viro <viro@zeniv.linux.org.uk>

The original code counted the number of zeroes whereas hweight8() counts ones, so

NAK

(hint: "tot += 8 - hweight8(b)" should do the trick)

Cheers
Anders

> ---
>  fs/qnx4/bitmap.c |   17 +----------------
>  1 files changed, 1 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/qnx4/bitmap.c b/fs/qnx4/bitmap.c
> index 0afba06..b913e3d 100644
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
> +		tot += hweight8(b);
>  		size--;
>  	} while (size != 0);
>  	*tf = tot;
> -- 
> 1.6.5.1

