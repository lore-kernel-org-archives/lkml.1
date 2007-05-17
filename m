Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbXEQLeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbXEQLeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 07:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbXEQLd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 07:33:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:62429 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbXEQLd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 07:33:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:x-priority:message-id:to:cc:subject:in-reply-to:references:mime-version:content-type:content-transfer-encoding;
        b=TeUvnT5UdxsXeeqegMPPvilV2V+aGR88kRLQxVf/zLPSF2VuK2U5tMZUwW4A70H5i7v5nzEtsg9LotxaPLyIcMwwu5+pgv1ibHMcEyjOJeI2K42hpuo3kF7r5IdNa0qAtSfSIpBcfC58FowkjUO54wwSSM6Zo6jPjnpcf7qRJD4=
Date: Thu, 17 May 2007 14:33:54 +0300
From: Paul Sokolovsky <pmiscml@gmail.com>
X-Priority: 3 (Normal)
Message-ID: <1726326841.20070517143354@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
CC: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ide.c: microscopic size and readability optimization
In-Reply-To: <20070517112554.GA32183@zmei.tnic>
References: <20070517112554.GA32183@zmei.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Borislav,

Thursday, May 17, 2007, 2:25:54 PM, you wrote:

> -----
> From: bbpetkov@yahoo.de

> A very small size (object file 432 bytes smaller) and readability optimization of ide.c

        And how these "optimizations" fit with BUG_ON() purpose - to
be able to easily identify cause and place of the failure? You
could just remove them altogether and claim that you did even "better"
"optimization".

> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

> --
> Index: 22-rc1/drivers/ide/ide.c
> ===================================================================
> --- 22-rc1/drivers/ide/ide.c.orig
> +++ 22-rc1/drivers/ide/ide.c
> @@ -568,10 +568,8 @@ void ide_unregister(unsigned int index)
>         ide_hwgroup_t *hwgroup;
>         int irq_count = 0, unit;

> -       BUG_ON(index >= MAX_HWIFS);
> +       BUG_ON(index >= MAX_HWIFS || in_interrupt() || irqs_disabled());

> -       BUG_ON(in_interrupt());
> -       BUG_ON(irqs_disabled());
>         down(&ide_cfg_sem);



-- 
Best regards,
 Paul                            mailto:pmiscml@gmail.com

