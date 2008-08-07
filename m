Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbYHGTJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbYHGTJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 15:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYHGTJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 15:09:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:54714 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYHGTJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 15:09:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=d/iYHvSGUxyvE8ksQN5ZNxbhxNHs0/5nTR233RsDXyc9CtdYBMWtneK/Su69yJaQZY
         heBdyaoFosCLzoZR4gpXL3Lj51+COF97zZVxAM5Z/PGrqn4mESt76Oi542wE5fZhUjtr
         prpESFYXRjr/Y/DEsH0wV3WEWUZD2c4UbJieo=
Message-ID: <dd18b0c30808071209u6638bfedm80dc0143b06dcfb3@mail.gmail.com>
Date: Thu, 7 Aug 2008 12:09:23 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Subject: Re: [PATCH] isight_firmware : Fix a leak and double kfree()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "akpm@osdl.org" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <82e4877d0808071034o3ec31f75k95308ed585563b2e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0808071034o3ec31f75k95308ed585563b2e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2008 at 10:34 AM, Parag Warudkar
<parag.warudkar@gmail.com> wrote:
> Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>
>
> --- linux-2.6/drivers/usb/misc/isight_firmware.c        2008-07-29
> 23:26:24.000000000 -0400
> +++ linux-2.6-wk/drivers/usb/misc/isight_firmware.c     2008-08-07
> 13:23:01.000000000 -0400
> @@ -48,7 +48,8 @@
>
>        if (request_firmware(&firmware, "isight.fw", &dev->dev) != 0) {
>                printk(KERN_ERR "Unable to load isight firmware\n");
> -               return -ENODEV;
> +               ret = -ENODEV;
> +               goto out;
>        }
>
>        ptr = firmware->data;
> @@ -91,7 +92,6 @@
>                             buf, llen, 300) != llen) {
>                                printk(KERN_ERR
>                                       "Failed to load isight firmware\n");
> -                               kfree(buf);
>                                ret = -ENODEV;
>                                goto out;
>                        }
>

Applied;
I guess with this BUG,
it's more of a waiting game.
("one day it's fine; the next is black")
anyways the module loads, and the firmware
is loading as well. If something like this appears
I'll send a post.

regards;
-- 
Justin P. Mattock
