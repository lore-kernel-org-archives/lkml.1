Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbXJKPlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbXJKPlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbXJKPl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:41:29 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:13680 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbXJKPl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:41:28 -0400
Date: Thu, 11 Oct 2007 08:40:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: Fix printk format strings
Message-Id: <20071011084028.2daf0fd9.randy.dunlap@oracle.com>
In-Reply-To: <1192083422.26648.19.camel@grianne>
References: <1192083422.26648.19.camel@grianne>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 08:17:02 +0200 Vegard Nossum wrote:

> This makes sure printk format strings are string literals containing no
> more than a single line.

Each patch needs justification (unless it is blatantly obvious).


> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  init/calibrate.c        |    4 +++-
>  init/do_mounts_initrd.c |    5 ++++-
>  init/main.c             |    2 +-
>  3 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
> index fd4fc12..ad6174c 100644
> --- a/init/do_mounts_initrd.c
> +++ b/init/do_mounts_initrd.c
> @@ -98,7 +98,10 @@ static void __init handle_initrd(void)
>  			error = sys_ioctl(fd, BLKFLSBUF, 0);
>  			sys_close(fd);
>  		}
> -		printk(!error ? "okay\n" : "failed\n");
> +		if(error)
> +			printk("failed\n");
> +		else
> +			printk("okay\n");
>  	}
>  }

Why this one?
and if it must change, use:
		if (error)
but I see little need for the change.

---
~Randy
