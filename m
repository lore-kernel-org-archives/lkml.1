Return-Path: <linux-kernel-owner+w=401wt.eu-S1759558AbXLUM0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759558AbXLUM0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbXLUM0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:26:16 -0500
Received: from brick.kernel.dk ([87.55.233.238]:7434 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbXLUM0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:26:16 -0500
Date: Fri, 21 Dec 2007 13:26:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH - SH/Dreamcast] Add support for GD-Rom device
Message-ID: <20071221122619.GC11583@kernel.dk>
References: <8b67d60712201559h5dbb2a17q8f16223b26b88006@mail.gmail.com> <8b67d60712201607k66d67fa2la8b21fc698fdb3ab@mail.gmail.com> <20071221121441.GB11583@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221121441.GB11583@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21 2007, Jens Axboe wrote:
> static void gdrom_readdisk_dma(struct work_struct *work)
> {
>         ...
> 
>         read_command = kzalloc(sizeof(struct packet_command), GFP_KERNEL);
>         if (!read_command)
>                 probably just defer the work to some time later
> 
>         spin_lock(&gdrom_lock);
>         while (!list_empty(&gdrom_deferred)) {
>                 req = list_entry(gdrom_deferred.next, struct request, queuelist);
>                 list_del_init(&req->queuelist);
>                 spin_unlock(&gdrom_lock);
> 
>                 ...
> 
>                 spin_lock(&gdrom_lock);
>         };
> 
+         spin_unlock(&gdrom_lock);
>         kfree(read_command);
> }

is missing, of course.

-- 
Jens Axboe

