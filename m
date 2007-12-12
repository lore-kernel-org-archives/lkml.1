Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbXLLA5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbXLLA5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXLLA5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:57:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbXLLA5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:57:05 -0500
Date: Tue, 11 Dec 2007 16:57:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin =?ISO-8859-1?Q?=5F=5Flusarz?= <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org, adaplas@gmail.com
Subject: Re: [PATCH] fbcon: fix sparse warning about shadowing 'p' symbol
Message-Id: <20071211165700.fb20c939.akpm@linux-foundation.org>
In-Reply-To: <20071209213429.GE9440@joi>
References: <20071209213429.GE9440@joi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Dec 2007 22:34:33 +0100
Marcin __lusarz <marcin.slusarz@gmail.com> wrote:

> fbcon: fix sparse warning about shadowing 'p' symbol
> 

Please always quote error messages and warnings in the changelog when
fixing them, thanks.

> ---
>  drivers/video/console/fbcon.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> index 0f32f4a..849e114 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -2795,7 +2795,7 @@ static int fbcon_scrolldelta(struct vc_data *vc, int lines)
>  {
>  	struct fb_info *info = registered_fb[con2fb_map[fg_console]];
>  	struct fbcon_ops *ops = info->fbcon_par;
> -	struct display *p = &fb_display[fg_console];
> +	struct display *disp = &fb_display[fg_console];

We have a global symbol called "p"?  That would be bad.  Where is it?

(The patch is good anwyay - "p" is a poorly chosen identifier here).
