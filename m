Return-Path: <linux-kernel-owner+w=401wt.eu-S966016AbXCSPcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966016AbXCSPcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966020AbXCSPcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:32:53 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62340 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966016AbXCSPcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:32:52 -0400
Date: Mon, 19 Mar 2007 08:31:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][1/5][resend] floppy.c: Initial (partial) CodingStyle
 cleanup
Message-Id: <20070319083159.0744cf5e.randy.dunlap@oracle.com>
In-Reply-To: <200703191610.13940.jesper.juhl@gmail.com>
References: <200703191610.13940.jesper.juhl@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 16:10:13 +0100 Jesper Juhl wrote:

>     This is a basic CodingStyle cleanup for drivers/block/floppy.c
>     
>     There are no functional changes in this patch.
> ---
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 5231ed7..5da54b8 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c

> @@ -1188,7 +1193,7 @@ static int output_byte(char byte)
>  	return -1;
>  }
>  
> -#define LAST_OUT(x) if (output_byte(x)<0){ reset_fdc();return;}
> +#define LAST_OUT(x) if (output_byte(x) < 0) { reset_fdc(); return; }

Not for a coding style cleanup, but that macro is Bad according to
CodingStyle, so hopefully it will be cleaned up in the future.

Things to avoid when using macros:
1) macros that affect control flow:

>  /* gets the response from the fdc */
>  static int result(void)

> @@ -3816,7 +3803,7 @@ static int check_floppy_change(struct gendisk *disk)
>   */
>  
>  static int floppy_rb0_complete(struct bio *bio, unsigned int bytes_done,
> -			       int err)
> +		int err)

I don't care one way or the other about most of these, but would
you explain that one above (and others like it), please?
It's not an < 80 columns thing.  My <cough> recollection is that
many indented function parameters in Linux are indented more like
the original here, near the opening '(' after the function name,
although I suppose that none of this is in CodingStyle.

>  {
>  	if (bio->bi_size)
>  		return 1;

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
