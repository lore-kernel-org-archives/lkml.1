Return-Path: <linux-kernel-owner+w=401wt.eu-S933237AbXGRT1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237AbXGRT1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756536AbXGRT1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:27:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40267 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbXGRT1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:27:01 -0400
Subject: Re: [PATCH] Conexant 2388x: check for kthread_run
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <v4l-dvb-maintainer@linuxtv.org>
In-Reply-To: <20070718185624.GA13996@cvg>
References: <20070718185624.GA13996@cvg>
Content-Type: text/plain; charset=utf-8
Date: Wed, 18 Jul 2007 16:25:38 -0300
Message-Id: <1184786738.4049.38.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

Em Qua, 2007-07-18 às 22:56 +0400, Cyrill Gorcunov escreveu:
> This patch adds checking of kthread_run return code.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> Probably we could just ignore a such situation (we do
> check for core->kthread value before trying to stop the
> thread) but we have to leave a footmark in kernel
> messages anyway I guess. Comments?

> +		if (IS_ERR(core->kthread)) {
> +			err = PTR_ERR(core->kthread);
> +			printk(KERN_ERR "Failed to create cx88 audio thread, err=%d\n",
> +			       err);
> +			goto fail_unreg;

I would just remove the goto from your patch. 

It is safe not starting the kernel thread, but keeping the driver
initializing.

The drawback of not having the thread is not changing to stereo on some
situations and not detecting audio standard changes (some countries may
have more than one audio standard when you changing from VHF to UHF or
on Cable TV).

-- 
Cheers,
Mauro

