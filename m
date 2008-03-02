Return-Path: <linux-kernel-owner+w=401wt.eu-S1755517AbYCBTtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbYCBTtR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:49:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYCBTs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:48:58 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:10965 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbYCBTsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:48:46 -0500
Date: Sun, 2 Mar 2008 14:45:17 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Craig Kelley <namonai@gmail.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] hwmon: add 0x8c id for smsc47b397 driver
Message-ID: <20080302194517.GA5324@jupiter.solarsys.private>
References: <847993120802290924m6b12567p964a17e080030889@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <847993120802290924m6b12567p964a17e080030889@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Craig:

* Craig Kelley <namonai@gmail.com> [2008-02-29 10:24:44 -0700]:
> From: Craig Kelley <namonai@gmail.com>
> 
> Added a new ID (0x8c) for the smsc47b397 hardware monitor driver.
> This ID is used by HP in, at least, their dc7700 line.
> 
> Signed-off-by: Craig Kelley <namonai@gmail.com>
> ---
> 
> --- drivers/hwmon/smsc47b397.c-orig     2008-02-29 07:54:18.000000000 -0800
> +++ drivers/hwmon/smsc47b397.c  2008-02-29 07:53:00.000000000 -0800
> @@ -331,11 +331,23 @@ exit:
>  static int __init smsc47b397_find(unsigned short *addr)
>  {
>         u8 id, rev;
> +       char *name;
> 
>         superio_enter();
>         id = superio_inb(SUPERIO_REG_DEVID);
> 
> -       if ((id != 0x6f) && (id != 0x81) && (id != 0x85)) {
> +       switch(id) {
> +       case 0x81:
> +               name = "SCH5307-NS";
> +               break;
> +       case 0x6f:
> +               name = "LPC47B397-NC";
> +               break;
> +       case 0x85:
> +       case 0x8c:
> +               name = "SCH5317";
> +               break;
> +       default:
>                 superio_exit();
>                 return -ENODEV;
>         }
> @@ -348,8 +360,7 @@ static int __init smsc47b397_find(unsign
> 
>         printk(KERN_INFO DRVNAME ": found SMSC %s "
>                 "(base address 0x%04x, revision %u)\n",
> -               id == 0x81 ? "SCH5307-NS" : id == 0x85 ? "SCH5317" :
> -              "LPC47B397-NC", *addr, rev);
> +               name, *addr, rev);
> 
>         superio_exit();
>         return 0;

Some problems with this patch...

1) The whitespace is all busted (spaces where tabs should be).
Did you copy-paste this patch into your mailer?

2) This patch requires 'patch -p0' to apply, whereas standard practice
for Linux kernel patches is to use 'patch -p1'.

3) It's not obvious: to which revision does this patch apply?

Despite these problems, I fixed it up and applied it to my testing
branch... so the change will get to Linus after 2.6.25 is final.

You can find the result here:

http://lm-sensors.org/kernel?p=kernel/mhoffman/hwmon-2.6.git;a=shortlog;h=testing

I try to cut some slack for first-time patch submitters (not to mention
former customers, heh).  But next time, please try to check those things
above before you send a patch.  

Thanks & regards,

-- 
Mark M. Hoffman
mhoffman@lightlink.com

