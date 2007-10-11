Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbXJKJBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbXJKJBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 05:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbXJKJBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 05:01:03 -0400
Received: from smtpoutm.mac.com ([17.148.16.68]:57279 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbXJKJBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 05:01:02 -0400
In-Reply-To: <20071011073537.GA6697@localhost.sw.ru>
References: <20071010104540.GA6366@localhost.sw.ru> <470CBB6A.7020305@freedesktop.org> <20071011073537.GA6697@localhost.sw.ru>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <19B9D181-BE66-41E5-AA24-6EBB39660A1F@mac.com>
Cc: Josh Triplett <josh@freedesktop.org>, Al Viro <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org, davej@codemonkey.org.uk,
       Pierre Ossman <drzeus@drzeus.cx>, akpm@osdl.org,
       linux-sparse@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: idio{,ma}tic typos (was Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree)
Date: Thu, 11 Oct 2007 05:00:55 -0400
To: Alexey Dobriyan <adobriyan@sw.ru>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 11, 2007, at 03:35:37, Alexey Dobriyan wrote:
> Sadly, yes.
>
> [PATCH] smctr: fix "|| 0x" typo
>
> IBM_PASS_SOURCE_ADDR is 1, so logically ORing it with status bits is
> pretty useless. Do bitwise OR, instead.
>
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
>
>  drivers/net/tokenring/smctr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/net/tokenring/smctr.c
> +++ b/drivers/net/tokenring/smctr.c
> @@ -3413,7 +3413,7 @@ static int smctr_make_tx_status_code(struct  
> net_device *dev,
>          tsv->svi = TRANSMIT_STATUS_CODE;
>          tsv->svl = S_TRANSMIT_STATUS_CODE;
>
> -        tsv->svv[0] = ((tx_fstatus & 0x0100 >> 6) ||  
> IBM_PASS_SOURCE_ADDR);
> +        tsv->svv[0] = ((tx_fstatus & 0x0100 >> 6) |  
> IBM_PASS_SOURCE_ADDR);
>
>          /* Stripped frame status of Transmitted Frame */
>          tsv->svv[1] = tx_fstatus & 0xff;

Hmm, here's a question for you:  The old code was equivalent to "tsv- 
 >svv[0] = 1;", what's your proof that we don't rely on this "bug"  
elsewhere in the code?  In other words, this is a significant  
behavior change (albeit fixing an apparent bug) from what we've done  
for a while.  You might want to do a git-blame on this bit of code to  
see who the last person to modify it was and ask them to test or  
confirm the patch first.  The same general questions apply to the  
other logical-op bugs.

Cheers,
Kyle Moffett

