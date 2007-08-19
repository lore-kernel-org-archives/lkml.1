Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbXHSW2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbXHSW2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbXHSW2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:28:30 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59582 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbXHSW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:28:28 -0400
Date: Sun, 19 Aug 2007 15:34:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Markus Rechberger <markus.rechberger@amd.com>
Subject: Re: [PATCH 4/5] Documentation/firmware/... convert #include
 "linux/..." to #include <linux/...>
Message-Id: <20070819153422.1e0b54af.randy.dunlap@oracle.com>
In-Reply-To: <1187561972.4200.143.camel@localhost>
References: <1187561972.4200.143.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2007 15:19:32 -0700 Joe Perches wrote:

> (untested)
> 
> There are several files that 
> #include "linux/file" not #include <linux/file>
> #include "asm/file" not #include <asm/file>
> 
> Here's a little script that converts them:
> 
> egrep -i -r -l --include=*.[ch] \
> "^[[:space:]]*\#[[:space:]]*include[[:space:]]*\"(linux|asm)/(.*)\"" * \
> | xargs sed -i -e 's/^[[:space:]]*#[[:space:]]*include[[:space:]]*"\(linux\|asm\)\/\(.*\)"/#include <\1\/\2>/g'
> 
> This one is probably wrong.
> 
> It should likely keep firmware.h in
> the same directory as firmware.c
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/Documentation/firmware_class/firmware_sample_driver.c b/Documentation/firmware_class/firmware_sample_driver.c
> index 6865cbe..754ded2 100644
> --- a/Documentation/firmware_class/firmware_sample_driver.c
> +++ b/Documentation/firmware_class/firmware_sample_driver.c
> @@ -13,7 +13,7 @@
>  #include <linux/device.h>
>  #include <linux/string.h>
>  
> -#include "linux/firmware.h"
> +#include "firmware.h"

I believe that it should be <linux/firmware.h>.

>  static struct device ghost_device = {
>  	.bus_id    = "ghost0",


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
