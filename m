Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbZC3Jxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbZC3Jxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 05:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbZC3Jxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 05:53:43 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:46107 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbZC3Jxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 05:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=CbH7I0ka/Nb2jhKvB3hRUbrnfwtcfyKLDhB9BqHM66AUZ7IClaNMhSBsKNSMG9+9Yr
         jk35cPRmDQ/ASwgyF7i2FW1/Ai+3RikquQpeoWL9jKVjkfvFnyziVYDtLWNIWsFSYsOE
         AgEINOASen77NyKT9Mla7fXvh8jYmsQ3QxYPs=
MIME-Version: 1.0
In-Reply-To: <20090320100011.GB26020@orion>
References: <20090320100011.GB26020@orion>
Date: Mon, 30 Mar 2009 13:53:39 +0400
Message-ID: <a4423d670903300253q2b7d6934n6407f3780556d275@mail.gmail.com>
Subject: Re: [PATCH next 2/2] PARISC: iosapic: fix build breakage
From: Alexander Beregalov <a.beregalov@gmail.com>
To: kyle@mcmartin.ca, linux-parisc@vger.kernel.org,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/20 Alexander Beregalov <a.beregalov@gmail.com>:
> drivers/parisc/iosapic.c:717: error: incompatible types in assignment
>
> irq_desc::affinity was changed from cpumask_t to cpumask_var_t in
> 7f7ace0cda (cpumask: update irq_desc to use cpumask_var_t)
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Could anybody please comment it?
Current -git does not build on parisc.

> ---
>
>  drivers/parisc/iosapic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
> index 501aaf1..73348c4 100644
> --- a/drivers/parisc/iosapic.c
> +++ b/drivers/parisc/iosapic.c
> @@ -714,7 +714,7 @@ static void iosapic_set_affinity_irq(unsigned int irq,
>        if (dest_cpu < 0)
>                return;
>
> -       irq_desc[irq].affinity = cpumask_of_cpu(dest_cpu);
> +       cpumask_copy(irq_desc[irq].affinity, cpumask_of(dest_cpu));
>        vi->txn_addr = txn_affinity_addr(irq, dest_cpu);
>
>        spin_lock_irqsave(&iosapic_lock, flags);
>
