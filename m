Return-Path: <linux-kernel-owner+w=401wt.eu-S1752907AbYCIPGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbYCIPGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 11:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYCIPGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 11:06:36 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:46620
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbYCIPGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 11:06:36 -0400
Message-ID: <47D3FCF6.70908@microgate.com>
Date: Sun, 09 Mar 2008 09:06:30 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/char/synclink drivers/pcmcia/synclink - BOOLEAN
 to	bool conversion
References: <1205046574.656.37.camel@localhost>
In-Reply-To: <1205046574.656.37.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Remove more TRUE/FALSE defines and uses
> Remove == TRUE tests
> Convert BOOLEAN to bool
> Convert int to bool where appropriate
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
>  include/linux/synclink.h          |    4 -
>  drivers/char/pcmcia/synclink_cs.c |  125 +++++++++---------
>  drivers/char/synclink.c           |  258 ++++++++++++++++++-------------------
>  drivers/char/synclink_gt.c        |   88 +++++++-------
>  drivers/char/synclinkmp.c         |  157 +++++++++++-----------
>  5 files changed, 312 insertions(+), 320 deletions(-)
> 
...
> diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
...
> @@ -4475,14 +4476,13 @@ static void reset_rbufs(struct slgt_info *info)
>  /*
>   * pass receive HDLC frame to upper layer
>   *
> - * return 1 if frame available, otherwise 0
> + * return true if frame available, otherwise false
>   */
>  static int rx_get_frame(struct slgt_info *info)
>  {
>  	unsigned int start, end;
>  	unsigned short status;
>  	unsigned int framesize = 0;
> -	int rc = 0;
>  	unsigned long flags;
>  	struct tty_struct *tty = info->tty;
>  	unsigned char addr_field = 0xff;
> @@ -4606,10 +4606,10 @@ check_again:
>  		}
>  	}
>  	free_rbufs(info, start, end);
> -	rc = 1;
> +	return true;
>  
>  cleanup:
> -	return rc;
> +	return false;
>  }

If you return bool values from this function
it would make sense to also change the return value
of the function declaration to bool.

Overall the patch seems reasonable. I need to spend
time tomorrow going over it more carefully,
compiling it, and testing it with hardware.

You may wish to shorten the subject line to:
[PATCH] synclink drivers bool conversion

It is more readable and covers all of the
patch changes including int to bool conversions.

--
Paul
