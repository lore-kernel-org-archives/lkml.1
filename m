Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab0CLMXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 07:23:41 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42963 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab0CLMXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 07:23:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Ma/fXyK7c5BsnzfG3WD7hvRE0biGzRB/SnYT43An6kNftYlMBUAuvSvkYZ1nJSHq0A
         IQRLI4Y0pVAfDcG3n2xP/Hwb1IoxZycfpMeuSGohiGOh0XlImaZwGgZESzEcLjw/+r/U
         r6/GoZFASHzuAAuxpQbGnZ7Ts6nTycU8aEKUM=
Subject: Re: [PATCH] ide: Build break in ide-iops.c
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
In-Reply-To: <1268395850-23408-2-git-send-email-jkacur@redhat.com>
References: <1268395850-23408-1-git-send-email-jkacur@redhat.com>
	 <1268395850-23408-2-git-send-email-jkacur@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Fri, 12 Mar 2010 20:17:00 +0800
Message-ID: <1268396220.9130.4.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 13:10 +0100, John Kacur wrote:
> I get the following build break due to 876c52cc046e00eaa2ffc5124dc187106ef57594
> 
> drivers/ide/ide-iops.c:29:26: error: asm/bootinfo.h: No such file or directory
> 

I think we'd better revert that commit
876c52cc046e00eaa2ffc5124dc187106ef57594 for it has introduced some arch
specific parts into the common ide source code.

And that commit doesn't influence the preempt-rt support, so, Thomas,
could you please revert it directly, thanks!

Regards,
	Wu Zhangjin

> Protect the include by #ifdef CONFIG_MIPS
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  drivers/ide/ide-iops.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
> index 9dba71e..8d32dda 100644
> --- a/drivers/ide/ide-iops.c
> +++ b/drivers/ide/ide-iops.c
> @@ -26,7 +26,10 @@
>  #include <asm/irq.h>
>  #include <asm/uaccess.h>
>  #include <asm/io.h>
> +
> +#ifdef CONFIG_MIPS
>  #include <asm/bootinfo.h>
> +#endif
>  
>  void SELECT_MASK(ide_drive_t *drive, int mask)
>  {


