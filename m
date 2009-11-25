Return-Path: <linux-kernel-owner+w=401wt.eu-S934689AbZKYNPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934689AbZKYNPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934598AbZKYNPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:15:45 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45857 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934212AbZKYNPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:15:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:references:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=KM0JKTUzm8Lhu+ACd89cTUx0d41aJxci3DkDllnELqDey+/MAE4Ce5lqdaBCmqTu48
         VwZxRp348ypkGB8q6atqn7kPVe7S/F3Ofeeey8Uh3FI9CoFltu9sIwnYBBMHlxpUQlT4
         QeKee3Ja+eJ1N8mENU2G2QDI41KrrYoxIjutY=
Date: Wed, 25 Nov 2009 21:20:06 +0800
From: "Liuweni" <qingshenlwy@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "xgr178" <xgr178@163.com>,
       "Jiri Kosina" <jkosina@suse.cz>
References: <200911242147508598860@gmail.com>
Subject: Re: [PATCH]irq/core:Add a length limitation
Message-ID: <200911252119598758808@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nAPDGA16015508

Hi Ingo,
    I don't know whether this situation happened in the past.
I upload this code for code Integrity. The WARN_ON is set on OFF, 
While anybody use it, and set it ON. 

Thank you for you suggestion.
I modify the code and use  scripts/checkpatch.pl and scripts/get_maintainer.pl
on the patch. Please have a check later.


--------------
Best Regards,
Liuweni
2009-11-25


·¢¼şÈË£º Ingo Molnar 
·¢ËÍÊ±¼ä£º 2009-11-24  22:45:38 
ÊÕ¼şÈË£º Liuweni; Thomas Gleixner 
³­ËÍ£º linux-kernel; xgr178; Jiri Kosina; qingshenlwy 
Ö÷Ìâ£º Re: [PATCH]irq/core:Add a length limitation 
 
* Liuweni <qingshenlwy@gmail.com> wrote:
> In the register_handler_proc(), the max length of irqaction->name is 
> MAX_NAMELEN. And this function will call name_unique() to compare name 
> with other irqs'.
>
> There is no any code for limitation the length. I add a warning in the 
> function to notice that the irqaction->name is too long.
> 
> Signed-off-by: Liuwenyi <qingshenlwy@gmail.com>
> ---
> diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
> index 0832145..9ab6e04 100644
> --- a/kernel/irq/proc.c
> +++ b/kernel/irq/proc.c
> @@ -196,6 +196,9 @@ void register_handler_proc(unsigned int irq, struct irqaction *action)
>   char name [MAX_NAMELEN];
>   struct irq_desc *desc = irq_to_desc(irq);
>  
> + if(strlen(action->name) >= MAX_NAMELEN)
> + WARN_ON(1);
> +
Has this situation happened in the past that requires this check to be 
added? The current limit of 128 chars is quite generous. Also, the check 
is buggy, it's off by 1.
( Also, please use scripts/checkpatch.pl on patches and please use 
  'scripts/get_maintainer.pl -f kernel/irq/proc.c' when constructing Cc: 
  lines. )
Thanks,
Ingo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
