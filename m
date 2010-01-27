Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164Ab0A0XF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab0A0XF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613Ab0A0XFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:05:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab0A0XFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:05:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 2/2] PM / Hibernate: swap, remove useless check from swsusp_read
Date: Thu, 28 Jan 2010 00:06:07 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc5-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <1264610778-13242-1-git-send-email-jslaby@suse.cz> <1264610778-13242-2-git-send-email-jslaby@suse.cz>
In-Reply-To: <1264610778-13242-2-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201001280006.07796.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 January 2010, Jiri Slaby wrote:
> It will never reach here if the sws_resume_bdev is erratic.
> swsusp_read is called only from software_resume, but after
> swsusp_check which would catch the error state.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Pavel Machek <pavel@ucw.cz>

Applied.

> ---
>  kernel/power/swap.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 09b2b0a..1d57573 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -657,10 +657,6 @@ int swsusp_read(unsigned int *flags_p)
>  	struct swsusp_info *header;
>  
>  	*flags_p = swsusp_header->flags;
> -	if (IS_ERR(resume_bdev)) {
> -		pr_debug("PM: Image device not initialised\n");
> -		return PTR_ERR(resume_bdev);
> -	}
>  
>  	memset(&snapshot, 0, sizeof(struct snapshot_handle));
>  	error = snapshot_write_next(&snapshot, PAGE_SIZE);
> 

Rafael
