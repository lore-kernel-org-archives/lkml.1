Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbXE3Ti1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbXE3Ti1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751782AbXE3TiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:38:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbXE3TiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:38:20 -0400
Date: Wed, 30 May 2007 12:38:40 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: axboe@kernel.dk, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       zaitcev@redhat.com
Subject: Re: [PATCH] drivers/block/ub.c: use list_for_each_entry()
Message-Id: <20070530123840.e54d73c2.zaitcev@redhat.com>
In-Reply-To: <20070530084752.GE14284@traven>
References: <20070530084752.GE14284@traven>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 10:47:52 +0200, Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:

> @@ -1608,8 +1605,7 @@ static void ub_reset_task(struct work_struct *work)
>  	spin_lock_irqsave(sc->lock, flags);
>  	sc->reset = 0;
>  	tasklet_schedule(&sc->tasklet);
> -	list_for_each(p, &sc->luns) {
> -		lun = list_entry(p, struct ub_lun, link);
> +	list_for_each_entry(lun, &sc->luns, link) {
>  		blk_start_queue(lun->disk->queue);
>  	}
>  	wake_up(&sc->reset_wait);

This patch straddles the border of acceptable. The pointless obfuscation
is balanced against the removal of explicit type in list_entry() and thus
a possible mismatched struct. I'm not acking nor naking this.

-- Pete
