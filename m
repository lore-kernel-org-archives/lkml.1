Return-Path: <linux-kernel-owner+w=401wt.eu-S936130AbYD1Qgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936130AbYD1Qgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965729AbYD1QgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:36:25 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:38110 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965717AbYD1QgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:36:24 -0400
In-Reply-To: <480FA529.2030800@tiscali.nl>
Subject: Re: [PATCH] ehca: ret is unsigned, ibmebus_request_irq() negative return
 ignored in hca_create_eq()
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Christoph Raisch <raisch@de.ibm.com>, general@lists.openfabrics.org,
       lkml <linux-kernel@vger.kernel.org>
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF9A87AED0.00E7FAFE-ONC1257439.005B0599-C1257439.005B2A38@de.ibm.com>
From: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Date: Mon, 28 Apr 2008 18:36:20 +0200
X-MIMETrack: Serialize by Router on D12ML065/12/M/IBM(Release 7.0.2FP2HF322 | September
 26, 2007) at 28/04/2008 18:36:21
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roel!
Thanks for pointing this out.
Will send another version with a more consistent naming convention
for return variable from firmware. We used to naming it h_ret.
Regards
Nam

Roel Kluin <12o3l@tiscali.nl> wrote on 23.04.2008 23:07:53:

> diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c
> b/drivers/infiniband/hw/ehca/ehca_eq.c
> index b4ac617..9727235 100644
> --- a/drivers/infiniband/hw/ehca/ehca_eq.c
> +++ b/drivers/infiniband/hw/ehca/ehca_eq.c
> @@ -59,6 +59,7 @@ int ehca_create_eq(struct ehca_shca *shca,
>     u32 i;
>     void *vpage;
>     struct ib_device *ib_dev = &shca->ib_device;
> +   int ret2;
>
>     spin_lock_init(&eq->spinlock);
>     spin_lock_init(&eq->irq_spinlock);
> @@ -123,18 +124,18 @@ int ehca_create_eq(struct ehca_shca *shca,
>
>     /* register interrupt handlers and initialize work queues */
>     if (type == EHCA_EQ) {
> -      ret = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
> +      ret2 = ibmebus_request_irq(eq->ist, ehca_interrupt_eq,
>                   IRQF_DISABLED, "ehca_eq",
>                   (void *)shca);
> -      if (ret < 0)
> +      if (ret2 < 0)
>           ehca_err(ib_dev, "Can't map interrupt handler.");
>
>        tasklet_init(&eq->interrupt_task, ehca_tasklet_eq, (long)shca);
>     } else if (type == EHCA_NEQ) {
> -      ret = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
> +      ret2 = ibmebus_request_irq(eq->ist, ehca_interrupt_neq,
>                   IRQF_DISABLED, "ehca_neq",
>                   (void *)shca);
> -      if (ret < 0)
> +      if (ret2 < 0)
>           ehca_err(ib_dev, "Can't map interrupt handler.");
>
>        tasklet_init(&eq->interrupt_task, ehca_tasklet_neq, (long)shca);

