Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYKUXzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYKUXzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 18:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYKUXzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 18:55:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888AbYKUXzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 18:55:04 -0500
Date: Fri, 21 Nov 2008 15:54:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@suse.cz>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: backlight: catch invalid input
Message-Id: <20081121155421.152cc555.akpm@linux-foundation.org>
In-Reply-To: <20081121111414.GA1455@elf.ucw.cz>
References: <20081121111414.GA1455@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 12:14:14 +0100
Pavel Machek <pavel@suse.cz> wrote:

> 
> Currently, echo > brightness turns brightness to zero due to
> insufficient checking. Add a test to catch that.
> 

OK.  And what happens if you do

	echo wibble > brightness

?

> 
> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> index fab0bc8..5c2e23d 100644
> --- a/drivers/video/backlight/backlight.c
> +++ b/drivers/video/backlight/backlight.c
> @@ -86,6 +86,8 @@ static ssize_t backlight_store_power(str
>  	int power = simple_strtoul(buf, &endp, 0);
>  	size_t size = endp - buf;
>  
> +	if (!size)
> +		return -EINVAL;
>  	if (*endp && isspace(*endp))
>  		size++;
>  	if (size != count)

A better fix would be to use strict_strtoul() and check its return value.
