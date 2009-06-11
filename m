Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZFKORw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZFKORw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZFKORa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:17:30 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:59891 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZFKOR2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:17:28 -0400
X-Greylist: delayed 3219 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2009 10:17:28 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GPQOj2kprhs2Z76/QNZI341qbjX81q0cA1xafxkgqj3yR51FUn90zuYbesPC5E3BK9
         VhpxLxzTovsXQxTjNSm/Gpi6kWnK4uUnk13GCBpKfeTySusrCvEZ6YB2OHO20Ckcyx0k
         kQI7Y7tzSGbhJfrp4p6fnqZKlo/WM7Ut+PhwU=
MIME-Version: 1.0
In-Reply-To: <20090611131440.GA3146@osiris.boeblingen.de.ibm.com>
References: <20090611131440.GA3146@osiris.boeblingen.de.ibm.com>
Date: Thu, 11 Jun 2009 21:23:51 +0800
Message-ID: <d82e647a0906110623w69dea2e2l4ac6d8b28ac39293@mail.gmail.com>
Subject: Re: [PATCH] partitions: fix broken uevent_suppress conversion
From: Ming Lei <tom.leiming@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/11 Heiko Carstens <heiko.carstens@de.ibm.com>:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> git commit f67f129e "Driver core: implement uevent suppress in kobject"
> contains this chunk for fs/partitions/check.c:
>
>        /* suppress uevent if the disk supresses it */
> -       if (!ddev->uevent_suppress)
> +       if (!dev_get_uevent_suppress(pdev))
>                kobject_uevent(&pdev->kobj, KOBJ_ADD);
>
> However that should have been
>
> -       if (!ddev->uevent_suppress)
> +       if (!dev_get_uevent_suppress(ddev))
>
> Cc: Ming Lei <tom.leiming@gmail.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  fs/partitions/check.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/fs/partitions/check.c
> ===================================================================
> --- linux-2.6.orig/fs/partitions/check.c
> +++ linux-2.6/fs/partitions/check.c
> @@ -426,7 +426,7 @@ struct hd_struct *add_partition(struct g
>        rcu_assign_pointer(ptbl->part[partno], p);
>
>        /* suppress uevent if the disk supresses it */
> -       if (!dev_get_uevent_suppress(pdev))
> +       if (!dev_get_uevent_suppress(ddev))
>                kobject_uevent(&pdev->kobj, KOBJ_ADD);
>
>        return p;
>

Thanks.

Acked-by: Ming Lei <tom.leiming@gmail.com>

-- 
Lei Ming
